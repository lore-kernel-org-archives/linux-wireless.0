Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33742 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935763AbdAFPvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 10:51:05 -0500
Received: by mail-wm0-f67.google.com with SMTP id u144so5919735wmu.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2017 07:51:04 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Subject: [RFC] ath9k: move RELAY and DEBUG_FS to ATH9K[_HTC]_DEBUGFS
Date: Fri,  6 Jan 2017 16:48:52 +0100
Message-Id: <20170106154852.22735-1-chunkeey@googlemail.com> (sfid-20170106_165110_531603_DCEDD75B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the common ath9k_common module needs to have a
dependency on RELAY and DEBUG_FS in order to built. This
is usually not a problem. But for RAM and FLASH starved
AR71XX devices, every little bit counts.

This patch adds a new symbol CONFIG_ATH9K_COMMON_DEBUG
which makes it possible to drop the RELAY and DEBUG_FS
dependency there and move it to ATH_(HTC)_DEBUGFS.

Note: The shared FFT/spectral code (which is the only user
of the relayfs in ath9k*) needs DEBUG_FS to export the relayfs
interface to dump the data to userspace. So it makes no sense
to have the functions compiled in, if DEBUG_FS is not there.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Here are some numbers for my WD Range Extender (AR7370 with a AR9300):
For both configurations MAC80211_DEBUGFS and ATH_DEBUG is disabled.
(if they are enabled, there should be no change). All sizes are in
bytes. And I only test with or without the patch applied.

module                 | file size | .text size |
ath9k_common.ko (w/o)  |     32208 |      12832 |
ath9k_common.ko (with) |     12204 |       3456 |

Note: The kernel with the patch, doesn't need RELAY support anymore.
Therefore it shrinks a bit as well.

              | lzma uimage size | .text size |
kernel (w/o)  |          1181777 |    3004592 |
kernel (with) |          1179666 |    2999448 |

If anyone wants to play with it, I made a test-patch For LEDE [0].
Just remember to disable CONFIG_PACKAGE_MAC80211_DEBUGFS and
CONFIG_PACKAGE_ATH_DEBUG.

There are more ways to do this. Let's hear if there's support for
it or not. The main motivation was that relayfs can be very costly
on the RAM as well (on ath10k in can eat like 4MiB with VM 
debugging etc...).

[0] <https://github.com/chunkeey/apm82181-lede/commit/5ef8d4e6497b0b41f0c562650347251e96d73ec8>
---
---
 drivers/net/wireless/ath/ath9k/Kconfig           |  9 ++++++--
 drivers/net/wireless/ath/ath9k/Makefile          |  5 +++--
 drivers/net/wireless/ath/ath9k/common-debug.h    | 27 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-spectral.c |  2 +-
 drivers/net/wireless/ath/ath9k/common-spectral.h | 23 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom_4k.c       |  2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c     |  2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c      |  2 +-
 8 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 8f231c67dd51..783a38f1a626 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -3,8 +3,8 @@ config ATH9K_HW
 config ATH9K_COMMON
 	tristate
 	select ATH_COMMON
-	select DEBUG_FS
-	select RELAY
+config ATH9K_COMMON_DEBUG
+	bool
 config ATH9K_DFS_DEBUGFS
 	def_bool y
 	depends on ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED
@@ -60,12 +60,14 @@ config ATH9K_DEBUGFS
 	bool "Atheros ath9k debugging"
 	depends on ATH9K && DEBUG_FS
 	select MAC80211_DEBUGFS
+	select ATH9K_COMMON_DEBUG
 	select RELAY
 	---help---
 	  Say Y, if you need access to ath9k's statistics for
 	  interrupts, rate control, etc.
 
 	  Also required for changing debug message flags at run time.
+	  As well as access to the FFT/spectral data and TX99.
 
 config ATH9K_STATION_STATISTICS
 	bool "Detailed station statistics"
@@ -174,8 +176,11 @@ config ATH9K_HTC
 config ATH9K_HTC_DEBUGFS
 	bool "Atheros ath9k_htc debugging"
 	depends on ATH9K_HTC && DEBUG_FS
+	select ATH9K_COMMON_DEBUG
+	select RELAY
 	---help---
 	  Say Y, if you need access to ath9k_htc's statistics.
+	  As well as access to the FFT/spectral data.
 
 config ATH9K_HWRNG
 	bool "Random number generator support"
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 76f9dc37500b..36a40ffdce15 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -60,8 +60,9 @@ obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
 ath9k_common-y:=	common.o \
 			common-init.o \
 			common-beacon.o \
-			common-debug.o \
-			common-spectral.o
+
+ath9k_common-$(CONFIG_ATH9K_COMMON_DEBUG) += common-debug.o \
+					     common-spectral.o
 
 ath9k_htc-y +=	htc_hst.o \
 		hif_usb.o \
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 7c9788490f7f..3376990d3a24 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -60,6 +60,7 @@ struct ath_rx_stats {
 	u32 rx_spectral;
 };
 
+#ifdef CONFIG_ATH9K_COMMON_DEBUG
 void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
 				  struct ath_hw *ah);
 void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
