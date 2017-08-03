Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:54371 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdHCJe1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:34:27 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com
Subject: [PATCH v2 3/3] brcmfmac: fix wrong num_different_channels when mchan feature enabled
Date: Thu,  3 Aug 2017 17:37:59 +0800
Message-Id: <1501753079-1758-3-git-send-email-wright.feng@cypress.com> (sfid-20170803_113439_719025_58411D30)
In-Reply-To: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmfmac: fix wrong num_different_channels when mchan feature enabled

When the device/firmware supports multi-channel, it can have P2P
connection and regular connection with AP simultaneous. In this case,
the num_different_channels in wiphy info was not correct when firmware
supports multi-channel (The iw wiphy# info showed "#channels <= 1" in 
interface combinations). It caused association failed and error message
"CTRL-EVENT-FREQ-CONFLICT error" in wpa_supplicant when P2P GO interface
was running at the same time.
The root cause is that the num_different_channels was always overridden
to 1 in brcmf_setup_ifmodes even multi-channel was enabled.
We correct the logic by moving num_different_channels setting forward.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v2: Describe the motivation and reason for this patch in commit message
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 0281a22..0bb3b0b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6315,6 +6315,8 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 	if (p2p) {
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
 			combo[c].num_different_channels = 2;
+		else
+			combo[c].num_different_channels = 1;
 		wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_CLIENT) |
 					  BIT(NL80211_IFTYPE_P2P_GO) |
 					  BIT(NL80211_IFTYPE_P2P_DEVICE);
@@ -6324,10 +6326,10 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
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
