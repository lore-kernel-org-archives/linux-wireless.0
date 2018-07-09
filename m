Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41839 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754200AbeGIE4V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 00:56:21 -0400
Received: by mail-lj1-f195.google.com with SMTP id y17-v6so8270021ljy.8
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2018 21:56:20 -0700 (PDT)
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
Subject: [PATCH V2] brcmfmac: specify some features per firmware version
Date: Mon,  9 Jul 2018 06:55:43 +0200
Message-Id: <20180709045543.15031-1-zajec5@gmail.com> (sfid-20180709_065628_696156_16D7A37F)
In-Reply-To: <20180704203130.12086-1-zajec5@gmail.com>
References: <20180704203130.12086-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Some features supported by firmware aren't advertised and there is no
way for a driver to query them. This includes e.g. monitor mode details.

Most firmwares support monitor interface but only the latest ones
/announce/ it with a "monitor" flag in the "cap" iovar. There isn't any
reliable detection method for older firmwares (BRCMF_C_MONITOR was tried
but "it only indicates the core part of the stack supports").

Similarly support for tagging monitor frames and building radiotap
headers can't be reliably detected for all firmwares.

This commit adds table that allows mapping features to firmware version.
It adds mappings for 43602a1 and 4366b1 firmwares from
linux-firmware.git. Both were confirmed to be passing monitor frames.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Added "commit" word when specifying SHAs. Thanks Arend!
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 4db4d444407a..8347da632a5b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -93,6 +93,42 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
 }
 #endif /* DEBUG */
 
+struct brcmf_feat_fwfeat {
+	const char * const fwid;
+	u32 feat_flags;
+};
+
+static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
+	/* brcmfmac43602-pcie.ap.bin from linux-firmware.git commit ea1178515b88 */
+	{ "01-6cb8e269", BIT(BRCMF_FEAT_MONITOR) },
+	/* brcmfmac4366b-pcie.bin from linux-firmware.git commit 52442afee990 */
+	{ "01-c47a91a4", BIT(BRCMF_FEAT_MONITOR) },
+};
+
+static void brcmf_feat_firmware_overrides(struct brcmf_pub *drv)
+{
+	const struct brcmf_feat_fwfeat *e;
+	u32 feat_flags = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(brcmf_feat_fwfeat_map); i++) {
+		e = &brcmf_feat_fwfeat_map[i];
+		if (!strcmp(e->fwid, drv->fwver)) {
+			feat_flags = e->feat_flags;
+			break;
+		}
+	}
+
+	if (!feat_flags)
+		return;
+
+	for (i = 0; i < BRCMF_FEAT_LAST; i++)
+		if (feat_flags & BIT(i))
+			brcmf_dbg(INFO, "enabling firmware feature: %s\n",
+				  brcmf_feat_names[i]);
+	drv->feat_flags |= feat_flags;
+}
+
 /**
  * brcmf_feat_iovar_int_get() - determine feature through iovar query.
  *
@@ -253,6 +289,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	}
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 
+	brcmf_feat_firmware_overrides(drvr);
+
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43236_CHIP_ID:
-- 
2.13.7
