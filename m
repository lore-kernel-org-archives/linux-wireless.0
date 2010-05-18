Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:53133 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490Ab0ERI1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 04:27:34 -0400
Subject: [PATCH] rndis_wlan: increase assocbuf size and validate association
	info offsets from driver
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 May 2010 11:27:31 +0300
Message-ID: <20100518082731.25486.42902.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Buffer size for get_association_info was limited to WEXT event size. Since association
info no longer is sent through WEXT, this limit is not needed. Code also did not
check if data get truncated, memory outside buffer might be addressed. Fix all these.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   36 +++++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index b280ad1..939e66e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2495,8 +2495,7 @@ static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-	struct ndis_80211_assoc_info *info;
-	u8 assoc_buf[sizeof(*info) + IW_CUSTOM_MAX + 32];
+	struct ndis_80211_assoc_info *info = NULL;
 	u8 bssid[ETH_ALEN];
 	int resp_ie_len, req_ie_len;
 	u8 *req_ie, *resp_ie;
@@ -2515,23 +2514,43 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 	resp_ie = NULL;
 
 	if (priv->infra_mode == NDIS_80211_INFRA_INFRA) {
-		memset(assoc_buf, 0, sizeof(assoc_buf));
-		info = (void *)assoc_buf;
+		info = kzalloc(CONTROL_BUFFER_SIZE, GFP_KERNEL);
+		if (!info) {
+			/* No memory? Try resume work later */
+			set_bit(WORK_LINK_UP, &priv->work_pending);
+			queue_work(priv->workqueue, &priv->work);
+			return;
+		}
 
-		/* Get association info IEs from device and send them back to
-		 * userspace. */
-		ret = get_association_info(usbdev, info, sizeof(assoc_buf));
+		/* Get association info IEs from device. */
+		ret = get_association_info(usbdev, info, CONTROL_BUFFER_SIZE);
 		if (!ret) {
 			req_ie_len = le32_to_cpu(info->req_ie_length);
 			if (req_ie_len > 0) {
 				offset = le32_to_cpu(info->offset_req_ies);
+
+				if (offset > CONTROL_BUFFER_SIZE)
+					offset = CONTROL_BUFFER_SIZE;
+
 				req_ie = (u8 *)info + offset;
+
+				if (offset + req_ie_len > CONTROL_BUFFER_SIZE)
+					req_ie_len =
+						CONTROL_BUFFER_SIZE - offset;
 			}
 
 			resp_ie_len = le32_to_cpu(info->resp_ie_length);
 			if (resp_ie_len > 0) {
 				offset = le32_to_cpu(info->offset_resp_ies);
+
+				if (offset > CONTROL_BUFFER_SIZE)
+					offset = CONTROL_BUFFER_SIZE;
+
 				resp_ie = (u8 *)info + offset;
+
+				if (offset + resp_ie_len > CONTROL_BUFFER_SIZE)
+					resp_ie_len =
+						CONTROL_BUFFER_SIZE - offset;
 			}
 		}
 	} else if (WARN_ON(priv->infra_mode != NDIS_80211_INFRA_ADHOC))
@@ -2563,6 +2582,9 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
 		cfg80211_ibss_joined(usbdev->net, bssid, GFP_KERNEL);
 
+	if (info != NULL)
+		kfree(info);
+
 	priv->connected = true;
 	memcpy(priv->bssid, bssid, ETH_ALEN);
 

