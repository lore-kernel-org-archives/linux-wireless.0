Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36043 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbeFXTrA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 15:47:00 -0400
Received: by mail-lf0-f66.google.com with SMTP id n24-v6so12803848lfh.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 12:46:59 -0700 (PDT)
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
Subject: [PATCH V4 2/3] brcmfmac: detect firmware support for radiotap monitor frames
Date: Sun, 24 Jun 2018 21:44:36 +0200
Message-Id: <20180624194437.28766-2-zajec5@gmail.com> (sfid-20180624_214754_788066_05E2B102)
In-Reply-To: <20180624194437.28766-1-zajec5@gmail.com>
References: <20180624194437.28766-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Depending on used build-time options some firmwares may already include
radiotap header in passed monitor frames. Add a new feature flag to
store info about it. It's needed for proper handling of received frames
before passing them up.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V4: Patch extracted out of:
    [PATCH V3 2/2] brcmfmac: handle monitor mode marked msgbuf packets
    Added mapping for the "rtap" string as reported by Arend
    Updated new feature flag description as preferred by Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index a78b9bae44e0..4db4d444407a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -49,6 +49,7 @@ static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
 	{ BRCMF_FEAT_MCHAN, "mchan" },
 	{ BRCMF_FEAT_P2P, "p2p" },
 	{ BRCMF_FEAT_MONITOR, "monitor" },
+	{ BRCMF_FEAT_MONITOR_FMT_RADIOTAP, "rtap" },
 };
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 3415d5d4d6b5..0b4974df353a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -34,6 +34,7 @@
  * GSCAN: enhanced scan offload feature.
  * FWSUP: Firmware supplicant.
  * MONITOR: firmware can pass monitor packets to host.
+ * MONITOR_FMT_RADIOTAP: firmware provides monitor packets with radiotap header
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -50,7 +51,8 @@
 	BRCMF_FEAT_DEF(MFP) \
 	BRCMF_FEAT_DEF(GSCAN) \
 	BRCMF_FEAT_DEF(FWSUP) \
-	BRCMF_FEAT_DEF(MONITOR)
+	BRCMF_FEAT_DEF(MONITOR) \
+	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP)
 
 /*
  * Quirks:
-- 
2.13.7
