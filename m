Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43279 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYAJTvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 14:51:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: [PATCH RFT] b43: Add support for new firmware
Date: Thu, 10 Jan 2008 20:46:56 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801102046.56979.mb@bu3sch.de> (sfid-20080110_195158_344397_16CEDE6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for new firmware.
Please test this on old and new firmware.

To get new firmware, go to
ftp://ftp.linksys.com/opensourcecode/wrt150nv11/1.51.3/
and download the tarball. We don't have a smaller tarball, yet.
That will be fixed later.
You can extract firmware out of the "wl_ap.o" file contained
in this tarball using latest fwcutter. You must pass the option
--unsupported to fwcutter.


Index: wireless-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.c	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/dma.c	2008-01-10 18:00:18.000000000 +0100
@@ -804,44 +804,43 @@ struct b43_dmaring *b43_setup_dmaring(st
 	ring->meta = kcalloc(nr_slots, sizeof(struct b43_dmadesc_meta),
 			     GFP_KERNEL);
 	if (!ring->meta)
 		goto err_kfree_ring;
 	if (for_tx) {
 		ring->txhdr_cache = kcalloc(nr_slots,
-					    sizeof(struct b43_txhdr_fw4),
+					    b43_txhdr_size(dev),
 					    GFP_KERNEL);
 		if (!ring->txhdr_cache)
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
 		dma_test = dma_map_single(dev->dev->dev,
 					  ring->txhdr_cache,
-					  sizeof(struct b43_txhdr_fw4),
+					  b43_txhdr_size(dev),
 					  DMA_TO_DEVICE);
 
 		if (dma_mapping_error(dma_test)) {
 			/* ugh realloc */
 			kfree(ring->txhdr_cache);
 			ring->txhdr_cache = kcalloc(nr_slots,
-						    sizeof(struct
-							   b43_txhdr_fw4),
+						    b43_txhdr_size(dev),
 						    GFP_KERNEL | GFP_DMA);
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
 			dma_test = dma_map_single(dev->dev->dev,
 						  ring->txhdr_cache,
-						  sizeof(struct b43_txhdr_fw4),
+						  b43_txhdr_size(dev),
 						  DMA_TO_DEVICE);
 
 			if (dma_mapping_error(dma_test))
 				goto err_kfree_txhdr_cache;
 		}
 
 		dma_unmap_single(dev->dev->dev,
-				 dma_test, sizeof(struct b43_txhdr_fw4),
+				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
 	}
 
 	ring->dev = dev;
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43_dmacontroller_base(dma64, controller_index);
@@ -1119,32 +1118,33 @@ static int dma_tx_fragment(struct b43_dm
 	int err;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
 	struct b43_dmadesc_meta *meta_hdr;
 	struct sk_buff *bounce_skb;
 	u16 cookie;
+	size_t hdrsize = b43_txhdr_size(ring->dev);
 
 #define SLOTS_PER_PACKET  2
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta_hdr);
 	memset(meta_hdr, 0, sizeof(*meta_hdr));
 
-	header = &(ring->txhdr_cache[slot * sizeof(struct b43_txhdr_fw4)]);
+	header = &(ring->txhdr_cache[slot * hdrsize]);
 	cookie = generate_cookie(ring, slot);
 	b43_generate_txhdr(ring->dev, header,
 			   skb->data, skb->len, ctl, cookie);
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
-					   sizeof(struct b43_txhdr_fw4), 1);
+					   hdrsize, 1);
 	if (dma_mapping_error(meta_hdr->dmaaddr))
 		return -EIO;
 	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
-			     sizeof(struct b43_txhdr_fw4), 1, 0, 0);
+			     hdrsize, 1, 0, 0);
 
 	/* Get a slot for the payload. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta);
 	memset(meta, 0, sizeof(*meta));
 
@@ -1186,13 +1186,13 @@ static int dma_tx_fragment(struct b43_dm
 	return 0;
 
 out_free_bounce:
 	dev_kfree_skb_any(skb);
 out_unmap_hdr:
 	unmap_descbuffer(ring, meta_hdr->dmaaddr,
-			 sizeof(struct b43_txhdr_fw4), 1);
+			 hdrsize, 1);
 	return err;
 }
 
 static inline int should_inject_overflow(struct b43_dmaring *ring)
 {
 #ifdef CONFIG_B43_DEBUG
@@ -1295,13 +1295,13 @@ void b43_dma_handle_txstatus(struct b43_
 
 		if (meta->skb)
 			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len,
 					 1);
 		else
 			unmap_descbuffer(ring, meta->dmaaddr,
-					 sizeof(struct b43_txhdr_fw4), 1);
+					 b43_txhdr_size(dev), 1);
 
 		if (meta->is_last_fragment) {
 			B43_WARN_ON(!meta->skb);
 			/* Call back to inform the ieee80211 subsystem about the
 			 * status of the transmission.
 			 * Some fields of txstat are already filled in dma_tx().
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-09 20:02:57.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-10 20:39:09.000000000 +0100
@@ -1566,17 +1566,23 @@ static void b43_release_firmware(struct 
 	release_firmware(dev->fw.initvals);
 	dev->fw.initvals = NULL;
 	release_firmware(dev->fw.initvals_band);
 	dev->fw.initvals_band = NULL;
 }
 
-static void b43_print_fw_helptext(struct b43_wl *wl)
+static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 {
-	b43err(wl, "You must go to "
+	const char *text;
+
+	text = "You must go to "
 	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
-	       "and download the correct firmware (version 4).\n");
+	       "and download the latest firmware (version 4).\n";
+	if (error)
+		b43err(wl, text);
+	else
+		b43warn(wl, text);
 }
 
 static int do_request_fw(struct b43_wldev *dev,
 			 const char *name,
 			 const struct firmware **fw)
 {
@@ -1722,13 +1728,13 @@ static int b43_request_firmware(struct b
 			goto err_load;
 	}
 
 	return 0;
 
 err_load:
-	b43_print_fw_helptext(dev->wl);
+	b43_print_fw_helptext(dev->wl, 1);
 	goto error;
 
 err_no_ucode:
 	err = -ENODEV;
 	b43err(dev->wl, "No microcode available for core rev %u\n", rev);
 	goto error;
@@ -1792,13 +1798,13 @@ static int b43_upload_microcode(struct b
 		tmp = b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
 		if (tmp == B43_IRQ_MAC_SUSPENDED)
 			break;
 		i++;
 		if (i >= 50) {
 			b43err(dev->wl, "Microcode not responding\n");
-			b43_print_fw_helptext(dev->wl);
+			b43_print_fw_helptext(dev->wl, 1);
 			err = -ENODEV;
 			goto out;
 		}
 		udelay(10);
 	}
 	b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);	/* dummy read */
