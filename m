Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:42930 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751558AbdFIMJC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 08:09:02 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 8/9] brcmfmac: switch to using cfg80211_connect_done()
Date: Fri,  9 Jun 2017 13:08:49 +0100
Message-Id: <1497010130-16186-9-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170609_140922_392215_B118D48B)
In-Reply-To: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver used cfg80211_connect_result() which is basically a wrapper
around cfg80211_connect_done() passing a subset of the information that
can be passed. For upcoming functionality this is not sufficient so
switching to use cfg80211_connect_done().

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index cc5b8ba..9d345c7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5537,26 +5537,28 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
+	struct cfg80211_connect_resp_params conn_params;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTING,
 			       &ifp->vif->sme_state)) {
+		memset(&conn_params, 0, sizeof(conn_params));
 		if (completed) {
 			brcmf_get_assoc_ies(cfg, ifp);
 			brcmf_update_bss_info(cfg, ifp);
 			set_bit(BRCMF_VIF_STATUS_CONNECTED,
 				&ifp->vif->sme_state);
+			conn_params.status = WLAN_STATUS_SUCCESS;
+		} else {
+			conn_params.status = WLAN_STATUS_AUTH_TIMEOUT;
 		}
-		cfg80211_connect_result(ndev,
-					(u8 *)profile->bssid,
-					conn_info->req_ie,
-					conn_info->req_ie_len,
-					conn_info->resp_ie,
-					conn_info->resp_ie_len,
-					completed ? WLAN_STATUS_SUCCESS :
-						    WLAN_STATUS_AUTH_TIMEOUT,
-					GFP_KERNEL);
+		conn_params.bssid = profile->bssid;
+		conn_params.req_ie = conn_info->req_ie;
+		conn_params.req_ie_len = conn_info->req_ie_len;
+		conn_params.resp_ie = conn_info->resp_ie;
+		conn_params.resp_ie_len = conn_info->resp_ie_len;
+		cfg80211_connect_done(ndev, &conn_params, GFP_KERNEL);
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
 	}
-- 
1.9.1
