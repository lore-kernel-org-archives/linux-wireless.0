Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62148 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1IPOda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 10:33:30 -0400
Received: by fxe4 with SMTP id 4so1724576fxe.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 07:33:29 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 7/6] b43: LCN-PHY: finish sense setup
Date: Fri, 16 Sep 2011 16:36:32 +0200
Message-Id: <1316183792-14824-7-git-send-email-zajec5@gmail.com> (sfid-20110916_163333_920870_0BB35CCB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   90 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_lcn.h |    1 +
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 3ac2357..bffeb44 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -49,6 +49,11 @@ struct lcn_tx_iir_filter {
 	u16 values[16];
 };
 
+enum lcn_sense_type {
+	B43_SENSE_TEMP,
+	B43_SENSE_VBAT,
+};
+
 /* In theory it's PHY common function, move if needed */
 /* brcms_b_switch_macfreq */
 static void b43_phy_switch_macfreq(struct b43_wldev *dev, u8 spurmode)
@@ -335,8 +340,12 @@ static void b43_phy_lcn_bu_tweaks(struct b43_wldev *dev)
 }
 
 /* wlc_lcnphy_vbat_temp_sense_setup */
-static void b43_phy_lcn_sense_setup(struct b43_wldev *dev)
+static void b43_phy_lcn_sense_setup(struct b43_wldev *dev,
+				    enum lcn_sense_type sense_type)
 {
+	u8 auxpga_vmidcourse, auxpga_vmidfine, auxpga_gain;
+	u16 auxpga_vmid;
+	u8 tx_pwr_idx;
 	u8 i;
 
 	u16 save_radio_regs[6][2] = {
@@ -351,21 +360,96 @@ static void b43_phy_lcn_sense_setup(struct b43_wldev *dev)
 	};
 	u16 save_radio_4a4;
 
+	msleep(1);
+
+	/* Save */
 	for (i = 0; i < 6; i++)
 		save_radio_regs[i][1] = b43_radio_read(dev,
 						       save_radio_regs[i][0]);
 	for (i = 0; i < 14; i++)
 		save_phy_regs[i][1] = b43_phy_read(dev, save_phy_regs[i][0]);
+	b43_mac_suspend(dev);
 	save_radio_4a4 = b43_radio_read(dev, 0x4a4);
+	/* wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF); */
+	tx_pwr_idx = dev->phy.lcn->tx_pwr_curr_idx;
+
+	/* Setup */
+	/* TODO: wlc_lcnphy_set_tx_pwr_by_index(pi, 127); */
+	b43_radio_set(dev, 0x007, 0x1);
+	b43_radio_set(dev, 0x0ff, 0x10);
+	b43_radio_set(dev, 0x11f, 0x4);
+
+	b43_phy_mask(dev, 0x503, ~0x1);
+	b43_phy_mask(dev, 0x503, ~0x4);
+	b43_phy_mask(dev, 0x4a4, ~0x4000);
+	b43_phy_mask(dev, 0x4a4, (u16) ~0x8000);
+	b43_phy_mask(dev, 0x4d0, ~0x20);
+	b43_phy_set(dev, 0x4a5, 0xff);
+	b43_phy_maskset(dev, 0x4a5, ~0x7000, 0x5000);
+	b43_phy_mask(dev, 0x4a5, ~0x700);
+	b43_phy_maskset(dev, 0x40d, ~0xff, 64);
+	b43_phy_maskset(dev, 0x40d, ~0x700, 0x600);
+	b43_phy_maskset(dev, 0x4a2, ~0xff, 64);
+	b43_phy_maskset(dev, 0x4a2, ~0x700, 0x600);
+	b43_phy_maskset(dev, 0x4d9, ~0x70, 0x20);
+	b43_phy_maskset(dev, 0x4d9, ~0x700, 0x300);
+	b43_phy_maskset(dev, 0x4d9, ~0x7000, 0x1000);
+	b43_phy_mask(dev, 0x4da, ~0x1000);
+	b43_phy_set(dev, 0x4da, 0x2000);
+	b43_phy_set(dev, 0x4a6, 0x8000);
+
+	b43_radio_write(dev, 0x025, 0xc);
+	b43_radio_set(dev, 0x005, 0x8);
+	b43_phy_set(dev, 0x938, 0x4);
+	b43_phy_set(dev, 0x939, 0x4);
+	b43_phy_set(dev, 0x4a4, 0x1000);
+
+	/* FIXME: don't hardcode */
+	b43_lcntab_write(dev, B43_LCNTAB16(0x8, 0x6), 0x640);
+
+	switch (sense_type) {
+	case B43_SENSE_TEMP:
+		b43_phy_set(dev, 0x4d7, 0x8);
+		b43_phy_maskset(dev, 0x4d7, ~0x7000, 0x1000);
+		auxpga_vmidcourse = 8;
+		auxpga_vmidfine = 0x4;
+		auxpga_gain = 2;
+		b43_radio_set(dev, 0x082, 0x20);
+		break;
+	case B43_SENSE_VBAT:
+		b43_phy_set(dev, 0x4d7, 0x8);
+		b43_phy_maskset(dev, 0x4d7, ~0x7000, 0x3000);
+		auxpga_vmidcourse = 7;
+		auxpga_vmidfine = 0xa;
+		auxpga_gain = 2;
+		break;
+	}
+	auxpga_vmid = (0x200 | (auxpga_vmidcourse << 4) | auxpga_vmidfine);
 
-	/* TODO: config sth */
+	b43_phy_set(dev, 0x4d8, 0x1);
+	b43_phy_maskset(dev, 0x4d8, ~(0x3ff << 2), auxpga_vmid << 2);
+	b43_phy_set(dev, 0x4d8, 0x2);
+	b43_phy_maskset(dev, 0x4d8, ~(0x7 << 12), auxpga_gain << 12);
+	b43_phy_set(dev, 0x4d0, 0x20);
+	b43_radio_write(dev, 0x112, 0x6);
 
+	/* TODO: dummy transmission? */
+	/* Wait if not done */
+	if (!(b43_phy_read(dev, 0x476) & 0x8000))
+		udelay(10);
+
+	/* Restore */
 	for (i = 0; i < 6; i++)
 		b43_radio_write(dev, save_radio_regs[i][0],
 				save_radio_regs[i][1]);
 	for (i = 0; i < 14; i++)
 		b43_phy_write(dev, save_phy_regs[i][0], save_phy_regs[i][1]);
+	/* TODO: wlc_lcnphy_set_tx_pwr_by_index(tx_pwr_idx) */
 	b43_radio_write(dev, 0x4a4, save_radio_4a4);
+
+	b43_mac_enable(dev);
+
+	msleep(1);
 }
 
 static bool b43_phy_lcn_load_tx_iir_cck_filter(struct b43_wldev *dev,
@@ -499,7 +583,7 @@ static void b43_phy_lcn_tx_pwr_ctl_init(struct b43_wldev *dev)
 		}
 		b43_phy_lcn_set_tx_gain(dev, &tx_gains);
 		b43_phy_lcn_set_bbmult(dev, bbmult);
-		b43_phy_lcn_sense_setup(dev); /* TODO: TEMPSENSE as arg */
+		b43_phy_lcn_sense_setup(dev, B43_SENSE_TEMP);
 	} else {
 		b43err(dev->wl, "TX power control not supported for this HW\n");
 	}
diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
index 2a386d0..6a7092e 100644
--- a/drivers/net/wireless/b43/phy_lcn.h
+++ b/drivers/net/wireless/b43/phy_lcn.h
@@ -21,6 +21,7 @@
 struct b43_phy_lcn {
 	bool hw_pwr_ctl;
 	bool hw_pwr_ctl_capable;
+	u8 tx_pwr_curr_idx;
 };
 
 
-- 
1.7.3.4

