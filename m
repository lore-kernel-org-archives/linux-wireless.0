Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:18110
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161101AbcBQK1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:24 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/21] brcmfmac: Limit memory allocs to <64K
Date: Wed, 17 Feb 2016 11:26:51 +0100
Message-Id: <1455704830-10088-3-git-send-email-arend@broadcom.com> (sfid-20160217_112740_931178_D94B07EF)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Some systems have problems with allocating memory allocation larger
then 64K. Often on unload/load or suspend/resume a failure is
reported: Could not allocate wiphy device. This patch makes the
escan intermediate storage buf dynamically allocated, and smaller
than 64K.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 18 +++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.h    | 11 ++++++-----
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5a4a0c4..5478128 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1125,7 +1125,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 
 	/* Arm scan timeout timer */
 	mod_timer(&cfg->escan_timeout, jiffies +
-			WL_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
+			BRCMF_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
 
 	return 0;
 
@@ -3020,7 +3020,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 
 		list = (struct brcmf_scan_results *)
 				cfg->escan_info.escan_buf;
-		if (bi_length > WL_ESCAN_BUF_SIZE - list->buflen) {
+		if (bi_length > BRCMF_ESCAN_BUF_SIZE - list->buflen) {
 			brcmf_err("Buffer is too small: ignoring\n");
 			goto exit;
 		}
@@ -3033,8 +3033,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 							  bss_info_le))
 				goto exit;
 		}
-		memcpy(&(cfg->escan_info.escan_buf[list->buflen]),
-			bss_info_le, bi_length);
+		memcpy(&cfg->escan_info.escan_buf[list->buflen], bss_info_le,
+		       bi_length);
 		list->version = le32_to_cpu(bss_info_le->version);
 		list->buflen += bi_length;
 		list->count++;
@@ -5402,14 +5402,14 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
 {
 	kfree(cfg->conf);
 	cfg->conf = NULL;
-	kfree(cfg->escan_ioctl_buf);
-	cfg->escan_ioctl_buf = NULL;
 	kfree(cfg->extra_buf);
 	cfg->extra_buf = NULL;
 	kfree(cfg->wowl.nd);
 	cfg->wowl.nd = NULL;
 	kfree(cfg->wowl.nd_info);
 	cfg->wowl.nd_info = NULL;
+	kfree(cfg->escan_info.escan_buf);
+	cfg->escan_info.escan_buf = NULL;
 }
 
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
@@ -5417,9 +5417,6 @@ static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
 	cfg->conf = kzalloc(sizeof(*cfg->conf), GFP_KERNEL);
 	if (!cfg->conf)
 		goto init_priv_mem_out;
-	cfg->escan_ioctl_buf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
-	if (!cfg->escan_ioctl_buf)
-		goto init_priv_mem_out;
 	cfg->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (!cfg->extra_buf)
 		goto init_priv_mem_out;
@@ -5431,6 +5428,9 @@ static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
 				    GFP_KERNEL);
 	if (!cfg->wowl.nd_info)
 		goto init_priv_mem_out;
+	cfg->escan_info.escan_buf = kzalloc(BRCMF_ESCAN_BUF_SIZE, GFP_KERNEL);
+	if (!cfg->escan_info.escan_buf)
+		goto init_priv_mem_out;
 
 	return 0;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 97c327d..01f096f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -28,8 +28,11 @@
 #define WL_ROAM_TRIGGER_LEVEL		-75
 #define WL_ROAM_DELTA			20
 
-#define WL_ESCAN_BUF_SIZE		(1024 * 64)
-#define WL_ESCAN_TIMER_INTERVAL_MS	10000 /* E-Scan timeout */
+/* Keep BRCMF_ESCAN_BUF_SIZE below 64K (65536). Allocing over 64K can be
+ * problematic on some systems and should be avoided.
+ */
+#define BRCMF_ESCAN_BUF_SIZE		65000
+#define BRCMF_ESCAN_TIMER_INTERVAL_MS	10000	/* E-Scan timeout */
 
 #define WL_ESCAN_ACTION_START		1
 #define WL_ESCAN_ACTION_CONTINUE	2
@@ -205,7 +208,7 @@ enum wl_escan_state {
 
 struct escan_info {
 	u32 escan_state;
-	u8 escan_buf[WL_ESCAN_BUF_SIZE];
+	u8 *escan_buf;
 	struct wiphy *wiphy;
 	struct brcmf_if *ifp;
 	s32 (*run)(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
@@ -278,7 +281,6 @@ struct brcmf_cfg80211_wowl {
  * @escan_info: escan information.
  * @escan_timeout: Timer for catch scan timeout.
  * @escan_timeout_work: scan timeout worker.
- * @escan_ioctl_buf: dongle command buffer for escan commands.
  * @vif_list: linked list of vif instances.
  * @vif_cnt: number of vif instances.
  * @vif_event: vif event signalling.
@@ -309,7 +311,6 @@ struct brcmf_cfg80211_info {
 	struct escan_info escan_info;
 	struct timer_list escan_timeout;
 	struct work_struct escan_timeout_work;
-	u8 *escan_ioctl_buf;
 	struct list_head vif_list;
 	struct brcmf_cfg80211_vif_event vif_event;
 	struct completion vif_disabled;
-- 
1.9.1

