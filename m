Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45510 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932226AbeE3UPl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 16:15:41 -0400
Received: by mail-lf0-f68.google.com with SMTP id n3-v6so6255094lfe.12
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 13:15:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 1/3] brcmfmac: allow specifying features per firmware version
Date: Wed, 30 May 2018 22:12:59 +0200
Message-Id: <20180530201301.4648-1-zajec5@gmail.com> (sfid-20180530_221554_632421_6F36B8CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Some features supported by firmware aren't advertised and there is no
way for a driver to query them. This includes e.g. monitor mode details.
Some firmwares support tagging monitor frames, some build radiotap
header but there is no way to detect it. Such features often depend on
used firmware compilation options.

This commit adds table that will allow specifying features like:
{ "01-abcdef01", BIT(BRCMF_FEAT_FOO) }

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Rename struct field to "feat_flags"
    Rename function to the brcmf_feat_firmware_overrides()
    Print enabled features
    Rename variable to "drv"
    Update commit message body (mention compilation time options)
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 800a423c7bc2..2712bfcb2864 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -91,6 +91,38 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
 }
 #endif /* DEBUG */
 
+struct brcmf_feat_fwfeat {
+	const char * const fwid;
+	u32 feat_flags;
+};
+
+static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
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
@@ -251,6 +283,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	}
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 
+	brcmf_feat_firmware_overrides(drvr);
+
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43236_CHIP_ID:
-- 
2.13.6
