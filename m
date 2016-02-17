Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:60898
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161098AbcBQK1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:24 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/21] brcmfmac: check for wowl support before enumerating feature flag
Date: Wed, 17 Feb 2016 11:26:52 +0100
Message-Id: <1455704830-10088-4-git-send-email-arend@broadcom.com> (sfid-20160217_112835_307006_044EB9BB)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

In some cases wiphy->wowlan could be NULL if firmware doesn't have the
support. Driver should check for support before walking down the feature
flags.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5478128..d66f08f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6594,7 +6594,8 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SCAN_RANDOM_MAC)) {
 		wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR;
 #ifdef CONFIG_PM
-		if (wiphy->wowlan->flags & WIPHY_WOWLAN_NET_DETECT)
+		if (wiphy->wowlan &&
+		    wiphy->wowlan->flags & WIPHY_WOWLAN_NET_DETECT)
 			wiphy->features |= NL80211_FEATURE_ND_RANDOM_MAC_ADDR;
 #endif
 	}
-- 
1.9.1

