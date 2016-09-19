Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58953 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933190AbcISLKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:14 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/9] brcmfmac: ignore 11d configuration errors
Date: Mon, 19 Sep 2016 12:09:51 +0100
Message-Id: <1474283399-14385-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131031_633757_D52A5553)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

802.11d is not always supported by firmware anymore. Currently the
AP configuration of 11d will cause an abort if the ioctl set is
failing. This behavior is not correct and the error should be
ignored.

Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 27 ++++++++++++----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 201a980..c3b8f59 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4502,6 +4502,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	u16 chanspec = chandef_to_chanspec(&cfg->d11inf, &settings->chandef);
 	bool mbss;
 	int is_11d;
+	bool supports_11d;
 
 	brcmf_dbg(TRACE, "ctrlchn=%d, center=%d, bw=%d, beacon_interval=%d, dtim_period=%d,\n",
 		  settings->chandef.chan->hw_value,
@@ -4514,11 +4515,16 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	mbss = ifp->vif->mbss;
 
 	/* store current 11d setting */
-	brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_REGULATORY, &ifp->vif->is_11d);
-	country_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
-				      settings->beacon.tail_len,
-				      WLAN_EID_COUNTRY);
-	is_11d = country_ie ? 1 : 0;
+	if (brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_REGULATORY,
+				  &ifp->vif->is_11d)) {
+		supports_11d = false;
+	} else {
+		country_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
+					      settings->beacon.tail_len,
+					      WLAN_EID_COUNTRY);
+		is_11d = country_ie ? 1 : 0;
+		supports_11d = true;
+	}
 
 	memset(&ssid_le, 0, sizeof(ssid_le));
 	if (settings->ssid == NULL || settings->ssid_len == 0) {
@@ -4577,7 +4583,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 	/* Parameters shared by all radio interfaces */
 	if (!mbss) {
-		if (is_11d != ifp->vif->is_11d) {
+		if ((supports_11d) && (is_11d != ifp->vif->is_11d)) {
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
 						    is_11d);
 			if (err < 0) {
@@ -4619,7 +4625,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("SET INFRA error %d\n", err);
 			goto exit;
 		}
-	} else if (WARN_ON(is_11d != ifp->vif->is_11d)) {
+	} else if (WARN_ON(supports_11d && (is_11d != ifp->vif->is_11d))) {
 		/* Multiple-BSS should use same 11d configuration */
 		err = -EINVAL;
 		goto exit;
@@ -4753,11 +4759,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 			brcmf_err("setting INFRA mode failed %d\n", err);
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
 			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
-					    ifp->vif->is_11d);
-		if (err < 0)
-			brcmf_err("restoring REGULATORY setting failed %d\n",
-				  err);
+		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
+				      ifp->vif->is_11d);
 		/* Bring device back up so it can be used again */
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0)
-- 
1.9.1
