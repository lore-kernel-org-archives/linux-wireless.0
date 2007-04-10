Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4390 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbXDJUeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 16:34:10 -0400
Date: Tue, 10 Apr 2007 16:24:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream' branch of wireless-2.6 (actually 'for-jgarzik')
Message-ID: <20070410202451.GD14123@tuxdriver.com>
References: <20070410202337.GC14123@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070410202337.GC14123@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff,

I branched off netdev-2.6#upstream, pulled my upstream into it, and
resolved the conflicts.  So, you probably want to pull from here
instead:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git for-jgarzik

FWIW, this also includes the patches from the pull request posted on
27 March 2007:

	http://marc.info/?l=linux-wireless&m=117514552402407&w=2

Thanks,

John

---

The following changes since commit 61bbb97c8b54f547a6f77c2849bc2e3005c886e4:
  John W. Linville (1):
        Merge branch 'upstream-fixes' into upstream

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream

Daniel Drake (4):
      zd1211rw: Remove invalid CR write during ZD1211 phy reset
      zd1211rw: rework band edge patching
      zd1211rw: Add AL7230B RF support for ZD1211B
      zd1211rw: Add ID for ZyXEL AG-220

Larry Finger (2):
      bcm43xx: Change initialization for 2050 radios
      ieee80211-crypt: Make some TKIP and CCMP error logging conditional

Marcin Juszkiewicz (1):
      hostap_cs: support ADLINK 345 CF

Pavel Roskin (1):
      Remove comment about IEEE80211_RADIOTAP_FCS

 drivers/net/wireless/bcm43xx/bcm43xx_phy.c    |   15 +-
 drivers/net/wireless/bcm43xx/bcm43xx_phy.h    |    4 +
 drivers/net/wireless/bcm43xx/bcm43xx_radio.c  |  196 +++++++++++++--
 drivers/net/wireless/hostap/hostap_cs.c       |    2 +
 drivers/net/wireless/zd1211rw/zd_chip.c       |   38 ++--
 drivers/net/wireless/zd1211rw/zd_chip.h       |    1 +
 drivers/net/wireless/zd1211rw/zd_rf.c         |   14 +
 drivers/net/wireless/zd1211rw/zd_rf.h         |    9 +-
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c  |    2 +-
 drivers/net/wireless/zd1211rw/zd_rf_al7230b.c |  317 +++++++++++++++++++++----
 drivers/net/wireless/zd1211rw/zd_usb.c        |    1 +
 include/net/ieee80211_radiotap.h              |    3 -
 net/ieee80211/ieee80211_crypt_ccmp.c          |    2 +-
 net/ieee80211/ieee80211_crypt_tkip.c          |    4 +-
 14 files changed, 500 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
index c47e19a..b37f1e3 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -300,16 +300,20 @@ static void bcm43xx_phy_agcsetup(struct bcm43xx_private *bcm)
 
 	if (phy->rev > 2) {
 		bcm43xx_phy_write(bcm, 0x0422, 0x287A);
-		bcm43xx_phy_write(bcm, 0x0420, (bcm43xx_phy_read(bcm, 0x0420) & 0x0FFF) | 0x3000); 
+		bcm43xx_phy_write(bcm, 0x0420, (bcm43xx_phy_read(bcm, 0x0420)
+				  & 0x0FFF) | 0x3000);
 	}
 		
-	bcm43xx_phy_write(bcm, 0x04A8, (bcm43xx_phy_read(bcm, 0x04A8) & 0x8080) | 0x7874);
+	bcm43xx_phy_write(bcm, 0x04A8, (bcm43xx_phy_read(bcm, 0x04A8) & 0x8080)
+					| 0x7874);
 	bcm43xx_phy_write(bcm, 0x048E, 0x1C00);
 
 	if (phy->rev == 1) {
-		bcm43xx_phy_write(bcm, 0x04AB, (bcm43xx_phy_read(bcm, 0x04AB) & 0xF0FF) | 0x0600);
+		bcm43xx_phy_write(bcm, 0x04AB, (bcm43xx_phy_read(bcm, 0x04AB)
+				  & 0xF0FF) | 0x0600);
 		bcm43xx_phy_write(bcm, 0x048B, 0x005E);
-		bcm43xx_phy_write(bcm, 0x048C, (bcm43xx_phy_read(bcm, 0x048C) & 0xFF00) | 0x001E);
+		bcm43xx_phy_write(bcm, 0x048C, (bcm43xx_phy_read(bcm, 0x048C)
+				  & 0xFF00) | 0x001E);
 		bcm43xx_phy_write(bcm, 0x048D, 0x0002);
 	}
 
@@ -335,7 +339,8 @@ static void bcm43xx_phy_setupg(struct bcm43xx_private *bcm)
 	if (phy->rev == 1) {
 		bcm43xx_phy_write(bcm, 0x0406, 0x4F19);
 		bcm43xx_phy_write(bcm, BCM43xx_PHY_G_CRS,
-				  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS) & 0xFC3F) | 0x0340);
+				  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS)
+				  & 0xFC3F) | 0x0340);
 		bcm43xx_phy_write(bcm, 0x042C, 0x005A);
 		bcm43xx_phy_write(bcm, 0x0427, 0x001A);
 
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.h b/drivers/net/wireless/bcm43xx/bcm43xx_phy.h
index 1f321ef..7311836 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.h
@@ -48,6 +48,10 @@ void bcm43xx_raw_phy_unlock(struct bcm43xx_private *bcm);
 		local_irq_restore(flags);	\
 	} while (0)
 
