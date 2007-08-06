Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:47590 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758753AbXHFAXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 20:23:51 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: removed noisy debug messages
Message-Id: <20070806002354.98E8E7B409F@zog.reactivated.net>
Date: Mon,  6 Aug 2007 01:23:54 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

While developing the driver we added a lot of debug messages for
setting hardware registers. These messages make the reading of the
log files difficult and are of no use anymore. This patch removes
those messages in zd_chip.c.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 zd_chip.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

Index: linux/drivers/net/wireless/zd1211rw/zd_chip.c
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_chip.c
+++ linux/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -500,8 +500,6 @@ int zd_chip_lock_phy_regs(struct zd_chip
 		return r;
 	}
 
-	dev_dbg_f(zd_chip_dev(chip),
-		"CR_REG1: 0x%02x -> 0x%02x\n", tmp, tmp & ~UNLOCK_PHY_REGS);
 	tmp &= ~UNLOCK_PHY_REGS;
 
 	r = zd_iowrite32_locked(chip, tmp, CR_REG1);
@@ -523,8 +521,6 @@ int zd_chip_unlock_phy_regs(struct zd_ch
 		return r;
 	}
 
-	dev_dbg_f(zd_chip_dev(chip),
-		"CR_REG1: 0x%02x -> 0x%02x\n", tmp, tmp | UNLOCK_PHY_REGS);
 	tmp |= UNLOCK_PHY_REGS;
 
 	r = zd_iowrite32_locked(chip, tmp, CR_REG1);
@@ -841,8 +837,6 @@ static int get_aw_pt_bi(struct zd_chip *
 	s->atim_wnd_period = values[0];
 	s->pre_tbtt = values[1];
 	s->beacon_interval = values[2];
-	dev_dbg_f(zd_chip_dev(chip), "aw %u pt %u bi %u\n",
-		s->atim_wnd_period, s->pre_tbtt, s->beacon_interval);
 	return 0;
 }
 
@@ -864,9 +858,6 @@ static int set_aw_pt_bi(struct zd_chip *
 	reqs[2].addr = CR_BCN_INTERVAL;
 	reqs[2].value = s->beacon_interval;
 
-	dev_dbg_f(zd_chip_dev(chip),
-		"aw %u pt %u bi %u\n", s->atim_wnd_period, s->pre_tbtt,
-		                       s->beacon_interval);
 	return zd_iowrite32a_locked(chip, reqs, ARRAY_SIZE(reqs));
 }
 
@@ -1160,16 +1151,12 @@ out:
 static int update_pwr_int(struct zd_chip *chip, u8 channel)
 {
 	u8 value = chip->pwr_int_values[channel - 1];
-	dev_dbg_f(zd_chip_dev(chip), "channel %d pwr_int %#04x\n",
-		 channel, value);
 	return zd_iowrite16_locked(chip, value, CR31);
 }
 
 static int update_pwr_cal(struct zd_chip *chip, u8 channel)
 {
 	u8 value = chip->pwr_cal_values[channel-1];
-	dev_dbg_f(zd_chip_dev(chip), "channel %d pwr_cal %#04x\n",
-		 channel, value);
 	return zd_iowrite16_locked(chip, value, CR68);
 }
 
@@ -1184,9 +1171,6 @@ static int update_ofdm_cal(struct zd_chi
 	ioreqs[2].addr = CR65;
 	ioreqs[2].value = chip->ofdm_cal_values[OFDM_54M_INDEX][channel-1];
 
-	dev_dbg_f(zd_chip_dev(chip),
-		"channel %d ofdm_cal 36M %#04x 48M %#04x 54M %#04x\n",
-		channel, ioreqs[0].value, ioreqs[1].value, ioreqs[2].value);
 	return zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
 }
 
@@ -1638,7 +1622,5 @@ int zd_chip_set_multicast_hash(struct zd
 		{ CR_GROUP_HASH_P2, hash->high },
 	};
 
-	dev_dbg_f(zd_chip_dev(chip), "hash l 0x%08x h 0x%08x\n",
-		ioreqs[0].value, ioreqs[1].value);
 	return zd_iowrite32a(chip, ioreqs, ARRAY_SIZE(ioreqs));
 }
