Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:37928 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbXHBPyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:54:31 -0400
Date: Thu, 02 Aug 2007 10:54:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 10/10] Port of bcm43xx from softmac to mac80211
Message-ID: <46b1fe27.MRk0xYwy9bH5VrBA%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This if file 10 of 10 of the port of the bcm43xx driver from softmac
to mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_xmit.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_xmit.c
@@ -4,11 +4,12 @@
 
   Transmission (TX/RX) related functions.
 
-  Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-                     Stefano Brivio <st3@riseup.net>
-                     Michael Buesch <mbuesch@freenet.de>
-                     Danny van Dyk <kugelfang@gentoo.org>
-                     Andreas Jaggi <andreas.jaggi@waterwave.ch>
+  Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
+  Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (C) 2005, 2006 Michael Buesch <mb@bu3sch.de>
+  Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
+  Copyright (C) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
+  Copyright (C) 2007 Larry Finger <Larry.Finger@lwfinger.net>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -27,103 +28,105 @@
 
 */
 
-#include "bcm43xx_xmit.h"
+#include <net/dst.h>
 
-#include <linux/etherdevice.h>
+#include "bcm43xx_xmit.h"
+#include "bcm43xx_phy.h"
+#include "bcm43xx_dma.h"
+#include "bcm43xx_pio.h"
 
 
 /* Extract the bitrate out of a CCK PLCP header. */
-static u8 bcm43xx_plcp_get_bitrate_cck(struct bcm43xx_plcp_hdr4 *plcp)
+static u8 bcm43xx_plcp_get_bitrate_cck(struct bcm43xx_plcp_hdr6 *plcp)
 {
 	switch (plcp->raw[0]) {
 	case 0x0A:
-		return IEEE80211_CCK_RATE_1MB;
+		return BCM43xx_CCK_RATE_1MB;
 	case 0x14:
-		return IEEE80211_CCK_RATE_2MB;
+		return BCM43xx_CCK_RATE_2MB;
 	case 0x37:
-		return IEEE80211_CCK_RATE_5MB;
+		return BCM43xx_CCK_RATE_5MB;
 	case 0x6E:
-		return IEEE80211_CCK_RATE_11MB;
+		return BCM43xx_CCK_RATE_11MB;
 	}
-	assert(0);
+	BCM43xx_BUG_ON(1);
 	return 0;
 }
 
 /* Extract the bitrate out of an OFDM PLCP header. */
-static u8 bcm43xx_plcp_get_bitrate_ofdm(struct bcm43xx_plcp_hdr4 *plcp)
+static u8 bcm43xx_plcp_get_bitrate_ofdm(struct bcm43xx_plcp_hdr6 *plcp)
 {
 	switch (plcp->raw[0] & 0xF) {
 	case 0xB:
-		return IEEE80211_OFDM_RATE_6MB;
+		return BCM43xx_OFDM_RATE_6MB;
 	case 0xF:
-		return IEEE80211_OFDM_RATE_9MB;
+		return BCM43xx_OFDM_RATE_9MB;
 	case 0xA:
-		return IEEE80211_OFDM_RATE_12MB;
+		return BCM43xx_OFDM_RATE_12MB;
 	case 0xE:
-		return IEEE80211_OFDM_RATE_18MB;
+		return BCM43xx_OFDM_RATE_18MB;
 	case 0x9:
-		return IEEE80211_OFDM_RATE_24MB;
+		return BCM43xx_OFDM_RATE_24MB;
 	case 0xD:
-		return IEEE80211_OFDM_RATE_36MB;
+		return BCM43xx_OFDM_RATE_36MB;
 	case 0x8:
-		return IEEE80211_OFDM_RATE_48MB;
+		return BCM43xx_OFDM_RATE_48MB;
 	case 0xC:
-		return IEEE80211_OFDM_RATE_54MB;
+		return BCM43xx_OFDM_RATE_54MB;
 	}
-	assert(0);
+	BCM43xx_BUG_ON(1);
 	return 0;
 }
 
 u8 bcm43xx_plcp_get_ratecode_cck(const u8 bitrate)
 {
 	switch (bitrate) {
-	case IEEE80211_CCK_RATE_1MB:
+	case BCM43xx_CCK_RATE_1MB:
 		return 0x0A;
-	case IEEE80211_CCK_RATE_2MB:
+	case BCM43xx_CCK_RATE_2MB:
 		return 0x14;
-	case IEEE80211_CCK_RATE_5MB:
+	case BCM43xx_CCK_RATE_5MB:
 		return 0x37;
-	case IEEE80211_CCK_RATE_11MB:
+	case BCM43xx_CCK_RATE_11MB:
 		return 0x6E;
 	}
-	assert(0);
+	BCM43xx_BUG_ON(1);
 	return 0;
 }
 
 u8 bcm43xx_plcp_get_ratecode_ofdm(const u8 bitrate)
 {
 	switch (bitrate) {
-	case IEEE80211_OFDM_RATE_6MB:
+	case BCM43xx_OFDM_RATE_6MB:
 		return 0xB;
-	case IEEE80211_OFDM_RATE_9MB:
+	case BCM43xx_OFDM_RATE_9MB:
 		return 0xF;
-	case IEEE80211_OFDM_RATE_12MB:
+	case BCM43xx_OFDM_RATE_12MB:
 		return 0xA;
-	case IEEE80211_OFDM_RATE_18MB:
+	case BCM43xx_OFDM_RATE_18MB:
 		return 0xE;
-	case IEEE80211_OFDM_RATE_24MB:
+	case BCM43xx_OFDM_RATE_24MB:
 		return 0x9;
-	case IEEE80211_OFDM_RATE_36MB:
+	case BCM43xx_OFDM_RATE_36MB:
 		return 0xD;
-	case IEEE80211_OFDM_RATE_48MB:
+	case BCM43xx_OFDM_RATE_48MB:
 		return 0x8;
-	case IEEE80211_OFDM_RATE_54MB:
+	case BCM43xx_OFDM_RATE_54MB:
 		return 0xC;
 	}
-	assert(0);
+	BCM43xx_BUG_ON(1);
 	return 0;
 }
 
