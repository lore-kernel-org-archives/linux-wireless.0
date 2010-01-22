Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35680 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0AVAx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:57 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so747111ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 16:53:56 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/5] b43: N-PHY: add TX tone
Date: Fri, 22 Jan 2010 01:53:16 +0100
Message-Id: <1264121596-9616-6-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   60 ++++++++++++++++++++++++++++++++++---
 1 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 97a44e4..a45a1f3 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -816,6 +816,43 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
+static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
+					bool test)
+{
+	int i;
+	u16 bw, len, num, rot, angle;
+	/* TODO: *buffer; */
+
+	bw = (dev->phy.is_40mhz) ? 40 : 20;
+	len = bw << 3;
+
+	if (test) {
+		if (b43_phy_read(dev, B43_NPHY_BBCFG) & B43_NPHY_BBCFG_RSTRX)
+			bw = 82;
+		else
+			bw = 80;
+
+		if (dev->phy.is_40mhz)
+			bw <<= 1;
+
+		len = bw << 1;
+	}
+
+	/* TODO: buffer = kzalloc(len * sizeof(u32), GFP_KERNEL); */
+	num = len;
+	rot = (((freq * 36) / bw) << 16) / 100;
+	angle = 0;
+
+	for (i = 0; i < num; i++) {
+		/* TODO */
+	}
+
+	/* TODO: Call N PHY Load Sample Table with buffer, num as arguments */
+	/* TODO: kfree(buffer); */
+	return num;
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
 static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 					u16 wait, bool iqmode, bool dac_test)
@@ -876,6 +913,20 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
 }
 
+/*
+ * Transmits a known value for LO calibration
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
+ */
+static int b43_nphy_tx_tone(struct b43_wldev *dev, u32 freq, u16 max_val,
+				bool iqmode, bool dac_test)
+{
+	u16 samp = b43_nphy_gen_load_samples(dev, freq, max_val, dac_test);
+	if (samp == 0)
+		return -1;
+	b43_nphy_run_samples(dev, samp, 0xFFFF, 0, iqmode, dac_test);
+	return 0;
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
 static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 {
@@ -1969,8 +2020,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 		b43_nphy_run_samples(dev, (dev->phy.is_40mhz ? 40 : 20) * 8,
 					0xFFFF, 0, true, false);
 	else
-		;/* TODO: Call N PHY TX Tone with freq, 250, 1, 0 as arguments
-			and save result as error */
+		error = b43_nphy_tx_tone(dev, freq, 250, true, false);
 
 	if (error == 0) {
 		if (nphy->mphase_cal_phase_id > 2) {
@@ -2254,9 +2304,9 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 			b43_nphy_stop_playback(dev);
 
 			if (playtone) {
-				/* TODO: Call N PHY TX Tone with 4000,
-					(nphy_rxcalparams & 0xffff), 0, 0
-					as arguments and save result as ret */
+				ret = b43_nphy_tx_tone(dev, 4000,
+						(nphy->rxcalparams & 0xFFFF),
+						false, false);
 				playtone = false;
 			} else {
 				b43_nphy_run_samples(dev, 160, 0xFFFF, 0,
-- 
1.6.4.2

