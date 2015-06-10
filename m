Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:25612 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbbFJWMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:12:32 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/7] brcmfmac: Check if firmware supports p2p
Date: Thu, 11 Jun 2015 00:12:17 +0200
Message-ID: <1433974343-16982-2-git-send-email-arend@broadcom.com> (sfid-20150611_001245_760624_001CCD08)
In-Reply-To: <1433974343-16982-1-git-send-email-arend@broadcom.com>
References: <1433974343-16982-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontusf@broadcom.com>

Add a feature flag to reflect the firmware's p2p capability.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Pontus Fuchs <pontusf@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/feature.c | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 2c5fad3..1e94e94 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -129,6 +129,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
 	if (drvr->bus_if->chip != BRCM_CC_43362_CHIP_ID)
 		brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_P2P, "p2p");
 
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
index 5469625..6b381f7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
@@ -23,12 +23,14 @@
  * MCHAN: multi-channel for concurrent P2P.
  * PNO: preferred network offload.
  * WOWL: Wake-On-WLAN.
+ * P2P: peer-to-peer
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
 	BRCMF_FEAT_DEF(MCHAN) \
 	BRCMF_FEAT_DEF(PNO) \
-	BRCMF_FEAT_DEF(WOWL)
+	BRCMF_FEAT_DEF(WOWL) \
+	BRCMF_FEAT_DEF(P2P)
 /*
  * Quirks:
  *
-- 
1.9.1

