Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:32911 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdHAJje (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:39:34 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com
Subject: [PATCH 3/3] brcmfmac: fix wrong num_different_channels when mchan feature enabled
Date: Tue,  1 Aug 2017 16:48:07 +0800
Message-Id: <1501577287-28904-3-git-send-email-wright.feng@cypress.com> (sfid-20170801_113938_402105_5EF85E15)
In-Reply-To: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The num_different_channels in wiphy info is not correct when firmware
supports mchan. When mchan is on, num_different_channels is always
overridden to 1 in brcmf_setup_ifmodes. Correct the logic by moving
num_different_channels setting forward.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 54588d2..3dcb139 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6318,6 +6318,8 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 	if (p2p) {
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
 			combo[c].num_different_channels = 2;
+		else
+			combo[c].num_different_channels = 1;
 		wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_CLIENT) |
 					  BIT(NL80211_IFTYPE_P2P_GO) |
 					  BIT(NL80211_IFTYPE_P2P_DEVICE);
@@ -6327,10 +6329,10 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 		c0_limits[i++].types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				       BIT(NL80211_IFTYPE_P2P_GO);
 	} else {
+		combo[c].num_different_channels = 1;
 		c0_limits[i].max = 1;
 		c0_limits[i++].types = BIT(NL80211_IFTYPE_AP);
 	}
-	combo[c].num_different_channels = 1;
 	combo[c].max_interfaces = i;
 	combo[c].n_limits = i;
 	combo[c].limits = c0_limits;
-- 
1.9.1
