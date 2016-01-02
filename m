Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:57046 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbcABIlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:41:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 4/7] brcmfmac: obtain feature info using 'cap' firmware command
Date: Sat, 2 Jan 2016 09:41:39 +0100
Message-ID: <1451724102-21911-5-git-send-email-arend@broadcom.com> (sfid-20160102_094235_446609_6813F455)
In-Reply-To: <1451724102-21911-1-git-send-email-arend@broadcom.com>
References: <1451724102-21911-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several features in the driver directly map to a firmware feature
listed in response of the 'cap' firmware command. For those features
this response will be examined instead of attempting individual
firmware commands.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
V2:
 - Correct feature bitmap update for 43362.
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 53 +++++++++++++---------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index e7ac8a2..d41f343 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -42,6 +42,17 @@ static const char *brcmf_feat_names[] = {
 };
 #undef BRCMF_FEAT_DEF
 
+struct brcmf_feat_fwcap {
+	enum brcmf_feat_id feature;
+	const char * const fwcap_id;
+};
+
+static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
+	{ BRCMF_FEAT_MBSS, "mbss" },
+	{ BRCMF_FEAT_MCHAN, "mchan" },
+	{ BRCMF_FEAT_P2P, "p2p" },
+};
+
 #ifdef DEBUG
 /*
  * expand quirk list to array of quirk strings.
@@ -106,25 +117,22 @@ static void brcmf_feat_iovar_int_get(struct brcmf_if *ifp,
 	}
 }
 
-/**
- * brcmf_feat_iovar_int_set() - determine feature through iovar set.
- *
- * @ifp: interface to query.
- * @id: feature id.
- * @name: iovar name.
- */
-static void brcmf_feat_iovar_int_set(struct brcmf_if *ifp,
-				     enum brcmf_feat_id id, char *name, u32 val)
+static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 {
-	int err;
-
-	err = brcmf_fil_iovar_int_set(ifp, name, val);
-	if (err == 0) {
-		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
-		ifp->drvr->feat_flags |= BIT(id);
-	} else {
-		brcmf_dbg(TRACE, "%s feature check failed: %d\n",
-			  brcmf_feat_names[id], err);
+	char caps[256];
+	enum brcmf_feat_id id;
+	int i;
+
+	brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
+	brcmf_dbg(INFO, "[ %s]\n", caps);
+
+	for (i = 0; i < ARRAY_SIZE(brcmf_fwcap_map); i++) {
+		if (strnstr(caps, brcmf_fwcap_map[i].fwcap_id, sizeof(caps))) {
+			id = brcmf_fwcap_map[i].feature;
+			brcmf_dbg(INFO, "enabling feature: %s\n",
+				  brcmf_feat_names[id]);
+			ifp->drvr->feat_flags |= BIT(id);
+		}
 	}
 }
 
@@ -134,13 +142,14 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	struct brcmf_pno_macaddr_le pfn_mac;
 	s32 err;
 
-	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
+	brcmf_feat_firmware_capabilities(ifp);
+
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
 	if (drvr->bus_if->wowl_supported)
 		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
-	if (drvr->bus_if->chip != BRCM_CC_43362_CHIP_ID)
-		brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
-	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_P2P, "p2p");
+	/* MBSS does not work for 43362 */
+	if (drvr->bus_if->chip == BRCM_CC_43362_CHIP_ID)
+		ifp->drvr->feat_flags &= ~BIT(BRCMF_FEAT_MBSS);
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_RSDB, "rsdb_mode");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_TDLS, "tdls_enable");
 
-- 
1.9.1

