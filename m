Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:40943 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZBXKQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 05:16:46 -0500
Received: by rv-out-0506.google.com with SMTP id g37so2414056rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 02:16:44 -0800 (PST)
Message-ID: <49A3C90A.2000608@gmail.com> (sfid-20090224_111652_424792_778EA20C)
Date: Tue, 24 Feb 2009 02:16:42 -0800
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: mb@bu3sch.de, stefano.brivio@polimi.it
Subject: b43: checkpatch.pl cleanups
Content-Type: multipart/mixed;
 boundary="------------090702040202040105070400"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090702040202040105070400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Keeping this one simple.  

Changing a few "foo * bar" to "foo *bar"

Removes 22 checkpatch.pl errors, with no introduced warnings.

John

Signed-off-by: John Daiker <daikerjohn@gmail.com>
---



--------------090702040202040105070400
Content-Type: text/x-diff;
 name="b43.checkpatch.cleanup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="b43.checkpatch.cleanup.diff"

diff --git a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/b43/debugfs.c
index e04fc91..08781b6 100644
--- a/drivers/net/wireless/b43/debugfs.c
+++ b/drivers/net/wireless/b43/debugfs.c
@@ -51,8 +51,8 @@ struct b43_debugfs_fops {
 };
 
 static inline
-struct b43_dfs_file * fops_to_dfs_file(struct b43_wldev *dev,
-				       const struct b43_debugfs_fops *dfops)
+struct b43_dfs_file *fops_to_dfs_file(struct b43_wldev *dev,
+				      const struct b43_debugfs_fops *dfops)
 {
 	void *p;
 
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 6d65a02..7d80cec 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1254,8 +1254,8 @@ static inline int should_inject_overflow(struct b43_dmaring *ring)
 }
 
 /* Static mapping of mac80211's queues (priorities) to b43 DMA rings. */
