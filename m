Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:59415 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0LUUoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:44:09 -0500
Subject: [PATCH 1/7] [v2] rndis_wlan: scanning,
	workaround device returning incorrect bssid-list item count.
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Dec 2010 22:44:05 +0200
Message-ID: <20101221204405.12250.35410.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes device returns wrong number of items in bssid-list. Appears that
some specific beacons trigger this problem and leads to very poor scanning
results. Workaround by ignoring num_items received from device and walkthrough
full bssid-list buffer.

v2: Fix buffer range checks and reading next item length. Old code read
    behind buffer on last item but didn't use those values as 'count' would
    also reach zero. Also fix resizing of buffer if device has larger buffer,
    old code assumed that BSSID-list OID would return same buffer size
    when it really can return yet another new larger length.

Tested-by: Luís Picciochi <Pitxyoki@gmail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   80 +++++++++++++++++++++++++++++--------
 1 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 4a4f005..de4c050 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1967,8 +1967,8 @@ static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 	int ie_len, bssid_len;
 	u8 *ie;
 
-	netdev_dbg(usbdev->net, " found bssid: '%.32s' [%pM]\n",
-		   bssid->ssid.essid, bssid->mac);
+	netdev_dbg(usbdev->net, " found bssid: '%.32s' [%pM], len: %d\n",
+		   bssid->ssid.essid, bssid->mac, le32_to_cpu(bssid->length));
 
 	/* parse bssid structure */
 	bssid_len = le32_to_cpu(bssid->length);
@@ -2002,54 +2002,98 @@ static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 		GFP_KERNEL);
 }
 
+static struct ndis_80211_bssid_ex *next_bssid_list_item(
+					struct ndis_80211_bssid_ex *bssid,
+					int *bssid_len, void *buf, int len)
+{
+	void *buf_end, *bssid_end;
+
+	buf_end = (char *)buf + len;
+	bssid_end = (char *)bssid + *bssid_len;
+
+	if ((int)(buf_end - bssid_end) < sizeof(bssid->length)) {
+		*bssid_len = 0;
+		return NULL;
+	} else {
+		bssid = (void *)((char *)bssid + *bssid_len);
+		*bssid_len = le32_to_cpu(bssid->length);
+		return bssid;
+	}
+}
+
+static bool check_bssid_list_item(struct ndis_80211_bssid_ex *bssid,
+				  int bssid_len, void *buf, int len)
+{
+	void *buf_end, *bssid_end;
+
+	if (!bssid || bssid_len <= 0 || bssid_len > len)
+		return false;
+
+	buf_end = (char *)buf + len;
+	bssid_end = (char *)bssid + bssid_len;
+
+	return (int)(buf_end - bssid_end) >= 0 && (int)(bssid_end - buf) >= 0;
+}
+
 static int rndis_check_bssid_list(struct usbnet *usbdev, u8 *match_bssid,
 					bool *matched)
 {
 	void *buf = NULL;
 	struct ndis_80211_bssid_list_ex *bssid_list;
 	struct ndis_80211_bssid_ex *bssid;
-	int ret = -EINVAL, len, count, bssid_len;
-	bool resized = false;
+	int ret = -EINVAL, len, count, bssid_len, real_count, new_len;
 
-	netdev_dbg(usbdev->net, "check_bssid_list\n");
+	netdev_dbg(usbdev->net, "%s()\n", __func__);
 
 	len = CONTROL_BUFFER_SIZE;
 resize_buf:
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	ret = rndis_query_oid(usbdev, OID_802_11_BSSID_LIST, buf, &len);
-	if (ret != 0)
+	/* BSSID-list might have got bigger last time we checked, keep
+	 * resizing until it won't get any bigger.
+	 */
+	new_len = len;
+	ret = rndis_query_oid(usbdev, OID_802_11_BSSID_LIST, buf, &new_len);
+	if (ret != 0 || new_len < sizeof(struct ndis_80211_bssid_list_ex))
 		goto out;
 
-	if (!resized && len > CONTROL_BUFFER_SIZE) {
-		resized = true;
+	if (new_len > len) {
+		len = new_len;
 		kfree(buf);
 		goto resize_buf;
 	}
 
+	len = new_len;
+
 	bssid_list = buf;
-	bssid = bssid_list->bssid;
-	bssid_len = le32_to_cpu(bssid->length);
 	count = le32_to_cpu(bssid_list->num_items);
-	netdev_dbg(usbdev->net, "check_bssid_list: %d BSSIDs found (buflen: %d)\n",
-		   count, len);
+	real_count = 0;
+	netdev_dbg(usbdev->net, "%s(): buflen: %d\n", __func__, len);
+
+	bssid_len = 0;
+	bssid = next_bssid_list_item(bssid_list->bssid, &bssid_len, buf, len);
 
-	while (count && ((void *)bssid + bssid_len) <= (buf + len)) {
+	/* Device returns incorrect 'num_items'. Workaround by ignoring the
+	 * received 'num_items' and walking through full bssid buffer instead.
+	 */
+	while (check_bssid_list_item(bssid, bssid_len, buf, len)) {
 		if (rndis_bss_info_update(usbdev, bssid) && match_bssid &&
 		    matched) {
 			if (compare_ether_addr(bssid->mac, match_bssid))
 				*matched = true;
 		}
 
-		bssid = (void *)bssid + bssid_len;
-		bssid_len = le32_to_cpu(bssid->length);
-		count--;
+		real_count++;
+		bssid = next_bssid_list_item(bssid, &bssid_len, buf, len);
 	}
 
+	netdev_dbg(usbdev->net, "%s(): num_items from device: %d, really found:"
+				" %d\n", __func__, count, real_count);
+
 out:
 	kfree(buf);
 	return ret;

