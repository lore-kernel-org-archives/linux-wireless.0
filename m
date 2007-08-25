Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50579
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbXHYACo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 20:02:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: b43: Always calibrate all LO control values
Date: Sat, 25 Aug 2007 02:01:44 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708250201.44950.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a workaround that (optionally) removes the broken
optimization to only calibrate "needed" control values.
With this applied, all possible control values are always
calibrated and some runtime warnings vanish.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/lo.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/lo.h	2007-08-24 13:21:54.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/lo.h	2007-08-25 01:01:32.000000000 +0200
@@ -55,7 +55,7 @@ static inline bool b43_loctl_is_calibrat
  * Use b43_get_lo_g_ctl() to retrieve a value from the lists.
  */
 struct b43_txpower_lo_control {
-#define B43_NR_BB	9
+#define B43_NR_BB	12
 #define B43_NR_RF	16
 	/* LO Control values, with PAD Mixer */
 	struct b43_loctl with_padmix[B43_NR_BB][B43_NR_RF];
Index: wireless-dev-new/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/lo.c	2007-08-24 13:21:54.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/lo.c	2007-08-25 01:42:55.000000000 +0200
@@ -35,6 +35,12 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 
+
+/* Define to 1 to always calibrate all possible LO control pairs.
+ * This is a workaround until we fix the partial LO calibration optimization. */
+#define B43_CALIB_ALL_LOCTLS	1
+
+
 /* Write the LocalOscillator Control (adjust) value-pair. */
 static void b43_lo_write(struct b43_wldev *dev, struct b43_loctl *control)
 {
@@ -77,6 +83,7 @@ static int assert_rfatt_and_bbatt(const 
 	return err;
 }
 
+#if !B43_CALIB_ALL_LOCTLS
 static
 struct b43_loctl *b43_get_lo_g_ctl_nopadmix(struct b43_wldev *dev,
 					    const struct b43_rfatt *rfatt,
@@ -89,6 +96,7 @@ struct b43_loctl *b43_get_lo_g_ctl_nopad
 		return &(lo->no_padmix[0][0]);	/* Just prevent a crash */
 	return &(lo->no_padmix[bbatt->att][rfatt->att]);
 }
+#endif /* !B43_CALIB_ALL_LOCTLS */
 
 struct b43_loctl *b43_get_lo_g_ctl(struct b43_wldev *dev,
 				   const struct b43_rfatt *rfatt,
@@ -936,6 +944,66 @@ static void lo_probe_loctls_statemachine
 	} while (++repeat_cnt < max_repeat);
 }
 
+#if B43_CALIB_ALL_LOCTLS
+static const struct b43_rfatt b43_full_rfatt_list_items[] = {
+	{ .att = 0, .with_padmix = 0, },
+	{ .att = 1, .with_padmix = 0, },
+	{ .att = 2, .with_padmix = 0, },
+	{ .att = 3, .with_padmix = 0, },
+	{ .att = 4, .with_padmix = 0, },
+	{ .att = 5, .with_padmix = 0, },
+	{ .att = 6, .with_padmix = 0, },
+	{ .att = 7, .with_padmix = 0, },
+	{ .att = 8, .with_padmix = 0, },
+	{ .att = 9, .with_padmix = 0, },
+	{ .att = 10, .with_padmix = 0, },
+	{ .att = 11, .with_padmix = 0, },
+	{ .att = 12, .with_padmix = 0, },
+	{ .att = 13, .with_padmix = 0, },
+	{ .att = 14, .with_padmix = 0, },
+	{ .att = 15, .with_padmix = 0, },
+	{ .att = 0, .with_padmix = 1, },
+	{ .att = 1, .with_padmix = 1, },
+	{ .att = 2, .with_padmix = 1, },
+	{ .att = 3, .with_padmix = 1, },
+	{ .att = 4, .with_padmix = 1, },
+	{ .att = 5, .with_padmix = 1, },
+	{ .att = 6, .with_padmix = 1, },
+	{ .att = 7, .with_padmix = 1, },
+	{ .att = 8, .with_padmix = 1, },
+	{ .att = 9, .with_padmix = 1, },
+	{ .att = 10, .with_padmix = 1, },
+	{ .att = 11, .with_padmix = 1, },
+	{ .att = 12, .with_padmix = 1, },
+	{ .att = 13, .with_padmix = 1, },
+	{ .att = 14, .with_padmix = 1, },
+	{ .att = 15, .with_padmix = 1, },
+};
+static const struct b43_rfatt_list b43_full_rfatt_list = {
+	.list		= b43_full_rfatt_list_items,
+	.len		= ARRAY_SIZE(b43_full_rfatt_list_items),
+};
+
+static const struct b43_bbatt b43_full_bbatt_list_items[] = {
+	{ .att = 0, },
+	{ .att = 1, },
+	{ .att = 2, },
+	{ .att = 3, },
+	{ .att = 4, },
+	{ .att = 5, },
+	{ .att = 6, },
+	{ .att = 7, },
+	{ .att = 8, },
+	{ .att = 9, },
+	{ .att = 10, },
+	{ .att = 11, },
+};
+static const struct b43_bbatt_list b43_full_bbatt_list = {
+	.list		= b43_full_bbatt_list_items,
+	.len		= ARRAY_SIZE(b43_full_bbatt_list_items),
+};
+#endif /* B43_CALIB_ALL_LOCTLS */
+
 static void lo_measure(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -947,41 +1015,51 @@ static void lo_measure(struct b43_wldev 
 	struct b43_loctl *ploctl;
 	int max_rx_gain;
 	int rfidx, bbidx;
+	const struct b43_bbatt_list *bbatt_list;
+	const struct b43_rfatt_list *rfatt_list;
 
 	/* Values from the "TXCTL Register and Value Table" */
 	u16 txctl_reg;
 	u16 txctl_value;
 	u16 pad_mix_gain;
 
+	bbatt_list = &lo->bbatt_list;
+	rfatt_list = &lo->rfatt_list;
+#if B43_CALIB_ALL_LOCTLS
+	bbatt_list = &b43_full_bbatt_list;
+	rfatt_list = &b43_full_rfatt_list;
+#endif
+
 	txctl_reg = lo_txctl_register_table(dev, &txctl_value, &pad_mix_gain);
 
-	for (rfidx = 0; rfidx < lo->rfatt_list.len; rfidx++) {
+	for (rfidx = 0; rfidx < rfatt_list->len; rfidx++) {
 
 		b43_radio_write16(dev, 0x43, (b43_radio_read16(dev, 0x43)
-					      & 0xFFF0) | lo->rfatt_list.
-				  list[rfidx].att);
+					      & 0xFFF0) |
+				  rfatt_list->list[rfidx].att);
 		b43_radio_write16(dev, txctl_reg,
 				  (b43_radio_read16(dev, txctl_reg)
 				   & ~txctl_value)
-				  | (lo->rfatt_list.list[rfidx].
-				     with_padmix ? txctl_value : 0));
+				  | (rfatt_list->list[rfidx].with_padmix ?
+				     txctl_value : 0));
 
-		for (bbidx = 0; bbidx < lo->bbatt_list.len; bbidx++) {
+		for (bbidx = 0; bbidx < bbatt_list->len; bbidx++) {
 			if (lo->rebuild) {
+#if B43_CALIB_ALL_LOCTLS
+				ploctl = b43_get_lo_g_ctl(dev,
+							  &rfatt_list->list[rfidx],
+							  &bbatt_list->list[bbidx]);
+#else
 				ploctl = b43_get_lo_g_ctl_nopadmix(dev,
-								   &lo->
-								   rfatt_list.
+								   &rfatt_list->
 								   list[rfidx],
-								   &lo->
-								   bbatt_list.
+								   &bbatt_list->
 								   list[bbidx]);
+#endif
 			} else {
-				ploctl =
-				    b43_get_lo_g_ctl(dev,
-						     &lo->rfatt_list.
-						     list[rfidx],
-						     &lo->bbatt_list.
-						     list[bbidx]);
+				ploctl = b43_get_lo_g_ctl(dev,
+							  &rfatt_list->list[rfidx],
+							  &bbatt_list->list[bbidx]);
 				if (!ploctl->used)
 					continue;
 			}
@@ -989,9 +1067,9 @@ static void lo_measure(struct b43_wldev 
 			loctl.i = 0;
 			loctl.q = 0;
 
-			max_rx_gain = lo->rfatt_list.list[rfidx].att * 2;
-			max_rx_gain += lo->bbatt_list.list[bbidx].att / 2;
-			if (lo->rfatt_list.list[rfidx].with_padmix)
+			max_rx_gain = rfatt_list->list[rfidx].att * 2;
+			max_rx_gain += bbatt_list->list[bbidx].att / 2;
+			if (rfatt_list->list[rfidx].with_padmix)
 				max_rx_gain -= pad_mix_gain;
 			if (has_loopback_gain(phy))
 				max_rx_gain += phy->max_lb_gain;
@@ -999,8 +1077,7 @@ static void lo_measure(struct b43_wldev 
 					       has_loopback_gain(phy));
 
 			b43_phy_set_baseband_attenuation(dev,
-							 lo->bbatt_list.
-							 list[bbidx].att);
+							 bbatt_list->list[bbidx].att);
 			lo_probe_loctls_statemachine(dev, &loctl, &max_rx_gain);
 			if (phy->type == B43_PHYTYPE_B) {
 				loctl.i++;
