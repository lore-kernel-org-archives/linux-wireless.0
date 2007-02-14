Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4602 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbXBNVjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 16:39:00 -0500
Date: Wed, 14 Feb 2007 16:28:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream' branch of wireless-2.6 (2007-02-14)
Message-ID: <20070214212817.GB28318@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some late-breaking small and/or important changes before the 2.6.21
merge window closes...

---

The following changes since commit 46b8c85e1df091fe2d53ae7d02addb0dc58a9123:
  Larry Finger (1):
        ieee80211: Fix sparse warning

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream

Ahmed S. Darwish (4):
      ipw2100: Use ARRAY_SIZE macro when appropriate
      misc-wireless: Use ARRAY_SIZE macro when appropriate
      hostap: Use ARRAY_SIZE macro when appropriate
      wavelan: Use ARRAY_SIZE macro when appropriate

Dan Williams (1):
      prism54: correct assignment of DOT1XENABLE in WE-19 codepaths

Daniel Drake (1):
      zd1211rw: Readd zd_addr_t cast

Ingo van Lil (1):
      wireless: fix IW_IS_{GET,SET} comment in wireless.h

Larry Finger (5):
      bcm43xx: Janitorial change - remove two unused variables
      bcm43xx: Fix for oops on resume
      bcm43xx: Fix for 4311 and 02/07/07 specification changes
      bcm43xx: OFDM fix for rev 1 cards
      ieee80211softmac: Fix setting of initial transmit rates

Michael Buesch (1):
      bcm43xx: Ignore ampdu status reports

 drivers/net/wireless/airo.c                     |    4 +-
 drivers/net/wireless/bcm43xx/bcm43xx.h          |    8 +-
 drivers/net/wireless/bcm43xx/bcm43xx_ilt.c      |   15 ++
 drivers/net/wireless/bcm43xx/bcm43xx_ilt.h      |    1 +
 drivers/net/wireless/bcm43xx/bcm43xx_main.c     |   20 +--
 drivers/net/wireless/bcm43xx/bcm43xx_phy.c      |  195 ++++++++++-------------
 drivers/net/wireless/bcm43xx/bcm43xx_radio.c    |   13 +-
 drivers/net/wireless/bcm43xx/bcm43xx_xmit.h     |   10 +-
 drivers/net/wireless/hostap/hostap.h            |    3 +-
 drivers/net/wireless/ipw2100.c                  |   14 +-
 drivers/net/wireless/prism54/isl_ioctl.c        |    8 +-
 drivers/net/wireless/prism54/oid_mgt.c          |    4 +-
 drivers/net/wireless/wavelan.c                  |   14 +-
 drivers/net/wireless/wavelan.p.h                |    3 -
 drivers/net/wireless/zd1211rw/zd_chip.c         |    2 +-
 include/linux/wireless.h                        |    4 +-
 net/ieee80211/softmac/ieee80211softmac_module.c |   13 +--
 net/ieee80211/softmac/ieee80211softmac_wx.c     |   11 +-
 18 files changed, 157 insertions(+), 185 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 44a2270..4ad910b 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1623,7 +1623,7 @@ static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
 
 	crypto_cipher_setkey(tfm, pkey, 16);
 	counter = 0;
