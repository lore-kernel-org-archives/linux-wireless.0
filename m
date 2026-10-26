Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793038553;
	b=1B6IMgcuXxUhe0AzL2r7RL35lryPfLPoc1odE8WnKwAnDWVivHiX35I3OQ7mLj8PSy+r
	 gLWoY321iFH8RLQKGy3+ifBSpIl0Z2Mz1YiKpdl/LjzM/dcIxKNWSy0p9GUAkRKxtbAJZ
	 oqOKBefWw7wo1uAyI9DM4GYh5Nhh1AHsS/DcvBqXOW6QSCqPq4752VOE3L2DG7MImmXyF
	 G6o0mypdOLxy2ZdBmU5I4NF775eN1yCQo+U8em1tzen3FtJDSfHJD2vaBBTSRB7NaRpDx
	 c1GRYoNHF5MiYOzLgtoVWPoizWnbV1Eruvq/zrocpvIV+/ZKI46GGyZWazZR17SzGQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NsuTrr6wIfPAB8pWsn28L5K8P03qXg+Oz5Zpu1MppRI=;
	b=OmDG8SPNbjWlHerqr821WJVsqIIGsMbYhx9FXVBDa8uiHiKDUNVk/MWlI63lHMXqZzeR
	 QFNpIj/xKc+L1uhDDQ0e7ET08eeWqWG110GrA/B+ZI33wpte8xkM7Gw4sBJOpvxt8Pcv+
	 D59ouocdxp0YwbzIIluIWJR930zkexpq2OawAilkLBWjsxMQ7esxmO3oqG/BMbwaMqlD+
	 tE5L0CielM4PswtSGyqT3Kz0s9jKoy37K2VowUcMWitU4QSBc0vaimquqmATzVVTx9lOB
	 ER2y0PDchkhbEeEwQR7fkb3btUzRblND+rVOwhnU3ExBBQQOpOhuGz5xu+N49UornWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="SWL5c/I2";
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FBD606A328
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10FBD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SWL5c/I2
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48df4f540ebso1648538f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038551; x=1793643351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NsuTrr6wIfPAB8pWsn28L5K8P03qXg+Oz5Zpu1MppRI=;
        b=SWL5c/I2vpPH3DiOat0r6PaZqDKRCbry59eoJPqmOV9MvqBg7J/IThbm/S4RIv85vn
         N8kbH6TZplOPONdD8ywdkPcGf982cAafU8LgLYpfdLNjB0m0AI88OcqQ3FlZW5vb9qvo
         Bx1XJQK0So+2n6N/R/UlBgmKIaLTK0iTjgJeJQUB6e1oJ8BR+WCfurwjk9nlA5A/BHbs
         yxTE3tlvQwVhfecnKlBe2ypbo/MJWt00hliuDCDYTr96Yi9GfBoen2Gi3Br4NaH5ba7s
         fnHOgVprrl6nXH7f0VuisnTXF86lQfjIXnNibvJeC9z/jlk8khuNdhc8FdowP9UY3yiF
         db4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038551; x=1793643351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NsuTrr6wIfPAB8pWsn28L5K8P03qXg+Oz5Zpu1MppRI=;
        b=uQeX6Hke387fqixKBsjhzKn1WFhHT4mvXBwHdeOjP4i99Iium1Xsf6uTkQPww+7/VP
         n0OyV4eN4j3ctKb9AHL1njhKG4sK8wVZV/j9bOl6IXt4xI1wlcDH1sgDBRwSSKrAKsu3
         fxogfd6NrEPiZRRMlWnAjOXABbvU02tJD0oArvLZp9HogNaFggOiD6N7WhZ+Jc+srwlf
         uuT1/g0Gp5ZYgxyxndXSQY5WDozUoFGjrwPXH6O1Y38zI1EgFpOs9Ir8LHnWFL7iDW1o
         eyomIbnNLlQQ1qwIlN7UFcMDvgCSs2o5QhpTpV4cRzqRy5wsKBogKn0xQl7sOD4TzJb1
         OXMw==
X-Gm-Message-State: AFq9FYLt4A2zyHL5v8NDz9cvGD/OHikOBmD9rrbnVu9fRendkzEzNj7M
	VgHrgQk8f+jn5TtGfN69nPztk2KcZuG4sbNHa222FwjBZVJJ8ctTxYkB4n7XP6Gv
