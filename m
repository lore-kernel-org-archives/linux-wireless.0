Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41624 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbeFXTqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 15:46:54 -0400
Received: by mail-lj1-f195.google.com with SMTP id v12-v6so4451335ljj.8
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 12:46:54 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V4 1/3] brcmfmac: detect firmware support for monitor interface
Date: Sun, 24 Jun 2018 21:44:35 +0200
Message-Id: <20180624194437.28766-1-zajec5@gmail.com> (sfid-20180624_214754_242705_EF42846D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Many/most of firmwares support creating monitor interface but only the
most recent ones explicitly /announce/ it using a "monitor" entry in the
list of capabilities.

Check for that entry and store internally info about monitor mode
support using a new feature flag. Once we sort out all details of
handling monitor interface it will be used when reporting available
interfaces to the cfg80211.

Later some fallback detecion method may be added for older firmwares.
For now just stick to the "monitor" capability which should be 100%
reliable.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V3: Patch added to the series
V4: Dropped fallback code as it was reported to be incorrect
    Updated new feature flag description as preferred by Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 800a423c7bc2..a78b9bae44e0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -48,6 +48,7 @@ static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
 	{ BRCMF_FEAT_MBSS, "mbss" },
 	{ BRCMF_FEAT_MCHAN, "mchan" },
 	{ BRCMF_FEAT_P2P, "p2p" },
+	{ BRCMF_FEAT_MONITOR, "monitor" },
 };
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index d1193825e559..3415d5d4d6b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -33,6 +33,7 @@
  * MFP: 802.11w Management Frame Protection.
  * GSCAN: enhanced scan offload feature.
  * FWSUP: Firmware supplicant.
+ * MONITOR: firmware can pass monitor packets to host.
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -48,7 +49,8 @@
 	BRCMF_FEAT_DEF(WOWL_ARP_ND) \
 	BRCMF_FEAT_DEF(MFP) \
 	BRCMF_FEAT_DEF(GSCAN) \
-	BRCMF_FEAT_DEF(FWSUP)
+	BRCMF_FEAT_DEF(FWSUP) \
+	BRCMF_FEAT_DEF(MONITOR)
 
 /*
  * Quirks:
-- 
2.13.7
