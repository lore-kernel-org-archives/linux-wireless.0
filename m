Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36947 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab1IEOje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 10:39:34 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 4/4] ath6kl: Allow enabling of P2P support
Date: Mon, 5 Sep 2011 17:38:47 +0300
Message-ID: <1315233527-6234-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20110905_163936_737871_F4307E46)
In-Reply-To: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now, use a module parameter (ath6kl_p2p) to allow P2P support
to be enabled. This is needed since there is no mechanism for
enabling the P2P mode more dynamically for a single netdev.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   12 ++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +
 drivers/net/wireless/ath/ath6kl/init.c     |   31 +++++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/target.h   |    6 +++++
 4 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6405696..a889bf4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -20,6 +20,10 @@
 #include "hif-ops.h"
 #include "testmode.h"
 
+static unsigned int ath6kl_p2p;
+
+module_param(ath6kl_p2p, uint, 0644);
+
 #define RATETAB_ENT(_rate, _rateid, _flags) {   \
 	.bitrate    = (_rate),                  \
 	.flags      = (_flags),                 \
@@ -1936,6 +1940,7 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 {
 	int ret = 0;
 	struct wireless_dev *wdev;
+	struct ath6kl *ar;
 
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
@@ -1951,6 +1956,9 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 		return NULL;
 	}
 
+	ar = wiphy_priv(wdev->wiphy);
+	ar->p2p = !!ath6kl_p2p;
+
 	wdev->wiphy->mgmt_stypes = ath6kl_mgmt_stypes;
 
 	wdev->wiphy->max_remain_on_channel_duration = 5000;
@@ -1960,6 +1968,10 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
+	if (ar->p2p) {
+		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_GO) |
+			BIT(NL80211_IFTYPE_P2P_CLIENT);
+	}
 	/* max num of ssids that can be probed during scanning */
 	wdev->wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
 	wdev->wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 054da13..c6ed1fc 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -471,6 +471,8 @@ struct ath6kl {
 	bool probe_req_report;
 	u16 next_chan;
 
+	bool p2p;
+
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
 		struct circ_buf fwlog_buf;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 3d67025..eca34aa 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -448,13 +448,26 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 			status = -EIO;
 		}
 
-	ret = ath6kl_wmi_info_req_cmd(ar->wmi, P2P_FLAG_CAPABILITIES_REQ |
-				      P2P_FLAG_MACADDR_REQ |
-				      P2P_FLAG_HMODEL_REQ);
-	if (ret) {
-		ath6kl_dbg(ATH6KL_DBG_TRC, "failed to request P2P "
-			   "capabilities (%d) - assuming P2P not supported\n",
-			   ret);
+	if (ar->p2p) {
+		ret = ath6kl_wmi_info_req_cmd(ar->wmi,
+					      P2P_FLAG_CAPABILITIES_REQ |
+					      P2P_FLAG_MACADDR_REQ |
+					      P2P_FLAG_HMODEL_REQ);
+		if (ret) {
+			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to request P2P "
+				   "capabilities (%d) - assuming P2P not "
+				   "supported\n", ret);
+			ar->p2p = 0;
+		}
+	}
+
+	if (ar->p2p) {
+		/* Enable Probe Request reporting for P2P */
+		ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, true);
+		if (ret) {
+			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to enable Probe "
+				   "Request reporting (%d)\n", ret);
+		}
 	}
 
 	return status;
@@ -492,6 +505,10 @@ int ath6kl_configure_target(struct ath6kl *ar)
 
 	param |= (1 << HI_OPTION_NUM_DEV_SHIFT);
 	param |= (fw_iftype << HI_OPTION_FW_MODE_SHIFT);
+	if (ar->p2p && fw_iftype == HI_OPTION_FW_MODE_BSS_STA) {
+		param |= HI_OPTION_FW_SUBMODE_P2PDEV <<
+			HI_OPTION_FW_SUBMODE_SHIFT;
+	}
 	param |= (0 << HI_OPTION_MAC_ADDR_METHOD_SHIFT);
 	param |= (0 << HI_OPTION_FW_BRIDGE_SHIFT);
 
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index dd8b953..7db06a5 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -304,6 +304,11 @@ struct host_interest {
 #define HI_OPTION_FW_MODE_BSS_STA 0x1
 #define HI_OPTION_FW_MODE_AP      0x2
 
+#define HI_OPTION_FW_SUBMODE_NONE      0x0
+#define HI_OPTION_FW_SUBMODE_P2PDEV    0x1
+#define HI_OPTION_FW_SUBMODE_P2PCLIENT 0x2
+#define HI_OPTION_FW_SUBMODE_P2PGO     0x3
+
 #define HI_OPTION_NUM_DEV_SHIFT   0x9
 
 #define HI_OPTION_FW_BRIDGE_SHIFT 0x04
@@ -316,6 +321,7 @@ struct host_interest {
 |------------------------------------------------------------------------------|
 */
 #define HI_OPTION_FW_MODE_SHIFT        0xC
+#define HI_OPTION_FW_SUBMODE_SHIFT     0x14
 
 /* Convert a Target virtual address into a Target physical address */
 #define AR6003_VTOP(vaddr) ((vaddr) & 0x001fffff)
-- 
1.7.4.1

