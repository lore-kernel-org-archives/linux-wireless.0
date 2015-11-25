Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1707 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbKYKcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:55 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/11] brcmfmac: Remove redundant parameter action from scan.
Date: Wed, 25 Nov 2015 11:32:41 +0100
Message-ID: <1448447567-12189-6-git-send-email-arend@broadcom.com> (sfid-20151125_115251_681144_26678697)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

ESCAN is always performed using action start scan. No need to
pass this parameter on to different functions.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |  6 +++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h |  2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      | 13 +++++--------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 49dfc00..53831f5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -946,7 +946,7 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 
 static s32
 brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
-		struct cfg80211_scan_request *request, u16 action)
+		struct cfg80211_scan_request *request)
 {
 	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
 			  offsetof(struct brcmf_escan_params_le, params_le);
@@ -971,7 +971,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 	BUG_ON(params_size + sizeof("escan") >= BRCMF_DCMD_MEDLEN);
 	brcmf_escan_prep(cfg, &params->params_le, request);
 	params->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
-	params->action = cpu_to_le16(action);
+	params->action = cpu_to_le16(WL_ESCAN_ACTION_START);
 	params->sync_id = cpu_to_le16(0x1234);
 
 	err = brcmf_fil_iovar_data_set(ifp, "escan", params, params_size);
@@ -1013,7 +1013,7 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	results->count = 0;
 	results->buflen = WL_ESCAN_RESULTS_FIXED_SIZE;
 
-	err = escan->run(cfg, ifp, request, WL_ESCAN_ACTION_START);
+	err = escan->run(cfg, ifp, request);
 	if (err)
 		brcmf_scan_config_mpc(ifp, 1);
 	return err;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 98c8920..3b3096b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -231,7 +231,7 @@ struct escan_info {
 	struct wiphy *wiphy;
 	struct brcmf_if *ifp;
 	s32 (*run)(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
-		   struct cfg80211_scan_request *request, u16 action);
+		   struct cfg80211_scan_request *request);
 };
 
 /**
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index a5902c3..b23dcbc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -625,11 +625,10 @@ exit:
  * @num_chans: number of channels to scan.
  * @chanspecs: channel parameters for @num_chans channels.
  * @search_state: P2P discover state to use.
- * @action: scan action to pass to firmware.
  * @bss_type: type of P2P bss.
  */
 static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
-			   u16 chanspecs[], s32 search_state, u16 action,
+			   u16 chanspecs[], s32 search_state,
 			   enum p2p_bss_type bss_type)
 {
 	s32 ret = 0;
@@ -738,7 +737,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 
 	/* set the escan specific parameters */
 	p2p_params->eparams.version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
-	p2p_params->eparams.action =  cpu_to_le16(action);
+	p2p_params->eparams.action =  cpu_to_le16(WL_ESCAN_ACTION_START);
 	p2p_params->eparams.sync_id = cpu_to_le16(0x1234);
 	/* perform p2p scan on primary device */
 	ret = brcmf_fil_bsscfg_data_set(vif->ifp, "p2p_scan", memblk, memsize);
@@ -762,8 +761,7 @@ exit:
  */
 static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 			       struct brcmf_if *ifp,
-			       struct cfg80211_scan_request *request,
-			       u16 action)
+			       struct cfg80211_scan_request *request)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	s32 err = 0;
@@ -823,7 +821,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 			num_nodfs++;
 		}
 		err = brcmf_p2p_escan(p2p, num_nodfs, chanspecs, search_state,
-				      action, P2PAPI_BSSCFG_DEVICE);
+				      P2PAPI_BSSCFG_DEVICE);
 		kfree(chanspecs);
 	}
 exit:
@@ -1092,8 +1090,7 @@ static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
 		default_chan_list[2] = ch.chspec;
 	}
 	err = brcmf_p2p_escan(p2p, channel_cnt, default_chan_list,
-			      WL_P2P_DISC_ST_SEARCH, WL_ESCAN_ACTION_START,
-			      P2PAPI_BSSCFG_DEVICE);
+			      WL_P2P_DISC_ST_SEARCH, P2PAPI_BSSCFG_DEVICE);
 	kfree(default_chan_list);
 exit:
 	return err;
-- 
1.9.1