@@ -1810,13 +1816,13 @@ static int b43_upload_microcode(struct b
 	fwtime = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_UCODETIME);
 
 	if (fwrev <= 0x128) {
 		b43err(dev->wl, "YOUR FIRMWARE IS TOO OLD. Firmware from "
 		       "binary drivers older than version 4.x is unsupported. "
 		       "You must upgrade your firmware files.\n");
-		b43_print_fw_helptext(dev->wl);
+		b43_print_fw_helptext(dev->wl, 1);
 		b43_write32(dev, B43_MMIO_MACCTL, 0);
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 	b43dbg(dev->wl, "Loading firmware version %u.%u "
 	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
@@ -1824,13 +1830,19 @@ static int b43_upload_microcode(struct b
 	       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
 	       (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
 
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;
 
-      out:
+	if (b43_is_old_txhdr_format(dev)) {
+		b43warn(dev->wl, "You are using an old firmware image. "
+			"Support for old firmware will be removed in July 2008.\n");
+		b43_print_fw_helptext(dev->wl, 0);
+	}
+
+out:
 	return err;
 }
 
 static int b43_write_initvals(struct b43_wldev *dev,
 			      const struct b43_iv *ivals,
 			      size_t count,
@@ -1884,13 +1896,13 @@ static int b43_write_initvals(struct b43
 		goto err_format;
 
 	return 0;
 
 err_format:
 	b43err(dev->wl, "Initial Values Firmware file-format error.\n");
-	b43_print_fw_helptext(dev->wl);
+	b43_print_fw_helptext(dev->wl, 1);
 
 	return -EPROTO;
 }
 
 static int b43_upload_initvals(struct b43_wldev *dev)
 {
@@ -2146,37 +2158,43 @@ static void b43_mgmtframe_txantenna(stru
 {
 	u16 ant = 0;
 	u16 tmp;
 
 	switch (antenna) {
 	case B43_ANTENNA0:
-		ant |= B43_TX4_PHY_ANT0;
+		ant |= B43_TXH_PHY_ANT0;
 		break;
 	case B43_ANTENNA1:
-		ant |= B43_TX4_PHY_ANT1;
+		ant |= B43_TXH_PHY_ANT1;
+		break;
+	case B43_ANTENNA2:
+		ant |= B43_TXH_PHY_ANT2;
+		break;
+	case B43_ANTENNA3:
+		ant |= B43_TXH_PHY_ANT3;
 		break;
 	case B43_ANTENNA_AUTO:
-		ant |= B43_TX4_PHY_ANTLAST;
+		ant |= B43_TXH_PHY_ANT01AUTO;
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
 
 	/* FIXME We also need to set the other flags of the PHY control field somewhere. */
 
 	/* For Beacons */
 	tmp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL);
-	tmp = (tmp & ~B43_TX4_PHY_ANT) | ant;
+	tmp = (tmp & ~B43_TXH_PHY_ANT) | ant;
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL, tmp);
 	/* For ACK/CTS */
 	tmp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_ACKCTSPHYCTL);
-	tmp = (tmp & ~B43_TX4_PHY_ANT) | ant;
+	tmp = (tmp & ~B43_TXH_PHY_ANT) | ant;
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_ACKCTSPHYCTL, tmp);
 	/* For Probe Resposes */
 	tmp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_PRPHYCTL);
-	tmp = (tmp & ~B43_TX4_PHY_ANT) | ant;
+	tmp = (tmp & ~B43_TXH_PHY_ANT) | ant;
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRPHYCTL, tmp);
 }
 
 /* This is the opposite of b43_chip_init() */
 static void b43_chip_exit(struct b43_wldev *dev)
 {
@@ -2735,12 +2753,16 @@ static int b43_antenna_from_ieee80211(st
 	case 0:		/* default/diversity */
 		return B43_ANTENNA_DEFAULT;
 	case 1:		/* Antenna 0 */
 		return B43_ANTENNA0;
 	case 2:		/* Antenna 1 */
 		return B43_ANTENNA1;
+	case 3:		/* Antenna 2 */
+		return B43_ANTENNA2;
+	case 4:		/* Antenna 3 */
+		return B43_ANTENNA3;
 	default:
 		return B43_ANTENNA_DEFAULT;
 	}
 }
 
 static int b43_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2008-01-10 20:05:13.000000000 +0100
@@ -174,19 +174,21 @@ static u8 b43_calc_fallback_rate(u8 bitr
 		return B43_OFDM_RATE_48MB;
 	}
 	B43_WARN_ON(1);
 	return 0;
 }
 