-static void bcm43xx_generate_plcp_hdr(struct bcm43xx_plcp_hdr4 *plcp,
-				      const u16 octets, const u8 bitrate,
-				      const int ofdm_modulation)
+void bcm43xx_generate_plcp_hdr(struct bcm43xx_plcp_hdr4 *plcp,
+			       const u16 octets, const u8 bitrate)
 {
 	__le32 *data = &(plcp->data);
 	__u8 *raw = plcp->raw;
 
-	if (ofdm_modulation) {
+	if (bcm43xx_is_ofdm_rate(bitrate)) {
 		*data = bcm43xx_plcp_get_ratecode_ofdm(bitrate);
-		assert(!(octets & 0xF000));
+		BCM43xx_WARN_ON(octets & 0xF000);
 		*data |= (octets << 5);
 		*data = cpu_to_le32(*data);
 	} else {
@@ -132,13 +135,14 @@ static void bcm43xx_generate_plcp_hdr(st
 		plen = octets * 16 / bitrate;
 		if ((octets * 16 % bitrate) > 0) {
 			plen++;
-			if ((bitrate == IEEE80211_CCK_RATE_11MB)
-			    && ((octets * 8 % 11) < 4)) {
+			if ((bitrate == BCM43xx_CCK_RATE_11MB)
+			    && ((octets * 8 % 11) < 4))
 				raw[1] = 0x84;
-			} else
+			else
 				raw[1] = 0x04;
-		} else
+		} else {
 			raw[1] = 0x04;
+		}
 		*data |= cpu_to_le32(plen << 16);
 		raw[0] = bcm43xx_plcp_get_ratecode_cck(bitrate);
 	}
@@ -147,249 +151,216 @@ static void bcm43xx_generate_plcp_hdr(st
 static u8 bcm43xx_calc_fallback_rate(u8 bitrate)
 {
 	switch (bitrate) {
-	case IEEE80211_CCK_RATE_1MB:
-		return IEEE80211_CCK_RATE_1MB;
-	case IEEE80211_CCK_RATE_2MB:
-		return IEEE80211_CCK_RATE_1MB;
-	case IEEE80211_CCK_RATE_5MB:
-		return IEEE80211_CCK_RATE_2MB;
-	case IEEE80211_CCK_RATE_11MB:
-		return IEEE80211_CCK_RATE_5MB;
-	case IEEE80211_OFDM_RATE_6MB:
-		return IEEE80211_CCK_RATE_5MB;
-	case IEEE80211_OFDM_RATE_9MB:
-		return IEEE80211_OFDM_RATE_6MB;
-	case IEEE80211_OFDM_RATE_12MB:
-		return IEEE80211_OFDM_RATE_9MB;
-	case IEEE80211_OFDM_RATE_18MB:
-		return IEEE80211_OFDM_RATE_12MB;
-	case IEEE80211_OFDM_RATE_24MB:
-		return IEEE80211_OFDM_RATE_18MB;
-	case IEEE80211_OFDM_RATE_36MB:
-		return IEEE80211_OFDM_RATE_24MB;
-	case IEEE80211_OFDM_RATE_48MB:
-		return IEEE80211_OFDM_RATE_36MB;
-	case IEEE80211_OFDM_RATE_54MB:
-		return IEEE80211_OFDM_RATE_48MB;
+	case BCM43xx_CCK_RATE_1MB:
+		return BCM43xx_CCK_RATE_1MB;
+	case BCM43xx_CCK_RATE_2MB:
+		return BCM43xx_CCK_RATE_1MB;
+	case BCM43xx_CCK_RATE_5MB:
+		return BCM43xx_CCK_RATE_2MB;
+	case BCM43xx_CCK_RATE_11MB:
+		return BCM43xx_CCK_RATE_5MB;
+	case BCM43xx_OFDM_RATE_6MB:
+		return BCM43xx_CCK_RATE_5MB;
+	case BCM43xx_OFDM_RATE_9MB:
+		return BCM43xx_OFDM_RATE_6MB;
+	case BCM43xx_OFDM_RATE_12MB:
+		return BCM43xx_OFDM_RATE_9MB;
+	case BCM43xx_OFDM_RATE_18MB:
+		return BCM43xx_OFDM_RATE_12MB;
+	case BCM43xx_OFDM_RATE_24MB:
+		return BCM43xx_OFDM_RATE_18MB;
+	case BCM43xx_OFDM_RATE_36MB:
+		return BCM43xx_OFDM_RATE_24MB;
+	case BCM43xx_OFDM_RATE_48MB:
+		return BCM43xx_OFDM_RATE_36MB;
+	case BCM43xx_OFDM_RATE_54MB:
+		return BCM43xx_OFDM_RATE_48MB;
 	}
-	assert(0);
+	BCM43xx_BUG_ON(1);
 	return 0;
 }
 
-static
-__le16 bcm43xx_calc_duration_id(const struct ieee80211_hdr *wireless_header,
-				u8 bitrate)
-{
-	const u16 frame_ctl = le16_to_cpu(wireless_header->frame_ctl);
-	__le16 duration_id = wireless_header->duration_id;
-
-	switch (WLAN_FC_GET_TYPE(frame_ctl)) {
-	case IEEE80211_FTYPE_DATA:
-	case IEEE80211_FTYPE_MGMT:
-		//TODO: Steal the code from ieee80211, once it is completed there.
-		break;
-	case IEEE80211_FTYPE_CTL:
-		/* Use the original duration/id. */
-		break;
-	default:
-		assert(0);
-	}
+static void generate_txhdr_fw3(struct bcm43xx_wldev *dev,
+			       struct bcm43xx_txhdr_fw3 *txhdr,
+			       const unsigned char *fragment_data,
+			       unsigned int fragment_len,
+			       const struct ieee80211_tx_control *txctl,
+			       u16 cookie)
+{
+	const struct ieee80211_hdr *wlhdr;
+	int use_encryption = ((!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
+			      && (txctl->key_idx >= 0));
+	u16 fctl;
+	u8 rate;
+	u8 rate_fb;
+	int rate_ofdm;
+	int rate_fb_ofdm;
+	unsigned int plcp_fragment_len;
+	u32 mac_ctl = 0;
+	u16 phy_ctl = 0;
 
-	return duration_id;
-}
+	wlhdr = (const struct ieee80211_hdr *)fragment_data;
+	fctl = le16_to_cpu(wlhdr->frame_control);
 
-static inline
-u16 ceiling_div(u16 dividend, u16 divisor)
-{
-	return ((dividend + divisor - 1) / divisor);
-}
+	memset(txhdr, 0, sizeof(*txhdr));
 
-static void bcm43xx_generate_rts(const struct bcm43xx_phyinfo *phy,
-				 struct bcm43xx_txhdr *txhdr,
-				 u16 *flags,
-				 u8 bitrate,
-				 const struct ieee80211_hdr_4addr *wlhdr)
-{
-	u16 fctl;
-	u16 dur;
-	u8 fallback_bitrate;
-	int ofdm_modulation;
-	int fallback_ofdm_modulation;
-//	u8 *sa, *da;
-	u16 flen;
-
-//FIXME	sa = ieee80211_get_SA((struct ieee80211_hdr *)wlhdr);
-//FIXME	da = ieee80211_get_DA((struct ieee80211_hdr *)wlhdr);
-	fallback_bitrate = bcm43xx_calc_fallback_rate(bitrate);
-	ofdm_modulation = !(ieee80211_is_cck_rate(bitrate));
-	fallback_ofdm_modulation = !(ieee80211_is_cck_rate(fallback_bitrate));
-
-	flen = sizeof(u16) + sizeof(u16) + ETH_ALEN + ETH_ALEN + IEEE80211_FCS_LEN,
-	bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->rts_cts_plcp),
-				  flen, bitrate,
-				  !ieee80211_is_cck_rate(bitrate));
-	bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->rts_cts_fallback_plcp),
-				  flen, fallback_bitrate,
-				  !ieee80211_is_cck_rate(fallback_bitrate));
-	fctl = IEEE80211_FTYPE_CTL;
-	fctl |= IEEE80211_STYPE_RTS;
-	dur = le16_to_cpu(wlhdr->duration_id);
-/*FIXME: should we test for dur==0 here and let it unmodified in this case?
- *       The following assert checks for this case...
- */
-assert(dur);
-/*FIXME: The duration calculation is not really correct.
- *       I am not 100% sure which bitrate to use. We use the RTS rate here,
- *       but this is likely to be wrong.
- */
-	if (phy->type == BCM43xx_PHYTYPE_A) {
-		/* Three times SIFS */
-		dur += 16 * 3;
-		/* Add ACK duration. */
-		dur += ceiling_div((16 + 8 * (14 /*bytes*/) + 6) * 10,
-				   bitrate * 4);
-		/* Add CTS duration. */
-		dur += ceiling_div((16 + 8 * (14 /*bytes*/) + 6) * 10,
-				   bitrate * 4);
+	rate = txctl->tx_rate;
+	rate_ofdm = bcm43xx_is_ofdm_rate(rate);
+	rate_fb = (txctl->alt_retry_rate == -1) ? rate : txctl->alt_retry_rate;
+	rate_fb_ofdm = bcm43xx_is_ofdm_rate(rate_fb);
+
+	txhdr->mac_frame_ctl = wlhdr->frame_control;
+	memcpy(txhdr->tx_receiver, wlhdr->addr1, 6);
+
+	/* Calculate duration for fallback rate */
+	if ((rate_fb == rate) ||
+	    (wlhdr->duration_id & cpu_to_le16(0x8000)) ||
+	    (wlhdr->duration_id == cpu_to_le16(0))) {
+		/* If the fallback rate equals the normal rate or the
+		 * dur_id field contains an AID, CFP magic or 0,
+		 * use the original dur_id field. */
+		txhdr->dur_fb = wlhdr->duration_id;
 	} else {
-		/* Three times SIFS */
-		dur += 10 * 3;
-		/* Add ACK duration. */
-		dur += ceiling_div(8 * (14 /*bytes*/) * 10,
-				   bitrate);
-		/* Add CTS duration. */
-		dur += ceiling_div(8 * (14 /*bytes*/) * 10,
-				   bitrate);
-	}
-
-	txhdr->rts_cts_frame_control = cpu_to_le16(fctl);
-	txhdr->rts_cts_dur = cpu_to_le16(dur);
-//printk(BCM43xx_MACFMT "  " BCM43xx_MACFMT "  " BCM43xx_MACFMT "\n", BCM43xx_MACARG(wlhdr->addr1), BCM43xx_MACARG(wlhdr->addr2), BCM43xx_MACARG(wlhdr->addr3));
-//printk(BCM43xx_MACFMT "  " BCM43xx_MACFMT "\n", BCM43xx_MACARG(sa), BCM43xx_MACARG(da));
-	memcpy(txhdr->rts_cts_mac1, wlhdr->addr1, ETH_ALEN);//FIXME!
-//	memcpy(txhdr->rts_cts_mac2, sa, ETH_ALEN);
-
-	*flags |= BCM43xx_TXHDRFLAG_RTSCTS;
-	*flags |= BCM43xx_TXHDRFLAG_RTS;
-	if (ofdm_modulation)
-		*flags |= BCM43xx_TXHDRFLAG_RTSCTS_OFDM;
-	if (fallback_ofdm_modulation)
-		*flags |= BCM43xx_TXHDRFLAG_RTSCTSFALLBACK_OFDM;
-}
-				 
-void bcm43xx_generate_txhdr(struct bcm43xx_private *bcm,
-			    struct bcm43xx_txhdr *txhdr,
-			    const unsigned char *fragment_data,
-			    const unsigned int fragment_len,
-			    const int is_first_fragment,
-			    const u16 cookie)
-{
-	const struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	const struct ieee80211_hdr_4addr *wireless_header = (const struct ieee80211_hdr_4addr *)fragment_data;
-	const struct ieee80211_security *secinfo = &bcm->ieee->sec;
-	u8 bitrate;
-	u8 fallback_bitrate;
-	int ofdm_modulation;
-	int fallback_ofdm_modulation;
-	u16 plcp_fragment_len = fragment_len;
-	u16 flags = 0;
-	u16 control = 0;
-	u16 wsec_rate = 0;
-	u16 encrypt_frame;
-	const u16 ftype = WLAN_FC_GET_TYPE(le16_to_cpu(wireless_header->frame_ctl));
-	const int is_mgt = (ftype == IEEE80211_FTYPE_MGMT);
+		int fbrate_base100kbps = BCM43xx_RATE_TO_100KBPS(rate_fb);
+		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
+							 fragment_len,
+							 fbrate_base100kbps);
+	}
+
+	plcp_fragment_len = fragment_len + FCS_LEN;
+	if (use_encryption) {
+		u8 key_idx = (u16)(txctl->key_idx);
+		struct bcm43xx_key *key;
+		int wlhdr_len;
+		size_t iv_len;
+
+		BCM43xx_WARN_ON(key_idx >= dev->max_nr_keys);
+		key = &(dev->key[key_idx]);
+
+		if (key->enabled) {
+			/* Hardware appends ICV. */
+			plcp_fragment_len += txctl->icv_len;
+
+			key_idx = bcm43xx_kidx_to_fw(dev, key_idx);
+			mac_ctl |= (key_idx << BCM43xx_TX4_MAC_KEYIDX_SHIFT) &
+				   BCM43xx_TX4_MAC_KEYIDX;
+			mac_ctl |= (key->algorithm <<
+				   BCM43xx_TX4_MAC_KEYALG_SHIFT) &
+				   BCM43xx_TX4_MAC_KEYALG;
+			wlhdr_len = ieee80211_get_hdrlen(fctl);
+			iv_len = min((size_t)txctl->iv_len,
+				     ARRAY_SIZE(txhdr->iv));
+			memcpy(txhdr->iv, ((u8 *)wlhdr) + wlhdr_len, iv_len);
+		}
+	}
+	bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->plcp),
+				  plcp_fragment_len, rate);
+	bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->plcp_fb),
+				  plcp_fragment_len, rate_fb);
+
+	/* PHY TX Control word */
+	if (rate_ofdm)
+		phy_ctl |= BCM43xx_TX4_PHY_OFDM;
+	if (dev->short_preamble)
+		phy_ctl |= BCM43xx_TX4_PHY_SHORTPRMBL;
+	switch (txctl->antenna_sel_tx) {
+	case 0:
+		phy_ctl |= BCM43xx_TX4_PHY_ANTLAST;
+		break;
+	case 1:
+		phy_ctl |= BCM43xx_TX4_PHY_ANT0;
+		break;
+	case 2:
+		phy_ctl |= BCM43xx_TX4_PHY_ANT1;
+		break;
+	default:
+		BCM43xx_BUG_ON(1);
+	}
 