@@ -70,3 +71,29 @@ void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
 			  struct ath_rx_stats *rxstats);
 void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
 			     struct ath_rx_stats *rxstats);
+#else
+static inline void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
+						struct ath_hw *ah)
+{
+}
+
+static inline void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
+					       struct ath_hw *ah)
+{
+}
+
+static inline void ath9k_cmn_debug_stat_rx(struct ath_rx_stats *rxstats,
+					   struct ath_rx_status *rs)
+{
+}
+
+static inline void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
+					struct ath_rx_stats *rxstats)
+{
+}
+
+static inline void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
+					   struct ath_rx_stats *rxstats)
+{
+}
+#endif /* CONFIG_ATH9K_COMMON_DEBUG */
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index eedf86b67cf5..789a3dbe8341 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -1075,7 +1075,7 @@ static struct rchan_callbacks rfs_spec_scan_cb = {
 
 void ath9k_cmn_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv)
 {
-	if (IS_ENABLED(CONFIG_ATH9K_DEBUGFS) && spec_priv->rfs_chan_spec_scan) {
+	if (spec_priv->rfs_chan_spec_scan) {
 		relay_close(spec_priv->rfs_chan_spec_scan);
 		spec_priv->rfs_chan_spec_scan = NULL;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
index 998743be9c67..5d1a51d83aa6 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.h
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -151,6 +151,7 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
 	return bins[0] & 0x3f;
 }
 
+#ifdef CONFIG_ATH9K_COMMON_DEBUG
 void ath9k_cmn_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy);
 void ath9k_cmn_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv);
 
@@ -161,5 +162,27 @@ int ath9k_cmn_spectral_scan_config(struct ath_common *common,
 			       enum spectral_mode spectral_mode);
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
 		    struct ath_rx_status *rs, u64 tsf);
+#else
+static inline void ath9k_cmn_spectral_init_debug(struct ath_spec_scan_priv *spec_priv,
+						 struct dentry *debugfs_phy)
+{
+}
+
+static inline void ath9k_cmn_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv)
+{
+}
+
+static inline void ath9k_cmn_spectral_scan_trigger(struct ath_common *common,
+						   struct ath_spec_scan_priv *spec_priv)
+{
+}
+
+static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
+				      struct ieee80211_hdr *hdr,
+				      struct ath_rx_status *rs, u64 tsf)
+{
+	return 0;
+}
+#endif /* CONFIG_ATH9K_COMMON_DEBUG */
 
 #endif /* SPECTRAL_H */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 4a01ebe53053..b8c0a08066a0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -72,7 +72,7 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_4k_fill_eeprom(ah);
 }
 
-#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
+#ifdef CONFIG_ATH9K_COMMON_DEBUG
 static u32 ath9k_dump_4k_modal_eeprom(char *buf, u32 len, u32 size,
 				      struct modal_eep_4k_header *modal_hdr)
 {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 9611f020f7c0..3caa149b1013 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -75,7 +75,7 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_ar9287_fill_eeprom(ah);
 }
 
-#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
+#ifdef CONFIG_ATH9K_COMMON_DEBUG
 static u32 ar9287_dump_modal_eeprom(char *buf, u32 len, u32 size,
 				    struct modal_eep_ar9287_header *modal_hdr)
 {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 7d5223451ce9..56b44fc7a8e6 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -131,7 +131,7 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_def_fill_eeprom(ah);
 }
 
-#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
+#ifdef CONFIG_ATH9K_COMMON_DEBUG
 static u32 ath9k_def_dump_modal_eeprom(char *buf, u32 len, u32 size,
 				       struct modal_eep_header *modal_hdr)
 {
-- 
2.11.0