+/* Card uses the loopback gain stuff */
+#define has_loopback_gain(phy) \
+        (((phy)->rev > 1) || ((phy)->connected))
+
 u16 bcm43xx_phy_read(struct bcm43xx_private *bcm, u16 offset);
 void bcm43xx_phy_write(struct bcm43xx_private *bcm, u16 offset, u16 val);
 
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
index 4025dd0..6a109f4 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -1343,11 +1343,110 @@ u16 bcm43xx_radio_calibrationvalue(struct bcm43xx_private *bcm)
 	return ret;
 }
 
+#define LPD(L, P, D)    (((L) << 2) | ((P) << 1) | ((D) << 0))
+static u16 bcm43xx_get_812_value(struct bcm43xx_private *bcm, u8 lpd)
+{
+	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
+	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
+	u16 loop_or = 0;
+	u16 adj_loopback_gain = phy->loopback_gain[0];
+	u8 loop;
+	u16 extern_lna_control;
+
+	if (!phy->connected)
+		return 0;
+	if (!has_loopback_gain(phy)) {
+		if (phy->rev < 7 || !(bcm->sprom.boardflags
+		    & BCM43xx_BFL_EXTLNA)) {
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x0FB2;
+			case LPD(0, 0, 1):
+				return 0x00B2;
+			case LPD(1, 0, 1):
+				return 0x30B2;
+			case LPD(1, 0, 0):
+				return 0x30B3;
+			default:
+				assert(0);
+			}
+		} else {
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x8FB2;
+			case LPD(0, 0, 1):
+				return 0x80B2;
+			case LPD(1, 0, 1):
+				return 0x20B2;
+			case LPD(1, 0, 0):
+				return 0x20B3;
+			default:
+				assert(0);
+			}
+		}
+	} else {
+		if (radio->revision == 8)
+			adj_loopback_gain += 0x003E;
+		else
+			adj_loopback_gain += 0x0026;
+		if (adj_loopback_gain >= 0x46) {
+			adj_loopback_gain -= 0x46;
+			extern_lna_control = 0x3000;
+		} else if (adj_loopback_gain >= 0x3A) {
+			adj_loopback_gain -= 0x3A;
+			extern_lna_control = 0x2000;
+		} else if (adj_loopback_gain >= 0x2E) {
+			adj_loopback_gain -= 0x2E;
+			extern_lna_control = 0x1000;
+		} else {
+			adj_loopback_gain -= 0x10;
+			extern_lna_control = 0x0000;
+		}
+		for (loop = 0; loop < 16; loop++) {
+			u16 tmp = adj_loopback_gain - 6 * loop;
+			if (tmp < 6)
+				break;
+		}
+
+		loop_or = (loop << 8) | extern_lna_control;
+		if (phy->rev >= 7 && bcm->sprom.boardflags
+		    & BCM43xx_BFL_EXTLNA) {
+			if (extern_lna_control)
+				loop_or |= 0x8000;
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x8F92;
+			case LPD(0, 0, 1):
+				return (0x8092 | loop_or);
+			case LPD(1, 0, 1):
+				return (0x2092 | loop_or);
+			case LPD(1, 0, 0):
+				return (0x2093 | loop_or);
+			default:
+				assert(0);
+			}
+		} else {
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x0F92;
+			case LPD(0, 0, 1):
+			case LPD(1, 0, 1):
+				return (0x0092 | loop_or);
+			case LPD(1, 0, 0):
+				return (0x0093 | loop_or);
+			default:
+				assert(0);
+			}
+		}
+	}
+	return 0;
+}
+
 u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 {
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	u16 backup[19] = { 0 };
+	u16 backup[21] = { 0 };
 	u16 ret;
 	u16 i, j;
 	u32 tmp1 = 0, tmp2 = 0;
@@ -1373,19 +1472,36 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 			backup[8] = bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS);
 			backup[9] = bcm43xx_phy_read(bcm, 0x0802);
 			bcm43xx_phy_write(bcm, 0x0814,
-			                  (bcm43xx_phy_read(bcm, 0x0814) | 0x0003));
+			                  (bcm43xx_phy_read(bcm, 0x0814)
+					  | 0x0003));
 			bcm43xx_phy_write(bcm, 0x0815,
-			                  (bcm43xx_phy_read(bcm, 0x0815) & 0xFFFC));	
+			                  (bcm43xx_phy_read(bcm, 0x0815)
+					  & 0xFFFC));
 			bcm43xx_phy_write(bcm, BCM43xx_PHY_G_CRS,
-			                  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS) & 0x7FFF));
+			                  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS)
+					  & 0x7FFF));
 			bcm43xx_phy_write(bcm, 0x0802,
 			                  (bcm43xx_phy_read(bcm, 0x0802) & 0xFFFC));
