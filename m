Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62135 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaI3IXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: On scan timeout do send received results.
Date: Tue, 30 Sep 2014 10:23:13 +0200
Message-ID: <1412065398-14316-2-git-send-email-arend@broadcom.com> (sfid-20140930_102333_630901_3E1CE40E)
In-Reply-To: <1412065398-14316-1-git-send-email-arend@broadcom.com>
References: <1412065398-14316-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Increase driver scan timeout from 8 to 10 seconds and report results
to cfg80211. Without this patch the already received results were
dropped on driver timeout.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 8 +++-----
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h | 3 +--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 12a60ca..6860501 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2426,7 +2426,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 	s32 err = 0;
 	int i;
 
-	bss_list = cfg->bss_list;
+	bss_list = (struct brcmf_scan_results *)cfg->escan_info.escan_buf;
 	if (bss_list->count != 0 &&
 	    bss_list->version != BRCMF_BSS_INFO_VERSION) {
 		brcmf_err("Version %d != WL_BSS_INFO_VERSION\n",
@@ -2602,6 +2602,7 @@ static void brcmf_cfg80211_escan_timeout_worker(struct work_struct *work)
 			container_of(work, struct brcmf_cfg80211_info,
 				     escan_timeout_work);
 
+	brcmf_inform_bss(cfg);
 	brcmf_notify_escan_complete(cfg, cfg->escan_info.ifp, true, true);
 }
 
@@ -2740,12 +2741,9 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		if (brcmf_p2p_scan_finding_common_channel(cfg, NULL))
 			goto exit;
 		if (cfg->scan_request) {
-			cfg->bss_list = (struct brcmf_scan_results *)
-				cfg->escan_info.escan_buf;
 			brcmf_inform_bss(cfg);
 			aborted = status != BRCMF_E_STATUS_SUCCESS;
-			brcmf_notify_escan_complete(cfg, ifp, aborted,
-						    false);
+			brcmf_notify_escan_complete(cfg, ifp, aborted, false);
 		} else
 			brcmf_dbg(SCAN, "Ignored scan complete result 0x%x\n",
 				  status);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index f9fb109..82f8778 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -35,7 +35,7 @@
 #define WL_SCAN_PASSIVE_TIME		120
 
 #define WL_ESCAN_BUF_SIZE		(1024 * 64)
-#define WL_ESCAN_TIMER_INTERVAL_MS	8000 /* E-Scan timeout */
+#define WL_ESCAN_TIMER_INTERVAL_MS	10000 /* E-Scan timeout */
 
 #define WL_ESCAN_ACTION_START		1
 #define WL_ESCAN_ACTION_CONTINUE	2
@@ -371,7 +371,6 @@ struct brcmf_cfg80211_info {
 	struct brcmf_btcoex_info *btcoex;
 	struct cfg80211_scan_request *scan_request;
 	struct mutex usr_sync;
-	struct brcmf_scan_results *bss_list;
 	struct brcmf_cfg80211_scan_req scan_req_int;
 	struct wl_cfg80211_bss_info *bss_info;
 	struct brcmf_cfg80211_ie ie;
-- 
1.9.1

