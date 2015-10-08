Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32306 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbbJHSd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/11] brcmfmac: Remove unused state AP creating.
Date: Thu, 8 Oct 2015 20:33:20 +0200
Message-ID: <1444329201-3696-11-git-send-email-arend@broadcom.com> (sfid-20151008_204654_174281_DCE1680E)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 3 ---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 1829337..ddb4e74 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -840,7 +840,6 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_p2p_ifchange(cfg, BRCMF_FIL_P2P_IF_GO);
 		}
 		if (!err) {
-			set_bit(BRCMF_VIF_STATUS_AP_CREATING, &vif->sme_state);
 			brcmf_dbg(INFO, "IF Type = AP\n");
 		}
 	} else {
@@ -4251,7 +4250,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		brcmf_dbg(TRACE, "GO mode configuration complete\n");
 	}
-	clear_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
 	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
 exit:
@@ -4316,7 +4314,6 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 	}
 	brcmf_set_mpc(ifp, 1);
 	brcmf_configure_arp_offload(ifp, true);
-	set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
 	return err;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
index 4d95c6e..6a878c8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
@@ -143,7 +143,6 @@ struct brcmf_cfg80211_profile {
  * @BRCMF_VIF_STATUS_CONNECTING: connect/join in progress.
  * @BRCMF_VIF_STATUS_CONNECTED: connected/joined succesfully.
  * @BRCMF_VIF_STATUS_DISCONNECTING: disconnect/disable in progress.
- * @BRCMF_VIF_STATUS_AP_CREATING: interface configured for AP operation.
  * @BRCMF_VIF_STATUS_AP_CREATED: AP operation started.
  */
 enum brcmf_vif_status {
@@ -151,7 +150,6 @@ enum brcmf_vif_status {
 	BRCMF_VIF_STATUS_CONNECTING,
 	BRCMF_VIF_STATUS_CONNECTED,
 	BRCMF_VIF_STATUS_DISCONNECTING,
-	BRCMF_VIF_STATUS_AP_CREATING,
 	BRCMF_VIF_STATUS_AP_CREATED
 };
 
-- 
1.9.1