-			bcm43xx_phy_write(bcm, 0x0811, 0x01B3);
-			bcm43xx_phy_write(bcm, 0x0812, 0x0FB2);
+			if (phy->rev > 1) { /* loopback gain enabled */
+				backup[19] = bcm43xx_phy_read(bcm, 0x080F);
+				backup[20] = bcm43xx_phy_read(bcm, 0x0810);
+				if (phy->rev >= 3)
+					bcm43xx_phy_write(bcm, 0x080F, 0xC020);
+				else
+					bcm43xx_phy_write(bcm, 0x080F, 0x8020);
+				bcm43xx_phy_write(bcm, 0x0810, 0x0000);
+			}
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(0, 1, 1)));
+			if (phy->rev < 7 || !(bcm->sprom.boardflags
+			    & BCM43xx_BFL_EXTLNA))
+				bcm43xx_phy_write(bcm, 0x0811, 0x01B3);
+			else
+				bcm43xx_phy_write(bcm, 0x0811, 0x09B3);
 		}
-		bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
-		                (bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_RADIO) | 0x8000));
 	}
+	bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
+	                (bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_RADIO) | 0x8000));
 	backup[10] = bcm43xx_phy_read(bcm, 0x0035);
 	bcm43xx_phy_write(bcm, 0x0035,
 	                  (bcm43xx_phy_read(bcm, 0x0035) & 0xFF7F));
@@ -1397,10 +1513,12 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 		bcm43xx_write16(bcm, 0x03E6, 0x0122);
 	} else {
 		if (phy->analog >= 2)
-			bcm43xx_phy_write(bcm, 0x0003, (bcm43xx_phy_read(bcm, 0x0003)
-					& 0xFFBF) | 0x0040);
+			bcm43xx_phy_write(bcm, 0x0003,
+					  (bcm43xx_phy_read(bcm, 0x0003)
+					  & 0xFFBF) | 0x0040);
 		bcm43xx_write16(bcm, BCM43xx_MMIO_CHANNEL_EXT,
-		                (bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT) | 0x2000));
+		                (bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT)
+				| 0x2000));
 	}
 
 	ret = bcm43xx_radio_calibrationvalue(bcm);
@@ -1408,16 +1526,25 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 	if (phy->type == BCM43xx_PHYTYPE_B)
 		bcm43xx_radio_write16(bcm, 0x0078, 0x0026);
 
+	if (phy->connected)
+		bcm43xx_phy_write(bcm, 0x0812,
+				  bcm43xx_get_812_value(bcm, LPD(0, 1, 1)));
 	bcm43xx_phy_write(bcm, 0x0015, 0xBFAF);
 	bcm43xx_phy_write(bcm, 0x002B, 0x1403);
 	if (phy->connected)
-		bcm43xx_phy_write(bcm, 0x0812, 0x00B2);
+		bcm43xx_phy_write(bcm, 0x0812,
+				  bcm43xx_get_812_value(bcm, LPD(0, 0, 1)));
 	bcm43xx_phy_write(bcm, 0x0015, 0xBFA0);
 	bcm43xx_radio_write16(bcm, 0x0051,
 	                      (bcm43xx_radio_read16(bcm, 0x0051) | 0x0004));
-	bcm43xx_radio_write16(bcm, 0x0052, 0x0000);
-	bcm43xx_radio_write16(bcm, 0x0043,
-			      (bcm43xx_radio_read16(bcm, 0x0043) & 0xFFF0) | 0x0009);
+	if (radio->revision == 8)
+		bcm43xx_radio_write16(bcm, 0x0043, 0x001F);
+	else {
+		bcm43xx_radio_write16(bcm, 0x0052, 0x0000);
+		bcm43xx_radio_write16(bcm, 0x0043,
+				      (bcm43xx_radio_read16(bcm, 0x0043) & 0xFFF0)
+				      | 0x0009);
+	}
 	bcm43xx_phy_write(bcm, 0x0058, 0x0000);
 
 	for (i = 0; i < 16; i++) {
@@ -1425,21 +1552,25 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 		bcm43xx_phy_write(bcm, 0x0059, 0xC810);
 		bcm43xx_phy_write(bcm, 0x0058, 0x000D);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 1)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 		udelay(10);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 1)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xEFB0);
 		udelay(10);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 0)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xFFF0);
-		udelay(10);
+		udelay(20);
 		tmp1 += bcm43xx_phy_read(bcm, 0x002D);
 		bcm43xx_phy_write(bcm, 0x0058, 0x0000);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 1)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 	}
 
@@ -1457,21 +1588,29 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 			bcm43xx_phy_write(bcm, 0x0059, 0xC810);
 			bcm43xx_phy_write(bcm, 0x0058, 0x000D);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 1)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 			udelay(10);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 1)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xEFB0);
 			udelay(10);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B3); /* 0x30B3 is not a typo */
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 0)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xFFF0);
 			udelay(10);
 			tmp2 += bcm43xx_phy_read(bcm, 0x002D);
 			bcm43xx_phy_write(bcm, 0x0058, 0x0000);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 1)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 		}
 		tmp2++;
@@ -1497,15 +1636,20 @@ u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 		bcm43xx_phy_write(bcm, 0x0030, backup[2]);
 		bcm43xx_write16(bcm, 0x03EC, backup[3]);
 	} else {
-		bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
-				(bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_RADIO) & 0x7FFF));
 		if (phy->connected) {
+			bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
+					(bcm43xx_read16(bcm,
+					BCM43xx_MMIO_PHY_RADIO) & 0x7FFF));
 			bcm43xx_phy_write(bcm, 0x0811, backup[4]);
 			bcm43xx_phy_write(bcm, 0x0812, backup[5]);
 			bcm43xx_phy_write(bcm, 0x0814, backup[6]);
 			bcm43xx_phy_write(bcm, 0x0815, backup[7]);
 			bcm43xx_phy_write(bcm, BCM43xx_PHY_G_CRS, backup[8]);
 			bcm43xx_phy_write(bcm, 0x0802, backup[9]);
