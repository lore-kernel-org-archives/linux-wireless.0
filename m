Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:52581 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932906AbcKOCjZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 21:39:25 -0500
Date: Tue, 15 Nov 2016 10:23:22 +0800
From: Wright Feng <wefe@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, pieterpg@broadcom.com,
        kvalo@codeaurora.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Chi-Hsien Lin <chln@cypress.com>,
        wright.feng@cypress.com
Subject: [PATCH] brcmfmac: update beacon IE when bss up and clear when stopped
Message-ID: <20161115022322.GA5611@cypress.com> (sfid-20161115_033930_253202_7C0366A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware doesn't update beacon vendor IEs when bss is down, so move brcmf_config_ap_mgmt_ie after BSS up. And host driver should clear IEs when AP stopped so that the IEs in host side will be synced with in firmware side.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b777e1b..d022605 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4578,8 +4578,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_configure_opensecurity(ifp);
 	}
 
-	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
-
 	/* Parameters shared by all radio interfaces */
 	if (!mbss) {
 		if ((supports_11d) && (is_11d != ifp->vif->is_11d)) {
@@ -4708,6 +4706,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WARN_ON(1);
 	}
 
+	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
 	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 	brcmf_net_setcarrier(ifp, true);
 
@@ -4764,6 +4763,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0)
 			brcmf_err("BRCMF_C_UP error %d\n", err);
+
+		brcmf_vif_clear_mgmt_ies(ifp->vif);
 	} else {
 		bss_enable.bsscfgidx = cpu_to_le32(ifp->bsscfgidx);
 		bss_enable.enable = cpu_to_le32(0);
-- 
2.1.0
