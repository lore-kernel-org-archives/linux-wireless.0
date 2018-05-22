Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38330 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbeEVNUI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 09:20:08 -0400
Received: by mail-wr0-f194.google.com with SMTP id 94-v6so20134386wrf.5
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 06:20:07 -0700 (PDT)
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
Subject: [PATCH 1/3] brcmfmac: allow specifying features per firmware version
Date: Tue, 22 May 2018 15:18:34 +0200
Message-Id: <20180522131836.26858-1-zajec5@gmail.com> (sfid-20180522_152012_391086_1D895D1A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Some features supported by firmware aren't advertised and there is no
way for a driver to query them. This includes e.g. monitor mode details.
Some firmwares support tagging monitor frames, some build radiotap
header but there is no way to detect it.

This commit adds table that will allow specifying features like:
{ "01-abcdef01", BIT(BRCMF_FEAT_FOO) }

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 876731c57bf5..1194d31d3902 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -91,6 +91,28 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
 }
 #endif /* DEBUG */
 
+struct brcmf_feat_fwfeat {
+	const char * const fwid;
+	u32 flags;
+};
+
+static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
+};
+
+static void brcmf_feat_firmware_features(struct brcmf_pub *pub)
+{
+	const struct brcmf_feat_fwfeat *e;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(brcmf_feat_fwfeat_map); i++) {
+		e = &brcmf_feat_fwfeat_map[i];
+		if (!strcmp(e->fwid, pub->fwver)) {
+			pub->feat_flags |= e->flags;
+			break;
+		}
+	}
+}
+
 /**
  * brcmf_feat_iovar_int_get() - determine feature through iovar query.
  *
@@ -216,6 +238,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	}
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 
+	brcmf_feat_firmware_features(drvr);
+
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43236_CHIP_ID:
-- 
2.13.6
