Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:51949 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZH1J7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:59:09 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 5/8] rndis_wlan: move link up/down work to separate functions
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:59:10 +0300
Message-ID: <20090828095910.10554.65637.stgit@fate.lan>
In-Reply-To: <20090828095849.10554.58857.stgit@fate.lan>
References: <20090828095849.10554.58857.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move link up/down work to separate functions and use local array
for allocating memory for info structure instead of kzmalloc.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  101 ++++++++++++++++++++-----------------
 1 files changed, 55 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index cb362b0..dc3083b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2319,68 +2319,77 @@ static const struct iw_handler_def rndis_iw_handlers = {
 };
 
 
-static void rndis_wlan_worker(struct work_struct *work)
+static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 {
-	struct rndis_wlan_private *priv =
-		container_of(work, struct rndis_wlan_private, work);
-	struct usbnet *usbdev = priv->usbdev;
-	union iwreq_data evt;
-	unsigned char bssid[ETH_ALEN];
 	struct ndis_80211_assoc_info *info;
-	int assoc_size = sizeof(*info) + IW_CUSTOM_MAX + 32;
+	union iwreq_data evt;
+	u8 assoc_buf[sizeof(*info) + IW_CUSTOM_MAX + 32];
+	u8 bssid[ETH_ALEN];
 	int ret, offset;
 
-	if (test_and_clear_bit(WORK_LINK_UP, &priv->work_pending)) {
-		netif_carrier_on(usbdev->net);
-
-		info = kzalloc(assoc_size, GFP_KERNEL);
-		if (!info)
-			goto get_bssid;
-
-		/* Get association info IEs from device and send them back to
-		 * userspace. */
-		ret = get_association_info(usbdev, info, assoc_size);
-		if (!ret) {
-			evt.data.length = le32_to_cpu(info->req_ie_length);
-			if (evt.data.length > 0) {
-				offset = le32_to_cpu(info->offset_req_ies);
-				wireless_send_event(usbdev->net,
-					IWEVASSOCREQIE, &evt,
-					(char *)info + offset);
-			}
-
-			evt.data.length = le32_to_cpu(info->resp_ie_length);
-			if (evt.data.length > 0) {
-				offset = le32_to_cpu(info->offset_resp_ies);
-				wireless_send_event(usbdev->net,
-					IWEVASSOCRESPIE, &evt,
-					(char *)info + offset);
-			}
+	memset(assoc_buf, 0, sizeof(assoc_buf));
+	info = (void *)assoc_buf;
+
+	netif_carrier_on(usbdev->net);
+
+	/* Get association info IEs from device and send them back to
+	 * userspace. */
+	ret = get_association_info(usbdev, info, sizeof(assoc_buf));
+	if (!ret) {
+		evt.data.length = le32_to_cpu(info->req_ie_length);
+		if (evt.data.length > 0) {
+			offset = le32_to_cpu(info->offset_req_ies);
+			wireless_send_event(usbdev->net,
+				IWEVASSOCREQIE, &evt,
+				(char *)info + offset);
 		}
 
-		kfree(info);
-
-get_bssid:
-		ret = get_bssid(usbdev, bssid);
-		if (!ret) {
-			evt.data.flags = 0;
-			evt.data.length = 0;
-			memcpy(evt.ap_addr.sa_data, bssid, ETH_ALEN);
-			wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
+		evt.data.length = le32_to_cpu(info->resp_ie_length);
+		if (evt.data.length > 0) {
+			offset = le32_to_cpu(info->offset_resp_ies);
+			wireless_send_event(usbdev->net,
+				IWEVASSOCRESPIE, &evt,
+				(char *)info + offset);
 		}
 
 		usbnet_resume_rx(usbdev);
 	}
 
-	if (test_and_clear_bit(WORK_LINK_DOWN, &priv->work_pending)) {
-		netif_carrier_off(usbdev->net);
-
+	ret = get_bssid(usbdev, bssid);
+	if (!ret) {
 		evt.data.flags = 0;
 		evt.data.length = 0;
-		memset(evt.ap_addr.sa_data, 0, ETH_ALEN);
+		memcpy(evt.ap_addr.sa_data, bssid, ETH_ALEN);
 		wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
 	}
 
+	usbnet_resume_rx(usbdev);
+}
+
+static void rndis_wlan_do_link_down_work(struct usbnet *usbdev)
+{
+	union iwreq_data evt;
+
+	netif_carrier_off(usbdev->net);
+
+	evt.data.flags = 0;
+	evt.data.length = 0;
+	memset(evt.ap_addr.sa_data, 0, ETH_ALEN);
+	wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
+}
+
+static void rndis_wlan_worker(struct work_struct *work)
+{
+	struct rndis_wlan_private *priv =
+		container_of(work, struct rndis_wlan_private, work);
+	struct usbnet *usbdev = priv->usbdev;
+
+	if (test_and_clear_bit(WORK_LINK_UP, &priv->work_pending))
+		rndis_wlan_do_link_up_work(usbdev);
+
+	if (test_and_clear_bit(WORK_LINK_DOWN, &priv->work_pending))
+		rndis_wlan_do_link_down_work(usbdev);
+
 	if (test_and_clear_bit(WORK_SET_MULTICAST_LIST, &priv->work_pending))
 		set_multicast_list(usbdev);
 }

