Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:56543 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753469Ab3BNBdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 20:33:32 -0500
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] brcmsmac: Remove unnecessary memset casts
Date: Wed, 13 Feb 2013 17:33:21 -0800
Message-Id: <6b2fcef4f4983542d3fd08005cfe06d7cd82e97e.1360805256.git.joe@perches.com> (sfid-20130214_023334_865971_D437B097)
In-Reply-To: <d9d111bab5b3186e858c9e85849a2ec61a7451f3.1360805256.git.joe@perches.com>
References: <d9d111bab5b3186e858c9e85849a2ec61a7451f3.1360805256.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the casts of the first argument of memset.

Neaten the style by using the sizeof the actual variable
being memset not the sizeof the type of variable.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index b3ea15e..8ef02dc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3138,8 +3138,7 @@ void brcms_c_reset(struct brcms_c_info *wlc)
 	brcms_c_statsupd(wlc);
 
 	/* reset our snapshot of macstat counters */
-	memset((char *)wlc->core->macstat_snapshot, 0,
-		sizeof(struct macstat));
+	memset(wlc->core->macstat_snapshot, 0, sizeof(struct macstat));
 
 	brcms_b_reset(wlc->hw);
 }
@@ -4052,7 +4051,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		return;
 	}
 
-	memset((char *)&acp_shm, 0, sizeof(struct shm_acparams));
+	memset(&acp_shm, 0, sizeof(struct shm_acparams));
 	/* fill in shm ac params struct */
 	acp_shm.txop = params->txop;
 	/* convert from units of 32us to us for ucode */
@@ -4768,7 +4767,7 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 	struct brcms_bss_info *bi = wlc->default_bss;
 
 	/* init default and target BSS with some sane initial values */
-	memset((char *)(bi), 0, sizeof(struct brcms_bss_info));
+	memset(bi, 0, sizeof(*bi));
 	bi->beacon_period = BEACON_INTERVAL_DEFAULT;
 
 	/* fill the default channel as the first valid channel
@@ -5297,7 +5296,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER, gmode);
 
 	/* Clear rateset override */
-	memset(&rs, 0, sizeof(struct brcms_c_rateset));
+	memset(&rs, 0, sizeof(rs));
 
 	switch (gmode) {
 	case GMODE_LEGACY_B:
@@ -5520,7 +5519,7 @@ int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs)
 	if (rs->count > BRCMS_NUMRATES)
 		return -ENOBUFS;
 
-	memset(&internal_rs, 0, sizeof(struct brcms_c_rateset));
+	memset(&internal_rs, 0, sizeof(internal_rs));
 
 	/* Copy only legacy rateset section */
 	internal_rs.count = rs->count;
@@ -5623,7 +5622,7 @@ int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
 	for (i = 0; i < BRCMS_MAXMODULES; i++) {
 		if (!strcmp(wlc->modulecb[i].name, name) &&
 		    (wlc->modulecb[i].hdl == hdl)) {
-			memset(&wlc->modulecb[i], 0, sizeof(struct modulecb));
+			memset(&wlc->modulecb[i], 0, sizeof(wlc->modulecb[i]));
 			return 0;
 		}
 	}
@@ -6678,11 +6677,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 					(struct ofdm_phy_hdr *) rts_plcp) :
 				rts_plcp[0]) << 8;
 	} else {
-		memset((char *)txh->RTSPhyHeader, 0, D11_PHY_HDR_LEN);
-		memset((char *)&txh->rts_frame, 0,
-			sizeof(struct ieee80211_rts));
-		memset((char *)txh->RTSPLCPFallback, 0,
-		      sizeof(txh->RTSPLCPFallback));
+		memset(txh->RTSPhyHeader, 0, D11_PHY_HDR_LEN);
+		memset(&txh->rts_frame, 0, sizeof(struct ieee80211_rts));
+		memset(txh->RTSPLCPFallback, 0, sizeof(txh->RTSPLCPFallback));
 		txh->RTSDurFallback = 0;
 	}
 
@@ -7324,7 +7321,7 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	*len = hdr_len + body_len;
 
 	/* format PHY and MAC headers */
-	memset((char *)buf, 0, hdr_len);
+	memset(buf, 0, hdr_len);
 
 	plcp = (struct cck_phy_hdr *) buf;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

