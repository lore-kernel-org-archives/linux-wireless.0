Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:55086 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933595AbXK2U7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 15:59:22 -0500
Date: Thu, 29 Nov 2007 21:51:39 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [RFT] [PATCH v3] b43: fix calc_nrssi_slope
Message-ID: <20071129215139.60ae663a@morte> (sfid-20071129_205942_771948_DD87B134)
In-Reply-To: <20071129163449.326e592e@morte>
References: <20071129043957.739b4d3f@morte>
	<20071129163449.326e592e@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix calc_nrssi_slope() which caused PHY TX errors on devices containing a
802.11a PHY. The code is synced to v4 specs and relevant registers are
renamed accordingly.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

It looks like I got confused by a comment and used
phy->hardware_power_control instead of b43_has_hardware_pctl() in order to
check whether hardware based power control is enabled. Michael, I think
that this comment:

	/* Hardware Power Control enabled? */
	bool hardware_power_control;

should at least be amended ("enabled by userspace" maybe would be better).
But it's obviously up to you. Here comes the correct patch.

---

Index: wireless-2.6/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.c
+++ wireless-2.6/drivers/net/wireless/b43/phy.c
@@ -2664,77 +2664,68 @@ void b43_calc_nrssi_slope(struct b43_wld
 			b43_calc_nrssi_offset(dev);
 
 		b43_phy_write(dev, B43_PHY_CRS,
-			      b43_phy_read(dev, B43_PHY_CRS) & 0x7FFF);
-		b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & 0xFFFC);
-		backup[7] = b43_read16(dev, 0x03E2);
-		b43_write16(dev, 0x03E2, b43_read16(dev, 0x03E2) | 0x8000);
-		backup[0] = b43_radio_read16(dev, 0x007A);
-		backup[1] = b43_radio_read16(dev, 0x0052);
-		backup[2] = b43_radio_read16(dev, 0x0043);
-		backup[3] = b43_phy_read(dev, 0x0015);
+			      b43_phy_read(dev, B43_PHY_CRS)
+			       & ~B43_PHY_CRS_EN_ALL);
+		b43_phy_write(dev, B43_PHY_CLASSCTL,
+			      b43_phy_read(dev, B43_PHY_CLASSCTL) &
+			       ~(B43_PHY_CLASSCTL_CCK | B43_PHY_CLASSCTL_OFDM));
+		backup[7] = b43_read16(dev, B43_MMIO_PHY_BBANDCFG);
+		b43_write16(dev, B43_MMIO_PHY_BBANDCFG, backup[7] | 0x8000);
+		backup[0] = b43_radio_read16(dev, B43_RADIO_2050_RXCTL0);
+		backup[1] = b43_radio_read16(dev, B43_RADIO_2050_TXCTL1);
+		backup[2] = b43_radio_read16(dev, B43_RADIO_2050_PCTL);
+		backup[3] = b43_phy_read(dev, B43_PHY_PGACTL);
 		backup[4] = b43_phy_read(dev, 0x005A);
 		backup[5] = b43_phy_read(dev, 0x0059);
 		backup[6] = b43_phy_read(dev, 0x0058);
-		backup[8] = b43_read16(dev, 0x03E6);
+		backup[8] = b43_read16(dev, B43_MMIO_PHY0);
 		backup[9] = b43_read16(dev, B43_MMIO_PHY_TEST);
