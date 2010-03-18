Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33180 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0CRK1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:49 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 11/21] wl1271: create qos nullfunc template
Date: Thu, 18 Mar 2010 12:26:36 +0200
Message-Id: <1268908006-16992-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Needed for U-APSD.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 8364270..0cbb0e1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -26,6 +26,7 @@
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/etherdevice.h>
+#include <linux/ieee80211.h>
 
 #include "wl1271.h"
 #include "wl1271_reg.h"
@@ -778,6 +779,27 @@ out:
 	return ret;
 }
 
+int wl1271_build_qos_null_data(struct wl1271 *wl)
+{
+	struct ieee80211_qos_hdr template;
+
+	memset(&template, 0, sizeof(template));
+
+	memcpy(template.addr1, wl->bssid, ETH_ALEN);
+	memcpy(template.addr2, wl->mac_addr, ETH_ALEN);
+	memcpy(template.addr3, wl->bssid, ETH_ALEN);
+
+	template.frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					     IEEE80211_STYPE_QOS_NULLFUNC |
+					     IEEE80211_FCTL_TODS);
+
+	/* FIXME: not sure what priority to use here */
+	template.qos_ctrl = cpu_to_le16(0);
+
+	return wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, &template,
+				       sizeof(template));
+}
+
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
 {
 	struct wl1271_cmd_set_keys *cmd;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index e936d3a..6324bbf 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -51,6 +51,7 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
 int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 			       const u8 *ssid, size_t ssid_len,
 			       const u8 *ie, size_t ie_len, u8 band);
+int wl1271_build_qos_null_data(struct wl1271 *wl);
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
 int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
-- 
1.6.3.3

