Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37058
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbXHNSN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:13:56 -0400
Message-Id: <20070814181213.698038000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:14 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 1/9] b43: Add more LO debugging
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to find uses of uncalibrated LO value pairs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/lo.c	2007-08-14 20:09:16.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/lo.c	2007-08-14 20:09:27.000000000 +0200
@@ -986,6 +986,8 @@ static void lo_measure(struct b43_wldev 
 					continue;
 			}
 			memcpy(&loctl, ploctl, sizeof(loctl));
+			loctl.i = 0;
+			loctl.q = 0;
 
 			max_rx_gain = lo->rfatt_list.list[rfidx].att * 2;
 			max_rx_gain += lo->bbatt_list.list[bbidx].att / 2;
@@ -1004,6 +1006,7 @@ static void lo_measure(struct b43_wldev 
 				loctl.i++;
 				loctl.q++;
 			}
+			b43_loctl_set_calibrated(&loctl, 1);
 			memcpy(ploctl, &loctl, sizeof(loctl));
 		}
 	}
@@ -1013,23 +1016,58 @@ static void lo_measure(struct b43_wldev 
 static void do_validate_loctl(struct b43_wldev *dev, struct b43_loctl *control)
 {
 	const int is_initializing = (b43_status(dev) == B43_STAT_UNINIT);
+	int i = control->i;
+	int q = control->q;
 
-	if (unlikely(abs(control->i) > 16 ||
-		     abs(control->q) > 16 ||
-		     (is_initializing && control->used))) {
-		bcmdbg(dev->wl, "ERROR: LO control pair validation failed "
-		       "(first: %d, second: %d, used %u)\n",
-		       control->i, control->q, control->used);
+	if (b43_loctl_is_calibrated(control)) {
+		if ((abs(i) > 16) || (abs(q) > 16))
+			goto error;
+	} else {
+		if (control->used)
+			goto error;
+		if (dev->phy.lo_control->rebuild) {
+			control->i = 0;
+			control->q = 0;
+			if ((i != B43_LOCTL_POISON) ||
+			    (q != B43_LOCTL_POISON))
+				goto error;
+		}
 	}
+	if (is_initializing && control->used)
+		goto error;
+
+	return;
+error:
+	bcmerr(dev->wl, "LO control pair validation failed "
+	       "(I: %d, Q: %d, used %u, calib: %u, initing: %d)\n",
+	       i, q, control->used,
+	       b43_loctl_is_calibrated(control),
+	       is_initializing);
 }
+
 static void validate_all_loctls(struct b43_wldev *dev)
 {
 	b43_call_for_each_loctl(dev, do_validate_loctl);
 }
-#else /* B43_DEBUG */
-static inline void validate_all_loctls(struct b43_wldev *dev)
+
+static void do_reset_calib(struct b43_wldev *dev, struct b43_loctl *control)
 {
+	if (dev->phy.lo_control->rebuild ||
+	    control->used) {
+		b43_loctl_set_calibrated(control, 0);
+		control->i = B43_LOCTL_POISON;
+		control->q = B43_LOCTL_POISON;
+	}
 }
+
+static void reset_all_loctl_calibration_states(struct b43_wldev *dev)
+{
+	b43_call_for_each_loctl(dev, do_reset_calib);
+}
+
+#else /* B43_DEBUG */
+static inline void validate_all_loctls(struct b43_wldev *dev) { }
+static inline void reset_all_loctl_calibration_states(struct b43_wldev *dev) { }
 #endif /* B43_DEBUG */
 
 void b43_lo_g_measure(struct b43_wldev *dev)
@@ -1042,6 +1080,7 @@ void b43_lo_g_measure(struct b43_wldev *
 
 	sav.old_channel = phy->channel;
 	lo_measure_setup(dev, &sav);
+	reset_all_loctl_calibration_states(dev);
 	lo_measure(dev);
 	lo_measure_restore(dev, &sav);
 
@@ -1051,10 +1090,33 @@ void b43_lo_g_measure(struct b43_wldev *
 	phy->lo_control->rebuild = 0;
 }
 
-void b43_lo_g_adjust(struct b43_wldev *dev)
+#if B43_DEBUG
+static void validate_loctl_calibration(struct b43_wldev *dev,
+				       struct b43_loctl *loctl,
+				       struct b43_rfatt *rfatt,
+				       struct b43_bbatt *bbatt)
+{
+	if (b43_loctl_is_calibrated(loctl))
+		return;
+	if (!dev->phy.lo_control->lo_measured) {
+		/* On init we set the attenuation values before we
+		 * calibrated the LO. I guess that's OK. */
+		return;
+	}
+	bcmerr(dev->wl, "Adjusting Local Oscillator to an uncalibrated "
+	       "control pair: rfatt=%u,%spadmix bbatt=%u\n",
+	       rfatt->att,
+	       (rfatt->with_padmix) ? "" : "no-",
+	       bbatt->att);
+}
+#else
+static inline void validate_loctl_calibration(struct b43_wldev *dev,
+					      struct b43_loctl *loctl,
+					      struct b43_rfatt *rfatt,
+					      struct b43_bbatt *bbatt)
 {
-	b43_lo_write(dev, b43_lo_g_ctl_current(dev));
 }
+#endif
 
 static inline void fixup_rfatt_for_txcontrol(struct b43_rfatt *rf,
 					     u8 tx_control)
@@ -1065,6 +1127,20 @@ static inline void fixup_rfatt_for_txcon
 	}
 }
 
+void b43_lo_g_adjust(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_rfatt rf;
+	struct b43_loctl *loctl;
+
+	memcpy(&rf, &phy->rfatt, sizeof(rf));
+	fixup_rfatt_for_txcontrol(&rf, phy->tx_control);
+
+	loctl = b43_get_lo_g_ctl(dev, &rf, &phy->bbatt);
+	validate_loctl_calibration(dev, loctl, &rf, &phy->bbatt);
+	b43_lo_write(dev, loctl);
+}
+
 void b43_lo_g_adjust_to(struct b43_wldev *dev,
 			u16 rfatt, u16 bbatt, u16 tx_control)
 {
@@ -1078,20 +1154,10 @@ void b43_lo_g_adjust_to(struct b43_wldev
 	bb.att = bbatt;
 	fixup_rfatt_for_txcontrol(&rf, tx_control);
 	loctl = b43_get_lo_g_ctl(dev, &rf, &bb);
+	validate_loctl_calibration(dev, loctl, &rf, &bb);
 	b43_lo_write(dev, loctl);
 }
 
-struct b43_loctl *b43_lo_g_ctl_current(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_rfatt rf;
-
-	memcpy(&rf, &phy->rfatt, sizeof(rf));
-	fixup_rfatt_for_txcontrol(&rf, phy->tx_control);
-
-	return b43_get_lo_g_ctl(dev, &rf, &phy->bbatt);
-}
-
 static void do_mark_unused(struct b43_wldev *dev, struct b43_loctl *control)
 {
 	control->used = 0;
@@ -1108,5 +1174,11 @@ void b43_lo_g_ctl_mark_all_unused(struct
 
 void b43_lo_g_ctl_mark_cur_used(struct b43_wldev *dev)
 {
-	b43_lo_g_ctl_current(dev)->used = 1;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_rfatt rf;
+
+	memcpy(&rf, &phy->rfatt, sizeof(rf));
+	fixup_rfatt_for_txcontrol(&rf, phy->tx_control);
+
+	b43_get_lo_g_ctl(dev, &rf, &phy->bbatt)->used = 1;
 }
Index: wireless-dev-new/drivers/net/wireless/b43/lo.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/lo.h	2007-08-14 20:09:16.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/lo.h	2007-08-14 20:09:27.000000000 +0200
@@ -11,9 +11,38 @@ struct b43_loctl {
 	s8 i;
 	s8 q;
 	/* "Used by hardware" flag. */
-	u8 used;
+	bool used;
+#ifdef CONFIG_B43_DEBUG
+	/* Is this lo-control-array entry calibrated? */
+	bool calibrated;
+#endif
 };
 
+/* Debugging: Poison value for i and q values. */
+#define B43_LOCTL_POISON	111
+
+/* loctl->calibrated debugging mechanism */
+#ifdef CONFIG_B43_DEBUG
+static inline void b43_loctl_set_calibrated(struct b43_loctl *loctl,
+					    bool calibrated)
+{
+	loctl->calibrated = calibrated;
+}
+static inline bool b43_loctl_is_calibrated(struct b43_loctl *loctl)
+{
+	return loctl->calibrated;
+}
+#else
+static inline void b43_loctl_set_calibrated(struct b43_loctl *loctl,
+					    bool calibrated)
+{
+}
+static inline bool b43_loctl_is_calibrated(struct b43_loctl *loctl)
+{
+	return 1;
+}
+#endif
+
 /* TX Power LO Control Array.
  * Value-pairs to adjust the LocalOscillator are stored
  * in this structure.
@@ -66,10 +95,6 @@ void b43_lo_g_adjust(struct b43_wldev *d
 void b43_lo_g_adjust_to(struct b43_wldev *dev,
 			u16 rfatt, u16 bbatt, u16 tx_control);
 
-/* Returns the b43_lo_g_ctl corresponding to the current
- * attenuation values.
- */
-struct b43_loctl *b43_lo_g_ctl_current(struct b43_wldev *dev);
 /* Mark all possible b43_lo_g_ctl as "unused" */
 void b43_lo_g_ctl_mark_all_unused(struct b43_wldev *dev);
 /* Mark the b43_lo_g_ctl corresponding to the current

-- 

