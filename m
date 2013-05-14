Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4518 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab3ENSwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 14:52:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] brcmfmac: announce P2P_DEVICE support in wiphy
 structure
Date: Tue, 14 May 2013 20:52:36 +0200
Message-ID: <1368557556-2957-1-git-send-email-arend@broadcom.com> (sfid-20130514_205257_319276_2986A14C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P2P_DEVICE support was removed from brcmfmac for v3.9 kernel with
the commit below:

commit 1527c343c12f3a2aae532aa881d12c6fbf8749f4
Author: Arend van Spriel <arend@broadcom.com>
Date:   Thu Apr 4 12:10:11 2013 +0200

    brcmfmac: remove advertising P2P device support

However, it got merged into wireless-next. But for 3.10 brcmfmac does
support P2P device. Putting it back with this commit.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Got started with 3.10-rc1 and found this 3.9 patch got merged.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6d758f2..761f501 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4140,6 +4140,10 @@ static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
 		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			 BIT(NL80211_IFTYPE_P2P_GO)
 	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
+	}
 };
 static const struct ieee80211_iface_combination brcmf_iface_combos[] = {
 	{
@@ -4197,7 +4201,8 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
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


