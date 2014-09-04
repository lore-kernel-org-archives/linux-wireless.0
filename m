Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39714 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaIDI30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 04:29:26 -0400
Received: by mail-lb0-f182.google.com with SMTP id u10so11116251lbd.13
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 01:29:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: use proper service bitmap size
Date: Thu,  4 Sep 2014 10:18:32 +0200
Message-Id: <1409818712-7493-1-git-send-email-michal.kazior@tieto.com> (sfid-20140904_102931_981409_51F2415F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 32bit systems the bitmap was too small and it
was overwritten partially by the stat completion
structure. This was visible with 10.2 firmware
only due to it using a few of the last service
ids.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c   |  4 ++--
 drivers/net/wireless/ath/ath10k/wmi.h   | 12 +++++-------
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 797741d..a2695e3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -293,7 +293,7 @@ struct ath10k_debug {
 	struct dentry *debugfs_phy;
 
 	struct ath10k_target_stats target_stats;
-	DECLARE_BITMAP(wmi_service_bitmap, WMI_SERVICE_BM_SIZE);
+	DECLARE_BITMAP(wmi_service_bitmap, WMI_SERVICE_MAX);
 
 	struct completion event_stats_compl;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index d922ef4..e487064 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -208,7 +208,7 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 	if (len > buf_len)
 		len = buf_len;
 
-	for (i = 0; i < WMI_MAX_SERVICE; i++) {
+	for (i = 0; i < WMI_SERVICE_MAX; i++) {
 		enabled = test_bit(i, ar->debug.wmi_service_bitmap);
 		name = wmi_service_name(i);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b13ccf6..e7edc89 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2164,7 +2164,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
 	struct wmi_service_ready_event *ev = (void *)skb->data;
-	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_BM_SIZE) = {};
+	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_MAX) = {};
 
 	if (skb->len < sizeof(*ev)) {
 		ath10k_warn(ar, "Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
@@ -2241,7 +2241,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
 	int ret;
 	struct wmi_service_ready_event_10x *ev = (void *)skb->data;
-	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_BM_SIZE) = {};
+	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_MAX) = {};
 
 	if (skb->len < sizeof(*ev)) {
 		ath10k_warn(ar, "Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e708365..bdb2e6c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -109,6 +109,9 @@ enum wmi_service {
 	WMI_SERVICE_BURST,
 	WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT,
 	WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT,
+
+	/* keep last */
+	WMI_SERVICE_MAX,
 };
 
 enum wmi_10x_service {
@@ -219,8 +222,6 @@ static inline char *wmi_service_name(int service_id)
 #undef SVCSTR
 }
 
-#define WMI_MAX_SERVICE 64
-
 #define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id) \
 	(__le32_to_cpu((wmi_svc_bmap)[(svc_id)/(sizeof(u32))]) & \
 	 BIT((svc_id)%(sizeof(u32))))
@@ -347,9 +348,6 @@ static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out)
 
 #undef SVCMAP
 
-#define WMI_SERVICE_BM_SIZE \
-	((WMI_MAX_SERVICE + sizeof(u32) - 1)/sizeof(u32))
-
 /* 2 word representation of MAC addr */
 struct wmi_mac_addr {
 	union {
@@ -1405,7 +1403,7 @@ struct wmi_service_ready_event {
 	__le32 phy_capability;
 	/* Maximum number of frag table entries that SW will populate less 1 */
 	__le32 max_frag_entry;
-	__le32 wmi_service_bitmap[WMI_SERVICE_BM_SIZE];
+	__le32 wmi_service_bitmap[16];
 	__le32 num_rf_chains;
 	/*
 	 * The following field is only valid for service type
@@ -1444,7 +1442,7 @@ struct wmi_service_ready_event_10x {
 
 	/* Maximum number of frag table entries that SW will populate less 1 */
 	__le32 max_frag_entry;
-	__le32 wmi_service_bitmap[WMI_SERVICE_BM_SIZE];
+	__le32 wmi_service_bitmap[16];
 	__le32 num_rf_chains;
 
 	/*
-- 
1.8.5.3