+			if (phy->rev > 1) {
+				bcm43xx_phy_write(bcm, 0x080F, backup[19]);
+				bcm43xx_phy_write(bcm, 0x0810, backup[20]);
+			}
 		}
 	}
 	if (i >= 15)
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 4b81c7d..ee1532b 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -838,6 +838,8 @@ static struct pcmcia_device_id hostap_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0005),
 	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0010),
 	PCMCIA_DEVICE_MANF_CARD(0x0126, 0x0002),
+	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0xd601, 0x0005, "ADLINK 345 CF",
+					 0x2d858104),
 	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "INTERSIL",
 					 0x74c5e40d),
 	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "Intersil",
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 8acaa6b..95b4a2a 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -615,16 +615,24 @@ static int patch_cr157(struct zd_chip *chip)
  * Vendor driver says: for FCC regulation, enabled per HWFeature 6M band edge
  * bit (for AL2230, AL2230S)
  */
-static int patch_6m_band_edge(struct zd_chip *chip, int channel)
+static int patch_6m_band_edge(struct zd_chip *chip, u8 channel)
+{
+	ZD_ASSERT(mutex_is_locked(&chip->mutex));
+	if (!chip->patch_6m_band_edge)
+		return 0;
+
+	return zd_rf_patch_6m_band_edge(&chip->rf, channel);
+}
+
+/* Generic implementation of 6M band edge patching, used by most RFs via
+ * zd_rf_generic_patch_6m() */
+int zd_chip_generic_patch_6m_band(struct zd_chip *chip, int channel)
 {
 	struct zd_ioreq16 ioreqs[] = {
 		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
 		{ CR47,  0x1e },
 	};
 
-	if (!chip->patch_6m_band_edge || !chip->rf.patch_6m_band_edge)
-		return 0;
-
 	/* FIXME: Channel 11 is not the edge for all regulatory domains. */
 	if (channel == 1 || channel == 11)
 		ioreqs[0].value = 0x12;
@@ -684,17 +692,17 @@ static int zd1211_hw_reset_phy(struct zd_chip *chip)
 		{ CR111, 0x27 }, { CR112, 0x27 }, { CR113, 0x27 },
 		{ CR114, 0x27 }, { CR115, 0x26 }, { CR116, 0x24 },
 		{ CR117, 0xfc }, { CR118, 0xfa }, { CR120, 0x4f },
-		{ CR123, 0x27 }, { CR125, 0xaa }, { CR127, 0x03 },
-		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-		{ CR131, 0x0C }, { CR136, 0xdf }, { CR137, 0x40 },
-		{ CR138, 0xa0 }, { CR139, 0xb0 }, { CR140, 0x99 },
-		{ CR141, 0x82 }, { CR142, 0x54 }, { CR143, 0x1c },
-		{ CR144, 0x6c }, { CR147, 0x07 }, { CR148, 0x4c },
-		{ CR149, 0x50 }, { CR150, 0x0e }, { CR151, 0x18 },
-		{ CR160, 0xfe }, { CR161, 0xee }, { CR162, 0xaa },
-		{ CR163, 0xfa }, { CR164, 0xfa }, { CR165, 0xea },
-		{ CR166, 0xbe }, { CR167, 0xbe }, { CR168, 0x6a },
-		{ CR169, 0xba }, { CR170, 0xba }, { CR171, 0xba },
+		{ CR125, 0xaa }, { CR127, 0x03 }, { CR128, 0x14 },
+		{ CR129, 0x12 }, { CR130, 0x10 }, { CR131, 0x0C },
+		{ CR136, 0xdf }, { CR137, 0x40 }, { CR138, 0xa0 },
+		{ CR139, 0xb0 }, { CR140, 0x99 }, { CR141, 0x82 },
+		{ CR142, 0x54 }, { CR143, 0x1c }, { CR144, 0x6c },
+		{ CR147, 0x07 }, { CR148, 0x4c }, { CR149, 0x50 },
+		{ CR150, 0x0e }, { CR151, 0x18 }, { CR160, 0xfe },
+		{ CR161, 0xee }, { CR162, 0xaa }, { CR163, 0xfa },
+		{ CR164, 0xfa }, { CR165, 0xea }, { CR166, 0xbe },
+		{ CR167, 0xbe }, { CR168, 0x6a }, { CR169, 0xba },
+		{ CR170, 0xba }, { CR171, 0xba },
 		/* Note: CR204 must lead the CR203 */
 		{ CR204, 0x7d },
 		{ },
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index e57ed75..ce0a5f6 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -833,6 +833,7 @@ int zd_chip_enable_rx(struct zd_chip *chip);
 void zd_chip_disable_rx(struct zd_chip *chip);
 int zd_chip_enable_hwint(struct zd_chip *chip);
 int zd_chip_disable_hwint(struct zd_chip *chip);
+int zd_chip_generic_patch_6m_band(struct zd_chip *chip, int channel);
 
 int zd_chip_set_rts_cts_rate_locked(struct zd_chip *chip,
 	u8 rts_rate, int preamble);
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.c b/drivers/net/wireless/zd1211rw/zd_rf.c
index 4ddc2cb..549c23b 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf.c
@@ -154,3 +154,17 @@ int zd_switch_radio_off(struct zd_rf *rf)
 		r = t;
 	return r;
 }