X-Gm-Gg: AYBFou0IxoEun725RSM87Ohf2b7ALv2OJHdp7i68ZNgKD5UKqrsSBrOqhePh6t2bsPR
	nEPxYmGFm/NjOPycmFdhwbQqbD5QKVXPb3p8QNbOJR7qkMqPUqCHBOgKuuBvWWK/JxCok8x6ker
	Fec4gHYl755GRmon7yfL/YQroARc2u0tryj7NxnOw3gpqWqAqKxkkYKwFiMuuQOrXvJW5JOK2Mq
	JA5OxE0A+7bTDgirGJiCGMc5q1orrkGtNhMuKI7TSPjSZHJ3BvrCIauKE3sxFqYkOYvYCBnsimo
	OoerNkjMwoVkIURLghsN8kzpsVJeUCg2JLcfxDvD9nfDC0voz+9mjgv/3BqXUm6Skc6hYynzEe0
	YyuCPoaPQsdZ9mInqWph9SfFilyunsWjeBGno39klJsVD/o8v8FLpnwZ5ki7vYfGtjftsz9J8MZ
	E8x+YuCngPfy9jGBeIeLuuVhX0mlVV3SfBoOEowSY93b+a4MGy20FFRB3ch3KctXHUvcqUhoWCF
	vbB9D1sZPH4aOJFPOhJjUs/LZgeWwhU/o/q3O1pk98Zva2v9jDh0RdnP7GZpIxqh7eLAC2J7aIj
	jOUX
X-Received: by 2002:a5d:59c4:0:b0:48e:d7c:4bc8 with SMTP id ffacd0b85a97d-48e3eb46851mr13346093f8f.7.1793038551308;
        Mon, 26 Oct 2026 11:15:51 -0700 (PDT)
Received: from luca-HP-ProBook-650-G1.lan ([2001:b07:6454:c33e:6c42:b004:d90b:d191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm20967847f8f.45.2026.10.26.11.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:15:50 -0700 (PDT)
From: Luca Casati <luk00casati@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	arend.vanspriel@broadcom.com,
	b43-dev@lists.infradead.org,
	Luca Casati <luk00casati@gmail.com>
Subject: [PATCH wireless-next 2/5] b43: N-PHY: fix TX IQ/LO calibration
Date: Mon, 26 Oct 2026 19:15:40 +0100
Message-ID: <20261026181543.77763-3-luk00casati@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026181543.77763-1-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several bugs kept the TX IQ/LO calibration from working, and on rev7+
it left TX dead afterwards:

- The busy poll on IQLOCAL_CMD was inverted: bits 15:14 are set while a
  step runs, so it stopped waiting as soon as the step started.
- The final copy was reversed: it wrote the stale buffer over the best
  coefficients (table 15 at 96) and read the active ones (at 80), so the
  result was never applied.
- TxCalPhyCleanup lacked the rev7+ part of brcmsmac's
  wlc_phy_txcal_phycleanup_nphy(): the 0x80 and 0x8 (PA power-up) RF
  overrides set up for the cal were left in place.
- There was no counterpart to b43_nphy_tx_cal_radio_setup_rev7(), so the
  TSSI/IQ-cal path stayed switched in. Add one, following
  wlc_phy_txcal_radio_cleanup_nphy().
- The TRSW override for the second core used 8, which does not fit the
  2-bit field on rev7+; use 2 as wl does.

With these, on a BCM43228 (N-PHY rev 16, radio 2057 rev 9) the per-step
coefficients match the proprietary wl driver's.

Found and fixed with the help of an AI coding assistant (Claude Opus 5.5),
by comparing mmiotraces of b43 and wl on the same card.

Signed-off-by: Luca Casati <luk00casati@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 89 +++++++++++++++++++++--
 1 file changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 66565c14e..cabf61870 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -4775,6 +4775,37 @@ static void b43_nphy_tx_cal_radio_setup_rev7(struct b43_wldev *dev)
 	}
 }
 
