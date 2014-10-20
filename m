Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48730 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaJTNKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:10:15 -0400
Received: by mail-lb0-f177.google.com with SMTP id w7so3727774lbi.8
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:10:14 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/7] ath10k: add sanity checks for service bmap parsing
Date: Mon, 20 Oct 2014 14:58:40 +0200
Message-Id: <1413809925-4352-3-git-send-email-michal.kazior@tieto.com> (sfid-20141020_151025_269178_13CDD504)
In-Reply-To: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
References: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This shouldn't really happen but take into account
the original service bitmap length when mapping
service ids.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   6 +-
 drivers/net/wireless/ath/ath10k/wmi.h | 121 +++++++++++++++++-----------------
 2 files changed, 66 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 45768c9..2c2e727 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2470,10 +2470,12 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
 		ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
-		wmi_10x_svc_map(arg.service_map, svc_bmap);
+		wmi_10x_svc_map(arg.service_map, svc_bmap,
+				arg.service_map_len);
 	} else {
 		ret = ath10k_wmi_main_pull_svc_rdy_ev(skb, &arg);
-		wmi_main_svc_map(arg.service_map, svc_bmap);
+		wmi_main_svc_map(arg.service_map, svc_bmap,
+				 arg.service_map_len);
 	}
 
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4d16dfe..8cf178c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -222,128 +222,131 @@ static inline char *wmi_service_name(int service_id)
 #undef SVCSTR
 }
 
-#define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id) \
-	(__le32_to_cpu((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
+#define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id, len) \
+	((svc_id) < (len) && \
+	 __le32_to_cpu((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
 	 BIT((svc_id)%(sizeof(u32))))
 
-#define SVCMAP(x, y) \
+#define SVCMAP(x, y, len) \
 	do { \
-		if (WMI_SERVICE_IS_ENABLED((in), (x))) \
+		if (WMI_SERVICE_IS_ENABLED((in), (x), (len))) \
 			__set_bit(y, out); \
 	} while (0)
 
-static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out)
+static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
+				   size_t len)
 {
 	SVCMAP(WMI_10X_SERVICE_BEACON_OFFLOAD,
-	       WMI_SERVICE_BEACON_OFFLOAD);
+	       WMI_SERVICE_BEACON_OFFLOAD, len);
 	SVCMAP(WMI_10X_SERVICE_SCAN_OFFLOAD,
-	       WMI_SERVICE_SCAN_OFFLOAD);
+	       WMI_SERVICE_SCAN_OFFLOAD, len);
 	SVCMAP(WMI_10X_SERVICE_ROAM_OFFLOAD,
-	       WMI_SERVICE_ROAM_OFFLOAD);
+	       WMI_SERVICE_ROAM_OFFLOAD, len);
 	SVCMAP(WMI_10X_SERVICE_BCN_MISS_OFFLOAD,
-	       WMI_SERVICE_BCN_MISS_OFFLOAD);
+	       WMI_SERVICE_BCN_MISS_OFFLOAD, len);
 	SVCMAP(WMI_10X_SERVICE_STA_PWRSAVE,
-	       WMI_SERVICE_STA_PWRSAVE);
+	       WMI_SERVICE_STA_PWRSAVE, len);
 	SVCMAP(WMI_10X_SERVICE_STA_ADVANCED_PWRSAVE,
-	       WMI_SERVICE_STA_ADVANCED_PWRSAVE);
+	       WMI_SERVICE_STA_ADVANCED_PWRSAVE, len);
 	SVCMAP(WMI_10X_SERVICE_AP_UAPSD,
-	       WMI_SERVICE_AP_UAPSD);
+	       WMI_SERVICE_AP_UAPSD, len);
 	SVCMAP(WMI_10X_SERVICE_AP_DFS,
-	       WMI_SERVICE_AP_DFS);
+	       WMI_SERVICE_AP_DFS, len);
 	SVCMAP(WMI_10X_SERVICE_11AC,
-	       WMI_SERVICE_11AC);
+	       WMI_SERVICE_11AC, len);
 	SVCMAP(WMI_10X_SERVICE_BLOCKACK,
-	       WMI_SERVICE_BLOCKACK);
+	       WMI_SERVICE_BLOCKACK, len);
 	SVCMAP(WMI_10X_SERVICE_PHYERR,
-	       WMI_SERVICE_PHYERR);
+	       WMI_SERVICE_PHYERR, len);
 	SVCMAP(WMI_10X_SERVICE_BCN_FILTER,
-	       WMI_SERVICE_BCN_FILTER);
+	       WMI_SERVICE_BCN_FILTER, len);
 	SVCMAP(WMI_10X_SERVICE_RTT,
-	       WMI_SERVICE_RTT);
+	       WMI_SERVICE_RTT, len);
 	SVCMAP(WMI_10X_SERVICE_RATECTRL,
-	       WMI_SERVICE_RATECTRL);
+	       WMI_SERVICE_RATECTRL, len);
 	SVCMAP(WMI_10X_SERVICE_WOW,
-	       WMI_SERVICE_WOW);
+	       WMI_SERVICE_WOW, len);
 	SVCMAP(WMI_10X_SERVICE_RATECTRL_CACHE,
-	       WMI_SERVICE_RATECTRL_CACHE);
+	       WMI_SERVICE_RATECTRL_CACHE, len);
 	SVCMAP(WMI_10X_SERVICE_IRAM_TIDS,
-	       WMI_SERVICE_IRAM_TIDS);
+	       WMI_SERVICE_IRAM_TIDS, len);
 	SVCMAP(WMI_10X_SERVICE_BURST,
-	       WMI_SERVICE_BURST);
+	       WMI_SERVICE_BURST, len);
 	SVCMAP(WMI_10X_SERVICE_SMART_ANTENNA_SW_SUPPORT,
-	       WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT);
+	       WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT, len);
 	SVCMAP(WMI_10X_SERVICE_FORCE_FW_HANG,
-	       WMI_SERVICE_FORCE_FW_HANG);
+	       WMI_SERVICE_FORCE_FW_HANG, len);
 	SVCMAP(WMI_10X_SERVICE_SMART_ANTENNA_HW_SUPPORT,
-	       WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT);
+	       WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT, len);
 }
 