-	/* Now construct the TX header. */
-	memset(txhdr, 0, sizeof(*txhdr));
+	/* MAC control */
+	if (!(txctl->flags & IEEE80211_TXCTL_NO_ACK))
+		mac_ctl |= BCM43xx_TX4_MAC_ACK;
+	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
+	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
+		mac_ctl |= BCM43xx_TX4_MAC_HWSEQ;
+	if (txctl->flags & IEEE80211_TXCTL_FIRST_FRAGMENT)
+		mac_ctl |= BCM43xx_TX4_MAC_STMSDU;
+	if (rate_fb_ofdm)
+		mac_ctl |= BCM43xx_TX4_MAC_FALLBACKOFDM;
+
+	/* Generate the RTS or CTS-to-self frame */
+	if ((txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
+	    (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
+		unsigned int len;
+		struct ieee80211_hdr *hdr;
+		int rts_rate;
+		int rts_rate_fb;
+		int rts_rate_ofdm;
+		int rts_rate_fb_ofdm;
+
+		rts_rate = txctl->rts_cts_rate;
+		rts_rate_ofdm = bcm43xx_is_ofdm_rate(rts_rate);
+		rts_rate_fb = bcm43xx_calc_fallback_rate(rts_rate);
+		rts_rate_fb_ofdm = bcm43xx_is_ofdm_rate(rts_rate_fb);
+		if (rts_rate_fb_ofdm)
+			mac_ctl |= BCM43xx_TX4_MAC_CTSFALLBACKOFDM;
+
+		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+			ieee80211_ctstoself_get(dev->wl->hw,
+						fragment_data,
+						fragment_len, txctl,
+						(struct ieee80211_cts *)
+						(txhdr->rts_frame));
+			mac_ctl |= BCM43xx_TX4_MAC_SENDCTS;
+			len = sizeof(struct ieee80211_cts);
+		} else {
+			ieee80211_rts_get(dev->wl->hw,
+					  fragment_data, fragment_len, txctl,
+					  (struct ieee80211_rts *)
+					  (txhdr->rts_frame));
+			mac_ctl |= BCM43xx_TX4_MAC_SENDRTS;
+			len = sizeof(struct ieee80211_rts);
+		}
+		len += FCS_LEN;
+		bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)
+					  (&txhdr->rts_plcp),
+					  len, rts_rate);
+		bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)
+					  (&txhdr->rts_plcp_fb),
+					  len, rts_rate_fb);
+		hdr = (struct ieee80211_hdr *)(&txhdr->rts_frame);
+		txhdr->rts_dur_fb = hdr->duration_id;
+		mac_ctl |= BCM43xx_TX4_MAC_LONGFRAME;
+	}
 
