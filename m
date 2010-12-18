Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:56370 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0LRO7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 09:59:33 -0500
Subject: [PATCH] rndis_wlan: scanning,
	workaround device returning incorrect bssid-list item count.
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 18 Dec 2010 16:59:29 +0200
Message-ID: <20101218145929.13559.78929.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes device returns wrong number of items in bssid-list. Appears that some specific beacons
trigger this problem and leads to very poor scanning results. Workaround by ignoring num_items
received from device and walkthrough full bssid-list buffer.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 4a4f005..8db8333 100644
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
@@ -2008,10 +2008,10 @@ static int rndis_check_bssid_list(struct usbnet *usbdev, u8 *match_bssid,
 	void *buf = NULL;
 	struct ndis_80211_bssid_list_ex *bssid_list;
 	struct ndis_80211_bssid_ex *bssid;
-	int ret = -EINVAL, len, count, bssid_len;
+	int ret = -EINVAL, len, count, bssid_len, real_count;
 	bool resized = false;
 
-	netdev_dbg(usbdev->net, "check_bssid_list\n");
+	netdev_dbg(usbdev->net, "%s\n", __func__);
 
 	len = CONTROL_BUFFER_SIZE;
 resize_buf:
@@ -2035,10 +2035,13 @@ resize_buf:
 	bssid = bssid_list->bssid;
 	bssid_len = le32_to_cpu(bssid->length);
 	count = le32_to_cpu(bssid_list->num_items);
-	netdev_dbg(usbdev->net, "check_bssid_list: %d BSSIDs found (buflen: %d)\n",
-		   count, len);
+	real_count = 0;
+	netdev_dbg(usbdev->net, "%s, buflen: %d\n", __func__, len);
 
-	while (count && ((void *)bssid + bssid_len) <= (buf + len)) {
+	/* Device returns incorrect 'num_items'. Workaround by ignoring the
+	 * received 'num_items' and walking through full bssid buffer instead.
+	 */
+	while (bssid_len > 0 && ((void *)bssid + bssid_len) <= (buf + len)) {
 		if (rndis_bss_info_update(usbdev, bssid) && match_bssid &&
 		    matched) {
 			if (compare_ether_addr(bssid->mac, match_bssid))
@@ -2047,9 +2050,12 @@ resize_buf:
 
 		bssid = (void *)bssid + bssid_len;
 		bssid_len = le32_to_cpu(bssid->length);
-		count--;
+		real_count++;
 	}
 
+	netdev_dbg(usbdev->net, "%s, num_items from device: %d, really found: "
+				"%d\n", __func__, count, real_count);
+
 out:
 	kfree(buf);
 	return ret;

