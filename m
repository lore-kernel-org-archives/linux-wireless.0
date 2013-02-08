Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4651 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760207Ab3BHO4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:42 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 22/27] brcmfmac: Update netdev configuration in wiphy
 for p2p.
Date: Fri, 8 Feb 2013 15:53:57 +0100
Message-ID: <1360335242-12608-23-git-send-email-arend@broadcom.com> (sfid-20130208_163815_862836_F66CD596)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Wiphy object holds information about possible netdev
combinations which can be supported. This needs updating for
p2p device. Also p2p device netdev has wrong 80211 iftype.
Limit the change interface support to match the netdev
configuration/combination possibilities.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c         |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 9f87a85..fd09074 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1320,7 +1320,7 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
 	p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif = pri_ifp->vif;
 
 	if (p2p_ifp) {
-		p2p_vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_STATION,
+		p2p_vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_P2P_DEVICE,
 					  false);
 		if (IS_ERR(p2p_vif)) {
 			brcmf_err("could not create discovery vif\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index cba2f34..e7ef827 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4163,20 +4163,24 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 
 static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
 	{
-		.max = 1,
+		.max = 2,
 		.types = BIT(NL80211_IFTYPE_STATION) |
 			 BIT(NL80211_IFTYPE_ADHOC) |
 			 BIT(NL80211_IFTYPE_AP)
 	},
 	{
 		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
+	},
+	{
+		.max = 1,
 		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			 BIT(NL80211_IFTYPE_P2P_GO)
 	},
 };
 static const struct ieee80211_iface_combination brcmf_iface_combos[] = {
 	{
-		 .max_interfaces = BRCMF_IFACE_MAX_CNT - 1,
+		 .max_interfaces = BRCMF_IFACE_MAX_CNT,
 		 .num_different_channels = 1, /* no multi-channel for now */
 		 .n_limits = ARRAY_SIZE(brcmf_iface_limits),
 		 .limits = brcmf_iface_limits
@@ -4225,7 +4229,8 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 				 BIT(NL80211_IFTYPE_ADHOC) |
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				 BIT(NL80211_IFTYPE_P2P_GO);
+				 BIT(NL80211_IFTYPE_P2P_GO) |
+				 BIT(NL80211_IFTYPE_P2P_DEVICE);
 	wiphy->iface_combinations = brcmf_iface_combos;
 	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
-- 
1.7.10.4


