Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:38252 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966469AbeFSPuw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 11:50:52 -0400
Received: by mail-lf0-f67.google.com with SMTP id i83-v6so246462lfh.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 08:50:51 -0700 (PDT)
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
Subject: [PATCH V3 1/2] brcmfmac: detect firmware support for monitor interface
Date: Tue, 19 Jun 2018 17:48:08 +0200
Message-Id: <20180619154809.25698-2-zajec5@gmail.com> (sfid-20180619_175056_480872_B0806B16)
In-Reply-To: <20180619154809.25698-1-zajec5@gmail.com>
References: <20180619154809.25698-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Most of firmwares support creating monitor interface. The newest ones
explicitly /announce/ it using a "monitor" entry in the list of
capabilities.

Check (and store) internally info about monitor mode support using a
new feature flag. Once we sort out all details of handling monitor
interface it will be used when reporting available interfaces to the
cfg80211.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V3: Patch added to the series
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 26 ++++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  4 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |  2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 800a423c7bc2..48d7978497b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -48,6 +48,7 @@ static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
 	{ BRCMF_FEAT_MBSS, "mbss" },
 	{ BRCMF_FEAT_MCHAN, "mchan" },
 	{ BRCMF_FEAT_P2P, "p2p" },
+	{ BRCMF_FEAT_MONITOR, "monitor" },
 };
 
 #ifdef DEBUG
@@ -91,6 +92,26 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
 }
 #endif /* DEBUG */
 
+static void brcmf_feat_cmd_int_get(struct brcmf_if *ifp, enum brcmf_feat_id id,
+				   u32 cmd)
+{
+	u32 data;
+	int err;
+
+	ifp->fwil_fwerr = true;
+
+	err = brcmf_fil_cmd_int_get(ifp, cmd, &data);
+	if (err == 0) {
+		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
+		ifp->drvr->feat_flags |= BIT(id);
+	} else {
+		brcmf_dbg(TRACE, "%s feature check failed: %d\n",
+			  brcmf_feat_names[id], err);
+	}
+
+	ifp->fwil_fwerr = false;
+}
+
 /**
  * brcmf_feat_iovar_int_get() - determine feature through iovar query.
  *
@@ -251,6 +272,11 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	}
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 
+	/* Fallback detection for older firmwares */
+	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR))
+		brcmf_feat_cmd_int_get(ifp, BRCMF_FEAT_MONITOR,
+				       BRCMF_C_GET_MONITOR);
+
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43236_CHIP_ID:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index d1193825e559..6eddb19ca48d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -33,6 +33,7 @@
  * MFP: 802.11w Management Frame Protection.
  * GSCAN: enhanced scan offload feature.
  * FWSUP: Firmware supplicant.
+ * MONITOR: monitor interface
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
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
index 63b1287e2e6d..0d9492fd758d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
@@ -60,6 +60,8 @@
 #define BRCMF_C_GET_PM				85
 #define BRCMF_C_SET_PM				86
 #define BRCMF_C_GET_REVINFO			98
+#define BRCMF_C_GET_MONITOR			107
+#define BRCMF_C_SET_MONITOR			108
 #define BRCMF_C_GET_CURR_RATESET		114
 #define BRCMF_C_GET_AP				117
 #define BRCMF_C_SET_AP				118
-- 
2.13.7