-		if (phy->rev >= 3) {
-			backup[10] = b43_phy_read(dev, 0x002E);
-			backup[11] = b43_phy_read(dev, 0x002F);
-			backup[12] = b43_phy_read(dev, 0x080F);
+		if (phy->pctl_en) {
+			backup[10] = b43_phy_read(dev, B43_PHY_TXDC_OFFSET1);
+			backup[11] = b43_phy_read(dev, B43_PHY_TXDC_OFFSET2);
+			backup[12] = b43_phy_read(dev, B43_PHY_LO_MASK);
 			backup[13] = b43_phy_read(dev, B43_PHY_LO_CTL);
-			backup[14] = b43_phy_read(dev, 0x0801);
-			backup[15] = b43_phy_read(dev, 0x0060);
-			backup[16] = b43_phy_read(dev, 0x0014);
-			backup[17] = b43_phy_read(dev, 0x0478);
-			b43_phy_write(dev, 0x002E, 0);
+			backup[14] = b43_phy_read(dev, B43_PHY_G_CTL);
+			backup[15] = b43_phy_read(dev, B43_PHY_DACCTL);
+			backup[16] = b43_phy_read(dev, B43_PHY_TR_LT2);
+			backup[17] = b43_phy_read(dev, B43_PHY_HPWR_TSSICTL);
+			b43_phy_write(dev, B43_PHY_TXDC_OFFSET1, 0);
+			b43_phy_write(dev, B43_PHY_TXDC_OFFSET2, 0);
+			b43_phy_write(dev, B43_PHY_LO_MASK, 0);
 			b43_phy_write(dev, B43_PHY_LO_CTL, 0);
-			switch (phy->rev) {
-			case 4:
-			case 6:
-			case 7:
-				b43_phy_write(dev, 0x0478,
-					      b43_phy_read(dev, 0x0478)
-					      | 0x0100);
-				b43_phy_write(dev, 0x0801,
-					      b43_phy_read(dev, 0x0801)
-					      | 0x0040);
-				break;
-			case 3:
-			case 5:
-				b43_phy_write(dev, 0x0801,
-					      b43_phy_read(dev, 0x0801)
-					      & 0xFFBF);
-				break;
-			}
-			b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060)
-				      | 0x0040);
-			b43_phy_write(dev, 0x0014, b43_phy_read(dev, 0x0014)
-				      | 0x0200);
-		}
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) | 0x0070);
+			b43_phy_write(dev, B43_PHY_HPWR_TSSICTL, 0);
+			b43_phy_write(dev, B43_PHY_G_CTL, 0);
+			b43_phy_write(dev, B43_PHY_DACCTL, 0);
+			b43_phy_write(dev, B43_PHY_TR_LT2, 0);
+		}
+		b43_radio_write16(dev, B43_RADIO_2050_RXCTL0,
+				  b43_radio_read16(dev, B43_RADIO_2050_RXCTL0)
+				   | 0x0070);
 		b43_set_all_gains(dev, 0, 8, 0);
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) & 0x00F7);
+		b43_radio_write16(dev, B43_RADIO_2050_RXCTL0,
+				  b43_radio_read16(dev, B43_RADIO_2050_RXCTL0)
+				   & 0x00F7);
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0811,
-				      (b43_phy_read(dev, 0x0811) & 0xFFCF) |
-				      0x0030);
-			b43_phy_write(dev, 0x0812,
-				      (b43_phy_read(dev, 0x0812) & 0xFFCF) |
-				      0x0010);
+			b43_phy_write(dev, B43_PHY_RFOVER,
+				      b43_phy_read(dev, B43_PHY_RFOVER)
+				       | 0x0030);
+			b43_phy_write(dev, B43_PHY_RFOVERVAL,
+				      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
+				       & 0xFFCF) | 0x0010);
 		}
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) | 0x0080);
+		b43_radio_write16(dev, B43_RADIO_2050_RXCTL0,
+				  b43_radio_read16(dev, B43_RADIO_2050_RXCTL0)
+				   | 0x0080);
 		udelay(20);
 
-		nrssi0 = (s16) ((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
+		nrssi0 = (s16)((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
 		if (nrssi0 >= 0x0020)
 			nrssi0 -= 0x0040;
 
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) & 0x007F);
-		if (phy->rev >= 2) {
+		b43_radio_write16(dev, B43_RADIO_2050_RXCTL0,
+				  b43_radio_read16(dev, B43_RADIO_2050_RXCTL0)
+				   & 0x0080);
+		if (phy->analog >= 2) {
 			b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003)
 						    & 0xFF9F) | 0x0040);
 		}
@@ -2742,32 +2733,34 @@ void b43_calc_nrssi_slope(struct b43_wld
 		b43_write16(dev, B43_MMIO_PHY_TEST,
 			    b43_read16(dev, B43_MMIO_PHY_TEST)
 			    | 0x2000);
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) | 0x000F);
-		b43_phy_write(dev, 0x0015, 0xF330);
+		b43_radio_write16(dev, B43_RADIO_2050_RXCTL0,
+				  b43_radio_read16(dev, B43_RADIO_2050_RXCTL0)
+				   | 0x000F);
+		b43_phy_write(dev, B43_PHY_PGACTL, 0xF330);
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0812,
-				      (b43_phy_read(dev, 0x0812) & 0xFFCF) |
-				      0x0020);
-			b43_phy_write(dev, 0x0811,
-				      (b43_phy_read(dev, 0x0811) & 0xFFCF) |
-				      0x0020);
+			b43_phy_write(dev, B43_PHY_RFOVERVAL,
+				      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
+				       & 0xFFCF) | 0x0020);
+			b43_phy_write(dev, B43_PHY_RFOVER,
+				      (b43_phy_read(dev, B43_PHY_RFOVER)
+				       & 0xFFCF) | 0x0020);
 		}
-
 		b43_set_all_gains(dev, 3, 0, 1);
