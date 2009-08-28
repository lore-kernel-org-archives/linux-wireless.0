Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:60057 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZH1J67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:58:59 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/8] rndis_wlan: resize bssid list if too small
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:59:00 +0300
Message-ID: <20090828095900.10554.29607.stgit@fate.lan>
In-Reply-To: <20090828095849.10554.58857.stgit@fate.lan>
References: <20090828095849.10554.58857.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Buffer used for bssid list might be too small. Change rndis_query_oid()
to return required buffer length to caller and make rndis_check_bssid_list()
resize buffer when needed.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 3779621..2309ad2 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -676,7 +676,8 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 
 	if (ret == 0) {
 		ret = le32_to_cpu(u.get_c->len);
-		*len = (*len > ret) ? ret : *len;
+		if (ret > *len)
+			*len = ret;
 		memcpy(data, u.buf + le32_to_cpu(u.get_c->offset) + 8, *len);
 		ret = rndis_error_status(u.get_c->status);
 
@@ -1656,6 +1657,9 @@ static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 	int ie_len, bssid_len;
 	u8 *ie;
 
+	devdbg(usbdev, " found bssid: '%.32s' [%pM]", bssid->ssid.essid,
+							bssid->mac);
+
 	/* parse bssid structure */
 	bssid_len = le32_to_cpu(bssid->length);
 
@@ -1695,10 +1699,12 @@ static int rndis_check_bssid_list(struct usbnet *usbdev)
 	struct ndis_80211_bssid_list_ex *bssid_list;
 	struct ndis_80211_bssid_ex *bssid;
 	int ret = -EINVAL, len, count, bssid_len;
+	bool resized = false;
 
 	devdbg(usbdev, "check_bssid_list");
 
 	len = CONTROL_BUFFER_SIZE;
+resize_buf:
 	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
@@ -1709,11 +1715,18 @@ static int rndis_check_bssid_list(struct usbnet *usbdev)
 	if (ret != 0)
 		goto out;
 
+	if (!resized && len > CONTROL_BUFFER_SIZE) {
+		resized = true;
+		kfree(buf);
+		goto resize_buf;
+	}
+
 	bssid_list = buf;
 	bssid = bssid_list->bssid;
 	bssid_len = le32_to_cpu(bssid->length);
 	count = le32_to_cpu(bssid_list->num_items);
-	devdbg(usbdev, "check_bssid_list: %d BSSIDs found", count);
+	devdbg(usbdev, "check_bssid_list: %d BSSIDs found (buflen: %d)", count,
+									len);
 
 	while (count && ((void *)bssid + bssid_len) <= (buf + len)) {
 		rndis_bss_info_update(usbdev, bssid);

