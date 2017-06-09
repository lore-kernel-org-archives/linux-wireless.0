Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:42929 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751598AbdFIMJC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 08:09:02 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 9/9] brcmfmac: provide port authorized state in CONNECT event
Date: Fri,  9 Jun 2017 13:08:50 +0100
Message-Id: <1497010130-16186-10-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170609_140922_041039_D14F33AF)
In-Reply-To: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fill struct cfg80211_connection_params::authorized field according
the supplicant state received from the device.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 27 +++++++++++++---------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 9d345c7..0e45993 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5327,10 +5327,12 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
 	u32 event = e->event_code;
 	u32 status = e->status;
 
-	if (vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_PSK &&
-	    event == BRCMF_E_PSK_SUP &&
-	    status == BRCMF_E_STATUS_FWSUP_COMPLETED)
+	if (event == BRCMF_E_PSK_SUP &&
+	    status == BRCMF_E_STATUS_FWSUP_COMPLETED) {
 		set_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
+		if (vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_1X)
+			return true;
+	}
 	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
 		brcmf_dbg(CONN, "Processing set ssid\n");
 		memcpy(vif->profile.bssid, e->addr, ETH_ALEN);
@@ -5341,11 +5343,9 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
 	}
 
 	if (test_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state) &&
-	    test_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state)) {
-		clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
-		clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state);
+	    test_and_clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state))
 		return true;
-	}
+
 	return false;
 }
 
@@ -5542,22 +5542,27 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTING,
-			       &ifp->vif->sme_state)) {
+			       &ifp->vif->sme_state) ||
+	    e->event_code == BRCMF_E_PSK_SUP) {
 		memset(&conn_params, 0, sizeof(conn_params));
-		if (completed) {
+		if (e->event_code != BRCMF_E_PSK_SUP && completed) {
 			brcmf_get_assoc_ies(cfg, ifp);
 			brcmf_update_bss_info(cfg, ifp);
 			set_bit(BRCMF_VIF_STATUS_CONNECTED,
 				&ifp->vif->sme_state);
+		}
+		if (completed)
 			conn_params.status = WLAN_STATUS_SUCCESS;
-		} else {
+		else
 			conn_params.status = WLAN_STATUS_AUTH_TIMEOUT;
-		}
 		conn_params.bssid = profile->bssid;
 		conn_params.req_ie = conn_info->req_ie;
 		conn_params.req_ie_len = conn_info->req_ie_len;
 		conn_params.resp_ie = conn_info->resp_ie;
 		conn_params.resp_ie_len = conn_info->resp_ie_len;
+		conn_params.authorized =
+			test_and_clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS,
+					   &ifp->vif->sme_state);
 		cfg80211_connect_done(ndev, &conn_params, GFP_KERNEL);
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
-- 
1.9.1