-		if (phy->radio_rev == 8) {
-			b43_radio_write16(dev, 0x0043, 0x001F);
-		} else {
-			tmp = b43_radio_read16(dev, 0x0052) & 0xFF0F;
-			b43_radio_write16(dev, 0x0052, tmp | 0x0060);
-			tmp = b43_radio_read16(dev, 0x0043) & 0xFFF0;
-			b43_radio_write16(dev, 0x0043, tmp | 0x0009);
+		if (phy->radio_rev == 8)
+			b43_radio_write16(dev, B43_RADIO_2050_PCTL, 0x001F);
+		else {
+			b43_radio_write16(dev, B43_RADIO_2050_TXCTL1,
+					  (b43_radio_read16(dev, B43_RADIO_2050_TXCTL1)
+					   & 0xFF0F) | 0x0060);
+			b43_radio_write16(dev, B43_RADIO_2050_PCTL,
+					  (b43_radio_read16(dev, B43_RADIO_2050_PCTL)
+					   & 0xFFF0) | 0x0009);
 		}
 		b43_phy_write(dev, 0x005A, 0x0480);
 		b43_phy_write(dev, 0x0059, 0x0810);
 		b43_phy_write(dev, 0x0058, 0x000D);
 		udelay(20);
-		nrssi1 = (s16) ((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
+		nrssi1 = (s16)((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
 		if (nrssi1 >= 0x0020)
 			nrssi1 -= 0x0040;
 		if (nrssi0 == nrssi1)
@@ -2778,40 +2771,43 @@ void b43_calc_nrssi_slope(struct b43_wld
 			phy->nrssi[0] = nrssi1;
 			phy->nrssi[1] = nrssi0;
 		}
-		if (phy->rev >= 3) {
-			b43_phy_write(dev, 0x002E, backup[10]);
-			b43_phy_write(dev, 0x002F, backup[11]);
-			b43_phy_write(dev, 0x080F, backup[12]);
+		if (phy->pctl_en) {
+			b43_phy_write(dev, B43_PHY_TXDC_OFFSET1, backup[10]);
+			b43_phy_write(dev, B43_PHY_TXDC_OFFSET2, backup[11]);
+			b43_phy_write(dev, B43_PHY_LO_MASK, backup[12]);
 			b43_phy_write(dev, B43_PHY_LO_CTL, backup[13]);
 		}
+		b43_radio_write16(dev, B43_RADIO_2050_RXCTL0, backup[0]);
+		b43_write16(dev, B43_MMIO_PHY_BBANDCFG, backup[7]);
+		b43_phy_write(dev, B43_PHY_PGACTL, backup[3]);
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0812,
-				      b43_phy_read(dev, 0x0812) & 0xFFCF);
-			b43_phy_write(dev, 0x0811,
-				      b43_phy_read(dev, 0x0811) & 0xFFCF);
+			b43_phy_write(dev, B43_PHY_RFOVERVAL,
+				      b43_phy_read(dev, B43_PHY_RFOVERVAL)
+				       & 0xFFCF);
+			b43_phy_write(dev, B43_PHY_RFOVERVAL,
+				      b43_phy_read(dev, B43_PHY_RFOVER)
+				       & 0xFFCF);
 		}
-
-		b43_radio_write16(dev, 0x007A, backup[0]);
-		b43_radio_write16(dev, 0x0052, backup[1]);
-		b43_radio_write16(dev, 0x0043, backup[2]);
-		b43_write16(dev, 0x03E2, backup[7]);
-		b43_write16(dev, 0x03E6, backup[8]);
+		b43_write16(dev, B43_MMIO_PHY0, backup[8]);
 		b43_write16(dev, B43_MMIO_PHY_TEST, backup[9]);
-		b43_phy_write(dev, 0x0015, backup[3]);
+		b43_radio_write16(dev, B43_RADIO_2050_TXCTL1, backup[1]);
+		b43_radio_write16(dev, B43_RADIO_2050_PCTL, backup[2]);
 		b43_phy_write(dev, 0x005A, backup[4]);
 		b43_phy_write(dev, 0x0059, backup[5]);
 		b43_phy_write(dev, 0x0058, backup[6]);
 		b43_synth_pu_workaround(dev, phy->channel);
-		b43_phy_write(dev, 0x0802,
-			      b43_phy_read(dev, 0x0802) | (0x0001 | 0x0002));
+		b43_phy_write(dev, B43_PHY_CLASSCTL,
+			      b43_phy_read(dev, B43_PHY_CLASSCTL)
+			       | (B43_PHY_CLASSCTL_CCK | B43_PHY_CLASSCTL_OFDM));
 		b43_set_original_gains(dev);
 		b43_phy_write(dev, B43_PHY_CRS,
-			      b43_phy_read(dev, B43_PHY_CRS) | 0x8000);
-		if (phy->rev >= 3) {
-			b43_phy_write(dev, 0x0801, backup[14]);
-			b43_phy_write(dev, 0x0060, backup[15]);
-			b43_phy_write(dev, 0x0014, backup[16]);
-			b43_phy_write(dev, 0x0478, backup[17]);
+			      b43_phy_read(dev, B43_PHY_CRS)
+			       | B43_PHY_CRS_EN_ALL);
+		if (phy->pctl_en) {
+			b43_phy_write(dev, B43_PHY_G_CTL, backup[14]);
+			b43_phy_write(dev, B43_PHY_DACCTL, backup[15]);
+			b43_phy_write(dev, B43_PHY_TR_LT2, backup[16]);
+			b43_phy_write(dev, B43_PHY_HPWR_TSSICTL, backup[17]);
 		}
 		b43_nrssi_mem_update(dev);
 		b43_calc_nrssi_threshold(dev);



-- 
Ciao
Stefano
