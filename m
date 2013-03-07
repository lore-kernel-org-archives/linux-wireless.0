Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:58810 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab3CGPr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:56 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so441461eek.30
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:47:55 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 07/13] b43: HT-PHY: implement PA override
Date: Thu,  7 Mar 2013 16:47:21 +0100
Message-Id: <1362671247-10766-8-git-send-email-zajec5@gmail.com> (sfid-20130307_164759_037128_C3F538EB)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h |    5 +++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index aedbae7..3b3517c 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -178,6 +178,26 @@ static void b43_phy_ht_force_rf_sequence(struct b43_wldev *dev, u16 rf_seq)
 	b43_phy_write(dev, B43_PHY_HT_RF_SEQ_MODE, save_seq_mode);
 }
 
+static void b43_phy_ht_pa_override(struct b43_wldev *dev, bool enable)
+{
+	struct b43_phy_ht *htphy = dev->phy.ht;
+	const u16 regs[3] = { B43_PHY_HT_RF_CTL_INT_C1,
+				  B43_PHY_HT_RF_CTL_INT_C2,
+				  B43_PHY_HT_RF_CTL_INT_C3 };
+	int i;
+
+	if (enable) {
+		for (i = 0; i < 3; i++)
+			b43_phy_write(dev, regs[i], htphy->rf_ctl_int_save[i]);
+	} else {
+		for (i = 0; i < 3; i++)
+			htphy->rf_ctl_int_save[i] = b43_phy_read(dev, regs[i]);
+		/* TODO: Does 5GHz band use different value (not 0x0400)? */
+		for (i = 0; i < 3; i++)
+			b43_phy_write(dev, regs[i], 0x0400);
+	}
+}
+
 /**************************************************
  * Various PHY ops
  **************************************************/
@@ -554,8 +574,10 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	b43_mac_phy_clock_set(dev, true);
 
+	b43_phy_ht_pa_override(dev, false);
 	b43_phy_ht_force_rf_sequence(dev, B43_PHY_HT_RF_SEQ_TRIG_RX2TX);
 	b43_phy_ht_force_rf_sequence(dev, B43_PHY_HT_RF_SEQ_TRIG_RST2RX);
+	b43_phy_ht_pa_override(dev, true);
 
 	/* TODO: Should we restore it? Or store it in global PHY info? */
 	b43_phy_ht_classifier(dev, 0, 0);
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 52603af..684807c 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -40,6 +40,10 @@
 
 #define B43_PHY_HT_RF_CTL1			B43_PHY_EXTG(0x010)
 
+#define B43_PHY_HT_RF_CTL_INT_C1		B43_PHY_EXTG(0x04c)
+#define B43_PHY_HT_RF_CTL_INT_C2		B43_PHY_EXTG(0x06c)
+#define B43_PHY_HT_RF_CTL_INT_C3		B43_PHY_EXTG(0x08c)
+
 #define B43_PHY_HT_AFE_C1_OVER			B43_PHY_EXTG(0x110)
 #define B43_PHY_HT_AFE_C1			B43_PHY_EXTG(0x111)
 #define B43_PHY_HT_AFE_C2_OVER			B43_PHY_EXTG(0x114)
@@ -62,6 +66,7 @@ struct b43_phy_ht_channeltab_e_phy {
 
 
 struct b43_phy_ht {
+	u16 rf_ctl_int_save[3];
 };
 
 
-- 
1.7.10.4