+
+int zd_rf_patch_6m_band_edge(struct zd_rf *rf, u8 channel)
+{
+	if (!rf->patch_6m_band_edge)
+		return 0;
+
+	return rf->patch_6m_band_edge(rf, channel);
+}
+
+int zd_rf_generic_patch_6m(struct zd_rf *rf, u8 channel)
+{
+	return zd_chip_generic_patch_6m_band(zd_rf_to_chip(rf), channel);
+}
+
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.h b/drivers/net/wireless/zd1211rw/zd_rf.h
index ee8ac3a..aa9cc10 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.h
+++ b/drivers/net/wireless/zd1211rw/zd_rf.h
@@ -47,17 +47,13 @@ struct zd_rf {
 	u8 type;
 
 	u8 channel;
-	/*
-	 * Whether this RF should patch the 6M band edge
-	 * (assuming E2P_POD agrees)
-	 */
-	u8 patch_6m_band_edge:1;
 
 	/* RF-specific functions */
 	int (*init_hw)(struct zd_rf *rf);
 	int (*set_channel)(struct zd_rf *rf, u8 channel);
 	int (*switch_radio_on)(struct zd_rf *rf);
 	int (*switch_radio_off)(struct zd_rf *rf);
+	int (*patch_6m_band_edge)(struct zd_rf *rf, u8 channel);
 };
 
 const char *zd_rf_name(u8 type);
@@ -72,6 +68,9 @@ int zd_rf_set_channel(struct zd_rf *rf, u8 channel);
 int zd_switch_radio_on(struct zd_rf *rf);
 int zd_switch_radio_off(struct zd_rf *rf);
 
+int zd_rf_patch_6m_band_edge(struct zd_rf *rf, u8 channel);
+int zd_rf_generic_patch_6m(struct zd_rf *rf, u8 channel);
+
 /* Functions for individual RF chips */
 
 int zd_rf_init_rf2959(struct zd_rf *rf);
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
index fe1c1fc..cf08cc0 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
@@ -437,6 +437,6 @@ int zd_rf_init_al2230(struct zd_rf *rf)
 		rf->set_channel = zd1211_al2230_set_channel;
 		rf->switch_radio_on = zd1211_al2230_switch_radio_on;
 	}
-	rf->patch_6m_band_edge = 1;
+	rf->patch_6m_band_edge = zd_rf_generic_patch_6m;
 	return 0;
 }
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
index bd07c9b..5e5e9dd 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
@@ -51,9 +51,52 @@ static const u32 std_rv[] = {
 	0xd8c010,
 };
 
