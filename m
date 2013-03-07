Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:41157 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073Ab3CGPsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:48:11 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so1588714eab.34
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:48:10 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 13/13] b43: HT-PHY: enable basic TX power setup
Date: Thu,  7 Mar 2013 16:47:27 +0100
Message-Id: <1362671247-10766-14-git-send-email-zajec5@gmail.com> (sfid-20130307_171303_267170_40FE0943)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 6d5eb04..54e5c85 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -297,7 +297,6 @@ static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
  * Samples
  **************************************************/
 
-#if 0
 static void b43_phy_ht_stop_playback(struct b43_wldev *dev)
 {
 	struct b43_phy_ht *phy_ht = dev->phy.ht;
@@ -385,13 +384,11 @@ static void b43_phy_ht_tx_tone(struct b43_wldev *dev)
 	samp = b43_phy_ht_load_samples(dev);
 	b43_phy_ht_run_samples(dev, samp, 0xFFFF, 0);
 }
-#endif
 
 /**************************************************
  * RSSI
  **************************************************/
 
-#if 0
 static void b43_phy_ht_rssi_select(struct b43_wldev *dev, u8 core_sel,
 				   u8 rssi_type)
 {
@@ -471,7 +468,6 @@ static void b43_phy_ht_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 	for (i = 0; i < 12; i++)
 		b43_phy_write(dev, phy_regs_to_save[i], phy_regs_values[i]);
 }
-#endif
 
 /**************************************************
  * Tx/Rx
@@ -499,7 +495,6 @@ static void b43_phy_ht_tx_power_fix(struct b43_wldev *dev)
 	}
 }
 
-#if 0
 static void b43_phy_ht_tx_power_ctl(struct b43_wldev *dev, bool enable)
 {
 	struct b43_phy_ht *phy_ht = dev->phy.ht;
@@ -665,7 +660,6 @@ static void b43_phy_ht_tx_power_ctl_setup(struct b43_wldev *dev)
 		b43_httab_write_bulk(dev, B43_HTTAB16(26 + c, 0), 64, regval);
 	}
 }
-#endif
 
 /**************************************************
  * Channel switching ops.
@@ -949,13 +943,10 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	saved_tx_pwr_ctl = phy_ht->tx_pwr_ctl;
 	b43_phy_ht_tx_power_fix(dev);
-#if 0
 	b43_phy_ht_tx_power_ctl(dev, false);
 	b43_phy_ht_tx_power_ctl_idle_tssi(dev);
 	b43_phy_ht_tx_power_ctl_setup(dev);
-	/* TODO */
 	b43_phy_ht_tx_power_ctl(dev, saved_tx_pwr_ctl);
-#endif
 
 	return 0;
 }
-- 
1.7.10.4