-static void generate_txhdr_fw4(struct b43_wldev *dev,
-			       struct b43_txhdr_fw4 *txhdr,
-			       const unsigned char *fragment_data,
-			       unsigned int fragment_len,
-			       const struct ieee80211_tx_control *txctl,
-			       u16 cookie)
+/* Generate a TX data header. */
+void b43_generate_txhdr(struct b43_wldev *dev,
+			u8 *_txhdr,
+			const unsigned char *fragment_data,
+			unsigned int fragment_len,
+			const struct ieee80211_tx_control *txctl,
+			u16 cookie)
 {
+	struct b43_txhdr *txhdr = (struct b43_txhdr *)_txhdr;
 	const struct b43_phy *phy = &dev->phy;
 	const struct ieee80211_hdr *wlhdr =
 	    (const struct ieee80211_hdr *)fragment_data;
 	int use_encryption = (!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT));
 	u16 fctl = le16_to_cpu(wlhdr->frame_control);
 	u8 rate, rate_fb;
@@ -238,135 +240,177 @@ static void generate_txhdr_fw4(struct b4
 		B43_WARN_ON(!key->keyconf);
 
 		/* Hardware appends ICV. */
 		plcp_fragment_len += txctl->icv_len;
 
 		key_idx = b43_kidx_to_fw(dev, key_idx);
-		mac_ctl |= (key_idx << B43_TX4_MAC_KEYIDX_SHIFT) &
-			   B43_TX4_MAC_KEYIDX;
-		mac_ctl |= (key->algorithm << B43_TX4_MAC_KEYALG_SHIFT) &
-			   B43_TX4_MAC_KEYALG;
+		mac_ctl |= (key_idx << B43_TXH_MAC_KEYIDX_SHIFT) &
+			   B43_TXH_MAC_KEYIDX;
+		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
+			   B43_TXH_MAC_KEYALG;
 		wlhdr_len = ieee80211_get_hdrlen(fctl);
 		iv_len = min((size_t) txctl->iv_len,
 			     ARRAY_SIZE(txhdr->iv));
 		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
 	}
-	b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->plcp),
-			      plcp_fragment_len, rate);
+	if (b43_is_old_txhdr_format(dev)) {
+		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->old_format.plcp),
+				      plcp_fragment_len, rate);
+	} else {
+		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->new_format.plcp),
+				      plcp_fragment_len, rate);
+	}
 	b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->plcp_fb),
 			      plcp_fragment_len, rate_fb);
 
 	/* Extra Frame Types */
 	if (rate_fb_ofdm)
-		extra_ft |= B43_TX4_EFT_FBOFDM;
+		extra_ft |= B43_TXH_EFT_FB_OFDM;
+	else
+		extra_ft |= B43_TXH_EFT_FB_CCK;
 
 	/* Set channel radio code. Note that the micrcode ORs 0x100 to
 	 * this value before comparing it to the value in SHM, if this
 	 * is a 5Ghz packet.
 	 */
 	txhdr->chan_radio_code = phy->channel;
 
 	/* PHY TX Control word */
 	if (rate_ofdm)
-		phy_ctl |= B43_TX4_PHY_OFDM;
+		phy_ctl |= B43_TXH_PHY_ENC_OFDM;
+	else
+		phy_ctl |= B43_TXH_PHY_ENC_CCK;
 	if (dev->short_preamble)