-static int al7230b_init_hw(struct zd_rf *rf)
+static const u32 rv_init1[] = {
+	0x3c9000,
+	0xbfffff,
+	0x700000,
+	0xf15d58,
+};
+
+static const u32 rv_init2[] = {
+	0xf15d59,
+	0xf15d5c,
+	0xf15d58,
+};
+
+static const struct zd_ioreq16 ioreqs_sw[] = {
+	{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
+	{ CR38,  0x38 }, { CR136, 0xdf },
+};
+
+static int zd1211b_al7230b_finalize(struct zd_chip *chip)
 {
-	int i, r;
+	int r;
+	static const struct zd_ioreq16 ioreqs[] = {
+		{ CR80,  0x30 }, { CR81,  0x30 }, { CR79,  0x58 },
+		{ CR12,  0xf0 }, { CR77,  0x1b }, { CR78,  0x58 },
+		{ CR203, 0x04 },
+		{ },
+		{ CR240, 0x80 },
+	};
+
+	r = zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
+	if (r)
+		return r;
+
+	if (chip->new_phy_layout) {
+		/* antenna selection? */
+		r = zd_iowrite16_locked(chip, 0xe5, CR9);
+		if (r)
+			return r;
+	}
+
+	return zd_iowrite16_locked(chip, 0x04, CR203);
+}
+
+static int zd1211_al7230b_init_hw(struct zd_rf *rf)
+{
+	int r;
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	/* All of these writes are identical to AL2230 unless otherwise
@@ -117,39 +160,136 @@ static int al7230b_init_hw(struct zd_rf *rf)
 	};
 
 	static const struct zd_ioreq16 ioreqs_2[] = {
-		/* PLL_ON */
-		{ CR251, 0x3f },
+		{ CR251, 0x3f }, /* PLL_ON */
 		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-		{ CR38, 0x38 }, { CR136, 0xdf },
+		{ CR38,  0x38 }, { CR136, 0xdf },
 	};
 
 	r = zd_iowrite16a_locked(chip, ioreqs_1, ARRAY_SIZE(ioreqs_1));
 	if (r)
 		return r;
 
-	r = zd_rfwrite_cr_locked(chip, 0x09ec04);
+	r = zd_rfwritev_cr_locked(chip, chan_rv[0], ARRAY_SIZE(chan_rv[0]));
 	if (r)
 		return r;
-	r = zd_rfwrite_cr_locked(chip, 0x8cccc8);
+
+	r = zd_rfwritev_cr_locked(chip, std_rv, ARRAY_SIZE(std_rv));
 	if (r)
 		return r;
 
-	for (i = 0; i < ARRAY_SIZE(std_rv); i++) {
-		r = zd_rfwrite_cr_locked(chip, std_rv[i]);
-		if (r)
-			return r;
-	}
+	r = zd_rfwritev_cr_locked(chip, rv_init1, ARRAY_SIZE(rv_init1));
+	if (r)
+		return r;
 
-	r = zd_rfwrite_cr_locked(chip, 0x3c9000);
+	r = zd_iowrite16a_locked(chip, ioreqs_2, ARRAY_SIZE(ioreqs_2));
 	if (r)
 		return r;
-	r = zd_rfwrite_cr_locked(chip, 0xbfffff);
+
+	r = zd_rfwritev_cr_locked(chip, rv_init2, ARRAY_SIZE(rv_init2));
 	if (r)
 		return r;
-	r = zd_rfwrite_cr_locked(chip, 0x700000);
+
+	r = zd_iowrite16_locked(chip, 0x06, CR203);
 	if (r)
 		return r;
-	r = zd_rfwrite_cr_locked(chip, 0xf15d58);
+	r = zd_iowrite16_locked(chip, 0x80, CR240);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+static int zd1211b_al7230b_init_hw(struct zd_rf *rf)
+{
+	int r;
+	struct zd_chip *chip = zd_rf_to_chip(rf);
+
+	static const struct zd_ioreq16 ioreqs_1[] = {
+		{ CR240, 0x57 }, { CR9,   0x9 },
+		{ },
+		{ CR10,  0x8b }, { CR15,  0x20 },
+		{ CR17,  0x2B }, /* for newest (3rd cut) AL2230 */
+		{ CR20,  0x10 }, /* 4N25->Stone Request */
+		{ CR23,  0x40 }, { CR24,  0x20 }, { CR26,  0x93 },
+		{ CR28,  0x3e }, { CR29,  0x00 },
+		{ CR33,  0x28 }, /* 5613 */
+		{ CR34,  0x30 },
+		{ CR35,  0x3e }, /* for newest (3rd cut) AL2230 */
+		{ CR41,  0x24 }, { CR44,  0x32 },
+		{ CR46,  0x99 }, /* for newest (3rd cut) AL2230 */
+		{ CR47,  0x1e },
+
+		/* ZD1215 5610 */
+		{ CR48,  0x00 }, { CR49,  0x00 }, { CR51,  0x01 },
+		{ CR52,  0x80 }, { CR53,  0x7e }, { CR65,  0x00 },
+		{ CR66,  0x00 }, { CR67,  0x00 }, { CR68,  0x00 },
+		{ CR69,  0x28 },
+
+		{ CR79,  0x58 }, { CR80,  0x30 }, { CR81,  0x30 },
+		{ CR87,  0x0A }, { CR89,  0x04 },
+		{ CR90,  0x58 }, /* 5112 */
+		{ CR91,  0x00 }, /* 5613 */
+		{ CR92,  0x0a },
+		{ CR98,  0x8d }, /* 4804, for 1212 new algorithm */
+		{ CR99,  0x00 }, { CR100, 0x02 }, { CR101, 0x13 },
+		{ CR102, 0x27 },
+		{ CR106, 0x20 }, /* change to 0x24 for AL7230B */
+		{ CR109, 0x13 }, /* 4804, for 1212 new algorithm */
+		{ CR112, 0x1f },
+	};
+
+	static const struct zd_ioreq16 ioreqs_new_phy[] = {
+		{ CR107, 0x28 },
+		{ CR110, 0x1f }, /* 5127, 0x13->0x1f */
+		{ CR111, 0x1f }, /* 0x13 to 0x1f for AL7230B */
+		{ CR116, 0x2a }, { CR118, 0xfa }, { CR119, 0x12 },
+		{ CR121, 0x6c }, /* 5613 */
+	};
+
+	static const struct zd_ioreq16 ioreqs_old_phy[] = {
+		{ CR107, 0x24 },
+		{ CR110, 0x13 }, /* 5127, 0x13->0x1f */
+		{ CR111, 0x13 }, /* 0x13 to 0x1f for AL7230B */
+		{ CR116, 0x24 }, { CR118, 0xfc }, { CR119, 0x11 },
+		{ CR121, 0x6a }, /* 5613 */
+	};
+
+	static const struct zd_ioreq16 ioreqs_2[] = {
+		{ CR113, 0x27 }, { CR114, 0x27 }, { CR115, 0x24 },
+		{ CR117, 0xfa }, { CR120, 0x4f },
+		{ CR122, 0xfc }, /* E0->FCh at 4901 */
+		{ CR123, 0x57 }, /* 5613 */
+		{ CR125, 0xad }, /* 4804, for 1212 new algorithm */
+		{ CR126, 0x6c }, /* 5613 */
+		{ CR127, 0x03 }, /* 4804, for 1212 new algorithm */
+		{ CR130, 0x10 },
+		{ CR131, 0x00 }, /* 5112 */
+		{ CR137, 0x50 }, /* 5613 */
+		{ CR138, 0xa8 }, /* 5112 */
+		{ CR144, 0xac }, /* 5613 */
+		{ CR148, 0x40 }, /* 5112 */
+		{ CR149, 0x40 }, /* 4O07, 50->40 */
+		{ CR150, 0x1a }, /* 5112, 0C->1A */
+		{ CR252, 0x34 }, { CR253, 0x34 },
+		{ CR251, 0x2f }, /* PLL_OFF */
+	};
+
+	static const struct zd_ioreq16 ioreqs_3[] = {
+		{ CR251, 0x7f }, /* PLL_ON */
+		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
+		{ CR38,  0x38 }, { CR136, 0xdf },
+	};
+
+	r = zd_iowrite16a_locked(chip, ioreqs_1, ARRAY_SIZE(ioreqs_1));
+	if (r)
+		return r;
+
+	if (chip->new_phy_layout)
+		r = zd_iowrite16a_locked(chip, ioreqs_new_phy,
+			ARRAY_SIZE(ioreqs_new_phy));
+	else
+		r = zd_iowrite16a_locked(chip, ioreqs_old_phy,
+			ARRAY_SIZE(ioreqs_old_phy));
 	if (r)
 		return r;
 
@@ -157,38 +297,36 @@ static int al7230b_init_hw(struct zd_rf *rf)
 	if (r)
 		return r;
 
-	r = zd_rfwrite_cr_locked(chip, 0xf15d59);
+	r = zd_rfwritev_cr_locked(chip, chan_rv[0], ARRAY_SIZE(chan_rv[0]));
 	if (r)
 		return r;
-	r = zd_rfwrite_cr_locked(chip, 0xf15d5c);
+
+	r = zd_rfwritev_cr_locked(chip, std_rv, ARRAY_SIZE(std_rv));
 	if (r)
 		return r;
-	r = zd_rfwrite_cr_locked(chip, 0xf15d58);
+
+	r = zd_rfwritev_cr_locked(chip, rv_init1, ARRAY_SIZE(rv_init1));
 	if (r)
 		return r;
 
-	r = zd_iowrite16_locked(chip, 0x06, CR203);
+	r = zd_iowrite16a_locked(chip, ioreqs_3, ARRAY_SIZE(ioreqs_3));
 	if (r)
 		return r;
-	r = zd_iowrite16_locked(chip, 0x80, CR240);
+
+	r = zd_rfwritev_cr_locked(chip, rv_init2, ARRAY_SIZE(rv_init2));
 	if (r)
 		return r;
 
-	return 0;
+	return zd1211b_al7230b_finalize(chip);
 }
 
-static int al7230b_set_channel(struct zd_rf *rf, u8 channel)
+static int zd1211_al7230b_set_channel(struct zd_rf *rf, u8 channel)
 {
-	int i, r;
+	int r;
 	const u32 *rv = chan_rv[channel-1];
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
-	static const struct zd_ioreq16 ioreqs_1[] = {
-		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
-		{ CR38,  0x38 }, { CR136, 0xdf },
-	};
-
-	static const struct zd_ioreq16 ioreqs_2[] = {
+	static const struct zd_ioreq16 ioreqs[] = {
 		/* PLL_ON */
 		{ CR251, 0x3f },
 		{ CR203, 0x06 }, { CR240, 0x08 },
@@ -203,11 +341,9 @@ static int al7230b_set_channel(struct zd_rf *rf, u8 channel)
 	if (r)
 		return r;
 
-	for (i = 0; i < ARRAY_SIZE(std_rv); i++) {
-		r = zd_rfwrite_cr_locked(chip, std_rv[i]);
-		if (r)
-			return r;
-	}
+	r = zd_rfwritev_cr_locked(chip, std_rv, ARRAY_SIZE(std_rv));
+	if (r)
+		return r;
 
 	r = zd_rfwrite_cr_locked(chip, 0x3c9000);
 	if (r)
@@ -216,24 +352,69 @@ static int al7230b_set_channel(struct zd_rf *rf, u8 channel)
 	if (r)
 		return r;
 
-	r = zd_iowrite16a_locked(chip, ioreqs_1, ARRAY_SIZE(ioreqs_1));
+	r = zd_iowrite16a_locked(chip, ioreqs_sw, ARRAY_SIZE(ioreqs_sw));
 	if (r)
 		return r;
 
-	for (i = 0; i < 2; i++) {
-		r = zd_rfwrite_cr_locked(chip, rv[i]);
-		if (r)
-			return r;
-	}
+	r = zd_rfwritev_cr_locked(chip, rv, 2);
+	if (r)
+		return r;
+
+	r = zd_rfwrite_cr_locked(chip, 0x3c9000);
+	if (r)
+		return r;
+
+	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
+}
+
+static int zd1211b_al7230b_set_channel(struct zd_rf *rf, u8 channel)
+{
+	int r;
+	const u32 *rv = chan_rv[channel-1];
+	struct zd_chip *chip = zd_rf_to_chip(rf);
+
+	r = zd_iowrite16_locked(chip, 0x57, CR240);
+	if (r)
+		return r;
+	r = zd_iowrite16_locked(chip, 0xe4, CR9);
+	if (r)
+		return r;
+
+	/* PLL_OFF */
+	r = zd_iowrite16_locked(chip, 0x2f, CR251);
+	if (r)
+		return r;
+	r = zd_rfwritev_cr_locked(chip, std_rv, ARRAY_SIZE(std_rv));
+	if (r)
+		return r;
 
 	r = zd_rfwrite_cr_locked(chip, 0x3c9000);
 	if (r)
 		return r;
+	r = zd_rfwrite_cr_locked(chip, 0xf15d58);
+	if (r)
+		return r;
 
-	return zd_iowrite16a_locked(chip, ioreqs_2, ARRAY_SIZE(ioreqs_2));
+	r = zd_iowrite16a_locked(chip, ioreqs_sw, ARRAY_SIZE(ioreqs_sw));
+	if (r)
+		return r;
+
+	r = zd_rfwritev_cr_locked(chip, rv, 2);
+	if (r)
+		return r;
+
+	r = zd_rfwrite_cr_locked(chip, 0x3c9000);
+	if (r)
+		return r;
+
+	r = zd_iowrite16_locked(chip, 0x7f, CR251);
+	if (r)
+		return r;
+
+	return zd1211b_al7230b_finalize(chip);
 }
 
-static int al7230b_switch_radio_on(struct zd_rf *rf)
+static int zd1211_al7230b_switch_radio_on(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 	static const struct zd_ioreq16 ioreqs[] = {
@@ -244,6 +425,17 @@ static int al7230b_switch_radio_on(struct zd_rf *rf)
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
 }
 
+static int zd1211b_al7230b_switch_radio_on(struct zd_rf *rf)
+{
+	struct zd_chip *chip = zd_rf_to_chip(rf);
+	static const struct zd_ioreq16 ioreqs[] = {
+		{ CR11,  0x00 },
+		{ CR251, 0x7f },
+	};
+
+	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
+}
+
 static int al7230b_switch_radio_off(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
@@ -255,20 +447,45 @@ static int al7230b_switch_radio_off(struct zd_rf *rf)
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
 }
 
+/* ZD1211B+AL7230B 6m band edge patching differs slightly from other
+ * configurations */
+static int zd1211b_al7230b_patch_6m(struct zd_rf *rf, u8 channel)
+{
+	struct zd_chip *chip = zd_rf_to_chip(rf);
+	struct zd_ioreq16 ioreqs[] = {
+		{ CR128, 0x14 }, { CR129, 0x12 },
+	};
+
+	/* FIXME: Channel 11 is not the edge for all regulatory domains. */
+	if (channel == 1) {
+		ioreqs[0].value = 0x0e;
+		ioreqs[1].value = 0x10;
+	} else if (channel == 11) {
+		ioreqs[0].value = 0x10;
+		ioreqs[1].value = 0x10;
+	}
+
+	dev_dbg_f(zd_chip_dev(chip), "patching for channel %d\n", channel);
+	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
+}
+
 int zd_rf_init_al7230b(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	if (chip->is_zd1211b) {
-		dev_err(zd_chip_dev(chip), "AL7230B is currently not "
-			"supported for ZD1211B devices\n");
-		return -ENODEV;
+		rf->init_hw = zd1211b_al7230b_init_hw;
+		rf->switch_radio_on = zd1211b_al7230b_switch_radio_on;
+		rf->set_channel = zd1211b_al7230b_set_channel;
+		rf->patch_6m_band_edge = zd1211b_al7230b_patch_6m;
+	} else {
+		rf->init_hw = zd1211_al7230b_init_hw;
+		rf->switch_radio_on = zd1211_al7230b_switch_radio_on;
+		rf->set_channel = zd1211_al7230b_set_channel;
+		rf->patch_6m_band_edge = zd_rf_generic_patch_6m;
 	}
 
-	rf->init_hw = al7230b_init_hw;
-	rf->set_channel = al7230b_set_channel;
-	rf->switch_radio_on = al7230b_switch_radio_on;
 	rf->switch_radio_off = al7230b_switch_radio_off;
-	rf->patch_6m_band_edge = 1;
+
 	return 0;
 }
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 55f4c61..e04cffc 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -66,6 +66,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0b05, 0x171b), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x3410), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0baf, 0x0121), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0586, 0x3412), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{}
diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index f3bc00e..a0c2b41 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -186,9 +186,6 @@ struct ieee80211_radiotap_header {
  *
  *     Number of unicast retries a transmitted frame used.
  *
- * IEEE80211_RADIOTAP_FCS           	__le32       data
- *
- *	FCS from frame in network byte order.
  */
 enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TSFT = 0,
diff --git a/net/ieee80211/ieee80211_crypt_ccmp.c b/net/ieee80211/ieee80211_crypt_ccmp.c
index 7ec8314..b016b41 100644
--- a/net/ieee80211/ieee80211_crypt_ccmp.c
+++ b/net/ieee80211/ieee80211_crypt_ccmp.c
@@ -338,7 +338,7 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (ccmp_replay_check(pn, key->rx_pn)) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: replay detected: STA=" MAC_FMT
+			IEEE80211_DEBUG_DROP("CCMP: replay detected: STA=" MAC_FMT
 			       " previous PN %02x%02x%02x%02x%02x%02x "
 			       "received PN %02x%02x%02x%02x%02x%02x\n",
 			       MAC_ARG(hdr->addr2), MAC_ARG(key->rx_pn),
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index bd0988f..5a48d8e 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -465,7 +465,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: replay detected: STA=" MAC_FMT
+			IEEE80211_DEBUG_DROP("TKIP: replay detected: STA=" MAC_FMT
 			       " previous TSC %08x%04x received TSC "
 			       "%08x%04x\n", MAC_ARG(hdr->addr2),
 			       tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
@@ -507,7 +507,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 			tkey->rx_phase1_done = 0;
 		}
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: ICV error detected: STA="
+			IEEE80211_DEBUG_DROP("TKIP: ICV error detected: STA="
 			       MAC_FMT "\n", MAC_ARG(hdr->addr2));
 		}
 		tkey->dot11RSNAStatsTKIPICVErrors++;
-- 
John W. Linville
linville@tuxdriver.com
