Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34701 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966826AbcAZQ5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:57:30 -0500
Received: by mail-lf0-f51.google.com with SMTP id 17so109173175lfz.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 08:57:29 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] brcmfmac: read extended capabilities of ChipCommon core
Date: Tue, 26 Jan 2016 17:57:03 +0100
Message-Id: <1453827425-16455-4-git-send-email-zajec5@gmail.com> (sfid-20160126_175739_485484_2388664F)
In-Reply-To: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
References: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an extra bitfield with info about some present hardware.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 55952d4..f4a4d00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1025,6 +1025,9 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 	/* get chipcommon capabilites */
 	pub->cc_caps = chip->ops->read32(chip->ctx,
 					 CORE_CC_REG(base, capabilities));
+	pub->cc_caps_ext = chip->ops->read32(chip->ctx,
+					     CORE_CC_REG(base,
+							 capabilities_ext));
 
 	/* get pmu caps & rev */
 	if (pub->cc_caps & CC_CAP_PMU) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
index f6b5fee..cb9145f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
@@ -27,6 +27,7 @@
  * @chip: chip identifier.
  * @chiprev: chip revision.
  * @cc_caps: chipcommon core capabilities.
+ * @cc_caps_ext: chipcommon core extended capabilities.
  * @pmucaps: PMU capabilities.
  * @pmurev: PMU revision.
  * @rambase: RAM base address (only applicable for ARM CR4 chips).
@@ -38,6 +39,7 @@ struct brcmf_chip {
 	u32 chip;
 	u32 chiprev;
 	u32 cc_caps;
+	u32 cc_caps_ext;
 	u32 pmucaps;
 	u32 pmurev;
 	u32 rambase;
-- 
1.8.4.5