-		phy_ctl |= B43_TX4_PHY_SHORTPRMBL;
+		phy_ctl |= B43_TXH_PHY_SHORTPRMBL;
 
 	switch (b43_ieee80211_antenna_sanitize(dev, txctl->antenna_sel_tx)) {
 	case 0: /* Default */
-		phy_ctl |= B43_TX4_PHY_ANTLAST;
+		phy_ctl |= B43_TXH_PHY_ANT01AUTO;
 		break;
 	case 1: /* Antenna 0 */
-		phy_ctl |= B43_TX4_PHY_ANT0;
+		phy_ctl |= B43_TXH_PHY_ANT0;
 		break;
 	case 2: /* Antenna 1 */
-		phy_ctl |= B43_TX4_PHY_ANT1;
+		phy_ctl |= B43_TXH_PHY_ANT1;
+		break;
+	case 3: /* Antenna 2 */
+		phy_ctl |= B43_TXH_PHY_ANT2;
+		break;
+	case 4: /* Antenna 3 */
+		phy_ctl |= B43_TXH_PHY_ANT3;
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
 
 	/* MAC control */
 	if (!(txctl->flags & IEEE80211_TXCTL_NO_ACK))
-		mac_ctl |= B43_TX4_MAC_ACK;
+		mac_ctl |= B43_TXH_MAC_ACK;
 	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
 	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
-		mac_ctl |= B43_TX4_MAC_HWSEQ;
+		mac_ctl |= B43_TXH_MAC_HWSEQ;
 	if (txctl->flags & IEEE80211_TXCTL_FIRST_FRAGMENT)
-		mac_ctl |= B43_TX4_MAC_STMSDU;
+		mac_ctl |= B43_TXH_MAC_STMSDU;
 	if (phy->type == B43_PHYTYPE_A)
-		mac_ctl |= B43_TX4_MAC_5GHZ;
+		mac_ctl |= B43_TXH_MAC_5GHZ;
 	if (txctl->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
-		mac_ctl |= B43_TX4_MAC_LONGFRAME;
+		mac_ctl |= B43_TXH_MAC_LONGFRAME;
 
 	/* Generate the RTS or CTS-to-self frame */
 	if ((txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
 	    (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
 		unsigned int len;
 		struct ieee80211_hdr *hdr;
 		int rts_rate, rts_rate_fb;
 		int rts_rate_ofdm, rts_rate_fb_ofdm;
+		struct b43_plcp_hdr6 *plcp;
 
 		rts_rate = txctl->rts_cts_rate;
 		rts_rate_ofdm = b43_is_ofdm_rate(rts_rate);
 		rts_rate_fb = b43_calc_fallback_rate(rts_rate);
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+			struct ieee80211_cts *cts;
+
+			if (b43_is_old_txhdr_format(dev)) {
+				cts = (struct ieee80211_cts *)
+					(txhdr->old_format.rts_frame);
+			} else {
+				cts = (struct ieee80211_cts *)
+					(txhdr->new_format.rts_frame);
+			}
 			ieee80211_ctstoself_get(dev->wl->hw, txctl->vif,
 						fragment_data, fragment_len,
-						txctl,
-						(struct ieee80211_cts *)(txhdr->
-									 rts_frame));
-			mac_ctl |= B43_TX4_MAC_SENDCTS;
+						txctl, cts);
+			mac_ctl |= B43_TXH_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
+			struct ieee80211_rts *rts;
+
+			if (b43_is_old_txhdr_format(dev)) {
+				rts = (struct ieee80211_rts *)
+					(txhdr->old_format.rts_frame);
+			} else {
+				rts = (struct ieee80211_rts *)
+					(txhdr->new_format.rts_frame);
+			}
 			ieee80211_rts_get(dev->wl->hw, txctl->vif,
-					  fragment_data, fragment_len, txctl,
-					  (struct ieee80211_rts *)(txhdr->
-								   rts_frame));
-			mac_ctl |= B43_TX4_MAC_SENDRTS;
+					  fragment_data, fragment_len,
+					  txctl, rts);
+			mac_ctl |= B43_TXH_MAC_SENDRTS;
 			len = sizeof(struct ieee80211_rts);
 		}
 		len += FCS_LEN;
-		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->
-							       rts_plcp), len,
-				      rts_rate);
-		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->
-							       rts_plcp_fb),
+
+		/* Generate the PLCP headers for the RTS/CTS frame */
+		if (b43_is_old_txhdr_format(dev))
+			plcp = &txhdr->old_format.rts_plcp;
+		else
+			plcp = &txhdr->new_format.rts_plcp;
+		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)plcp,
+				      len, rts_rate);
+		plcp = &txhdr->rts_plcp_fb;
+		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)plcp,
 				      len, rts_rate_fb);