-	bitrate = ieee80211softmac_suggest_txrate(bcm->softmac,
-		is_multicast_ether_addr(wireless_header->addr1), is_mgt);
-	ofdm_modulation = !(ieee80211_is_cck_rate(bitrate));
-	fallback_bitrate = bcm43xx_calc_fallback_rate(bitrate);
-	fallback_ofdm_modulation = !(ieee80211_is_cck_rate(fallback_bitrate));
-
-	/* Set Frame Control from 80211 header. */
-	txhdr->frame_control = wireless_header->frame_ctl;
-	/* Copy address1 from 80211 header. */
-	memcpy(txhdr->mac1, wireless_header->addr1, 6);
-	/* Set the fallback duration ID. */
-	txhdr->fallback_dur_id = bcm43xx_calc_duration_id((const struct ieee80211_hdr *)wireless_header,
-							  fallback_bitrate);
-	/* Set the cookie (used as driver internal ID for the frame) */
+	/* Magic cookie */
 	txhdr->cookie = cpu_to_le16(cookie);
 
-	/* Hardware appends FCS. */
-	plcp_fragment_len += IEEE80211_FCS_LEN;
-
-	/* Hardware encryption. */
-	encrypt_frame = le16_to_cpup(&wireless_header->frame_ctl) & IEEE80211_FCTL_PROTECTED;
-	if (encrypt_frame && !bcm->ieee->host_encrypt) {
-		const struct ieee80211_hdr_3addr *hdr = (struct ieee80211_hdr_3addr *)wireless_header;
-		memcpy(txhdr->wep_iv, hdr->payload, 4);
-		/* Hardware appends ICV. */
-		plcp_fragment_len += 4;
-
-		wsec_rate |= (bcm->key[secinfo->active_key].algorithm << BCM43xx_TXHDR_WSEC_ALGO_SHIFT)
-			     & BCM43xx_TXHDR_WSEC_ALGO_MASK;
-		wsec_rate |= (secinfo->active_key << BCM43xx_TXHDR_WSEC_KEYINDEX_SHIFT)
-			     & BCM43xx_TXHDR_WSEC_KEYINDEX_MASK;
-	}
+	/* Apply the bitfields */
+	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
+	txhdr->phy_ctl = cpu_to_le16(phy_ctl);
+}
 
-	/* Generate the PLCP header and the fallback PLCP header. */
-	bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->plcp),
-				  plcp_fragment_len,
-				  bitrate, ofdm_modulation);
-	bcm43xx_generate_plcp_hdr(&txhdr->fallback_plcp, plcp_fragment_len,
-				  fallback_bitrate, fallback_ofdm_modulation);
-
-	/* Set the CONTROL field */
-	if (ofdm_modulation)
-		control |= BCM43xx_TXHDRCTL_OFDM;
-	if (bcm->short_preamble) //FIXME: could be the other way around, please test
-		control |= BCM43xx_TXHDRCTL_SHORT_PREAMBLE;
-	control |= (phy->antenna_diversity << BCM43xx_TXHDRCTL_ANTENNADIV_SHIFT)
-		   & BCM43xx_TXHDRCTL_ANTENNADIV_MASK;
-
-	/* Set the FLAGS field */
-	if (!is_multicast_ether_addr(wireless_header->addr1) &&
-	    !is_broadcast_ether_addr(wireless_header->addr1))
-		flags |= BCM43xx_TXHDRFLAG_EXPECTACK;
-	if (1 /* FIXME: PS poll?? */)
-		flags |= 0x10; // FIXME: unknown meaning.
-	if (fallback_ofdm_modulation)
-		flags |= BCM43xx_TXHDRFLAG_FALLBACKOFDM;
-	if (is_first_fragment)
-		flags |= BCM43xx_TXHDRFLAG_FIRSTFRAGMENT;
-
-	/* Set WSEC/RATE field */
-	wsec_rate |= (txhdr->plcp.raw[0] << BCM43xx_TXHDR_RATE_SHIFT)
-		     & BCM43xx_TXHDR_RATE_MASK;
-
-	/* Generate the RTS/CTS packet, if required. */
-	/* FIXME: We should first try with CTS-to-self,
-	 *        if we are on 80211g. If we get too many
-	 *        failures (hidden nodes), we should switch back to RTS/CTS.
-	 */
-	if (0/*FIXME txctl->use_rts_cts*/) {
-		bcm43xx_generate_rts(phy, txhdr, &flags,
-				     0/*FIXME txctl->rts_cts_rate*/,
-				     wireless_header);
-	}
-
-	txhdr->flags = cpu_to_le16(flags);
-	txhdr->control = cpu_to_le16(control);
-	txhdr->wsec_rate = cpu_to_le16(wsec_rate);
+void bcm43xx_generate_txhdr(struct bcm43xx_wldev *dev,
+			    u8 *txhdr,
+			    const unsigned char *fragment_data,
+			    unsigned int fragment_len,
+			    const struct ieee80211_tx_control *txctl,
+			    u16 cookie)
+{
+	generate_txhdr_fw3(dev, (struct bcm43xx_txhdr_fw3 *)txhdr,
+			   fragment_data, fragment_len,
+			   txctl, cookie);
 }
 