-static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out)
+static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
+				    size_t len)
 {
 	SVCMAP(WMI_MAIN_SERVICE_BEACON_OFFLOAD,
-	       WMI_SERVICE_BEACON_OFFLOAD);
+	       WMI_SERVICE_BEACON_OFFLOAD, len);
 	SVCMAP(WMI_MAIN_SERVICE_SCAN_OFFLOAD,
-	       WMI_SERVICE_SCAN_OFFLOAD);
+	       WMI_SERVICE_SCAN_OFFLOAD, len);
 	SVCMAP(WMI_MAIN_SERVICE_ROAM_OFFLOAD,
-	       WMI_SERVICE_ROAM_OFFLOAD);
+	       WMI_SERVICE_ROAM_OFFLOAD, len);
 	SVCMAP(WMI_MAIN_SERVICE_BCN_MISS_OFFLOAD,
-	       WMI_SERVICE_BCN_MISS_OFFLOAD);
+	       WMI_SERVICE_BCN_MISS_OFFLOAD, len);
 	SVCMAP(WMI_MAIN_SERVICE_STA_PWRSAVE,
-	       WMI_SERVICE_STA_PWRSAVE);
+	       WMI_SERVICE_STA_PWRSAVE, len);
 	SVCMAP(WMI_MAIN_SERVICE_STA_ADVANCED_PWRSAVE,
-	       WMI_SERVICE_STA_ADVANCED_PWRSAVE);
+	       WMI_SERVICE_STA_ADVANCED_PWRSAVE, len);
 	SVCMAP(WMI_MAIN_SERVICE_AP_UAPSD,
-	       WMI_SERVICE_AP_UAPSD);
+	       WMI_SERVICE_AP_UAPSD, len);
 	SVCMAP(WMI_MAIN_SERVICE_AP_DFS,
-	       WMI_SERVICE_AP_DFS);
+	       WMI_SERVICE_AP_DFS, len);
 	SVCMAP(WMI_MAIN_SERVICE_11AC,
-	       WMI_SERVICE_11AC);
+	       WMI_SERVICE_11AC, len);
 	SVCMAP(WMI_MAIN_SERVICE_BLOCKACK,
-	       WMI_SERVICE_BLOCKACK);
+	       WMI_SERVICE_BLOCKACK, len);
 	SVCMAP(WMI_MAIN_SERVICE_PHYERR,
-	       WMI_SERVICE_PHYERR);
+	       WMI_SERVICE_PHYERR, len);
 	SVCMAP(WMI_MAIN_SERVICE_BCN_FILTER,
-	       WMI_SERVICE_BCN_FILTER);
+	       WMI_SERVICE_BCN_FILTER, len);
 	SVCMAP(WMI_MAIN_SERVICE_RTT,
-	       WMI_SERVICE_RTT);
+	       WMI_SERVICE_RTT, len);
 	SVCMAP(WMI_MAIN_SERVICE_RATECTRL,
-	       WMI_SERVICE_RATECTRL);
+	       WMI_SERVICE_RATECTRL, len);
 	SVCMAP(WMI_MAIN_SERVICE_WOW,
-	       WMI_SERVICE_WOW);
+	       WMI_SERVICE_WOW, len);
 	SVCMAP(WMI_MAIN_SERVICE_RATECTRL_CACHE,
-	       WMI_SERVICE_RATECTRL_CACHE);
+	       WMI_SERVICE_RATECTRL_CACHE, len);
 	SVCMAP(WMI_MAIN_SERVICE_IRAM_TIDS,
-	       WMI_SERVICE_IRAM_TIDS);
+	       WMI_SERVICE_IRAM_TIDS, len);
 	SVCMAP(WMI_MAIN_SERVICE_ARPNS_OFFLOAD,
-	       WMI_SERVICE_ARPNS_OFFLOAD);
+	       WMI_SERVICE_ARPNS_OFFLOAD, len);
 	SVCMAP(WMI_MAIN_SERVICE_NLO,
-	       WMI_SERVICE_NLO);
+	       WMI_SERVICE_NLO, len);
 	SVCMAP(WMI_MAIN_SERVICE_GTK_OFFLOAD,
-	       WMI_SERVICE_GTK_OFFLOAD);
+	       WMI_SERVICE_GTK_OFFLOAD, len);
 	SVCMAP(WMI_MAIN_SERVICE_SCAN_SCH,
-	       WMI_SERVICE_SCAN_SCH);
+	       WMI_SERVICE_SCAN_SCH, len);
 	SVCMAP(WMI_MAIN_SERVICE_CSA_OFFLOAD,
-	       WMI_SERVICE_CSA_OFFLOAD);
+	       WMI_SERVICE_CSA_OFFLOAD, len);
 	SVCMAP(WMI_MAIN_SERVICE_CHATTER,
-	       WMI_SERVICE_CHATTER);
+	       WMI_SERVICE_CHATTER, len);
 	SVCMAP(WMI_MAIN_SERVICE_COEX_FREQAVOID,
-	       WMI_SERVICE_COEX_FREQAVOID);
+	       WMI_SERVICE_COEX_FREQAVOID, len);
 	SVCMAP(WMI_MAIN_SERVICE_PACKET_POWER_SAVE,
-	       WMI_SERVICE_PACKET_POWER_SAVE);
+	       WMI_SERVICE_PACKET_POWER_SAVE, len);
 	SVCMAP(WMI_MAIN_SERVICE_FORCE_FW_HANG,
-	       WMI_SERVICE_FORCE_FW_HANG);
+	       WMI_SERVICE_FORCE_FW_HANG, len);
 	SVCMAP(WMI_MAIN_SERVICE_GPIO,
-	       WMI_SERVICE_GPIO);
+	       WMI_SERVICE_GPIO, len);
 	SVCMAP(WMI_MAIN_SERVICE_STA_DTIM_PS_MODULATED_DTIM,
-	       WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM);
+	       WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM, len);
 	SVCMAP(WMI_MAIN_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG,
-	       WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG);
+	       WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG, len);
 	SVCMAP(WMI_MAIN_SERVICE_STA_UAPSD_VAR_AUTO_TRIG,
-	       WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG);
+	       WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG, len);
 	SVCMAP(WMI_MAIN_SERVICE_STA_KEEP_ALIVE,
-	       WMI_SERVICE_STA_KEEP_ALIVE);
+	       WMI_SERVICE_STA_KEEP_ALIVE, len);
 	SVCMAP(WMI_MAIN_SERVICE_TX_ENCAP,
-	       WMI_SERVICE_TX_ENCAP);
+	       WMI_SERVICE_TX_ENCAP, len);
 }
 
 #undef SVCMAP
-- 
1.8.5.3