+/*
+ * Undo b43_nphy_tx_cal_radio_setup_rev7(), as brcmsmac's
+ * wlc_phy_txcal_radio_cleanup_nphy() does. Without it the TSSI/IQ cal
+ * path stays switched in after a TX IQ/LO cal.
+ */
+static void b43_nphy_tx_cal_radio_cleanup(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	u16 *save = dev->phy.n->tx_rx_cal_radio_saveregs;
+	int core, off;
+	u16 r;
+
+	if (phy->rev < 7 || phy->rev >= 19)
+		return;
+
+	for (core = 0; core < 2; core++) {
+		r = core ? 0x20 : 0;
+		off = core * 11;
+
+		b43_radio_write(dev, r + R2057_TX0_TX_SSI_MASTER, save[off + 0]);
+		b43_radio_write(dev, r + R2057_TX0_IQCAL_VCM_HG, save[off + 1]);
+		b43_radio_write(dev, r + R2057_TX0_IQCAL_IDAC, save[off + 2]);
+		b43_radio_write(dev, r + R2057_TX0_TSSI_VCM, save[off + 3]);
+		b43_radio_write(dev, r + R2057_TX0_TX_SSI_MUX, save[off + 5]);
+		if (phy->radio_rev != 5)
+			b43_radio_write(dev, r + R2057_TX0_TSSIA, save[off + 6]);
+		b43_radio_write(dev, r + R2057_TX0_TSSIG, save[off + 7]);
+		b43_radio_write(dev, r + R2057_TX0_TSSI_MISC1, save[off + 8]);
+	}
+}
+
 /* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalRadioSetup */
 static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 {
@@ -5033,7 +5064,9 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 /* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhyCleanup */
 static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
 {
-	u16 *regs = dev->phy.n->tx_rx_cal_phy_saveregs;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 *regs = nphy->tx_rx_cal_phy_saveregs;
 
 	if (dev->phy.rev >= 3) {
 		b43_phy_write(dev, B43_NPHY_AFECTL_C1, regs[0]);
@@ -5047,7 +5080,42 @@ static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs[8]);
 		b43_phy_write(dev, B43_NPHY_PAPD_EN0, regs[9]);
 		b43_phy_write(dev, B43_NPHY_PAPD_EN1, regs[10]);
+
+		/*
+		 * Drop the overrides b43_nphy_tx_cal_phy_setup() set on rev7+
+		 * (as brcmsmac's wlc_phy_txcal_phycleanup_nphy()). Leaving
+		 * the 0x8 (PA power-up) override in place kills TX.
+		 */
+		if (phy->rev >= 19)
+			b43_nphy_rf_ctl_override_rev19(dev, 0x80, 0, 0, true,
+						       1);
+		else if (phy->rev >= 7)
+			b43_nphy_rf_ctl_override_rev7(dev, 0x80, 0, 0, true, 1);
+
 		b43_nphy_reset_cca(dev);
+
+		if (nphy->use_int_tx_iq_lo_cal) {
+			if (phy->rev >= 19) {
+				b43_nphy_rf_ctl_override_rev19(dev, 0x8, 0, 0x3,
+							       true, 0);
+			} else if (phy->rev >= 8) {
+				b43_nphy_rf_ctl_override_rev7(dev, 0x8, 0, 0x3,
+							      true, 0);
+			} else if (phy->rev == 7) {
+				bool ghz2 = b43_current_band(dev->wl) ==
+					    NL80211_BAND_2GHZ;
+
+				b43_radio_maskset(dev, ghz2 ?
+						  R2057_PAD2G_TUNE_PUS_CORE0 :
+						  R2057_IPA5G_CASCOFFV_PU_CORE0,
+						  ~1, 1);
+				b43_radio_maskset(dev, ghz2 ?
+						  R2057_PAD2G_TUNE_PUS_CORE1 :
+						  R2057_IPA5G_CASCOFFV_PU_CORE1,
+						  ~1, 1);
+				b43_radio_mask(dev, R2057_OVR_REG0, ~(1 << 4));
+			}
+		}
 	} else {
 		b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, regs[0]);
 		b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, regs[1]);
@@ -5102,7 +5170,12 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 			b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_PA,
 						      0, 3);
 		b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_TRSW, 2, 1);
-		b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_TRSW, 8, 2);
+		/*
+		 * On rev7+ the TRSW field is 2 bits wide, so the legacy value
+		 * 8 for the second core ends up as 0; wl uses 2 there.
+		 */
+		b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_TRSW,
+					      phy->rev >= 7 ? 2 : 8, 2);
 
 		regs[9] = b43_phy_read(dev, B43_NPHY_PAPD_EN0);
 		regs[10] = b43_phy_read(dev, B43_NPHY_PAPD_EN1);
@@ -5478,12 +5551,16 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 			}
 
 			b43_phy_write(dev, B43_NPHY_IQLOCAL_CMD, cmd);
+			/* bits 15:14 stay set while the cal step runs */
 			for (i = 0; i < 2000; i++) {
 				tmp = b43_phy_read(dev, B43_NPHY_IQLOCAL_CMD);
-				if (tmp & 0xC000)
+				if (!(tmp & 0xC000))
 					break;
 				udelay(10);
 			}
+			if (i == 2000)
+				b43err(dev->wl, "TX IQ/LO cal step 0x%04x timed out\n",
+				       cmd);
 
 			b43_ntab_read_bulk(dev, B43_NTAB16(15, 96), length,
 						buffer);
@@ -5500,8 +5577,9 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 		last = (dev->phy.rev < 3) ? 6 : 7;
 
 		if (!mphase || nphy->mphase_cal_phase_id == last) {
-			b43_ntab_write_bulk(dev, B43_NTAB16(15, 96), 4, buffer);
-			b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 4, buffer);
+			/* apply the result: best coeffs (96) -> active (80) */
+			b43_ntab_read_bulk(dev, B43_NTAB16(15, 96), 4, buffer);
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 80), 4, buffer);
 			if (dev->phy.rev < 3) {
 				buffer[0] = 0;
 				buffer[1] = 0;
@@ -5540,6 +5618,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 
 	b43_nphy_tx_cal_phy_cleanup(dev);
 	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x110), 2, save);
+	b43_nphy_tx_cal_radio_cleanup(dev);
 
 	if (dev->phy.rev < 2 && (!mphase || nphy->mphase_cal_phase_id == last))
 		b43_nphy_tx_iq_workaround(dev);
-- 
2.43.0

