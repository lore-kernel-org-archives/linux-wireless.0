Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:36953 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaFVVSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2014 17:18:34 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so6036605wes.3
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2014 14:18:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: update code for sending sample tone
Date: Sun, 22 Jun 2014 23:18:21 +0200
Message-Id: <1403471902-12731-1-git-send-email-zajec5@gmail.com> (sfid-20140622_231856_421168_E0CA5220)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6398c7e..d9409b4 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1248,7 +1248,8 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
 static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
-					u16 wait, bool iqmode, bool dac_test)
+				 u16 wait, bool iqmode, bool dac_test,
+				 bool modify_bbmult)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 	int i;
@@ -1262,12 +1263,10 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 		nphy->bb_mult_save = (tmp & 0xFFFF) | 0x80000000;
 	}
 
-	/* TODO: add modify_bbmult argument */
-	if (!b43_is_40mhz(dev))
-		tmp = 0x6464;
-	else
-		tmp = 0x4747;
-	b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
+	if (modify_bbmult) {
+		tmp = !b43_is_40mhz(dev) ? 0x6464 : 0x4747;
+		b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
+	}
 
 	b43_phy_write(dev, B43_NPHY_SAMP_DEPCNT, (samps - 1));
 
@@ -1285,10 +1284,8 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 		b43_phy_mask(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x7FFF);
 		b43_phy_set(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8000);
 	} else {
-		if (dac_test)
-			b43_phy_write(dev, B43_NPHY_SAMP_CMD, 5);
-		else
-			b43_phy_write(dev, B43_NPHY_SAMP_CMD, 1);
+		tmp = dac_test ? 5 : 1;
+		b43_phy_write(dev, B43_NPHY_SAMP_CMD, tmp);
 	}
 	for (i = 0; i < 100; i++) {
 		if (!(b43_phy_read(dev, B43_NPHY_RFSEQST) & 1)) {
@@ -2947,12 +2944,13 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
  */
 static int b43_nphy_tx_tone(struct b43_wldev *dev, u32 freq, u16 max_val,
-				bool iqmode, bool dac_test)
+			    bool iqmode, bool dac_test, bool modify_bbmult)
 {
 	u16 samp = b43_nphy_gen_load_samples(dev, freq, max_val, dac_test);
 	if (samp == 0)
 		return -1;
-	b43_nphy_run_samples(dev, samp, 0xFFFF, 0, iqmode, dac_test);
+	b43_nphy_run_samples(dev, samp, 0xFFFF, 0, iqmode, dac_test,
+			     modify_bbmult);
 	return 0;
 }
 
@@ -3390,7 +3388,7 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 		b43_nphy_rf_ctl_override(dev, 0x2000, 0, 3, false);
 
 	b43_nphy_stop_playback(dev);
-	b43_nphy_tx_tone(dev, 0xFA0, 0, false, false);
+	b43_nphy_tx_tone(dev, 4000, 0, false, false, false);
 	udelay(20);
 	tmp = b43_nphy_poll_rssi(dev, N_RSSI_TSSI_2G, rssi, 1);
 	b43_nphy_stop_playback(dev);
@@ -4648,9 +4646,9 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 
 	if (nphy->mphase_cal_phase_id > 2)
 		b43_nphy_run_samples(dev, (b43_is_40mhz(dev) ? 40 : 20) * 8,
-					0xFFFF, 0, true, false);
+				     0xFFFF, 0, true, false, false);
 	else
-		error = b43_nphy_tx_tone(dev, freq, 250, true, false);
+		error = b43_nphy_tx_tone(dev, freq, 250, true, false, false);
 
 	if (error == 0) {
 		if (nphy->mphase_cal_phase_id > 2) {
@@ -4973,11 +4971,11 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 			if (playtone) {
 				ret = b43_nphy_tx_tone(dev, 4000,
 						(nphy->rxcalparams & 0xFFFF),
-						false, false);
+						false, false, true);
 				playtone = false;
 			} else {
-				b43_nphy_run_samples(dev, 160, 0xFFFF, 0,
-							false, false);
+				b43_nphy_run_samples(dev, 160, 0xFFFF, 0, false,
+						     false, true);
 			}
 
 			if (ret == 0) {
-- 
1.8.4.5