-static struct b43_dmaring * select_ring_by_priority(struct b43_wldev *dev,
-						    u8 queue_prio)
+static struct b43_dmaring *select_ring_by_priority(struct b43_wldev *dev,
+						   u8 queue_prio)
 {
 	struct b43_dmaring *ring;
 
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 6a18a14..325e4ad 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -36,8 +36,8 @@
 #include <linux/sched.h>
 
 
-static struct b43_lo_calib * b43_find_lo_calib(struct b43_txpower_lo_control *lo,
-					       const struct b43_bbatt *bbatt,
+static struct b43_lo_calib *b43_find_lo_calib(struct b43_txpower_lo_control *lo,
+					      const struct b43_bbatt *bbatt,
 					       const struct b43_rfatt *rfatt)
 {
 	struct b43_lo_calib *c;
@@ -138,7 +138,7 @@ static u16 lo_measure_feedthrough(struct b43_wldev *dev,
  * "pad_mix_gain" is the PAD Mixer Gain.
  */
 static u16 lo_txctl_register_table(struct b43_wldev *dev,
-				   u16 * value, u16 * pad_mix_gain)
+				   u16 *value, u16 *pad_mix_gain)
 {
 	struct b43_phy *phy = &dev->phy;
 	u16 reg, v, padmix;
@@ -754,9 +754,9 @@ static void lo_probe_loctls_statemachine(struct b43_wldev *dev,
 }
 
 static
-struct b43_lo_calib * b43_calibrate_lo_setting(struct b43_wldev *dev,
-					       const struct b43_bbatt *bbatt,
-					       const struct b43_rfatt *rfatt)
+struct b43_lo_calib *b43_calibrate_lo_setting(struct b43_wldev *dev,
+					      const struct b43_bbatt *bbatt,
+					      const struct b43_rfatt *rfatt)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
@@ -824,9 +824,9 @@ struct b43_lo_calib * b43_calibrate_lo_setting(struct b43_wldev *dev,
 /* Get a calibrated LO setting for the given attenuation values.
  * Might return a NULL pointer under OOM! */
 static
-struct b43_lo_calib * b43_get_calib_lo_settings(struct b43_wldev *dev,
-						const struct b43_bbatt *bbatt,
-						const struct b43_rfatt *rfatt)
+struct b43_lo_calib *b43_get_calib_lo_settings(struct b43_wldev *dev,
+					       const struct b43_bbatt *bbatt,
+					       const struct b43_rfatt *rfatt)
 {
 	struct b43_txpower_lo_control *lo = dev->phy.g->lo_control;
 	struct b43_lo_calib *c;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c788bad..8bf49a5 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -500,7 +500,7 @@ void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
 }
 
 /* Read HostFlags */
-u64 b43_hf_read(struct b43_wldev * dev)
+u64 b43_hf_read(struct b43_wldev *dev)
 {
 	u64 ret;
 
@@ -526,7 +526,7 @@ void b43_hf_write(struct b43_wldev *dev, u64 value)
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFHI, hi);
 }
 
-void b43_tsf_read(struct b43_wldev *dev, u64 * tsf)
+void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 {
 	/* We need to be careful. As we read the TSF from multiple
 	 * registers, we should take care of register overflows.
@@ -637,7 +637,7 @@ void b43_tsf_write(struct b43_wldev *dev, u64 tsf)
 }
 
 static
-void b43_macfilter_set(struct b43_wldev *dev, u16 offset, const u8 * mac)
+void b43_macfilter_set(struct b43_wldev *dev, u16 offset, const u8 *mac)
 {
 	static const u8 zero_addr[ETH_ALEN] = { 0 };
 	u16 data;
@@ -827,7 +827,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 }
 
 static void key_write(struct b43_wldev *dev,
-		      u8 index, u8 algorithm, const u8 * key)
+		      u8 index, u8 algorithm, const u8 *key)
 {
 	unsigned int i;
 	u32 offset;
@@ -849,7 +849,7 @@ static void key_write(struct b43_wldev *dev,
 	}
 }
 
-static void keymac_write(struct b43_wldev *dev, u8 index, const u8 * addr)
+static void keymac_write(struct b43_wldev *dev, u8 index, const u8 *addr)
 {
 	u32 addrtmp[2] = { 0, 0, };
 	u8 per_sta_keys_start = 8;
@@ -899,7 +899,7 @@ static void keymac_write(struct b43_wldev *dev, u8 index, const u8 * addr)
 
 static void do_key_write(struct b43_wldev *dev,
 			 u8 index, u8 algorithm,
-			 const u8 * key, size_t key_len, const u8 * mac_addr)
+			 const u8 *key, size_t key_len, const u8 *mac_addr)
 {
 	u8 buf[B43_SEC_KEYSIZE] = { 0, };
 	u8 per_sta_keys_start = 8;
@@ -923,8 +923,8 @@ static void do_key_write(struct b43_wldev *dev,
 
 static int b43_key_write(struct b43_wldev *dev,
 			 int index, u8 algorithm,
-			 const u8 * key, size_t key_len,
-			 const u8 * mac_addr,
+			 const u8 *key, size_t key_len,
+			 const u8 *mac_addr,
 			 struct ieee80211_key_conf *keyconf)
 {
 	int i;
@@ -1324,7 +1324,7 @@ static void handle_irq_pmq(struct b43_wldev *dev)
 }
 
 static void b43_write_template_common(struct b43_wldev *dev,
-				      const u8 * data, u16 size,
+				      const u8 *data, u16 size,
 				      u16 ram_offset,
 				      u16 shm_size_offset, u8 rate)
 {
@@ -1514,9 +1514,9 @@ static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
  * 2) Patching duration field
  * 3) Stripping TIM
  */
-static const u8 * b43_generate_probe_resp(struct b43_wldev *dev,
-					  u16 *dest_size,
-					  struct ieee80211_rate *rate)
+static const u8 *b43_generate_probe_resp(struct b43_wldev *dev,
+					 u16 *dest_size,
+					 struct ieee80211_rate *rate)
 {
 	const u8 *src_data;
 	u8 *dest_data;
@@ -2946,7 +2946,7 @@ static void b43_security_init(struct b43_wldev *dev)
 	b43_clear_keys(dev);
 }
 
-static int b43_rng_read(struct hwrng *rng, u32 * data)
+static int b43_rng_read(struct hwrng *rng, u32 *data)
 {
 	struct b43_wl *wl = (struct b43_wl *)rng->priv;
 	unsigned long flags;
@@ -3240,7 +3240,7 @@ static void b43_put_phy_into_reset(struct b43_wldev *dev)
 	msleep(1);
 }
 
-static const char * band_to_string(enum ieee80211_band band)
+static const char *band_to_string(enum ieee80211_band band)
 {
 	switch (band) {
 	case IEEE80211_BAND_5GHZ:
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index caac4a4..f1cde96 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -823,7 +823,7 @@ static void b43_calc_nrssi_threshold(struct b43_wldev *dev)
  * interference mitigation code.
  * It is save to restore values in random order.
  */
-static void _stack_save(u32 * _stackptr, size_t * stackidx,
+static void _stack_save(u32 *_stackptr, size_t *stackidx,
 			u8 id, u16 offset, u16 value)
 {
 	u32 *stackptr = &(_stackptr[*stackidx]);
@@ -837,7 +837,7 @@ static void _stack_save(u32 * _stackptr, size_t * stackidx,
 	B43_WARN_ON(*stackidx >= B43_INTERFSTACK_SIZE);
 }
 
-static u16 _stack_restore(u32 * stackptr, u8 id, u16 offset)
+static u16 _stack_restore(u32 *stackptr, u8 id, u16 offset)
 {
 	size_t i;
 
@@ -2565,8 +2565,8 @@ static s8 b43_tssi2dbm_entry(s8 entry[], u8 index,
 	return 0;
 }
 
-u8 * b43_generate_dyn_tssi2dbm_tab(struct b43_wldev *dev,
-				   s16 pab0, s16 pab1, s16 pab2)
+u8 *b43_generate_dyn_tssi2dbm_tab(struct b43_wldev *dev,
+				  s16 pab0, s16 pab1, s16 pab2)
 {
 	unsigned int i;
 	u8 *tab;
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 1036bef..8cd9776 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -55,8 +55,8 @@ static u16 generate_cookie(struct b43_pio_txqueue *q,
 }
 
 static
-struct b43_pio_txqueue * parse_cookie(struct b43_wldev *dev,
-				      u16 cookie,
+struct b43_pio_txqueue *parse_cookie(struct b43_wldev *dev,
+				     u16 cookie,
 				      struct b43_pio_txpacket **pack)
 {
 	struct b43_pio *pio = &dev->pio;
@@ -134,8 +134,8 @@ static u16 pio_rxqueue_offset(struct b43_wldev *dev)
 	return 8;
 }
 
-static struct b43_pio_txqueue * b43_setup_pioqueue_tx(struct b43_wldev *dev,
-						      unsigned int index)
+static struct b43_pio_txqueue *b43_setup_pioqueue_tx(struct b43_wldev *dev,
+						     unsigned int index)
 {
 	struct b43_pio_txqueue *q;
 	struct b43_pio_txpacket *p;
@@ -171,8 +171,8 @@ static struct b43_pio_txqueue * b43_setup_pioqueue_tx(struct b43_wldev *dev,
 	return q;
 }
 
-static struct b43_pio_rxqueue * b43_setup_pioqueue_rx(struct b43_wldev *dev,
-						      unsigned int index)
+static struct b43_pio_rxqueue *b43_setup_pioqueue_rx(struct b43_wldev *dev,
+						     unsigned int index)
 {
 	struct b43_pio_rxqueue *q;
 
@@ -308,8 +308,8 @@ err_destroy_bk:
 }
 
 /* Static mapping of mac80211's queues (priorities) to b43 PIO queues. */
-static struct b43_pio_txqueue * select_queue_by_priority(struct b43_wldev *dev,
-							 u8 queue_prio)
+static struct b43_pio_txqueue *select_queue_by_priority(struct b43_wldev *dev,
+							u8 queue_prio)
 {
 	struct b43_pio_txqueue *q;
 
diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 7137537..afad423 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -113,7 +113,7 @@ out_unlock:
 	return err;
 }
 
-char * b43_rfkill_led_name(struct b43_wldev *dev)
+char *b43_rfkill_led_name(struct b43_wldev *dev)
 {
 	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 

--------------090702040202040105070400--
