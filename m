Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:55757 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754793AbdC1I63 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 04:58:29 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.11 1/2] brcmfmac: use local iftype avoiding use-after-free of virtual interface
Date: Tue, 28 Mar 2017 09:11:30 +0100
Message-Id: <1490688691-20100-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_112615_268270_F767450F)
In-Reply-To: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A use-after-free was found using KASAN. In brcmf_p2p_del_if() the virtual
interface is removed using call to brcmf_remove_interface(). After that
the virtual interface instance has been freed and should not be referenced.
Solve this by storing the nl80211 iftype in local variable, which is used
in a couple of places anyway.

Cc: stable@vger.kernel.org # 4.10.x, 4.9.x
Reported-by: Daniel J Blueman <daniel@quora.org>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index de19c7c..85d949e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2238,14 +2238,16 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct brcmf_cfg80211_vif *vif;
+	enum nl80211_iftype iftype;
 	bool wait_for_disable = false;
 	int err;
 
 	brcmf_dbg(TRACE, "delete P2P vif\n");
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 
+	iftype = vif->wdev.iftype;
 	brcmf_cfg80211_arm_vif_event(cfg, vif);
-	switch (vif->wdev.iftype) {
+	switch (iftype) {
 	case NL80211_IFTYPE_P2P_CLIENT:
 		if (test_bit(BRCMF_VIF_STATUS_DISCONNECTING, &vif->sme_state))
 			wait_for_disable = true;
@@ -2275,7 +2277,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 					    BRCMF_P2P_DISABLE_TIMEOUT);
 
 	err = 0;
-	if (vif->wdev.iftype != NL80211_IFTYPE_P2P_DEVICE) {
+	if (iftype != NL80211_IFTYPE_P2P_DEVICE) {
 		brcmf_vif_clear_mgmt_ies(vif);
 		err = brcmf_p2p_release_p2p_if(vif);
 	}
@@ -2291,7 +2293,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	brcmf_remove_interface(vif->ifp, true);
 
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
-	if (vif->wdev.iftype != NL80211_IFTYPE_P2P_DEVICE)
+	if (iftype != NL80211_IFTYPE_P2P_DEVICE)
 		p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
 
 	return err;
-- 
1.9.1
