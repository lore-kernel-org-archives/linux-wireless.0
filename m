Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4580 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758088Ab3DDKK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 06:10:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.9 2/2] brcmfmac: remove advertising P2P device
 support
Date: Thu, 4 Apr 2013 12:10:11 +0200
Message-ID: <1365070211-26308-3-git-send-email-arend@broadcom.com> (sfid-20130404_121032_979787_9385F1A8)
In-Reply-To: <1365070211-26308-1-git-send-email-arend@broadcom.com>
References: <1365070211-26308-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For v3.9 kernel the P2P functionality was merged, but it does
not fully support the P2P_DEVICE interface type. This patch
removes advertising that support.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index ec46fff..78da3ef 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4128,10 +4128,6 @@ static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
 	},
 	{
 		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
-	},
-	{
-		.max = 1,
 		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			 BIT(NL80211_IFTYPE_P2P_GO)
 	},
@@ -4187,8 +4183,7 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 				 BIT(NL80211_IFTYPE_ADHOC) |
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				 BIT(NL80211_IFTYPE_P2P_GO) |
-				 BIT(NL80211_IFTYPE_P2P_DEVICE);
+				 BIT(NL80211_IFTYPE_P2P_GO);
 	wiphy->iface_combinations = brcmf_iface_combos;
 	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
-- 
1.7.10.4


