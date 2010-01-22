Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35680 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0AVAxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:45 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so747111ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 16:53:43 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] b43: N-PHY: add running samples
Date: Fri, 22 Jan 2010 01:53:14 +0100
Message-Id: <1264121596-9616-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   68 +++++++++++++++++++++++++++++++++++--
 1 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d3c9783..f5900f0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -816,6 +816,66 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
+static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
+					u16 wait, bool iqmode, bool dac_test)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	int i;
+	u16 seq_mode;
+	u32 tmp;
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, true);
+
+	if ((nphy->bb_mult_save & 0x80000000) == 0) {
+		tmp = b43_ntab_read(dev, B43_NTAB16(15, 87));
+		nphy->bb_mult_save = (tmp & 0xFFFF) | 0x80000000;
+	}
+
+	if (!dev->phy.is_40mhz)
+		tmp = 0x6464;
+	else
+		tmp = 0x4747;
+	b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, false);
+
+	b43_phy_write(dev, B43_NPHY_SAMP_DEPCNT, (samps - 1));
+
+	if (loops != 0xFFFF)
+		b43_phy_write(dev, B43_NPHY_SAMP_LOOPCNT, (loops - 1));
+	else
+		b43_phy_write(dev, B43_NPHY_SAMP_LOOPCNT, loops);
+
+	b43_phy_write(dev, B43_NPHY_SAMP_WAITCNT, wait);
+
+	seq_mode = b43_phy_read(dev, B43_NPHY_RFSEQMODE);
+
+	b43_phy_set(dev, B43_NPHY_RFSEQMODE, B43_NPHY_RFSEQMODE_CAOVER);
+	if (iqmode) {
+		b43_phy_mask(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x7FFF);
+		b43_phy_set(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8000);
+	} else {
+		if (dac_test)
+			b43_phy_write(dev, B43_NPHY_SAMP_CMD, 5);
+		else
+			b43_phy_write(dev, B43_NPHY_SAMP_CMD, 1);
+	}
+	for (i = 0; i < 100; i++) {
+		if (b43_phy_read(dev, B43_NPHY_RFSEQST) & 1) {
+			i = 0;
+			break;
+		}
+		udelay(10);
+	}
+	if (i)
+		b43err(dev->wl, "run samples timeout\n");
+
+	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
 static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 {
@@ -1869,8 +1929,8 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 		freq = 5000;
 
 	if (nphy->mphase_cal_phase_id > 2)
-		;/* TODO: Call N PHY Run Samples with (band width * 8),
-			0xFFFF, 0, 1, 0 as arguments */
+		b43_nphy_run_samples(dev, (dev->phy.is_40mhz ? 40 : 20) * 8,
+					0xFFFF, 0, true, false);
 	else
 		;/* TODO: Call N PHY TX Tone with freq, 250, 1, 0 as arguments
 			and save result as error */
@@ -2162,8 +2222,8 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 					as arguments and save result as ret */
 				playtone = false;
 			} else {
-				/* TODO: Call N PHY Run Samples with 160,
-					0xFFFF, 0, 0, 0 as arguments */
+				b43_nphy_run_samples(dev, 160, 0xFFFF, 0,
+							false, false);
 			}
 
 			if (ret == 0) {
-- 
1.6.4.2

