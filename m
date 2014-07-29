Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57749 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaG2KM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 06:12:59 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so8520994wgh.25
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2014 03:12:54 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix wmi service bitmap debug
Date: Tue, 29 Jul 2014 12:03:59 +0200
Message-Id: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com> (sfid-20140729_121303_490824_DD5F2901)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 10.x and main firmware branches have
conflicting WMI service bitmap definitions.

This also fixes WMI services parsing on big-endian
hosts and changes debugfs output to be more human
friendly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   2 +-
 drivers/net/wireless/ath/ath10k/debug.c |  26 ++-
 drivers/net/wireless/ath/ath10k/wmi.c   |  14 +-
 drivers/net/wireless/ath/ath10k/wmi.h   | 367 +++++++++++++++++++++++---------
 4 files changed, 290 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ded3af2..d8141fe 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -280,7 +280,7 @@ struct ath10k_debug {
 	struct dentry *debugfs_phy;
 
 	struct ath10k_target_stats target_stats;
-	u32 wmi_service_bitmap[WMI_SERVICE_BM_SIZE];
+	DECLARE_BITMAP(wmi_service_bitmap, WMI_SERVICE_BM_SIZE);
 
 	struct completion event_stats_compl;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c9e35c87e..df1abe7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -115,9 +115,10 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 	char *buf;
-	unsigned int len = 0, buf_len = 1500;
-	const char *status;
+	unsigned int len = 0, buf_len = 4096;
+	const char *name;
 	ssize_t ret_cnt;
+	bool enabled;
 	int i;
 
 	buf = kzalloc(buf_len, GFP_KERNEL);
@@ -129,15 +130,22 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 	if (len > buf_len)
 		len = buf_len;
 
-	for (i = 0; i < WMI_SERVICE_LAST; i++) {
-		if (WMI_SERVICE_IS_ENABLED(ar->debug.wmi_service_bitmap, i))
-			status = "enabled";
-		else
-			status = "disabled";
+	for (i = 0; i < WMI_MAX_SERVICE; i++) {
+		enabled = test_bit(i, ar->debug.wmi_service_bitmap);
+		name = wmi_service_name(i);
+
+		if (!name) {
+			if (enabled)
+				len += scnprintf(buf + len, buf_len - len,
+						 "%-40s %s (bit %d)\n",
+						 "unknown", "enabled", i);
+
+			continue;
+		}
 
 		len += scnprintf(buf + len, buf_len - len,
-				 "0x%02x - %20s - %s\n",
-				 i, wmi_service_name(i), status);
+				 "%-40s %s\n",
+				 name, enabled ? "enabled" : "-");
 	}
 
 	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b09661d..94e534a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2033,6 +2033,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
 	struct wmi_service_ready_event *ev = (void *)skb->data;
+	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_BM_SIZE) = {};
 
 	if (skb->len < sizeof(*ev)) {
 		ath10k_warn("Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
@@ -2066,8 +2067,10 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	ar->ath_common.regulatory.current_rd =
 		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
 
-	ath10k_debug_read_service_map(ar, ev->wmi_service_bitmap,
-				      sizeof(ev->wmi_service_bitmap));
+	wmi_main_svc_map(ev->wmi_service_bitmap, svc_bmap);
+	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
+	ath10k_dbg_dump(ATH10K_DBG_WMI, NULL, "ath10k: wmi svc: ",
+			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
 
 	if (strlen(ar->hw->wiphy->fw_version) == 0) {
 		snprintf(ar->hw->wiphy->fw_version,
@@ -2107,6 +2110,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
 	int ret;
 	struct wmi_service_ready_event_10x *ev = (void *)skb->data;
+	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_BM_SIZE) = {};
 
 	if (skb->len < sizeof(*ev)) {
 		ath10k_warn("Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
@@ -2133,8 +2137,10 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	ar->ath_common.regulatory.current_rd =
 		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
 
-	ath10k_debug_read_service_map(ar, ev->wmi_service_bitmap,
-				      sizeof(ev->wmi_service_bitmap));
+	wmi_10x_svc_map(ev->wmi_service_bitmap, svc_bmap);
+	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
+	ath10k_dbg_dump(ATH10K_DBG_WMI, NULL, "ath10k: wmi svc: ",
+			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
 
 	if (strlen(ar->hw->wiphy->fw_version) == 0) {
 		snprintf(ar->hw->wiphy->fw_version,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c9ac11c..c197012 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -73,116 +73,277 @@ struct wmi_cmd_hdr {
 #define HTC_PROTOCOL_VERSION    0x0002
 #define WMI_PROTOCOL_VERSION    0x0002
 
-enum wmi_service_id {
-	WMI_SERVICE_BEACON_OFFLOAD = 0,   /* beacon offload */
-	WMI_SERVICE_SCAN_OFFLOAD,	  /* scan offload */
-	WMI_SERVICE_ROAM_OFFLOAD,	  /* roam offload */
-	WMI_SERVICE_BCN_MISS_OFFLOAD,     /* beacon miss offload */
-	WMI_SERVICE_STA_PWRSAVE,	  /* fake sleep + basic power save */
-	WMI_SERVICE_STA_ADVANCED_PWRSAVE, /* uapsd, pspoll, force sleep */
-	WMI_SERVICE_AP_UAPSD,		  /* uapsd on AP */
-	WMI_SERVICE_AP_DFS,		  /* DFS on AP */
-	WMI_SERVICE_11AC,		  /* supports 11ac */
-	WMI_SERVICE_BLOCKACK,	/* Supports triggering ADDBA/DELBA from host*/
-	WMI_SERVICE_PHYERR,		  /* PHY error */
-	WMI_SERVICE_BCN_FILTER,		  /* Beacon filter support */
-	WMI_SERVICE_RTT,		  /* RTT (round trip time) support */
-	WMI_SERVICE_RATECTRL,		  /* Rate-control */
-	WMI_SERVICE_WOW,		  /* WOW Support */
-	WMI_SERVICE_RATECTRL_CACHE,       /* Rate-control caching */
-	WMI_SERVICE_IRAM_TIDS,            /* TIDs in IRAM */
-	WMI_SERVICE_ARPNS_OFFLOAD,	  /* ARP NS Offload support */
-	WMI_SERVICE_NLO,		  /* Network list offload service */
-	WMI_SERVICE_GTK_OFFLOAD,	  /* GTK offload */
-	WMI_SERVICE_SCAN_SCH,		  /* Scan Scheduler Service */
-	WMI_SERVICE_CSA_OFFLOAD,	  /* CSA offload service */
-	WMI_SERVICE_CHATTER,		  /* Chatter service */
-	WMI_SERVICE_COEX_FREQAVOID,	  /* FW report freq range to avoid */
-	WMI_SERVICE_PACKET_POWER_SAVE,	  /* packet power save service */
-	WMI_SERVICE_FORCE_FW_HANG,        /* To test fw recovery mechanism */
-	WMI_SERVICE_GPIO,                 /* GPIO service */
-	WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM, /* Modulated DTIM support */
-	WMI_STA_UAPSD_BASIC_AUTO_TRIG,    /* UAPSD AC Trigger Generation  */
-	WMI_STA_UAPSD_VAR_AUTO_TRIG,      /* -do- */
-	WMI_SERVICE_STA_KEEP_ALIVE,       /* STA keep alive mechanism support */
-	WMI_SERVICE_TX_ENCAP,             /* Packet type for TX encapsulation */
-
-	WMI_SERVICE_LAST,
-	WMI_MAX_SERVICE = 64		  /* max service */
+enum wmi_service {
+	WMI_SERVICE_BEACON_OFFLOAD = 0,
+	WMI_SERVICE_SCAN_OFFLOAD,
+	WMI_SERVICE_ROAM_OFFLOAD,
+	WMI_SERVICE_BCN_MISS_OFFLOAD,
+	WMI_SERVICE_STA_PWRSAVE,
+	WMI_SERVICE_STA_ADVANCED_PWRSAVE,
+	WMI_SERVICE_AP_UAPSD,
+	WMI_SERVICE_AP_DFS,
+	WMI_SERVICE_11AC,
+	WMI_SERVICE_BLOCKACK,
+	WMI_SERVICE_PHYERR,
+	WMI_SERVICE_BCN_FILTER,
+	WMI_SERVICE_RTT,
+	WMI_SERVICE_RATECTRL,
+	WMI_SERVICE_WOW,
+	WMI_SERVICE_RATECTRL_CACHE,
+	WMI_SERVICE_IRAM_TIDS,
+	WMI_SERVICE_ARPNS_OFFLOAD,
+	WMI_SERVICE_NLO,
+	WMI_SERVICE_GTK_OFFLOAD,
+	WMI_SERVICE_SCAN_SCH,
+	WMI_SERVICE_CSA_OFFLOAD,
+	WMI_SERVICE_CHATTER,
+	WMI_SERVICE_COEX_FREQAVOID,
+	WMI_SERVICE_PACKET_POWER_SAVE,
+	WMI_SERVICE_FORCE_FW_HANG,
+	WMI_SERVICE_GPIO,
+	WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM,
+	WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG,
+	WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG,
+	WMI_SERVICE_STA_KEEP_ALIVE,
+	WMI_SERVICE_TX_ENCAP,
+	WMI_SERVICE_BURST,
+	WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT,
+	WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT,
+};
+
+enum wmi_10x_service {
+	WMI_10X_SERVICE_BEACON_OFFLOAD = 0,
+	WMI_10X_SERVICE_SCAN_OFFLOAD,
+	WMI_10X_SERVICE_ROAM_OFFLOAD,
+	WMI_10X_SERVICE_BCN_MISS_OFFLOAD,
+	WMI_10X_SERVICE_STA_PWRSAVE,
+	WMI_10X_SERVICE_STA_ADVANCED_PWRSAVE,
+	WMI_10X_SERVICE_AP_UAPSD,
+	WMI_10X_SERVICE_AP_DFS,
+	WMI_10X_SERVICE_11AC,
+	WMI_10X_SERVICE_BLOCKACK,
+	WMI_10X_SERVICE_PHYERR,
+	WMI_10X_SERVICE_BCN_FILTER,
+	WMI_10X_SERVICE_RTT,
+	WMI_10X_SERVICE_RATECTRL,
+	WMI_10X_SERVICE_WOW,
+	WMI_10X_SERVICE_RATECTRL_CACHE,
+	WMI_10X_SERVICE_IRAM_TIDS,
+	WMI_10X_SERVICE_BURST,
+
+	/* introduced in 10.2 */
+	WMI_10X_SERVICE_SMART_ANTENNA_SW_SUPPORT,
+	WMI_10X_SERVICE_FORCE_FW_HANG,
+	WMI_10X_SERVICE_SMART_ANTENNA_HW_SUPPORT,
+};
+
+enum wmi_main_service {
+	WMI_MAIN_SERVICE_BEACON_OFFLOAD = 0,
+	WMI_MAIN_SERVICE_SCAN_OFFLOAD,
+	WMI_MAIN_SERVICE_ROAM_OFFLOAD,
+	WMI_MAIN_SERVICE_BCN_MISS_OFFLOAD,
+	WMI_MAIN_SERVICE_STA_PWRSAVE,
+	WMI_MAIN_SERVICE_STA_ADVANCED_PWRSAVE,
+	WMI_MAIN_SERVICE_AP_UAPSD,
+	WMI_MAIN_SERVICE_AP_DFS,
+	WMI_MAIN_SERVICE_11AC,
+	WMI_MAIN_SERVICE_BLOCKACK,
+	WMI_MAIN_SERVICE_PHYERR,
+	WMI_MAIN_SERVICE_BCN_FILTER,
+	WMI_MAIN_SERVICE_RTT,
+	WMI_MAIN_SERVICE_RATECTRL,
+	WMI_MAIN_SERVICE_WOW,
+	WMI_MAIN_SERVICE_RATECTRL_CACHE,
+	WMI_MAIN_SERVICE_IRAM_TIDS,
+	WMI_MAIN_SERVICE_ARPNS_OFFLOAD,
+	WMI_MAIN_SERVICE_NLO,
+	WMI_MAIN_SERVICE_GTK_OFFLOAD,
+	WMI_MAIN_SERVICE_SCAN_SCH,
+	WMI_MAIN_SERVICE_CSA_OFFLOAD,
+	WMI_MAIN_SERVICE_CHATTER,
+	WMI_MAIN_SERVICE_COEX_FREQAVOID,
+	WMI_MAIN_SERVICE_PACKET_POWER_SAVE,
+	WMI_MAIN_SERVICE_FORCE_FW_HANG,
+	WMI_MAIN_SERVICE_GPIO,
+	WMI_MAIN_SERVICE_STA_DTIM_PS_MODULATED_DTIM,
+	WMI_MAIN_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG,
+	WMI_MAIN_SERVICE_STA_UAPSD_VAR_AUTO_TRIG,
+	WMI_MAIN_SERVICE_STA_KEEP_ALIVE,
+	WMI_MAIN_SERVICE_TX_ENCAP,
 };
 
 static inline char *wmi_service_name(int service_id)
 {
+#define SVCSTR(x) { case x: return #x; }
 	switch (service_id) {
-	case WMI_SERVICE_BEACON_OFFLOAD:
-		return "BEACON_OFFLOAD";
-	case WMI_SERVICE_SCAN_OFFLOAD:
-		return "SCAN_OFFLOAD";
-	case WMI_SERVICE_ROAM_OFFLOAD:
-		return "ROAM_OFFLOAD";
-	case WMI_SERVICE_BCN_MISS_OFFLOAD:
-		return "BCN_MISS_OFFLOAD";
-	case WMI_SERVICE_STA_PWRSAVE:
-		return "STA_PWRSAVE";
-	case WMI_SERVICE_STA_ADVANCED_PWRSAVE:
-		return "STA_ADVANCED_PWRSAVE";
-	case WMI_SERVICE_AP_UAPSD:
-		return "AP_UAPSD";
-	case WMI_SERVICE_AP_DFS:
-		return "AP_DFS";
-	case WMI_SERVICE_11AC:
-		return "11AC";
-	case WMI_SERVICE_BLOCKACK:
-		return "BLOCKACK";
-	case WMI_SERVICE_PHYERR:
-		return "PHYERR";
-	case WMI_SERVICE_BCN_FILTER:
-		return "BCN_FILTER";
-	case WMI_SERVICE_RTT:
-		return "RTT";
-	case WMI_SERVICE_RATECTRL:
-		return "RATECTRL";
-	case WMI_SERVICE_WOW:
-		return "WOW";
-	case WMI_SERVICE_RATECTRL_CACHE:
-		return "RATECTRL CACHE";
-	case WMI_SERVICE_IRAM_TIDS:
-		return "IRAM TIDS";
-	case WMI_SERVICE_ARPNS_OFFLOAD:
-		return "ARPNS_OFFLOAD";
-	case WMI_SERVICE_NLO:
-		return "NLO";
-	case WMI_SERVICE_GTK_OFFLOAD:
-		return "GTK_OFFLOAD";
-	case WMI_SERVICE_SCAN_SCH:
-		return "SCAN_SCH";
-	case WMI_SERVICE_CSA_OFFLOAD:
-		return "CSA_OFFLOAD";
-	case WMI_SERVICE_CHATTER:
-		return "CHATTER";
-	case WMI_SERVICE_COEX_FREQAVOID:
-		return "COEX_FREQAVOID";
-	case WMI_SERVICE_PACKET_POWER_SAVE:
-		return "PACKET_POWER_SAVE";
-	case WMI_SERVICE_FORCE_FW_HANG:
-		return "FORCE FW HANG";
-	case WMI_SERVICE_GPIO:
-		return "GPIO";
-	case WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM:
-		return "MODULATED DTIM";
-	case WMI_STA_UAPSD_BASIC_AUTO_TRIG:
-		return "BASIC UAPSD";
-	case WMI_STA_UAPSD_VAR_AUTO_TRIG:
-		return "VAR UAPSD";
-	case WMI_SERVICE_STA_KEEP_ALIVE:
-		return "STA KEEP ALIVE";
-	case WMI_SERVICE_TX_ENCAP:
-		return "TX ENCAP";
+	SVCSTR(WMI_SERVICE_BEACON_OFFLOAD)
+	SVCSTR(WMI_SERVICE_SCAN_OFFLOAD)
+	SVCSTR(WMI_SERVICE_ROAM_OFFLOAD)
+	SVCSTR(WMI_SERVICE_BCN_MISS_OFFLOAD)
+	SVCSTR(WMI_SERVICE_STA_PWRSAVE)
+	SVCSTR(WMI_SERVICE_STA_ADVANCED_PWRSAVE)
+	SVCSTR(WMI_SERVICE_AP_UAPSD)
+	SVCSTR(WMI_SERVICE_AP_DFS)
+	SVCSTR(WMI_SERVICE_11AC)
+	SVCSTR(WMI_SERVICE_BLOCKACK)
+	SVCSTR(WMI_SERVICE_PHYERR)
+	SVCSTR(WMI_SERVICE_BCN_FILTER)
+	SVCSTR(WMI_SERVICE_RTT)
+	SVCSTR(WMI_SERVICE_RATECTRL)
+	SVCSTR(WMI_SERVICE_WOW)
+	SVCSTR(WMI_SERVICE_RATECTRL_CACHE)
+	SVCSTR(WMI_SERVICE_IRAM_TIDS)
+	SVCSTR(WMI_SERVICE_ARPNS_OFFLOAD)
+	SVCSTR(WMI_SERVICE_NLO)
+	SVCSTR(WMI_SERVICE_GTK_OFFLOAD)
+	SVCSTR(WMI_SERVICE_SCAN_SCH)
+	SVCSTR(WMI_SERVICE_CSA_OFFLOAD)
+	SVCSTR(WMI_SERVICE_CHATTER)
+	SVCSTR(WMI_SERVICE_COEX_FREQAVOID)
+	SVCSTR(WMI_SERVICE_PACKET_POWER_SAVE)
+	SVCSTR(WMI_SERVICE_FORCE_FW_HANG)
+	SVCSTR(WMI_SERVICE_GPIO)
+	SVCSTR(WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM)
+	SVCSTR(WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG)
+	SVCSTR(WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG)
+	SVCSTR(WMI_SERVICE_STA_KEEP_ALIVE)
+	SVCSTR(WMI_SERVICE_TX_ENCAP)
+	SVCSTR(WMI_SERVICE_BURST)
+	SVCSTR(WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT)
+	SVCSTR(WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT)
 	default:
-		return "UNKNOWN SERVICE\n";
+		return NULL;
 	}
+#undef SVCSTR
+}
+
+#define WMI_MAX_SERVICE 64
+
+#define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id) \
+	(__le32_to_cpu((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
+	 BIT((svc_id)%(sizeof(u32))))
+
+#define SVCMAP(x, y) \
+	do { \
+		if (WMI_SERVICE_IS_ENABLED((in), (x))) \
+			__set_bit(y, out); \
+	} while (0)
+
+static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out)
+{
+	SVCMAP(WMI_10X_SERVICE_BEACON_OFFLOAD,
+	       WMI_SERVICE_BEACON_OFFLOAD);
+	SVCMAP(WMI_10X_SERVICE_SCAN_OFFLOAD,
+	       WMI_SERVICE_SCAN_OFFLOAD);
+	SVCMAP(WMI_10X_SERVICE_ROAM_OFFLOAD,
+	       WMI_SERVICE_ROAM_OFFLOAD);
+	SVCMAP(WMI_10X_SERVICE_BCN_MISS_OFFLOAD,
+	       WMI_SERVICE_BCN_MISS_OFFLOAD);
+	SVCMAP(WMI_10X_SERVICE_STA_PWRSAVE,
+	       WMI_SERVICE_STA_PWRSAVE);
+	SVCMAP(WMI_10X_SERVICE_STA_ADVANCED_PWRSAVE,
+	       WMI_SERVICE_STA_ADVANCED_PWRSAVE);
+	SVCMAP(WMI_10X_SERVICE_AP_UAPSD,
+	       WMI_SERVICE_AP_UAPSD);
+	SVCMAP(WMI_10X_SERVICE_AP_DFS,
+	       WMI_SERVICE_AP_DFS);
+	SVCMAP(WMI_10X_SERVICE_11AC,
+	       WMI_SERVICE_11AC);
+	SVCMAP(WMI_10X_SERVICE_BLOCKACK,
+	       WMI_SERVICE_BLOCKACK);
+	SVCMAP(WMI_10X_SERVICE_PHYERR,
+	       WMI_SERVICE_PHYERR);
+	SVCMAP(WMI_10X_SERVICE_BCN_FILTER,
+	       WMI_SERVICE_BCN_FILTER);
+	SVCMAP(WMI_10X_SERVICE_RTT,
+	       WMI_SERVICE_RTT);
+	SVCMAP(WMI_10X_SERVICE_RATECTRL,
+	       WMI_SERVICE_RATECTRL);
+	SVCMAP(WMI_10X_SERVICE_WOW,
+	       WMI_SERVICE_WOW);
+	SVCMAP(WMI_10X_SERVICE_RATECTRL_CACHE,
+	       WMI_SERVICE_RATECTRL_CACHE);
+	SVCMAP(WMI_10X_SERVICE_IRAM_TIDS,
+	       WMI_SERVICE_IRAM_TIDS);
+	SVCMAP(WMI_10X_SERVICE_BURST,
+	       WMI_SERVICE_BURST);
+	SVCMAP(WMI_10X_SERVICE_SMART_ANTENNA_SW_SUPPORT,
+	       WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT);
+	SVCMAP(WMI_10X_SERVICE_FORCE_FW_HANG,
+	       WMI_SERVICE_FORCE_FW_HANG);
+	SVCMAP(WMI_10X_SERVICE_SMART_ANTENNA_HW_SUPPORT,
+	       WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT);
 }
 
+static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out)
+{
+	SVCMAP(WMI_MAIN_SERVICE_BEACON_OFFLOAD,
+	       WMI_SERVICE_BEACON_OFFLOAD);
+	SVCMAP(WMI_MAIN_SERVICE_SCAN_OFFLOAD,
+	       WMI_SERVICE_SCAN_OFFLOAD);
+	SVCMAP(WMI_MAIN_SERVICE_ROAM_OFFLOAD,
+	       WMI_SERVICE_ROAM_OFFLOAD);
+	SVCMAP(WMI_MAIN_SERVICE_BCN_MISS_OFFLOAD,
+	       WMI_SERVICE_BCN_MISS_OFFLOAD);
+	SVCMAP(WMI_MAIN_SERVICE_STA_PWRSAVE,
+	       WMI_SERVICE_STA_PWRSAVE);
+	SVCMAP(WMI_MAIN_SERVICE_STA_ADVANCED_PWRSAVE,
+	       WMI_SERVICE_STA_ADVANCED_PWRSAVE);
+	SVCMAP(WMI_MAIN_SERVICE_AP_UAPSD,
+	       WMI_SERVICE_AP_UAPSD);
+	SVCMAP(WMI_MAIN_SERVICE_AP_DFS,
+	       WMI_SERVICE_AP_DFS);
+	SVCMAP(WMI_MAIN_SERVICE_11AC,
+	       WMI_SERVICE_11AC);
+	SVCMAP(WMI_MAIN_SERVICE_BLOCKACK,
+	       WMI_SERVICE_BLOCKACK);
+	SVCMAP(WMI_MAIN_SERVICE_PHYERR,
+	       WMI_SERVICE_PHYERR);
+	SVCMAP(WMI_MAIN_SERVICE_BCN_FILTER,
+	       WMI_SERVICE_BCN_FILTER);
+	SVCMAP(WMI_MAIN_SERVICE_RTT,
+	       WMI_SERVICE_RTT);
+	SVCMAP(WMI_MAIN_SERVICE_RATECTRL,
+	       WMI_SERVICE_RATECTRL);
+	SVCMAP(WMI_MAIN_SERVICE_WOW,
+	       WMI_SERVICE_WOW);
+	SVCMAP(WMI_MAIN_SERVICE_RATECTRL_CACHE,
+	       WMI_SERVICE_RATECTRL_CACHE);
+	SVCMAP(WMI_MAIN_SERVICE_IRAM_TIDS,
+	       WMI_SERVICE_IRAM_TIDS);
+	SVCMAP(WMI_MAIN_SERVICE_ARPNS_OFFLOAD,
+	       WMI_SERVICE_ARPNS_OFFLOAD);
+	SVCMAP(WMI_MAIN_SERVICE_NLO,
+	       WMI_SERVICE_NLO);
+	SVCMAP(WMI_MAIN_SERVICE_GTK_OFFLOAD,
+	       WMI_SERVICE_GTK_OFFLOAD);
+	SVCMAP(WMI_MAIN_SERVICE_SCAN_SCH,
+	       WMI_SERVICE_SCAN_SCH);
+	SVCMAP(WMI_MAIN_SERVICE_CSA_OFFLOAD,
+	       WMI_SERVICE_CSA_OFFLOAD);
+	SVCMAP(WMI_MAIN_SERVICE_CHATTER,
+	       WMI_SERVICE_CHATTER);
+	SVCMAP(WMI_MAIN_SERVICE_COEX_FREQAVOID,
+	       WMI_SERVICE_COEX_FREQAVOID);
+	SVCMAP(WMI_MAIN_SERVICE_PACKET_POWER_SAVE,
+	       WMI_SERVICE_PACKET_POWER_SAVE);
+	SVCMAP(WMI_MAIN_SERVICE_FORCE_FW_HANG,
+	       WMI_SERVICE_FORCE_FW_HANG);
+	SVCMAP(WMI_MAIN_SERVICE_GPIO,
+	       WMI_SERVICE_GPIO);
+	SVCMAP(WMI_MAIN_SERVICE_STA_DTIM_PS_MODULATED_DTIM,
+	       WMI_SERVICE_STA_DTIM_PS_MODULATED_DTIM);
+	SVCMAP(WMI_MAIN_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG,
+	       WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG);
+	SVCMAP(WMI_MAIN_SERVICE_STA_UAPSD_VAR_AUTO_TRIG,
+	       WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG);
+	SVCMAP(WMI_MAIN_SERVICE_STA_KEEP_ALIVE,
+	       WMI_SERVICE_STA_KEEP_ALIVE);
+	SVCMAP(WMI_MAIN_SERVICE_TX_ENCAP,
+	       WMI_SERVICE_TX_ENCAP);
+}
+
+#undef SVCMAP
 
 #define WMI_SERVICE_BM_SIZE \
 	((WMI_MAX_SERVICE + sizeof(u32) - 1)/sizeof(u32))
@@ -1229,10 +1390,6 @@ struct wlan_host_mem_req {
 	__le32 num_units;
 } __packed;
 
-#define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id) \
-	((((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
-	(1 << ((svc_id)%(sizeof(u32))))) != 0)
-
 /*
  * The following struct holds optional payload for
  * wmi_service_ready_event,e.g., 11ac pass some of the
-- 
1.8.5.3