-		hdr = (struct ieee80211_hdr *)(&txhdr->rts_frame);
+
+		if (b43_is_old_txhdr_format(dev)) {
+			hdr = (struct ieee80211_hdr *)
+				(&txhdr->old_format.rts_frame);
+		} else {
+			hdr = (struct ieee80211_hdr *)
+				(&txhdr->new_format.rts_frame);
+		}
 		txhdr->rts_dur_fb = hdr->duration_id;
+
 		if (rts_rate_ofdm) {
-			extra_ft |= B43_TX4_EFT_RTSOFDM;
+			extra_ft |= B43_TXH_EFT_RTS_OFDM;
 			txhdr->phy_rate_rts =
 			    b43_plcp_get_ratecode_ofdm(rts_rate);
-		} else
+		} else {
+			extra_ft |= B43_TXH_EFT_RTS_CCK;
 			txhdr->phy_rate_rts =
 			    b43_plcp_get_ratecode_cck(rts_rate);
+		}
 		if (rts_rate_fb_ofdm)
-			extra_ft |= B43_TX4_EFT_RTSFBOFDM;
+			extra_ft |= B43_TXH_EFT_RTSFB_OFDM;
+		else
+			extra_ft |= B43_TXH_EFT_RTSFB_CCK;
 	}
 
 	/* Magic cookie */
-	txhdr->cookie = cpu_to_le16(cookie);
+	if (b43_is_old_txhdr_format(dev))
+		txhdr->old_format.cookie = cpu_to_le16(cookie);
+	else
+		txhdr->new_format.cookie = cpu_to_le16(cookie);
 
 	/* Apply the bitfields */
 	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
 	txhdr->phy_ctl = cpu_to_le16(phy_ctl);
 	txhdr->extra_ft = extra_ft;
-}
 