-static s8 bcm43xx_rssi_postprocess(struct bcm43xx_private *bcm,
+static s8 bcm43xx_rssi_postprocess(struct bcm43xx_wldev *dev,
 				   u8 in_rssi, int ofdm,
 				   int adjust_2053, int adjust_2050)
 {
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
+	struct bcm43xx_phy *phy = &dev->phy;
 	s32 tmp;
 
-	switch (radio->version) {
+	switch (phy->radio_ver) {
 	case 0x2050:
 		if (ofdm) {
 			tmp = in_rssi;
@@ -402,10 +373,11 @@ static s8 bcm43xx_rssi_postprocess(struc
 			else
 				tmp -= 3;
 		} else {
-			if (bcm->sprom.boardflags & BCM43xx_BFL_RSSI) {
+			if (dev->dev->bus->sprom.r1.boardflags_lo
+			    & BCM43xx_BFL_RSSI) {
 				if (in_rssi > 63)
 					in_rssi = 63;
-				tmp = radio->nrssi_lt[in_rssi];
+				tmp = phy->nrssi_lt[in_rssi];
 				tmp = 31 - tmp;
 				tmp *= -131;
 				tmp /= 128;
@@ -442,124 +414,221 @@ static s8 bcm43xx_rssi_postprocess(struc
 	return (s8)tmp;
 }
 
-//TODO
-#if 0
-static s8 bcm43xx_rssinoise_postprocess(struct bcm43xx_private *bcm,
-					u8 in_rssi)
-{
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	s8 ret;
-
-	if (phy->type == BCM43xx_PHYTYPE_A) {
-		//TODO: Incomplete specs.
-		ret = 0;
-	} else
-		ret = bcm43xx_rssi_postprocess(bcm, in_rssi, 0, 1, 1);
-
-	return ret;
-}
-#endif
-
-int bcm43xx_rx(struct bcm43xx_private *bcm,
-	       struct sk_buff *skb,
-	       struct bcm43xx_rxhdr *rxhdr)
-{
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	struct bcm43xx_plcp_hdr4 *plcp;
-	struct ieee80211_rx_stats stats;
-	struct ieee80211_hdr_4addr *wlhdr;
-	u16 frame_ctl;
-	int is_packet_for_us = 0;
-	int err = -EINVAL;
-	const u16 rxflags1 = le16_to_cpu(rxhdr->flags1);
-	const u16 rxflags2 = le16_to_cpu(rxhdr->flags2);
-	const u16 rxflags3 = le16_to_cpu(rxhdr->flags3);
-	const int is_ofdm = !!(rxflags1 & BCM43xx_RXHDR_FLAGS1_OFDM);
-
-	if (rxflags2 & BCM43xx_RXHDR_FLAGS2_TYPE2FRAME) {
-		plcp = (struct bcm43xx_plcp_hdr4 *)(skb->data + 2);
-		/* Skip two unknown bytes and the PLCP header. */
-		skb_pull(skb, 2 + sizeof(struct bcm43xx_plcp_hdr6));
-	} else {
-		plcp = (struct bcm43xx_plcp_hdr4 *)(skb->data);
-		/* Skip the PLCP header. */
-		skb_pull(skb, sizeof(struct bcm43xx_plcp_hdr6));
-	}
-	/* The SKB contains the PAYLOAD (wireless header + data)
-	 * at this point. The FCS at the end is stripped.
-	 */
-
-	memset(&stats, 0, sizeof(stats));
-	stats.mac_time = le16_to_cpu(rxhdr->mactime);
-	stats.rssi = rxhdr->rssi;
-	stats.signal = bcm43xx_rssi_postprocess(bcm, rxhdr->rssi, is_ofdm,
-					      !!(rxflags1 & BCM43xx_RXHDR_FLAGS1_2053RSSIADJ),
-					      !!(rxflags3 & BCM43xx_RXHDR_FLAGS3_2050RSSIADJ));
-	stats.noise = bcm->stats.noise;
-	if (is_ofdm)
-		stats.rate = bcm43xx_plcp_get_bitrate_ofdm(plcp);
-	else
-		stats.rate = bcm43xx_plcp_get_bitrate_cck(plcp);
-	stats.received_channel = radio->channel;
-	stats.mask = IEEE80211_STATMASK_SIGNAL |
-		     IEEE80211_STATMASK_NOISE |
-		     IEEE80211_STATMASK_RATE |
-		     IEEE80211_STATMASK_RSSI;
-	if (phy->type == BCM43xx_PHYTYPE_A)
-		stats.freq = IEEE80211_52GHZ_BAND;
-	else
-		stats.freq = IEEE80211_24GHZ_BAND;
-	stats.len = skb->len;
+void bcm43xx_rx(struct bcm43xx_wldev *dev,
+		struct sk_buff *skb,
+		const void *_rxhdr)
+{
+	struct ieee80211_rx_status status;
+	struct bcm43xx_plcp_hdr6 *plcp;
+	struct ieee80211_hdr *wlhdr;
+	const struct bcm43xx_rxhdr_fw3 *rxhdr = _rxhdr;
+	u16 fctl;
+	u16 phystat0;
+	u16 phystat3;
+	u16 chanstat;
+	u16 mactime;
+	u32 macstat;
+	u16 chanid;
+	u8 jssi;
+	int padding;
+
+	memset(&status, 0, sizeof(status));
+
+	/* Get metadata about the frame from the header. */
+	phystat0 = le16_to_cpu(rxhdr->phy_status0);
+	phystat3 = le16_to_cpu(rxhdr->phy_status3);
+	jssi = rxhdr->jssi;
+	macstat = le32_to_cpu(rxhdr->mac_status);
+	mactime = le16_to_cpu(rxhdr->mac_time);
+	chanstat = le16_to_cpu(rxhdr->channel);
+
+	if (macstat & BCM43xx_RX_MAC_FCSERR)
+		dev->wl->ieee_stats.dot11FCSErrorCount++;
+
+	/* Skip PLCP and padding */
+	padding = (macstat & BCM43xx_RX_MAC_PADDING) ? 2 : 0;
+	if (unlikely(skb->len < (sizeof(struct bcm43xx_plcp_hdr6) + padding))) {
+		bcmdbg(dev->wl, "RX: Packet size underrun (1)\n");
+		goto drop;
+	}
+	plcp = (struct bcm43xx_plcp_hdr6 *)(skb->data + padding);
+	skb_pull(skb, sizeof(struct bcm43xx_plcp_hdr6) + padding);
+	/* The skb contains the Wireless Header + payload data now */
+	if (unlikely(skb->len < (2+2+6/*minimum hdr*/ + FCS_LEN))) {
+		bcmdbg(dev->wl, "RX: Packet size underrun (2)\n");
+		goto drop;
+	}
+	wlhdr = (struct ieee80211_hdr *)(skb->data);
+	fctl = le16_to_cpu(wlhdr->frame_control);
+	skb_trim(skb, skb->len - FCS_LEN);
+
+	if ((macstat & BCM43xx_RX_MAC_DEC) &&
+	    !(macstat & BCM43xx_RX_MAC_DECERR)) {
+		unsigned int keyidx;
+		int wlhdr_len;
+		int iv_len;
+		int icv_len;
+
+		keyidx = ((macstat & BCM43xx_RX_MAC_KEYIDX)
+			  >> BCM43xx_RX_MAC_KEYIDX_SHIFT);
+		/* We must adjust the key index here. We want the "physical"
+		 * key index, but the ucode passed it slightly different.
+		 */
+		keyidx = bcm43xx_kidx_to_raw(dev, keyidx);
+		BCM43xx_WARN_ON(keyidx >= dev->max_nr_keys);
+
+		if (dev->key[keyidx].algorithm != BCM43xx_SEC_ALGO_NONE) {
+			/* Remove PROTECTED flag to mark it as decrypted. */
+			BCM43xx_WARN_ON(!(fctl & IEEE80211_FCTL_PROTECTED));
+			fctl &= ~IEEE80211_FCTL_PROTECTED;
+			wlhdr->frame_control = cpu_to_le16(fctl);
+
+			wlhdr_len = ieee80211_get_hdrlen(fctl);
+			if (unlikely(skb->len < (wlhdr_len + 3))) {
+				bcmdbg(dev->wl, "RX: Packet size underrun3\n");
+				goto drop;
+			}
+			if (skb->data[wlhdr_len + 3] & (1 << 5)) {
+				/* The Ext-IV Bit is set in the "KeyID"
+				 * octet of the IV.
+				 */
+				iv_len = 8;
+				icv_len = 8;
+			} else {
+				iv_len = 4;
+				icv_len = 4;
+			}
+			if (unlikely(skb->len < (wlhdr_len + iv_len +
+			    icv_len))) {
+				bcmdbg(dev->wl, "RX: Packet size underrun4\n");
+				goto drop;
+			}
+			/* Remove the IV */
+			memmove(skb->data + iv_len, skb->data, wlhdr_len);
+			skb_pull(skb, iv_len);
+			/* Remove the ICV */
+			skb_trim(skb, skb->len - icv_len);
 
-	bcm->stats.last_rx = jiffies;
-	if (bcm->ieee->iw_mode == IW_MODE_MONITOR) {
-		err = ieee80211_rx(bcm->ieee, skb, &stats);
-		return (err == 0) ? -EINVAL : 0;
-	}
-
-	wlhdr = (struct ieee80211_hdr_4addr *)(skb->data);
-
-	switch (bcm->ieee->iw_mode) {
-	case IW_MODE_ADHOC:
-		if (memcmp(wlhdr->addr1, bcm->net_dev->dev_addr, ETH_ALEN) == 0 ||
-		    memcmp(wlhdr->addr3, bcm->ieee->bssid, ETH_ALEN) == 0 ||
-		    is_broadcast_ether_addr(wlhdr->addr1) ||
-		    is_multicast_ether_addr(wlhdr->addr1) ||
-		    bcm->net_dev->flags & IFF_PROMISC)
-			is_packet_for_us = 1;
-		break;
-	case IW_MODE_INFRA:
-	default:
-		/* When receiving multicast or broadcast packets, filter out
-		   the packets we send ourself; we shouldn't see those */
-		if (memcmp(wlhdr->addr3, bcm->ieee->bssid, ETH_ALEN) == 0 ||
-		    memcmp(wlhdr->addr1, bcm->net_dev->dev_addr, ETH_ALEN) == 0 ||
-		    (memcmp(wlhdr->addr3, bcm->net_dev->dev_addr, ETH_ALEN) &&
-		     (is_broadcast_ether_addr(wlhdr->addr1) ||
-		      is_multicast_ether_addr(wlhdr->addr1) ||
-		      bcm->net_dev->flags & IFF_PROMISC)))
-			is_packet_for_us = 1;
-		break;
+			status.flag |= RX_FLAG_DECRYPTED;
+		}
 	}
 
-	frame_ctl = le16_to_cpu(wlhdr->frame_ctl);
-	switch (WLAN_FC_GET_TYPE(frame_ctl)) {
-	case IEEE80211_FTYPE_MGMT:
-		ieee80211_rx_mgt(bcm->ieee, wlhdr, &stats);
-		break;
-	case IEEE80211_FTYPE_DATA:
-		if (is_packet_for_us) {
-			err = ieee80211_rx(bcm->ieee, skb, &stats);
-			err = (err == 0) ? -EINVAL : 0;
-		}
+	status.ssi = bcm43xx_rssi_postprocess(dev, jssi,
+				      (phystat0 & BCM43xx_RX_PHYST0_OFDM),
+				      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
+				      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
+	status.noise = dev->stats.link_noise;
+	status.signal = jssi * 100 / BCM43xx_RX_MAX_SSI;
+	if (phystat0 & BCM43xx_RX_PHYST0_OFDM)
+		status.rate = bcm43xx_plcp_get_bitrate_ofdm(plcp);
+	else
+		status.rate = bcm43xx_plcp_get_bitrate_cck(plcp);
+	status.antenna = !!(phystat0 & BCM43xx_RX_PHYST0_ANT);
+	status.mactime = mactime;
+
+	chanid = (chanstat & BCM43xx_RX_CHAN_ID) >> BCM43xx_RX_CHAN_ID_SHIFT;
+	switch (chanstat & BCM43xx_RX_CHAN_PHYTYPE) {
+	case BCM43xx_PHYTYPE_B:
+		status.phymode = MODE_IEEE80211B;
+		status.freq = chanid + 2400;
+		status.channel = bcm43xx_freq_to_channel_bg(chanid + 2400);
 		break;
-	case IEEE80211_FTYPE_CTL:
+	case BCM43xx_PHYTYPE_G:
+		status.phymode = MODE_IEEE80211G;
+		status.freq = chanid + 2400;
+		status.channel = bcm43xx_freq_to_channel_bg(chanid + 2400);
 		break;
 	default:
-		assert(0);
-		return -EINVAL;
+		bcmwarn(dev->wl, "Unexpected value for chanstat (0x%X)\n",
+		       chanstat);
+	}
+
+	dev->stats.last_rx = jiffies;
+	ieee80211_rx_irqsafe(dev->wl->hw, skb, &status);
+
+	return;
+drop:
+	bcmdbg(dev->wl, "RX: Packet dropped\n");
+	dev_kfree_skb_any(skb);
+}
+
+void bcm43xx_handle_txstatus(struct bcm43xx_wldev *dev,
+			     const struct bcm43xx_txstatus *status)
+{
+	bcm43xx_debugfs_log_txstat(dev, status);
+
+	if (status->intermediate)
+		return;
+	if (status->for_ampdu)
+		return;
+	if (!status->acked)
+		dev->wl->ieee_stats.dot11ACKFailureCount++;
+	if (status->rts_count) {
+		if (status->rts_count == 0xF) /* FIXME */
+			dev->wl->ieee_stats.dot11RTSFailureCount++;
+		else
+			dev->wl->ieee_stats.dot11RTSSuccessCount++;
 	}
 
-	return err;
+	if (bcm43xx_using_pio(dev))
+		bcm43xx_pio_handle_txstatus(dev, status);
+	else
+		bcm43xx_dma_handle_txstatus(dev, status);
+}
+
+/* Handle TX status report as received through DMA/PIO queues */
+void bcm43xx_handle_hwtxstatus(struct bcm43xx_wldev *dev,
+			       const struct bcm43xx_hwtxstatus *hw)
+{
+	struct bcm43xx_txstatus status;
+	u8 tmp;
+
+	status.cookie = le16_to_cpu(hw->cookie);
+	status.seq = le16_to_cpu(hw->seq);
+	status.phy_stat = hw->phy_stat;
+	tmp = hw->count;
+	status.frame_count = (tmp >> 4);
+	status.rts_count = (tmp & 0x0F);
+	tmp = hw->flags;
+	status.supp_reason = ((tmp & 0x1C) >> 2);
+	status.pm_indicated = !!(tmp & 0x80);
+	status.intermediate = !!(tmp & 0x40);
+	status.for_ampdu = !!(tmp & 0x20);
+	status.acked = !!(tmp & 0x02);
+
+	bcm43xx_handle_txstatus(dev, &status);
+}
+
+/* Stop any TX operation on the device (suspend the hardware queues) */
+void bcm43xx_tx_suspend(struct bcm43xx_wldev *dev)
+{
+	if (bcm43xx_using_pio(dev))
+		bcm43xx_pio_freeze_txqueues(dev);
+	else
+		bcm43xx_dma_tx_suspend(dev);
+}
+
+/* Resume any TX operation on the device (resume the hardware queues) */
+void bcm43xx_tx_resume(struct bcm43xx_wldev *dev)
+{
+	if (bcm43xx_using_pio(dev))
+		bcm43xx_pio_thaw_txqueues(dev);
+	else
+		bcm43xx_dma_tx_resume(dev);
+}
+
+/* Initialize the QoS parameters */
+void bcm43xx_qos_init(struct bcm43xx_wldev *dev)
+{
+	/* FIXME: This function must probably be called from the mac80211
+	 * config callback. */
+return;
+
+	bcm43xx_hf_write(dev, bcm43xx_hf_read(dev) | BCM43xx_HF_EDCF);
+	/* FIXME kill magic */
+	bcm43xx_write16(dev, 0x688,
+			bcm43xx_read16(dev, 0x688) | 0x4);
+
+
+	/*TODO: We might need some stack support here to get the values. */
 }
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
@@ -19,132 +19,240 @@ _bcm43xx_declare_plcp_hdr(6);
 
 #undef _bcm43xx_declare_plcp_hdr
 
-/* Device specific TX header. To be prepended to TX frames. */
-struct bcm43xx_txhdr {
-	union {
-		struct {
-			__le16 flags;
-			__le16 wsec_rate;
-			__le16 frame_control;
-			u16 unknown_zeroed_0;
-			__le16 control;
-			u8 wep_iv[10];
-			u8 unknown_wsec_tkip_data[3]; //FIXME
-			PAD_BYTES(3);
-			u8 mac1[6];
-			u16 unknown_zeroed_1;
-			struct bcm43xx_plcp_hdr4 rts_cts_fallback_plcp;
-			__le16 rts_cts_dur_fallback;
-			struct bcm43xx_plcp_hdr4 fallback_plcp;
-			__le16 fallback_dur_id;
-			PAD_BYTES(2);
-			__le16 cookie;
-			__le16 unknown_scb_stuff; //FIXME
-			struct bcm43xx_plcp_hdr6 rts_cts_plcp;
-			__le16 rts_cts_frame_control;
-			__le16 rts_cts_dur;
-			u8 rts_cts_mac1[6];
-			u8 rts_cts_mac2[6];
-			PAD_BYTES(2);
-			struct bcm43xx_plcp_hdr6 plcp;
-		} __attribute__((__packed__));
-		u8 raw[82];
-	} __attribute__((__packed__));
-} __attribute__((__packed__));
-
-/* Values/Masks for the device TX header */
-#define BCM43xx_TXHDRFLAG_EXPECTACK		0x0001
-#define BCM43xx_TXHDRFLAG_RTSCTS		0x0002
-#define BCM43xx_TXHDRFLAG_RTS			0x0004
-#define BCM43xx_TXHDRFLAG_FIRSTFRAGMENT		0x0008
-#define BCM43xx_TXHDRFLAG_DESTPSMODE		0x0020
-#define BCM43xx_TXHDRFLAG_RTSCTS_OFDM		0x0080
-#define BCM43xx_TXHDRFLAG_FALLBACKOFDM		0x0100
-#define BCM43xx_TXHDRFLAG_RTSCTSFALLBACK_OFDM	0x0200
-#define BCM43xx_TXHDRFLAG_CTS			0x0400
-#define BCM43xx_TXHDRFLAG_FRAMEBURST		0x0800
-
-#define BCM43xx_TXHDRCTL_OFDM			0x0001
-#define BCM43xx_TXHDRCTL_SHORT_PREAMBLE		0x0010
-#define BCM43xx_TXHDRCTL_ANTENNADIV_MASK	0x0030
-#define BCM43xx_TXHDRCTL_ANTENNADIV_SHIFT	8
-
-#define BCM43xx_TXHDR_RATE_MASK			0x0F00
-#define BCM43xx_TXHDR_RATE_SHIFT		8
-#define BCM43xx_TXHDR_RTSRATE_MASK		0xF000
-#define BCM43xx_TXHDR_RTSRATE_SHIFT		12
-#define BCM43xx_TXHDR_WSEC_KEYINDEX_MASK	0x00F0
-#define BCM43xx_TXHDR_WSEC_KEYINDEX_SHIFT	4
-#define BCM43xx_TXHDR_WSEC_ALGO_MASK		0x0003
-#define BCM43xx_TXHDR_WSEC_ALGO_SHIFT		0
 
-void bcm43xx_generate_txhdr(struct bcm43xx_private *bcm,
-			    struct bcm43xx_txhdr *txhdr,
-			    const unsigned char *fragment_data,
-			    const unsigned int fragment_len,
-			    const int is_first_fragment,
-			    const u16 cookie);
-
-/* RX header as received from the hardware. */
-struct bcm43xx_rxhdr {
-	/* Frame Length. Must be generated explicitely in PIO mode. */
-	__le16 frame_length;
+/* TX header for v3 firmware */
+struct bcm43xx_txhdr_fw3 {
+	__le32 mac_ctl;				/* MAC TX control */
+	__le16 mac_frame_ctl;			/* Copy of the FrameControl field */
+	__le16 tx_fes_time_norm;		/* TX FES Time Normal */
+	__le16 phy_ctl;				/* PHY TX control */
+	__u8 iv[16];				/* Encryption IV */
+	__u8 tx_receiver[6];			/* TX Frame Receiver address */
+	__le16 tx_fes_time_fb;			/* TX FES Time Fallback */
+	struct bcm43xx_plcp_hdr4 rts_plcp_fb;	/* RTS fallback PLCP */
+	__le16 rts_dur_fb;			/* RTS fallback duration */
+	struct bcm43xx_plcp_hdr4 plcp_fb;	/* Fallback PLCP */
+	__le16 dur_fb;				/* Fallback duration */
 	PAD_BYTES(2);
-	/* Flags field 1 */
-	__le16 flags1;
-	u8 rssi;
-	u8 signal_quality;
-	PAD_BYTES(2);
-	/* Flags field 3 */
-	__le16 flags3;
-	/* Flags field 2 */
-	__le16 flags2;
-	/* Lower 16bits of the TSF at the time the frame started. */
-	__le16 mactime;
-	PAD_BYTES(14);
+	__le16 cookie;
+	__le16 unknown_scb_stuff;
+	struct bcm43xx_plcp_hdr6 rts_plcp;	/* RTS PLCP */
+	__u8 rts_frame[18];			/* The RTS frame (if used) */
+	struct bcm43xx_plcp_hdr6 plcp;
 } __attribute__((__packed__));
 
-#define BCM43xx_RXHDR_FLAGS1_OFDM		(1 << 0)
-/*#define BCM43xx_RXHDR_FLAGS1_SIGNAL???	(1 << 3) FIXME */
-#define BCM43xx_RXHDR_FLAGS1_SHORTPREAMBLE	(1 << 7)
-#define BCM43xx_RXHDR_FLAGS1_2053RSSIADJ	(1 << 14)
-
-#define BCM43xx_RXHDR_FLAGS2_INVALIDFRAME	(1 << 0)
-#define BCM43xx_RXHDR_FLAGS2_TYPE2FRAME		(1 << 2)
-/*FIXME: WEP related flags */
+/* MAC TX control */
+#define BCM43xx_TX4_MAC_KEYIDX		0x0FF00000 /* Security key index */
+#define BCM43xx_TX4_MAC_KEYIDX_SHIFT	20
+#define BCM43xx_TX4_MAC_KEYALG		0x00070000 /* Security key algorithm */
+#define BCM43xx_TX4_MAC_KEYALG_SHIFT	16
+#define BCM43xx_TX4_MAC_LIFETIME	0x00001000
+#define BCM43xx_TX4_MAC_FRAMEBURST	0x00000800
+#define BCM43xx_TX4_MAC_SENDCTS		0x00000400
+#define BCM43xx_TX4_MAC_AMPDU		0x00000300
+#define BCM43xx_TX4_MAC_AMPDU_SHIFT	8
+#define BCM43xx_TX4_MAC_CTSFALLBACKOFDM	0x00000200
+#define BCM43xx_TX4_MAC_FALLBACKOFDM	0x00000100
+#define BCM43xx_TX4_MAC_5GHZ		0x00000080
+#define BCM43xx_TX4_MAC_IGNPMQ		0x00000020
+#define BCM43xx_TX4_MAC_HWSEQ		0x00000010 /* Use Hardware Seq No */
+#define BCM43xx_TX4_MAC_STMSDU		0x00000008 /* Start MSDU */
+#define BCM43xx_TX4_MAC_SENDRTS		0x00000004
+#define BCM43xx_TX4_MAC_LONGFRAME	0x00000002
+#define BCM43xx_TX4_MAC_ACK		0x00000001
+
+/* Extra Frame Types */
+#define BCM43xx_TX4_EFT_FBOFDM		0x0001 /* Data frame fb rate type */
+#define BCM43xx_TX4_EFT_RTSOFDM		0x0004 /* RTS/CTS rate type */
+#define BCM43xx_TX4_EFT_RTSFBOFDM	0x0010 /* RTS/CTS fallback rate type */
+
+/* PHY TX control word */
+#define BCM43xx_TX4_PHY_OFDM		0x0001 /* Data frame rate type */
+#define BCM43xx_TX4_PHY_SHORTPRMBL	0x0010 /* Use short preamble */
+#define BCM43xx_TX4_PHY_ANT		0x03C0 /* Antenna selection */
+#define  BCM43xx_TX4_PHY_ANT0		0x0000 /* Use antenna 0 */
+#define  BCM43xx_TX4_PHY_ANT1		0x0100 /* Use antenna 1 */
+#define  BCM43xx_TX4_PHY_ANTLAST	0x0300 /* Use last used antenna */
+
 
-#define BCM43xx_RXHDR_FLAGS3_2050RSSIADJ	(1 << 10)
 
-/* Transmit Status as received from the hardware. */
-struct bcm43xx_hwxmitstatus {
+void bcm43xx_generate_txhdr(struct bcm43xx_wldev *dev,
+			    u8 *txhdr,
+			    const unsigned char *fragment_data,
+			    unsigned int fragment_len,
+			    const struct ieee80211_tx_control *txctl,
+			    u16 cookie);
+
+
+/* Transmit Status */
+struct bcm43xx_txstatus {
+	u16 cookie;		/* The cookie from the txhdr */
+	u16 seq;		/* Sequence number */
+	u8 phy_stat;		/* PHY TX status */
+	u8 frame_count;		/* Frame transmit count */
+	u8 rts_count;		/* RTS transmit count */
+	u8 supp_reason;		/* Suppression reason */
+	/* flags */
+	u8 pm_indicated;	/* PM mode indicated to AP */
+	u8 intermediate;	/* Intermediate status notification */
+	u8 for_ampdu;		/* Status is for an AMPDU (afterburner) */
+	u8 acked;		/* Wireless ACK received */
+};
+
+/* txstatus supp_reason values */
+enum {
+	BCM43xx_TXST_SUPP_NONE,		/* Not suppressed */
+	BCM43xx_TXST_SUPP_PMQ,		/* Suppressed due to PMQ entry */
+	BCM43xx_TXST_SUPP_FLUSH,	/* Suppressed due to flush request */
+	BCM43xx_TXST_SUPP_PREV,		/* Previous fragment failed */
+	BCM43xx_TXST_SUPP_CHAN,		/* Channel mismatch */
+	BCM43xx_TXST_SUPP_LIFE,		/* Lifetime expired */
+	BCM43xx_TXST_SUPP_UNDER,	/* Buffer underflow */
+	BCM43xx_TXST_SUPP_ABNACK,	/* Afterburner NACK */
+};
+
+/* Transmit Status as received through DMA/PIO on old chips */
+struct bcm43xx_hwtxstatus {
 	PAD_BYTES(4);
 	__le16 cookie;
 	u8 flags;
-	u8 cnt1:4,
-	   cnt2:4;
+	u8 count;
 	PAD_BYTES(2);
 	__le16 seq;
-	__le16 unknown; //FIXME
+	u8 phy_stat;
+	PAD_BYTES(1);
 } __attribute__((__packed__));
 
-/* Transmit Status in CPU byteorder. */
-struct bcm43xx_xmitstatus {
-	u16 cookie;
-	u8 flags;
-	u8 cnt1:4,
-	   cnt2:4;
-	u16 seq;
-	u16 unknown; //FIXME
-};
 
-#define BCM43xx_TXSTAT_FLAG_AMPDU	0x10
-#define BCM43xx_TXSTAT_FLAG_INTER	0x20
+/* Receive header for v3 firmware. */
+struct bcm43xx_rxhdr_fw3 {
+	__le16 frame_len;	/* Frame length */
+	PAD_BYTES(2);
+	__le16 phy_status0;	/* PHY RX Status 0 */
+	__u8 jssi;		/* PHY RX Status 1: JSSI */
+	__u8 sig_qual;		/* PHY RX Status 1: Signal Quality */
+	PAD_BYTES(2);		/* PHY RX Status 2 */
+	__le16 phy_status3;	/* PHY RX Status 3 */
+	__le16 mac_status;	/* MAC RX status */
+	__le16 mac_time;
+	__le16 channel;
+} __attribute__((__packed__));
+
+
+/* PHY RX Status 0 */
+#define BCM43xx_RX_PHYST0_GAINCTL	0x4000 /* Gain Control */
+#define BCM43xx_RX_PHYST0_PLCPHCF	0x0200
+#define BCM43xx_RX_PHYST0_PLCPFV	0x0100
+#define BCM43xx_RX_PHYST0_SHORTPRMBL	0x0080 /* Recvd with Short Preamble */
+#define BCM43xx_RX_PHYST0_LCRS		0x0040
+#define BCM43xx_RX_PHYST0_ANT		0x0020 /* Antenna */
+#define BCM43xx_RX_PHYST0_UNSRATE	0x0010
+#define BCM43xx_RX_PHYST0_CLIP		0x000C
+#define BCM43xx_RX_PHYST0_CLIP_SHIFT	2
+#define BCM43xx_RX_PHYST0_FTYPE		0x0003 /* Frame type */
+#define  BCM43xx_RX_PHYST0_CCK		0x0000 /* Frame type: CCK */
+#define  BCM43xx_RX_PHYST0_OFDM		0x0001 /* Frame type: OFDM */
+#define  BCM43xx_RX_PHYST0_PRE_N	0x0002 /* Pre-standard N-PHY frame */
+#define  BCM43xx_RX_PHYST0_STD_N	0x0003 /* Standard N-PHY frame */
+
+/* PHY RX Status 2 */
+#define BCM43xx_RX_PHYST2_LNAG		0xC000 /* LNA Gain */
+#define BCM43xx_RX_PHYST2_LNAG_SHIFT	14
+#define BCM43xx_RX_PHYST2_PNAG		0x3C00 /* PNA Gain */
+#define BCM43xx_RX_PHYST2_PNAG_SHIFT	10
+#define BCM43xx_RX_PHYST2_FOFF		0x03FF /* F offset */
+
+/* PHY RX Status 3 */
+#define BCM43xx_RX_PHYST3_DIGG		0x1800 /* DIG Gain */
+#define BCM43xx_RX_PHYST3_DIGG_SHIFT	11
+#define BCM43xx_RX_PHYST3_TRSTATE	0x0400 /* TR state */
+
+/* MAC RX Status */
+#define BCM43xx_RX_MAC_BEACONSENT	0x00008000 /* Beacon send flag */
+#define BCM43xx_RX_MAC_KEYIDX		0x000007E0 /* Key index */
+#define BCM43xx_RX_MAC_KEYIDX_SHIFT	5
+#define BCM43xx_RX_MAC_DECERR		0x00000010 /* Decrypt error */
+#define BCM43xx_RX_MAC_DEC		0x00000008 /* Decryption attempted */
+#define BCM43xx_RX_MAC_PADDING		0x00000004 /* Pad bytes present */
+#define BCM43xx_RX_MAC_RESP		0x00000002 /* Response frame xmitted */
+#define BCM43xx_RX_MAC_FCSERR		0x00000001 /* FCS error */
+
+/* RX channel */
+#define BCM43xx_RX_CHAN_GAIN		0xFC00 /* Gain */
+#define BCM43xx_RX_CHAN_GAIN_SHIFT	10
+#define BCM43xx_RX_CHAN_ID		0x03FC /* Channel ID */
+#define BCM43xx_RX_CHAN_ID_SHIFT	2
+#define BCM43xx_RX_CHAN_PHYTYPE		0x0003 /* PHY type */
+
+
 
 u8 bcm43xx_plcp_get_ratecode_cck(const u8 bitrate);
 u8 bcm43xx_plcp_get_ratecode_ofdm(const u8 bitrate);
 
-int bcm43xx_rx(struct bcm43xx_private *bcm,
-	       struct sk_buff *skb,
-	       struct bcm43xx_rxhdr *rxhdr);
+void bcm43xx_generate_plcp_hdr(struct bcm43xx_plcp_hdr4 *plcp,
+			       const u16 octets, const u8 bitrate);
+
+void bcm43xx_rx(struct bcm43xx_wldev *dev,
+		struct sk_buff *skb,
+		const void *_rxhdr);
+
+void bcm43xx_handle_txstatus(struct bcm43xx_wldev *dev,
+			     const struct bcm43xx_txstatus *status);
+
+void bcm43xx_handle_hwtxstatus(struct bcm43xx_wldev *dev,
+			       const struct bcm43xx_hwtxstatus *hw);
+
+void bcm43xx_tx_suspend(struct bcm43xx_wldev *dev);
+void bcm43xx_tx_resume(struct bcm43xx_wldev *dev);
+
+
+#define BCM43xx_NR_QOSPARMS		22
+enum {
+	BCM43xx_QOSPARM_TXOP = 0,
+	BCM43xx_QOSPARM_CWMIN,
+	BCM43xx_QOSPARM_CWMAX,
+	BCM43xx_QOSPARM_CWCUR,
+	BCM43xx_QOSPARM_AIFS,
+	BCM43xx_QOSPARM_BSLOTS,
+	BCM43xx_QOSPARM_REGGAP,
+	BCM43xx_QOSPARM_STATUS,
+};
+void bcm43xx_qos_init(struct bcm43xx_wldev *dev);
+
+
+/* Helper functions for converting the key-table index from "firmware-format"
+ * to "raw-format" and back. The firmware API changed for this at some revision.
+ * We need to account for that here. */
+static inline
+int bcm43xx_new_kidx_api(struct bcm43xx_wldev *dev)
+{
+	/* FIXME: Not sure the change was at rev 351 */
+	return (dev->fw.rev >= 351);
+}
+static inline
+u8 bcm43xx_kidx_to_fw(struct bcm43xx_wldev *dev, u8 raw_kidx)
+{
+	u8 firmware_kidx;
+	if (bcm43xx_new_kidx_api(dev)) {
+		firmware_kidx = raw_kidx;
+	} else {
+		if (raw_kidx >= 4) /* Is per STA key? */
+			firmware_kidx = raw_kidx - 4;
+		else
+			firmware_kidx = raw_kidx; /* TX default key */
+	}
+	return firmware_kidx;
+}
+static inline
+u8 bcm43xx_kidx_to_raw(struct bcm43xx_wldev *dev, u8 firmware_kidx)
+{
+	u8 raw_kidx;
+	if (bcm43xx_new_kidx_api(dev))
+		raw_kidx = firmware_kidx;
+	else
+		/* RX default keys or per STA keys */
+		raw_kidx = firmware_kidx + 4;
+	return raw_kidx;
+}
 
 #endif /* BCM43xx_XMIT_H_ */
