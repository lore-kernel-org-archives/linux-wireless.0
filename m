Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXHJVRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 17:17:33 -0400
Subject: [PATCH] hostapd: make it work on the latest kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ed Howland <ed.howland@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:20:05 +0200
Message-Id: <1186780805.17351.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i802_if_update isn't actually used so remove all code from it, add
ieee80211_msg_passive_scan as our own constant and #if 0 more code in
handle_frame()

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

diff --git a/hostapd/driver_devicescape.c b/hostapd/driver_devicescape.c
index 73e05f0..de8fe4a 100644
--- a/hostapd/driver_devicescape.c
+++ b/hostapd/driver_devicescape.c
@@ -39,6 +39,11 @@
 #include "hw_features.h"
 #include <hostapd_ioctl.h>
 #include <ieee80211_common.h>
+
+/* there used to be this constant in the kernel sources, but
+ * the kernel no longer needs it.... we use it internally.... */
+#define ieee80211_msg_passive_scan 3
+
 /* from net/mac80211.h */
 enum {
 	MODE_IEEE80211A = 0 /* IEEE 802.11a */,
@@ -1021,32 +1026,8 @@ static int i802_if_add(const char *iface, void *priv,
 static int i802_if_update(void *priv, enum hostapd_driver_if_type type,
 			  char *ifname, const u8 *addr)
 {
-	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param *param;
-
-	param = malloc(sizeof(struct prism2_hostapd_param) + ETH_ALEN);
-	if (!param)
-		return -1;
-	memset(param, 0, sizeof(param));
-
-	param->cmd = PRISM2_HOSTAPD_UPDATE_IF;
-	param->u.if_info.type = i802_if_type(type);
-	if (addr)
-		memcpy(param->u.if_info.data, addr, ETH_ALEN);
-	else
-		memset(param->u.if_info.data, 0, ETH_ALEN);
-	os_strlcpy((char *) param->u.if_info.name, ifname, IFNAMSIZ);
-
-	/* FIX: should the size have + ETH_ALEN ? */
-	if (hostapd_ioctl(drv, param, sizeof(struct prism2_hostapd_param))) {
-		printf("Could not update iface: %s.\n", ifname);
-		free(param);
-		return -1;
-	}
-
-	os_strlcpy(ifname, (char *) param->u.if_info.name, IFNAMSIZ);
-	free(param);
-	return 0;
+	/* unused at the moment */
+	return -1;
 }
 
 
@@ -1354,13 +1335,13 @@ static void handle_frame(struct hostapd_iface *iface, u8 *buf, size_t len,
 	int msg_type = ntohl(fi->msg_type);
 	struct hostapd_frame_info hfi;
 
+#if 0 /* TODO */
 	/* special handling for message types without IEEE 802.11 header */
 	if (msg_type == ieee80211_msg_set_aid_for_sta) {
-#if 0 /* TODO */
 		ieee802_11_set_aid_for_sta(iface->bss[0], buf, data_len);
-#endif
 		return;
 	}
+#endif
 	if (msg_type == ieee80211_msg_key_threshold_notification) {
 #if 0 /* TODO */
 		ieee802_11_key_threshold_notification(iface->bss[0], buf,