-void b43_generate_txhdr(struct b43_wldev *dev,
-			u8 * txhdr,
-			const unsigned char *fragment_data,
-			unsigned int fragment_len,
-			const struct ieee80211_tx_control *txctl, u16 cookie)
-{
-	generate_txhdr_fw4(dev, (struct b43_txhdr_fw4 *)txhdr,
-			   fragment_data, fragment_len, txctl, cookie);
 }
 
 static s8 b43_rssi_postprocess(struct b43_wldev *dev,
 			       u8 in_rssi, int ofdm,
 			       int adjust_2053, int adjust_2050)
 {
Index: wireless-2.6/drivers/net/wireless/b43/xmit.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.h	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.h	2008-01-10 20:23:10.000000000 +0100
@@ -16,74 +16,166 @@ _b43_declare_plcp_hdr(4);
 /* struct b43_plcp_hdr6 */
 _b43_declare_plcp_hdr(6);
 
 #undef _b43_declare_plcp_hdr
 
 /* TX header for v4 firmware */
-struct b43_txhdr_fw4 {
-	__le32 mac_ctl;		/* MAC TX control */
-	__le16 mac_frame_ctl;	/* Copy of the FrameControl field */
+struct b43_txhdr {
+	__le32 mac_ctl;			/* MAC TX control */
+	__le16 mac_frame_ctl;		/* Copy of the FrameControl field */
 	__le16 tx_fes_time_norm;	/* TX FES Time Normal */
-	__le16 phy_ctl;		/* PHY TX control */
-	__le16 phy_ctl_0;	/* Unused */
-	__le16 phy_ctl_1;	/* Unused */
-	__le16 phy_ctl_rts_0;	/* Unused */
-	__le16 phy_ctl_rts_1;	/* Unused */
-	__u8 phy_rate;		/* PHY rate */
-	__u8 phy_rate_rts;	/* PHY rate for RTS/CTS */
-	__u8 extra_ft;		/* Extra Frame Types */
-	__u8 chan_radio_code;	/* Channel Radio Code */
-	__u8 iv[16];		/* Encryption IV */
-	__u8 tx_receiver[6];	/* TX Frame Receiver address */
-	__le16 tx_fes_time_fb;	/* TX FES Time Fallback */
-	struct b43_plcp_hdr6 rts_plcp_fb;	/* RTS fallback PLCP */
-	__le16 rts_dur_fb;	/* RTS fallback duration */
-	struct b43_plcp_hdr6 plcp_fb;	/* Fallback PLCP */
-	__le16 dur_fb;		/* Fallback duration */
-	__le16 mm_dur_time;	/* Unused */
-	__le16 mm_dur_time_fb;	/* Unused */
-	__le32 time_stamp;	/* Timestamp */
-	 PAD_BYTES(2);
-	__le16 cookie;		/* TX frame cookie */
-	__le16 tx_status;	/* TX status */
-	struct b43_plcp_hdr6 rts_plcp;	/* RTS PLCP */
-	__u8 rts_frame[16];	/* The RTS frame (if used) */
-	 PAD_BYTES(2);
-	struct b43_plcp_hdr6 plcp;	/* Main PLCP */
+	__le16 phy_ctl;			/* PHY TX control */
+	__le16 phy_ctl1;		/* PHY TX control word 1 */
+	__le16 phy_ctl1_fb;		/* PHY TX control word 1 for fallback rates */
+	__le16 phy_ctl1_rts;		/* PHY TX control word 1 RTS */
+	__le16 phy_ctl1_rts_fb;		/* PHY TX control word 1 RTS for fallback rates */
+	__u8 phy_rate;			/* PHY rate */
+	__u8 phy_rate_rts;		/* PHY rate for RTS/CTS */
+	__u8 extra_ft;			/* Extra Frame Types */
+	__u8 chan_radio_code;		/* Channel Radio Code */
+	__u8 iv[16];			/* Encryption IV */
+	__u8 tx_receiver[6];		/* TX Frame Receiver address */
+	__le16 tx_fes_time_fb;		/* TX FES Time Fallback */
+	struct b43_plcp_hdr6 rts_plcp_fb; /* RTS fallback PLCP header */
+	__le16 rts_dur_fb;		/* RTS fallback duration */
+	struct b43_plcp_hdr6 plcp_fb;	/* Fallback PLCP header */
+	__le16 dur_fb;			/* Fallback duration */
+	__le16 mimo_modelen;		/* MIMO mode length */
+	__le16 mimo_ratelen_fb;		/* MIMO fallback rate length */
+	__le32 timeout;			/* Timeout */
+
+	union {
+		/* The new r410 format. */
+		struct {
+			__le16 mimo_antenna;		/* MIMO antenna select */
+			__le16 preload_size;		/* Preload size */
+			PAD_BYTES(2);
+			__le16 cookie;			/* TX frame cookie */
+			__le16 tx_status;		/* TX status */
+			struct b43_plcp_hdr6 rts_plcp;	/* RTS PLCP header */
+			__u8 rts_frame[16];		/* The RTS frame (if used) */
+			PAD_BYTES(2);
+			struct b43_plcp_hdr6 plcp;	/* Main PLCP header */
+		} new_format __attribute__ ((__packed__));
+
+		/* The old r351 format. */
+		struct {
+			PAD_BYTES(2);
+			__le16 cookie;			/* TX frame cookie */
+			__le16 tx_status;		/* TX status */
+			struct b43_plcp_hdr6 rts_plcp;	/* RTS PLCP header */
+			__u8 rts_frame[16];		/* The RTS frame (if used) */
+			PAD_BYTES(2);
+			struct b43_plcp_hdr6 plcp;	/* Main PLCP header */
+		} old_format __attribute__ ((__packed__));
+
+	} __attribute__ ((__packed__));
 } __attribute__ ((__packed__));
 
 /* MAC TX control */
-#define B43_TX4_MAC_KEYIDX		0x0FF00000	/* Security key index */
-#define B43_TX4_MAC_KEYIDX_SHIFT	20
-#define B43_TX4_MAC_KEYALG		0x00070000	/* Security key algorithm */
-#define B43_TX4_MAC_KEYALG_SHIFT	16
-#define B43_TX4_MAC_LIFETIME	0x00001000
-#define B43_TX4_MAC_FRAMEBURST	0x00000800
-#define B43_TX4_MAC_SENDCTS		0x00000400
-#define B43_TX4_MAC_AMPDU		0x00000300
-#define B43_TX4_MAC_AMPDU_SHIFT	8
-#define B43_TX4_MAC_5GHZ		0x00000080
-#define B43_TX4_MAC_IGNPMQ		0x00000020
-#define B43_TX4_MAC_HWSEQ		0x00000010	/* Use Hardware Sequence Number */
-#define B43_TX4_MAC_STMSDU		0x00000008	/* Start MSDU */
-#define B43_TX4_MAC_SENDRTS		0x00000004
-#define B43_TX4_MAC_LONGFRAME	0x00000002
-#define B43_TX4_MAC_ACK		0x00000001
+#define B43_TXH_MAC_USEFBR		0x10000000 /* Use fallback rate for this AMPDU */
+#define B43_TXH_MAC_KEYIDX		0x0FF00000 /* Security key index */
+#define B43_TXH_MAC_KEYIDX_SHIFT	20
+#define B43_TXH_MAC_KEYALG		0x00070000 /* Security key algorithm */
+#define B43_TXH_MAC_KEYALG_SHIFT	16
+#define B43_TXH_MAC_AMIC		0x00008000 /* AMIC */
+#define B43_TXH_MAC_RIFS		0x00004000 /* Use RIFS */
+#define B43_TXH_MAC_LIFETIME		0x00002000 /* Lifetime */
+#define B43_TXH_MAC_FRAMEBURST		0x00001000 /* Frameburst */
+#define B43_TXH_MAC_SENDCTS		0x00000800 /* Send CTS-to-self */
+#define B43_TXH_MAC_AMPDU		0x00000600 /* AMPDU status */
+#define  B43_TXH_MAC_AMPDU_MPDU		0x00000000 /* Regular MPDU, not an AMPDU */
+#define  B43_TXH_MAC_AMPDU_FIRST	0x00000200 /* First MPDU or AMPDU */
+#define  B43_TXH_MAC_AMPDU_INTER	0x00000400 /* Intermediate MPDU or AMPDU */
+#define  B43_TXH_MAC_AMPDU_LAST		0x00000600 /* Last (or only) MPDU of AMPDU */
+#define B43_TXH_MAC_40MHZ		0x00000100 /* Use 40 MHz bandwidth */
+#define B43_TXH_MAC_5GHZ		0x00000080 /* 5GHz band */
+#define B43_TXH_MAC_DFCS		0x00000040 /* DFCS */
+#define B43_TXH_MAC_IGNPMQ		0x00000020 /* Ignore PMQ */
+#define B43_TXH_MAC_HWSEQ		0x00000010 /* Use Hardware Sequence Number */
+#define B43_TXH_MAC_STMSDU		0x00000008 /* Start MSDU */
+#define B43_TXH_MAC_SENDRTS		0x00000004 /* Send RTS */
+#define B43_TXH_MAC_LONGFRAME		0x00000002 /* Long frame */
+#define B43_TXH_MAC_ACK			0x00000001 /* Immediate ACK */
 
 /* Extra Frame Types */
-#define B43_TX4_EFT_FBOFDM		0x0001	/* Data frame fallback rate type */
-#define B43_TX4_EFT_RTSOFDM		0x0004	/* RTS/CTS rate type */
-#define B43_TX4_EFT_RTSFBOFDM	0x0010	/* RTS/CTS fallback rate type */
+#define B43_TXH_EFT_FB			0x03 /* Data frame fallback encoding */
+#define  B43_TXH_EFT_FB_CCK		0x00 /* CCK */
+#define  B43_TXH_EFT_FB_OFDM		0x01 /* OFDM */
+#define  B43_TXH_EFT_FB_EWC		0x02 /* EWC */
+#define  B43_TXH_EFT_FB_N		0x03 /* N */
+#define B43_TXH_EFT_RTS			0x0C /* RTS/CTS encoding */
+#define  B43_TXH_EFT_RTS_CCK		0x00 /* CCK */
+#define  B43_TXH_EFT_RTS_OFDM		0x04 /* OFDM */
+#define  B43_TXH_EFT_RTS_EWC		0x08 /* EWC */
+#define  B43_TXH_EFT_RTS_N		0x0C /* N */
+#define B43_TXH_EFT_RTSFB		0x30 /* RTS/CTS fallback encoding */
+#define  B43_TXH_EFT_RTSFB_CCK		0x00 /* CCK */
+#define  B43_TXH_EFT_RTSFB_OFDM		0x10 /* OFDM */
+#define  B43_TXH_EFT_RTSFB_EWC		0x20 /* EWC */
+#define  B43_TXH_EFT_RTSFB_N		0x30 /* N */
 
 /* PHY TX control word */
-#define B43_TX4_PHY_OFDM		0x0001	/* Data frame rate type */
-#define B43_TX4_PHY_SHORTPRMBL	0x0010	/* Use short preamble */
-#define B43_TX4_PHY_ANT		0x03C0	/* Antenna selection */
-#define  B43_TX4_PHY_ANT0		0x0000	/* Use antenna 0 */
-#define  B43_TX4_PHY_ANT1		0x0100	/* Use antenna 1 */
-#define  B43_TX4_PHY_ANTLAST	0x0300	/* Use last used antenna */
+#define B43_TXH_PHY_ENC			0x0003 /* Data frame encoding */
+#define  B43_TXH_PHY_ENC_CCK		0x0000 /* CCK */
+#define  B43_TXH_PHY_ENC_OFDM		0x0001 /* OFDM */
+#define  B43_TXH_PHY_ENC_EWC		0x0002 /* EWC */
+#define  B43_TXH_PHY_ENC_N		0x0003 /* N */
+#define B43_TXH_PHY_SHORTPRMBL		0x0010 /* Use short preamble */
+#define B43_TXH_PHY_ANT			0x03C0 /* Antenna selection */
+#define  B43_TXH_PHY_ANT0		0x0000 /* Use antenna 0 */
+#define  B43_TXH_PHY_ANT1		0x0040 /* Use antenna 1 */
+#define  B43_TXH_PHY_ANT01AUTO		0x00C0 /* Use antenna 0/1 auto */
+#define  B43_TXH_PHY_ANT2		0x0100 /* Use antenna 2 */
+#define  B43_TXH_PHY_ANT3		0x0200 /* Use antenna 3 */
+#define B43_TXH_PHY_TXPWR		0xFC00 /* TX power */
+#define B43_TXH_PHY_TXPWR_SHIFT		10
+
+/* PHY TX control word 1 */
+#define B43_TXH_PHY1_BW			0x0007 /* Bandwidth */
+#define  B43_TXH_PHY1_BW_10		0x0000 /* 10 MHz */
+#define  B43_TXH_PHY1_BW_10U		0x0001 /* 10 MHz upper */
+#define  B43_TXH_PHY1_BW_20		0x0002 /* 20 MHz */
+#define  B43_TXH_PHY1_BW_20U		0x0003 /* 20 MHz upper */
+#define  B43_TXH_PHY1_BW_40		0x0004 /* 40 MHz */
+#define  B43_TXH_PHY1_BW_40DUP		0x0005 /* 50 MHz duplicate */
+#define B43_TXH_PHY1_MODE		0x0038 /* Mode */
+#define  B43_TXH_PHY1_MODE_SISO		0x0000 /* SISO */
+#define  B43_TXH_PHY1_MODE_CDD		0x0008 /* CDD */
+#define  B43_TXH_PHY1_MODE_STBC		0x0010 /* STBC */
+#define  B43_TXH_PHY1_MODE_SDM		0x0018 /* SDM */
+#define B43_TXH_PHY1_CRATE		0x0700 /* Coding rate */
+#define  B43_TXH_PHY1_CRATE_1_2		0x0000 /* 1/2 */
+#define  B43_TXH_PHY1_CRATE_2_3		0x0100 /* 2/3 */
+#define  B43_TXH_PHY1_CRATE_3_4		0x0200 /* 3/4 */
+#define  B43_TXH_PHY1_CRATE_4_5		0x0300 /* 4/5 */
+#define  B43_TXH_PHY1_CRATE_5_6		0x0400 /* 5/6 */
+#define  B43_TXH_PHY1_CRATE_7_8		0x0600 /* 7/8 */
+#define B43_TXH_PHY1_MODUL		0x3800 /* Modulation scheme */
+#define  B43_TXH_PHY1_MODUL_BPSK	0x0000 /* BPSK */
+#define  B43_TXH_PHY1_MODUL_QPSK	0x0800 /* QPSK */
+#define  B43_TXH_PHY1_MODUL_QAM16	0x1000 /* QAM16 */
+#define  B43_TXH_PHY1_MODUL_QAM64	0x1800 /* QAM64 */
+#define  B43_TXH_PHY1_MODUL_QAM256	0x2000 /* QAM256 */
+
+
+/* r351 firmware compatibility stuff. */
+static inline
+bool b43_is_old_txhdr_format(struct b43_wldev *dev)
+{
+	return (dev->fw.rev <= 351);
+}
+
+static inline
+size_t b43_txhdr_size(struct b43_wldev *dev)
+{
+	if (b43_is_old_txhdr_format(dev))
+		return 100 + sizeof(struct b43_plcp_hdr6);
+	return 104 + sizeof(struct b43_plcp_hdr6);
+}
+
 
 void b43_generate_txhdr(struct b43_wldev *dev,
 			u8 * txhdr,
 			const unsigned char *fragment_data,
 			unsigned int fragment_len,
 			const struct ieee80211_tx_control *txctl, u16 cookie);
Index: wireless-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- wireless-2.6.orig/Documentation/feature-removal-schedule.txt	2007-12-20 18:53:57.000000000 +0100
+++ wireless-2.6/Documentation/feature-removal-schedule.txt	2008-01-10 20:29:48.000000000 +0100
@@ -355,6 +355,15 @@ What:	rc80211-simple rate control algori
 When:	2.6.26
 Files:	net/mac80211/rc80211-simple.c
 Why:	This algorithm was provided for reference but always exhibited bad
 	responsiveness and performance and has some serious flaws. It has been
 	replaced by rc80211-pid.
 Who:	Stefano Brivio <stefano.brivio@polimi.it>
+
+---------------------------
+
+What:	b43 support for firmware revision < 410
+When:	July 2008
+Why:	The support code for the old firmware hurts code readability/maintainability
+	and slightly hurts runtime performance. Bugfixes for the old firmware
+	are not provided by Broadcom anymore.
+Who:	Michael Buesch <mb@bu3sch.de>
Index: wireless-2.6/drivers/net/wireless/b43/phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.h	2008-01-09 18:48:42.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/phy.h	2008-01-10 19:57:45.000000000 +0100
@@ -177,12 +177,14 @@ void b43_gtab_write(struct b43_wldev *de
 
 enum {
 	B43_ANTENNA0,		/* Antenna 0 */
 	B43_ANTENNA1,		/* Antenna 0 */
 	B43_ANTENNA_AUTO1,	/* Automatic, starting with antenna 1 */
 	B43_ANTENNA_AUTO0,	/* Automatic, starting with antenna 0 */
+	B43_ANTENNA2,
+	B43_ANTENNA3 = 8,
 
 	B43_ANTENNA_AUTO = B43_ANTENNA_AUTO0,
 	B43_ANTENNA_DEFAULT = B43_ANTENNA_AUTO,
 };
 
 enum {
