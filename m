Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44537 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1LQM4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:34 -0500
Received: by eekc4 with SMTP id c4so4011144eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:33 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/8] b43: N-PHY: reorder functions: collect samples ones
Date: Sat, 17 Dec 2011 13:57:22 +0100
Message-Id: <1324126647-22425-4-git-send-email-zajec5@gmail.com> (sfid-20111217_135638_677902_67EC2316)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  266 +++++++++++++++++++-------------------
 1 files changed, 135 insertions(+), 131 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 29ab432..3140b60 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -778,6 +778,141 @@ static void b43_radio_init2055(struct b43_wldev *dev)
 }
 
 /**************************************************
+ * Samples
+ **************************************************/
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
+static int b43_nphy_load_samples(struct b43_wldev *dev,
+					struct b43_c32 *samples, u16 len) {
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 i;
+	u32 *data;
+
+	data = kzalloc(len * sizeof(u32), GFP_KERNEL);
+	if (!data) {
+		b43err(dev->wl, "allocation for samples loading failed\n");
+		return -ENOMEM;
+	}
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	for (i = 0; i < len; i++) {
+		data[i] = (samples[i].i & 0x3FF << 10);
+		data[i] |= samples[i].q & 0x3FF;
+	}
+	b43_ntab_write_bulk(dev, B43_NTAB32(17, 0), len, data);
+
+	kfree(data);
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+	return 0;
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
+static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
+					bool test)
+{
+	int i;
+	u16 bw, len, rot, angle;
+	struct b43_c32 *samples;
+
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
+	samples = kcalloc(len, sizeof(struct b43_c32), GFP_KERNEL);
+	if (!samples) {
+		b43err(dev->wl, "allocation for samples generation failed\n");
+		return 0;
+	}
+	rot = (((freq * 36) / bw) << 16) / 100;
+	angle = 0;
+
+	for (i = 0; i < len; i++) {
+		samples[i] = b43_cordic(angle);
+		angle += rot;
+		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
+		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
+	}
+
+	i = b43_nphy_load_samples(dev, samples, len);
+	kfree(samples);
+	return (i < 0) ? 0 : len;
+}
+
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
+/**************************************************
  * Others
  **************************************************/
 
@@ -2077,137 +2212,6 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
-static int b43_nphy_load_samples(struct b43_wldev *dev,
-					struct b43_c32 *samples, u16 len) {
-	struct b43_phy_n *nphy = dev->phy.n;
-	u16 i;
-	u32 *data;
-
-	data = kzalloc(len * sizeof(u32), GFP_KERNEL);
-	if (!data) {
-		b43err(dev->wl, "allocation for samples loading failed\n");
-		return -ENOMEM;
-	}
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 1);
-
-	for (i = 0; i < len; i++) {
-		data[i] = (samples[i].i & 0x3FF << 10);
-		data[i] |= samples[i].q & 0x3FF;
-	}
-	b43_ntab_write_bulk(dev, B43_NTAB32(17, 0), len, data);
-
-	kfree(data);
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 0);
-	return 0;
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
-static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
-					bool test)
-{
-	int i;
-	u16 bw, len, rot, angle;
-	struct b43_c32 *samples;
-
-
-	bw = (dev->phy.is_40mhz) ? 40 : 20;
-	len = bw << 3;
-
-	if (test) {
-		if (b43_phy_read(dev, B43_NPHY_BBCFG) & B43_NPHY_BBCFG_RSTRX)
-			bw = 82;
-		else
-			bw = 80;
-
-		if (dev->phy.is_40mhz)
-			bw <<= 1;
-
-		len = bw << 1;
-	}
-
-	samples = kcalloc(len, sizeof(struct b43_c32), GFP_KERNEL);
-	if (!samples) {
-		b43err(dev->wl, "allocation for samples generation failed\n");
-		return 0;
-	}
-	rot = (((freq * 36) / bw) << 16) / 100;
-	angle = 0;
-
-	for (i = 0; i < len; i++) {
-		samples[i] = b43_cordic(angle);
-		angle += rot;
-		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
-		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
-	}
-
-	i = b43_nphy_load_samples(dev, samples, len);
-	kfree(samples);
-	return (i < 0) ? 0 : len;
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
-static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
-					u16 wait, bool iqmode, bool dac_test)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-	int i;
-	u16 seq_mode;
-	u32 tmp;
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, true);
-
-	if ((nphy->bb_mult_save & 0x80000000) == 0) {
-		tmp = b43_ntab_read(dev, B43_NTAB16(15, 87));
-		nphy->bb_mult_save = (tmp & 0xFFFF) | 0x80000000;
-	}
-
-	if (!dev->phy.is_40mhz)
-		tmp = 0x6464;
-	else
-		tmp = 0x4747;
-	b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, false);
-
-	b43_phy_write(dev, B43_NPHY_SAMP_DEPCNT, (samps - 1));
-
-	if (loops != 0xFFFF)
-		b43_phy_write(dev, B43_NPHY_SAMP_LOOPCNT, (loops - 1));
-	else
-		b43_phy_write(dev, B43_NPHY_SAMP_LOOPCNT, loops);
-
-	b43_phy_write(dev, B43_NPHY_SAMP_WAITCNT, wait);
-
-	seq_mode = b43_phy_read(dev, B43_NPHY_RFSEQMODE);
-
-	b43_phy_set(dev, B43_NPHY_RFSEQMODE, B43_NPHY_RFSEQMODE_CAOVER);
-	if (iqmode) {
-		b43_phy_mask(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x7FFF);
-		b43_phy_set(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8000);
-	} else {
-		if (dac_test)
-			b43_phy_write(dev, B43_NPHY_SAMP_CMD, 5);
-		else
-			b43_phy_write(dev, B43_NPHY_SAMP_CMD, 1);
-	}
-	for (i = 0; i < 100; i++) {
-		if (b43_phy_read(dev, B43_NPHY_RFSEQST) & 1) {
-			i = 0;
-			break;
-		}
-		udelay(10);
-	}
-	if (i)
-		b43err(dev->wl, "run samples timeout\n");
-
-	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
-}
-
 /*
  * Transmits a known value for LO calibration
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
-- 
1.7.7

