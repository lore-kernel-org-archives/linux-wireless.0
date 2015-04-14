Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:28313 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbbDNSKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:10:51 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/10] brcmfmac: make scheduled scan support conditional
Date: Tue, 14 Apr 2015 20:10:27 +0200
Message-ID: <1429035033-14076-5-git-send-email-arend@broadcom.com> (sfid-20150414_201116_948359_D74A8E92)
In-Reply-To: <1429035033-14076-1-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scheduled scan support depends on firmware supporting the PNO
feature. This feature is optional so add a feature flag for this
in the driver and announce scheduled scan support accordingly.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 84d9ab1..6fe2b75 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -5783,7 +5783,8 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
-	brcmf_wiphy_pno_params(wiphy);
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO))
+		brcmf_wiphy_pno_params(wiphy);
 
 	/* vendor commands/events support */
 	wiphy->vendor_commands = brcmf_vendor_cmds;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 7748a1c..2c5fad3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -124,6 +124,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	struct brcmf_if *ifp = drvr->iflist[0];
 
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
 	if (drvr->bus_if->wowl_supported)
 		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
 	if (drvr->bus_if->chip != BRCM_CC_43362_CHIP_ID)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
index 4bf40ff..5469625 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
@@ -21,11 +21,13 @@
  *
  * MBSS: multiple BSSID support (eg. guest network in AP mode).
  * MCHAN: multi-channel for concurrent P2P.
+ * PNO: preferred network offload.
  * WOWL: Wake-On-WLAN.
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
 	BRCMF_FEAT_DEF(MCHAN) \
+	BRCMF_FEAT_DEF(PNO) \
 	BRCMF_FEAT_DEF(WOWL)
 /*
  * Quirks:
-- 
1.9.1