-	for (i = 0; i < (sizeof(context->coeff)/sizeof(context->coeff[0])); ) {
+	for (i = 0; i < ARRAY_SIZE(context->coeff); ) {
 		aes_counter[15] = (u8)(counter >> 0);
 		aes_counter[14] = (u8)(counter >> 8);
 		aes_counter[13] = (u8)(counter >> 16);
@@ -1632,7 +1632,7 @@ static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
 		memcpy (plain, aes_counter, 16);
 		crypto_cipher_encrypt_one(tfm, plain, plain);
 		cipher = plain;
-		for (j=0; (j<16) && (i< (sizeof(context->coeff)/sizeof(context->coeff[0]))); ) {
+		for (j = 0; (j < 16) && (i < ARRAY_SIZE(context->coeff)); ) {
 			context->coeff[i++] = ntohl(*(u32 *)&cipher[j]);
 			j += 4;
 		}
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx.h b/drivers/net/wireless/bcm43xx/bcm43xx.h
index 4168b1a..6b1749b 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -21,7 +21,7 @@
 #define PFX				KBUILD_MODNAME ": "
 
 #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
-#define BCM43xx_IRQWAIT_MAX_RETRIES	50
+#define BCM43xx_IRQWAIT_MAX_RETRIES	100
 
 #define BCM43xx_IO_SIZE			8192
 
@@ -333,7 +333,7 @@
 #define BCM43xx_SBF_PS2			0x04000000
 #define BCM43xx_SBF_NO_SSID_BCAST	0x08000000
 #define BCM43xx_SBF_TIME_UPDATE		0x10000000
-#define BCM43xx_SBF_80000000		0x80000000 /*FIXME: fix name*/
+#define BCM43xx_SBF_MODE_G		0x80000000
 
 /* Microcode */
 #define BCM43xx_UCODE_REVISION		0x0000
@@ -503,8 +503,6 @@ struct bcm43xx_sprominfo {
 	u8 et1macaddr[6];
 	u8 et0phyaddr:5;
 	u8 et1phyaddr:5;
-	u8 et0mdcport:1;
-	u8 et1mdcport:1;
 	u8 boardrev;
 	u8 locale:4;
 	u8 antennas_aphy:2;
@@ -538,7 +536,7 @@ struct bcm43xx_lopair {
 
 struct bcm43xx_phyinfo {
 	/* Hardware Data */
-	u8 version;
+	u8 analog;
 	u8 type;
 	u8 rev;
 	u16 antenna_diversity;
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c b/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
index ad8e569..f2b8dba 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
@@ -325,6 +325,21 @@ void bcm43xx_ilt_write(struct bcm43xx_private *bcm, u16 offset, u16 val)
 	}
 }
 
+void bcm43xx_ilt_write32(struct bcm43xx_private *bcm, u16 offset, u32 val)
+{
+	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A) {
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_CTRL, offset);
+		mmiowb();
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_DATA2, (val & 0xFFFF0000) >> 16);
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_DATA1, val & 0x0000FFFF);
+	} else {
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_CTRL, offset);
+		mmiowb();
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_DATA2, (val & 0xFFFF0000) >> 16);
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_DATA1, val & 0x0000FFFF);
+	}
+}
+
 u16 bcm43xx_ilt_read(struct bcm43xx_private *bcm, u16 offset)
 {
 	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A) {
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h b/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
index 464521a..d7eaf5f 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
@@ -27,6 +27,7 @@ extern const u16 bcm43xx_ilt_sigmasqr2[BCM43xx_ILT_SIGMASQR_SIZE];
 
 
 void bcm43xx_ilt_write(struct bcm43xx_private *bcm, u16 offset, u16 val);
+void bcm43xx_ilt_write32(struct bcm43xx_private *bcm, u16 offset, u32 val);
 u16 bcm43xx_ilt_read(struct bcm43xx_private *bcm, u16 offset);
 
 #endif /* BCM43xx_ILT_H_ */
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index 63fc16f..e5336fa 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -851,8 +851,6 @@ static int bcm43xx_sprom_extract(struct bcm43xx_private *bcm)
 	value = sprom[BCM43xx_SPROM_ETHPHY];
 	bcm->sprom.et0phyaddr = (value & 0x001F);
 	bcm->sprom.et1phyaddr = (value & 0x03E0) >> 5;
-	bcm->sprom.et0mdcport = (value & (1 << 14)) >> 14;
-	bcm->sprom.et1mdcport = (value & (1 << 15)) >> 15;
 
 	/* boardrev, antennas, locale */
 	value = sprom[BCM43xx_SPROM_BOARDREV];
@@ -1449,12 +1447,10 @@ static void handle_irq_transmit_status(struct bcm43xx_private *bcm)
 
 		bcm43xx_debugfs_log_txstat(bcm, &stat);
 
-		if (stat.flags & BCM43xx_TXSTAT_FLAG_IGNORE)
+		if (stat.flags & BCM43xx_TXSTAT_FLAG_AMPDU)
+			continue;
+		if (stat.flags & BCM43xx_TXSTAT_FLAG_INTER)
 			continue;
-		if (!(stat.flags & BCM43xx_TXSTAT_FLAG_ACK)) {
-			//TODO: packet was not acked (was lost)
-		}
-		//TODO: There are more (unknown) flags to test. see bcm43xx_main.h
 
 		if (bcm43xx_using_pio(bcm))
 			bcm43xx_pio_handle_xmitstatus(bcm, &stat);
@@ -3678,7 +3674,7 @@ static int bcm43xx_read_phyinfo(struct bcm43xx_private *bcm)
 {
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	u16 value;
-	u8 phy_version;
+	u8 phy_analog;
 	u8 phy_type;
 	u8 phy_rev;
 	int phy_rev_ok = 1;
@@ -3686,12 +3682,12 @@ static int bcm43xx_read_phyinfo(struct bcm43xx_private *bcm)
 
 	value = bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_VER);
 
-	phy_version = (value & 0xF000) >> 12;
+	phy_analog = (value & 0xF000) >> 12;
 	phy_type = (value & 0x0F00) >> 8;
 	phy_rev = (value & 0x000F);
 
-	dprintk(KERN_INFO PFX "Detected PHY: Version: %x, Type %x, Revision %x\n",
-		phy_version, phy_type, phy_rev);
+	dprintk(KERN_INFO PFX "Detected PHY: Analog: %x, Type %x, Revision %x\n",
+		phy_analog, phy_type, phy_rev);
 
 	switch (phy_type) {
 	case BCM43xx_PHYTYPE_A:
@@ -3734,7 +3730,7 @@ static int bcm43xx_read_phyinfo(struct bcm43xx_private *bcm)
 		       phy_rev);
 	}
 
-	phy->version = phy_version;
+	phy->analog = phy_analog;
 	phy->type = phy_type;
 	phy->rev = phy_rev;
 	if ((phy_type == BCM43xx_PHYTYPE_B) || (phy_type == BCM43xx_PHYTYPE_G)) {
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
index 52ce2a9..3a5c9c2 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -205,8 +205,8 @@ static void bcm43xx_phy_init_pctl(struct bcm43xx_private *bcm)
 	    (bcm->board_type == 0x0416))
 		return;
 
-	bcm43xx_write16(bcm, 0x03E6, bcm43xx_read16(bcm, 0x03E6) & 0xFFDF);
 	bcm43xx_phy_write(bcm, 0x0028, 0x8018);
+	bcm43xx_write16(bcm, 0x03E6, bcm43xx_read16(bcm, 0x03E6) & 0xFFDF);
 
 	if (phy->type == BCM43xx_PHYTYPE_G) {
 		if (!phy->connected)
@@ -317,6 +317,13 @@ static void bcm43xx_phy_agcsetup(struct bcm43xx_private *bcm)
 	bcm43xx_ilt_write(bcm, offset + 0x0801, 7);
 	bcm43xx_ilt_write(bcm, offset + 0x0802, 16);
 	bcm43xx_ilt_write(bcm, offset + 0x0803, 28);
+
+	if (phy->rev >= 6) {
+		bcm43xx_phy_write(bcm, 0x0426, (bcm43xx_phy_read(bcm, 0x0426)
+				  & 0xFFFC));
+		bcm43xx_phy_write(bcm, 0x0426, (bcm43xx_phy_read(bcm, 0x0426)
+				  & 0xEFFF));
+	}
 }
 
 static void bcm43xx_phy_setupg(struct bcm43xx_private *bcm)
@@ -337,7 +344,7 @@ static void bcm43xx_phy_setupg(struct bcm43xx_private *bcm)
 		for (i = 0; i < BCM43xx_ILT_NOISEG1_SIZE; i++)
 			bcm43xx_ilt_write(bcm, 0x1800 + i, bcm43xx_ilt_noiseg1[i]);
 		for (i = 0; i < BCM43xx_ILT_ROTOR_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
+			bcm43xx_ilt_write32(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
 	} else {
 		/* nrssi values are signed 6-bit values. Not sure why we write 0x7654 here... */
 		bcm43xx_nrssi_hw_write(bcm, 0xBA98, (s16)0x7654);
@@ -377,7 +384,7 @@ static void bcm43xx_phy_setupg(struct bcm43xx_private *bcm)
 	
 	if (phy->rev == 1) {
 		for (i = 0; i < BCM43xx_ILT_RETARD_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
+			bcm43xx_ilt_write32(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
 		for (i = 0; i < 4; i++) {
 			bcm43xx_ilt_write(bcm, 0x5404 + i, 0x0020);
 			bcm43xx_ilt_write(bcm, 0x5408 + i, 0x0020);
@@ -500,10 +507,10 @@ static void bcm43xx_phy_setupa(struct bcm43xx_private *bcm)
 		for (i = 0; i < BCM43xx_ILT_NOISEA2_SIZE; i++)
 			bcm43xx_ilt_write(bcm, 0x1800 + i, bcm43xx_ilt_noisea2[i]);
 		for (i = 0; i < BCM43xx_ILT_ROTOR_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
+			bcm43xx_ilt_write32(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
 		bcm43xx_phy_init_noisescaletbl(bcm);
 		for (i = 0; i < BCM43xx_ILT_RETARD_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
+			bcm43xx_ilt_write32(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
 		break;
 	case 3:
 		for (i = 0; i < 64; i++)
@@ -729,19 +736,19 @@ static void bcm43xx_phy_initb5(struct bcm43xx_private *bcm)
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
 	u16 offset;
+	u16 value;
+	u8 old_channel;
 
-	if (phy->version == 1 &&
-	    radio->version == 0x2050) {
+	if (phy->analog == 1)
 		bcm43xx_radio_write16(bcm, 0x007A,
 				      bcm43xx_radio_read16(bcm, 0x007A)
 				      | 0x0050);
-	}
 	if ((bcm->board_vendor != PCI_VENDOR_ID_BROADCOM) &&
 	    (bcm->board_type != 0x0416)) {
+		value = 0x2120;
 		for (offset = 0x00A8 ; offset < 0x00C7; offset++) {
-			bcm43xx_phy_write(bcm, offset,
-					  (bcm43xx_phy_read(bcm, offset) + 0x2020)
-					  & 0x3F3F);
+			bcm43xx_phy_write(bcm, offset, value);
+			value += 0x0202;
 		}
 	}
 	bcm43xx_phy_write(bcm, 0x0035,
@@ -750,7 +757,7 @@ static void bcm43xx_phy_initb5(struct bcm43xx_private *bcm)
 	if (radio->version == 0x2050)
 		bcm43xx_phy_write(bcm, 0x0038, 0x0667);
 
-	if (phy->connected) {
+	if (phy->type == BCM43xx_PHYTYPE_G) {
 		if (radio->version == 0x2050) {
 			bcm43xx_radio_write16(bcm, 0x007A,
 					      bcm43xx_radio_read16(bcm, 0x007A)
@@ -776,7 +783,7 @@ static void bcm43xx_phy_initb5(struct bcm43xx_private *bcm)
 				  bcm43xx_phy_read(bcm, BCM43xx_PHY_RADIO_BITFIELD) | (1 << 11));
 	}
 
-	if (phy->version == 1 && radio->version == 0x2050) {
+	if (phy->analog == 1) {
 		bcm43xx_phy_write(bcm, 0x0026, 0xCE00);
 		bcm43xx_phy_write(bcm, 0x0021, 0x3763);
 		bcm43xx_phy_write(bcm, 0x0022, 0x1BC3);
@@ -787,14 +794,15 @@ static void bcm43xx_phy_initb5(struct bcm43xx_private *bcm)
 	bcm43xx_phy_write(bcm, 0x0030, 0x00C6);
 	bcm43xx_write16(bcm, 0x03EC, 0x3F22);
 
-	if (phy->version == 1 && radio->version == 0x2050)
+	if (phy->analog == 1)
 		bcm43xx_phy_write(bcm, 0x0020, 0x3E1C);
 	else
 		bcm43xx_phy_write(bcm, 0x0020, 0x301C);
 
-	if (phy->version == 0)
+	if (phy->analog == 0)
 		bcm43xx_write16(bcm, 0x03E4, 0x3000);
 
+	old_channel = radio->channel;
 	/* Force to channel 7, even if not supported. */
 	bcm43xx_radio_selectchannel(bcm, 7, 0);
 
@@ -816,11 +824,11 @@ static void bcm43xx_phy_initb5(struct bcm43xx_private *bcm)
 
 	bcm43xx_radio_write16(bcm, 0x007A, bcm43xx_radio_read16(bcm, 0x007A) | 0x0007);
 
-	bcm43xx_radio_selectchannel(bcm, BCM43xx_RADIO_DEFAULT_CHANNEL_BG, 0);
+	bcm43xx_radio_selectchannel(bcm, old_channel, 0);
 
 	bcm43xx_phy_write(bcm, 0x0014, 0x0080);
 	bcm43xx_phy_write(bcm, 0x0032, 0x00CA);
-	bcm43xx_phy_write(bcm, 0x88A3, 0x002A);
+	bcm43xx_phy_write(bcm, 0x002A, 0x88A3);
 
 	bcm43xx_radio_set_txpower_bg(bcm, 0xFFFF, 0xFFFF, 0xFFFF);
 
@@ -835,61 +843,24 @@ static void bcm43xx_phy_initb6(struct bcm43xx_private *bcm)
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
 	u16 offset, val;
+	u8 old_channel;
 
 	bcm43xx_phy_write(bcm, 0x003E, 0x817A);
 	bcm43xx_radio_write16(bcm, 0x007A,
 	                      (bcm43xx_radio_read16(bcm, 0x007A) | 0x0058));
-	if ((radio->manufact == 0x17F) &&
-	    (radio->version == 0x2050) &&
-	    (radio->revision == 3 ||
-	     radio->revision == 4 ||
-	     radio->revision == 5)) {
-		bcm43xx_radio_write16(bcm, 0x0051, 0x001F);
-		bcm43xx_radio_write16(bcm, 0x0052, 0x0040);
-		bcm43xx_radio_write16(bcm, 0x0053, 0x005B);
-		bcm43xx_radio_write16(bcm, 0x0054, 0x0098);
+	if (radio->revision == 4 ||
+	     radio->revision == 5) {
+		bcm43xx_radio_write16(bcm, 0x0051, 0x0037);
+		bcm43xx_radio_write16(bcm, 0x0052, 0x0070);
+		bcm43xx_radio_write16(bcm, 0x0053, 0x00B3);
+		bcm43xx_radio_write16(bcm, 0x0054, 0x009B);
 		bcm43xx_radio_write16(bcm, 0x005A, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x005B, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x005D, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x005E, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x007D, 0x0088);
 	}
-	if ((radio->manufact == 0x17F) &&
-	    (radio->version == 0x2050) &&
-	    (radio->revision == 6)) {
-		bcm43xx_radio_write16(bcm, 0x0051, 0x0000);
-		bcm43xx_radio_write16(bcm, 0x0052, 0x0040);
-		bcm43xx_radio_write16(bcm, 0x0053, 0x00B7);
-		bcm43xx_radio_write16(bcm, 0x0054, 0x0098);
-		bcm43xx_radio_write16(bcm, 0x005A, 0x0088);
-		bcm43xx_radio_write16(bcm, 0x005B, 0x008B);
-		bcm43xx_radio_write16(bcm, 0x005C, 0x00B5);
-		bcm43xx_radio_write16(bcm, 0x005D, 0x0088);
-		bcm43xx_radio_write16(bcm, 0x005E, 0x0088);
-		bcm43xx_radio_write16(bcm, 0x007D, 0x0088);
-		bcm43xx_radio_write16(bcm, 0x007C, 0x0001);
-		bcm43xx_radio_write16(bcm, 0x007E, 0x0008);
-	}
-	if ((radio->manufact == 0x17F) &&
-	    (radio->version == 0x2050) &&
-	    (radio->revision == 7)) {
-		bcm43xx_radio_write16(bcm, 0x0051, 0x0000);
-		bcm43xx_radio_write16(bcm, 0x0052, 0x0040);
-		bcm43xx_radio_write16(bcm, 0x0053, 0x00B7);
-		bcm43xx_radio_write16(bcm, 0x0054, 0x0098);
-		bcm43xx_radio_write16(bcm, 0x005A, 0x0088);
-		bcm43xx_radio_write16(bcm, 0x005B, 0x00A8);
-		bcm43xx_radio_write16(bcm, 0x005C, 0x0075);
-		bcm43xx_radio_write16(bcm, 0x005D, 0x00F5);
-		bcm43xx_radio_write16(bcm, 0x005E, 0x00B8);
-		bcm43xx_radio_write16(bcm, 0x007D, 0x00E8);
-		bcm43xx_radio_write16(bcm, 0x007C, 0x0001);
-		bcm43xx_radio_write16(bcm, 0x007E, 0x0008);
-		bcm43xx_radio_write16(bcm, 0x007B, 0x0000);
-	}
-	if ((radio->manufact == 0x17F) &&
-	    (radio->version == 0x2050) &&
-	    (radio->revision == 8)) {
+	if (radio->revision == 8) {
 		bcm43xx_radio_write16(bcm, 0x0051, 0x0000);
 		bcm43xx_radio_write16(bcm, 0x0052, 0x0040);
 		bcm43xx_radio_write16(bcm, 0x0053, 0x00B7);
@@ -933,20 +904,26 @@ static void bcm43xx_phy_initb6(struct bcm43xx_private *bcm)
 		                  bcm43xx_phy_read(bcm, 0x0802) | 0x0100);
 		bcm43xx_phy_write(bcm, 0x042B,
 		                  bcm43xx_phy_read(bcm, 0x042B) | 0x2000);
+		bcm43xx_phy_write(bcm, 0x5B, 0x0000);
+		bcm43xx_phy_write(bcm, 0x5C, 0x0000);
 	}
 
-	/* Force to channel 7, even if not supported. */
-	bcm43xx_radio_selectchannel(bcm, 7, 0);
+	old_channel = radio->channel;
+	if (old_channel >= 8)
+		bcm43xx_radio_selectchannel(bcm, 1, 0);
+	else
+		bcm43xx_radio_selectchannel(bcm, 13, 0);
 
 	bcm43xx_radio_write16(bcm, 0x0050, 0x0020);
 	bcm43xx_radio_write16(bcm, 0x0050, 0x0023);
 	udelay(40);
-	bcm43xx_radio_write16(bcm, 0x007C, (bcm43xx_radio_read16(bcm, 0x007C) | 0x0002));
-	bcm43xx_radio_write16(bcm, 0x0050, 0x0020);
-	if (radio->manufact == 0x17F &&
-	    radio->version == 0x2050 &&
-	    radio->revision <= 2) {
+	if (radio->revision < 6 || radio-> revision == 8) {
+		bcm43xx_radio_write16(bcm, 0x007C, (bcm43xx_radio_read16(bcm, 0x007C)
+				      | 0x0002));
 		bcm43xx_radio_write16(bcm, 0x0050, 0x0020);
+	}
+	if (radio->revision <= 2) {
+		bcm43xx_radio_write16(bcm, 0x007C, 0x0020);
 		bcm43xx_radio_write16(bcm, 0x005A, 0x0070);
 		bcm43xx_radio_write16(bcm, 0x005B, 0x007B);
 		bcm43xx_radio_write16(bcm, 0x005C, 0x00B0);
@@ -954,46 +931,41 @@ static void bcm43xx_phy_initb6(struct bcm43xx_private *bcm)
 	bcm43xx_radio_write16(bcm, 0x007A,
 	                      (bcm43xx_radio_read16(bcm, 0x007A) & 0x00F8) | 0x0007);
 
-	bcm43xx_radio_selectchannel(bcm, BCM43xx_RADIO_DEFAULT_CHANNEL_BG, 0);
+	bcm43xx_radio_selectchannel(bcm, old_channel, 0);
 
 	bcm43xx_phy_write(bcm, 0x0014, 0x0200);
-	if (radio->version == 0x2050){
-		if (radio->revision == 3 ||
-		    radio->revision == 4 ||
-		    radio->revision == 5)
-			bcm43xx_phy_write(bcm, 0x002A, 0x8AC0);
-		else
-			bcm43xx_phy_write(bcm, 0x002A, 0x88C2);
-	}
+	if (radio->revision >= 6)
+		bcm43xx_phy_write(bcm, 0x002A, 0x88C2);
+	else
+		bcm43xx_phy_write(bcm, 0x002A, 0x8AC0);
 	bcm43xx_phy_write(bcm, 0x0038, 0x0668);
 	bcm43xx_radio_set_txpower_bg(bcm, 0xFFFF, 0xFFFF, 0xFFFF);
-	if (radio->version == 0x2050) {
-		if (radio->revision == 3 ||
-		    radio->revision == 4 ||
-		    radio->revision == 5)
-			bcm43xx_phy_write(bcm, 0x005D, bcm43xx_phy_read(bcm, 0x005D) | 0x0003);
-		else if (radio->revision <= 2)
-			bcm43xx_radio_write16(bcm, 0x005D, 0x000D);
-	}
+	if (radio->revision <= 5)
+		bcm43xx_phy_write(bcm, 0x005D, bcm43xx_phy_read(bcm, 0x005D) | 0x0003);
+	if (radio->revision <= 2)
+		bcm43xx_radio_write16(bcm, 0x005D, 0x000D);
 	
-	if (phy->rev == 4)
-		bcm43xx_phy_write(bcm, 0x0002, (bcm43xx_phy_read(bcm, 0x0002) & 0xFFC0) | 0x0004);
-	else
+	if (phy->analog == 4){
 		bcm43xx_write16(bcm, 0x03E4, 0x0009);
+		bcm43xx_phy_write(bcm, 0x61, bcm43xx_phy_read(bcm, 0x61) & 0xFFF);
+	} else {
+		bcm43xx_phy_write(bcm, 0x0002, (bcm43xx_phy_read(bcm, 0x0002) & 0xFFC0) | 0x0004);
+	}
+	if (phy->type == BCM43xx_PHYTYPE_G)
+		bcm43xx_write16(bcm, 0x03E6, 0x0);
 	if (phy->type == BCM43xx_PHYTYPE_B) {
 		bcm43xx_write16(bcm, 0x03E6, 0x8140);
 		bcm43xx_phy_write(bcm, 0x0016, 0x0410);
 		bcm43xx_phy_write(bcm, 0x0017, 0x0820);
 		bcm43xx_phy_write(bcm, 0x0062, 0x0007);
 		(void) bcm43xx_radio_calibrationvalue(bcm);
-		bcm43xx_phy_lo_b_measure(bcm);
+		bcm43xx_phy_lo_g_measure(bcm);
 		if (bcm->sprom.boardflags & BCM43xx_BFL_RSSI) {
 			bcm43xx_calc_nrssi_slope(bcm);
 			bcm43xx_calc_nrssi_threshold(bcm);
 		}
 		bcm43xx_phy_init_pctl(bcm);
-	} else
-		bcm43xx_write16(bcm, 0x03E6, 0x0);
+	}
 }
 
 static void bcm43xx_calc_loopback_gain(struct bcm43xx_private *bcm)
@@ -1063,7 +1035,7 @@ static void bcm43xx_calc_loopback_gain(struct bcm43xx_private *bcm)
 	bcm43xx_phy_write(bcm, 0x005A, 0x0780);
 	bcm43xx_phy_write(bcm, 0x0059, 0xC810);
 	bcm43xx_phy_write(bcm, 0x0058, 0x000D);
-	if (phy->version == 0) {
+	if (phy->analog == 0) {
 		bcm43xx_phy_write(bcm, 0x0003, 0x0122);
 	} else {
 		bcm43xx_phy_write(bcm, 0x000A,
@@ -1205,27 +1177,30 @@ static void bcm43xx_phy_initg(struct bcm43xx_private *bcm)
 	if (phy->rev >= 2) {
 		bcm43xx_phy_write(bcm, 0x0814, 0x0000);
 		bcm43xx_phy_write(bcm, 0x0815, 0x0000);
-		if (phy->rev == 2)
-			bcm43xx_phy_write(bcm, 0x0811, 0x0000);
-		else if (phy->rev >= 3)
-			bcm43xx_phy_write(bcm, 0x0811, 0x0400);
+	}
+	if (phy->rev == 2) {
+		bcm43xx_phy_write(bcm, 0x0811, 0x0000);
 		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
-		if (phy->connected) {
-			tmp = bcm43xx_phy_read(bcm, 0x0400) & 0xFF;
-			if (tmp < 6) {
-				bcm43xx_phy_write(bcm, 0x04C2, 0x1816);
-				bcm43xx_phy_write(bcm, 0x04C3, 0x8006);
-				if (tmp != 3) {
-					bcm43xx_phy_write(bcm, 0x04CC,
-							  (bcm43xx_phy_read(bcm, 0x04CC)
-							   & 0x00FF) | 0x1F00);
-				}
+	}
+	if (phy->rev >= 3) {
+		bcm43xx_phy_write(bcm, 0x0811, 0x0400);
+		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
+	}
+	if (phy->connected) {
+		tmp = bcm43xx_phy_read(bcm, 0x0400) & 0xFF;
+		if (tmp < 6) {
+			bcm43xx_phy_write(bcm, 0x04C2, 0x1816);
+			bcm43xx_phy_write(bcm, 0x04C3, 0x8006);
+			if (tmp != 3) {
+				bcm43xx_phy_write(bcm, 0x04CC,
+						  (bcm43xx_phy_read(bcm, 0x04CC)
+						   & 0x00FF) | 0x1F00);
 			}
 		}
 	}
 	if (phy->rev < 3 && phy->connected)
 		bcm43xx_phy_write(bcm, 0x047E, 0x0078);
-	if (phy->rev >= 6 && phy->rev <= 8) {
+	if (radio->revision == 8) {
 		bcm43xx_phy_write(bcm, 0x0801, bcm43xx_phy_read(bcm, 0x0801) | 0x0080);
 		bcm43xx_phy_write(bcm, 0x043E, bcm43xx_phy_read(bcm, 0x043E) | 0x0004);
 	}
@@ -1638,14 +1613,14 @@ void bcm43xx_phy_set_baseband_attenuation(struct bcm43xx_private *bcm,
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	u16 value;
 
-	if (phy->version == 0) {
+	if (phy->analog == 0) {
 		value = (bcm43xx_read16(bcm, 0x03E6) & 0xFFF0);
 		value |= (baseband_attenuation & 0x000F);
 		bcm43xx_write16(bcm, 0x03E6, value);
 		return;
 	}
 
-	if (phy->version > 1) {
+	if (phy->analog > 1) {
 		value = bcm43xx_phy_read(bcm, 0x0060) & ~0x003C;
 		value |= (baseband_attenuation << 2) & 0x003C;
 	} else {
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
index bb9c484..3fbb3c6 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -1393,11 +1393,12 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 	backup[12] = bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT);
 
 	// Initialization
-	if (phy->version == 0) {
+	if (phy->analog == 0) {
 		bcm43xx_write16(bcm, 0x03E6, 0x0122);
 	} else {
-		if (phy->version >= 2)
-			bcm43xx_write16(bcm, 0x03E6, 0x0040);
+		if (phy->analog >= 2)
+			bcm43xx_phy_write(bcm, 0x0003, (bcm43xx_phy_read(bcm, 0x0003)
+					& 0xFFBF) | 0x0040);
 		bcm43xx_write16(bcm, BCM43xx_MMIO_CHANNEL_EXT,
 		                (bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT) | 0x2000));
 	}
@@ -1405,7 +1406,7 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 	ret = bcm43xx_radio_calibrationvalue(bcm);
 
 	if (phy->type == BCM43xx_PHYTYPE_B)
-		bcm43xx_radio_write16(bcm, 0x0078, 0x0003);
+		bcm43xx_radio_write16(bcm, 0x0078, 0x0026);
 
 	bcm43xx_phy_write(bcm, 0x0015, 0xBFAF);
 	bcm43xx_phy_write(bcm, 0x002B, 0x1403);
@@ -1416,7 +1417,7 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 	                      (bcm43xx_radio_read16(bcm, 0x0051) | 0x0004));
 	bcm43xx_radio_write16(bcm, 0x0052, 0x0000);
 	bcm43xx_radio_write16(bcm, 0x0043,
-			      bcm43xx_radio_read16(bcm, 0x0043) | 0x0009);
+			      (bcm43xx_radio_read16(bcm, 0x0043) & 0xFFF0) | 0x0009);
 	bcm43xx_phy_write(bcm, 0x0058, 0x0000);
 
 	for (i = 0; i < 16; i++) {
@@ -1488,7 +1489,7 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 	bcm43xx_phy_write(bcm, 0x0059, backup[17]);
 	bcm43xx_phy_write(bcm, 0x0058, backup[18]);
 	bcm43xx_write16(bcm, 0x03E6, backup[11]);
-	if (phy->version != 0)
+	if (phy->analog != 0)
 		bcm43xx_write16(bcm, BCM43xx_MMIO_CHANNEL_EXT, backup[12]);
 	bcm43xx_phy_write(bcm, 0x0035, backup[10]);
 	bcm43xx_radio_selectchannel(bcm, radio->channel, 1);
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h b/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
index 2aed19e..9ecf2bf 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_xmit.h
@@ -137,14 +137,8 @@ struct bcm43xx_xmitstatus {
 	u16 unknown; //FIXME
 };
 
-#define BCM43xx_TXSTAT_FLAG_ACK		0x01
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x02
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x04
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x08
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x10
-#define BCM43xx_TXSTAT_FLAG_IGNORE	0x20
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x40
-//TODO #define BCM43xx_TXSTAT_FLAG_???	0x80
+#define BCM43xx_TXSTAT_FLAG_AMPDU	0x10
+#define BCM43xx_TXSTAT_FLAG_INTER	0x20
 
 u8 bcm43xx_plcp_get_ratecode_cck(const u8 bitrate);
 u8 bcm43xx_plcp_get_ratecode_ofdm(const u8 bitrate);
diff --git a/drivers/net/wireless/hostap/hostap.h b/drivers/net/wireless/hostap/hostap.h
index e89c890..ef37a75 100644
--- a/drivers/net/wireless/hostap/hostap.h
+++ b/drivers/net/wireless/hostap/hostap.h
@@ -2,13 +2,14 @@
 #define HOSTAP_H
 
 #include <linux/ethtool.h>
+#include <linux/kernel.h>
 
 #include "hostap_wlan.h"
 #include "hostap_ap.h"
 
 static const long freq_list[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
 				  2447, 2452, 2457, 2462, 2467, 2472, 2484 };
-#define FREQ_COUNT (sizeof(freq_list) / sizeof(freq_list[0]))
+#define FREQ_COUNT ARRAY_SIZE(freq_list)
 
 /* hostap.c */
 
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index d0639a4..ad6e4a4 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -2888,7 +2888,7 @@ static int __ipw2100_tx_process(struct ipw2100_priv *priv)
 
 #ifdef CONFIG_IPW2100_DEBUG
 		if (packet->info.c_struct.cmd->host_command_reg <
-		    sizeof(command_types) / sizeof(*command_types))
+		    ARRAY_SIZE(command_types))
 			IPW_DEBUG_TX("Command '%s (%d)' processed: %d.\n",
 				     command_types[packet->info.c_struct.cmd->
 						   host_command_reg],
@@ -3736,7 +3736,7 @@ static ssize_t show_registers(struct device *d, struct device_attribute *attr,
 
 	out += sprintf(out, "%30s [Address ] : Hex\n", "Register");
 
-	for (i = 0; i < (sizeof(hw_data) / sizeof(*hw_data)); i++) {
+	for (i = 0; i < ARRAY_SIZE(hw_data); i++) {
 		read_register(dev, hw_data[i].addr, &val);
 		out += sprintf(out, "%30s [%08X] : %08X\n",
 			       hw_data[i].name, hw_data[i].addr, val);
@@ -3757,7 +3757,7 @@ static ssize_t show_hardware(struct device *d, struct device_attribute *attr,
 
 	out += sprintf(out, "%30s [Address ] : Hex\n", "NIC entry");
 
-	for (i = 0; i < (sizeof(nic_data) / sizeof(*nic_data)); i++) {
+	for (i = 0; i < ARRAY_SIZE(nic_data); i++) {
 		u8 tmp8;
 		u16 tmp16;
 		u32 tmp32;
@@ -3894,13 +3894,11 @@ static ssize_t show_ordinals(struct device *d, struct device_attribute *attr,
 	if (priv->status & STATUS_RF_KILL_MASK)
 		return 0;
 
-	if (loop >= sizeof(ord_data) / sizeof(*ord_data))
+	if (loop >= ARRAY_SIZE(ord_data))
 		loop = 0;
 
 	/* sysfs provides us PAGE_SIZE buffer */
-	while (len < PAGE_SIZE - 128 &&
-	       loop < (sizeof(ord_data) / sizeof(*ord_data))) {
-
+	while (len < PAGE_SIZE - 128 && loop < ARRAY_SIZE(ord_data)) {
 		val_len = sizeof(u32);
 
 		if (ipw2100_get_ordinal(priv, ord_data[loop].index, &val,
@@ -6589,7 +6587,7 @@ static const long ipw2100_rates_11b[] = {
 	11000000
 };
 
-#define RATE_COUNT (sizeof(ipw2100_rates_11b) / sizeof(ipw2100_rates_11b[0]))
+#define RATE_COUNT ARRAY_SIZE(ipw2100_rates_11b)
 
 static int ipw2100_wx_get_name(struct net_device *dev,
 			       struct iw_request_info *info,
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 838d510..841b3c1 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1395,11 +1395,16 @@ static int prism54_set_auth(struct net_device *ndev,
 		break;
 
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-		dot1x = param->value ? 1 : 0;
+		/* dot1x should be the opposite of RX_UNENCRYPTED_EAPOL;
+		 * turn off dot1x when allowing receipt of unencrypted EAPOL
+		 * frames, turn on dot1x when receipt should be disallowed
+		 */
+		dot1x = param->value ? 0 : 0x01;
 		break;
 
 	case IW_AUTH_PRIVACY_INVOKED:
 		privinvoked = param->value ? 1 : 0;
+		break;
 
 	case IW_AUTH_DROP_UNENCRYPTED:
 		exunencrypt = param->value ? 1 : 0;
@@ -1589,6 +1594,7 @@ static int prism54_set_encodeext(struct net_device *ndev,
 			}
 			key.type = DOT11_PRIV_TKIP;
 			key.length = KEY_SIZE_TKIP;
+			break;
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/net/wireless/prism54/oid_mgt.c b/drivers/net/wireless/prism54/oid_mgt.c
index e6cf9df..4278032 100644
--- a/drivers/net/wireless/prism54/oid_mgt.c
+++ b/drivers/net/wireless/prism54/oid_mgt.c
@@ -16,6 +16,8 @@
  *
  */
 
+#include <linux/kernel.h>
+
 #include "prismcompat.h"
 #include "islpci_dev.h"
 #include "islpci_mgt.h"
@@ -692,7 +694,7 @@ mgt_update_addr(islpci_private *priv)
 	return ret;
 }
 
-#define VEC_SIZE(a) (sizeof(a)/sizeof(a[0]))
+#define VEC_SIZE(a) ARRAY_SIZE(a)
 
 int
 mgt_commit(islpci_private *priv)
diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index 24221e4..2aa3c76 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -28,7 +28,7 @@
  */
 static u8 wv_irq_to_psa(int irq)
 {
-	if (irq < 0 || irq >= NELS(irqvals))
+	if (irq < 0 || irq >= ARRAY_SIZE(irqvals))
 		return 0;
 
 	return irqvals[irq];
@@ -42,7 +42,7 @@ static int __init wv_psa_to_irq(u8 irqval)
 {
 	int irq;
 
-	for (irq = 0; irq < NELS(irqvals); irq++)
+	for (irq = 0; irq < ARRAY_SIZE(irqvals); irq++)
 		if (irqvals[irq] == irqval)
 			return irq;
 
@@ -1695,7 +1695,7 @@ static int wv_frequency_list(unsigned long ioaddr,	/* I/O port of the card */
 		/* Look in the table if the frequency is allowed */
 		if (table[9 - (freq / 16)] & (1 << (freq % 16))) {
 			/* Compute approximate channel number */
-			while ((c < NELS(channel_bands)) &&
+			while ((c < ARRAY_SIZE(channel_bands)) &&
 				(((channel_bands[c] >> 1) - 24) < freq)) 
 				c++;
 			list[i].i = c;	/* Set the list index */
@@ -4269,7 +4269,7 @@ struct net_device * __init wavelan_probe(int unit)
 		printk(KERN_DEBUG "%s: <-wavelan_probe()\n", dev->name);
 #endif
 	} else { /* Scan all possible addresses of the WaveLAN hardware. */
-		for (i = 0; i < NELS(iobase); i++) {
+		for (i = 0; i < ARRAY_SIZE(iobase); i++) {
 			dev->irq = def_irq;
 			if (wavelan_config(dev, iobase[i]) == 0) {
 #ifdef DEBUG_CALLBACK_TRACE
@@ -4280,7 +4280,7 @@ struct net_device * __init wavelan_probe(int unit)
 				break;
 			}
 		}
-		if (i == NELS(iobase))
+		if (i == ARRAY_SIZE(iobase))
 			r = -ENODEV;
 	}
 	if (r) 
@@ -4327,14 +4327,14 @@ int __init init_module(void)
 #endif
 
 		/* Copy the basic set of address to be probed. */
-		for (i = 0; i < NELS(iobase); i++)
+		for (i = 0; i < ARRAY_SIZE(iobase); i++)
 			io[i] = iobase[i];
 	}
 
 
 	/* Loop on all possible base addresses. */
 	i = -1;
-	while ((io[++i] != 0) && (i < NELS(io))) {
+	while ((io[++i] != 0) && (i < ARRAY_SIZE(io))) {
 		struct net_device *dev = alloc_etherdev(sizeof(net_local));
 		if (!dev)
 			break;
diff --git a/drivers/net/wireless/wavelan.p.h b/drivers/net/wireless/wavelan.p.h
index 72b646c..fe24281 100644
--- a/drivers/net/wireless/wavelan.p.h
+++ b/drivers/net/wireless/wavelan.p.h
@@ -449,9 +449,6 @@ static const char	*version	= "wavelan.c : v24 (SMP + wireless extensions) 11/12/
 /* Watchdog temporisation */
 #define	WATCHDOG_JIFFIES	(512*HZ/100)
 
-/* Macro to get the number of elements in an array */
-#define	NELS(a)				(sizeof(a) / sizeof(a[0]))
-
 /* ------------------------ PRIVATE IOCTL ------------------------ */
 
 #define SIOCSIPQTHR	SIOCIWFIRSTPRIV		/* Set quality threshold */
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 78ea72f..953ac3a 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -101,7 +101,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
-	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
+	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
 		                   GFP_NOFS);
 	if (!a16) {
 		dev_dbg_f(zd_chip_dev(chip),
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 7c269f4..447c52b 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -334,7 +334,7 @@
  * separate range because of collisions with other tools such as
  * 'mii-tool'.
  * We now have 32 commands, so a bit more space ;-).
- * Also, all 'odd' commands are only usable by root and don't return the
+ * Also, all 'even' commands are only usable by root and don't return the
  * content of ifr/iwr to user (but you are not obliged to use the set/get
  * convention, just use every other two command). More details in iwpriv.c.
  * And I repeat : you are not forced to use them with iwpriv, but you
@@ -348,7 +348,7 @@
 #define SIOCIWLAST	SIOCIWLASTPRIV		/* 0x8BFF */
 #define IW_IOCTL_IDX(cmd)	((cmd) - SIOCIWFIRST)
 
-/* Even : get (world access), odd : set (root access) */
+/* Odd : get (world access), even : set (root access) */
 #define IW_IS_SET(cmd)	(!((cmd) & 0x1))
 #define IW_IS_GET(cmd)	((cmd) & 0x1)
 
diff --git a/net/ieee80211/softmac/ieee80211softmac_module.c b/net/ieee80211/softmac/ieee80211softmac_module.c
index 256207b..770a068 100644
--- a/net/ieee80211/softmac/ieee80211softmac_module.c
+++ b/net/ieee80211/softmac/ieee80211softmac_module.c
@@ -265,17 +265,10 @@ void ieee80211softmac_init_bss(struct ieee80211softmac_device *mac)
 	/* Change the default txrate to the highest possible value.
 	 * The txrate machine will lower it, if it is too high.
 	 */
-	/* FIXME: We don't correctly handle backing down to lower
-	   rates, so 801.11g devices start off at 11M for now. People
-	   can manually change it if they really need to, but 11M is
-	   more reliable. Note similar logic in
-	   ieee80211softmac_wx_set_rate() */	 
-	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
+	if (ieee->modulation & IEEE80211_OFDM_MODULATION)
+		txrates->user_rate = IEEE80211_OFDM_RATE_24MB;
+	else
 		txrates->user_rate = IEEE80211_CCK_RATE_11MB;
-	} else if (ieee->modulation & IEEE80211_OFDM_MODULATION) {
-		txrates->user_rate = IEEE80211_OFDM_RATE_54MB;
-	} else
-		assert(0);
 
 	txrates->default_rate = IEEE80211_CCK_RATE_1MB;
 	change |= IEEE80211SOFTMAC_TXRATECHG_DEFAULT;
diff --git a/net/ieee80211/softmac/ieee80211softmac_wx.c b/net/ieee80211/softmac/ieee80211softmac_wx.c
index fa2f7da..89c83fa 100644
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -177,15 +177,10 @@ ieee80211softmac_wx_set_rate(struct net_device *net_dev,
 	int err = -EINVAL;
 
 	if (in_rate == -1) {
-		/* FIXME: We don't correctly handle backing down to lower
-		   rates, so 801.11g devices start off at 11M for now. People
-		   can manually change it if they really need to, but 11M is
-		   more reliable. Note similar logic in
-		   ieee80211softmac_wx_set_rate() */	 
-		if (ieee->modulation & IEEE80211_CCK_MODULATION)
-			in_rate = 11000000;
+		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
+			in_rate = 24000000;
 		else
-			in_rate = 54000000;
+			in_rate = 11000000;
 	}
 
 	switch (in_rate) {
-- 
John W. Linville
linville@tuxdriver.com
