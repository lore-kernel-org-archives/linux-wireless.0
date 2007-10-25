Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37241 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbXJYJXQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:23:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 30/30] iwlwifi: cleanup Kconfig and ifdefs to split 3945 and 4965
Date: Thu, 25 Oct 2007 17:15:51 +0800
Message-Id: <11933037992954-git-send-email-yi.zhu@intel.com> (sfid-20071025_102333_719335_3DB48318)
In-Reply-To: <11933037931724-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
 <11933037784073-git-send-email-yi.zhu@intel.com>
 <11933037794199-git-send-email-yi.zhu@intel.com>
 <11933037812209-git-send-email-yi.zhu@intel.com>
 <11933037822284-git-send-email-yi.zhu@intel.com>
 <11933037831480-git-send-email-yi.zhu@intel.com>
 <11933037851697-git-send-email-yi.zhu@intel.com>
 <11933037863641-git-send-email-yi.zhu@intel.com>
 <11933037881944-git-send-email-yi.zhu@intel.com>
 <11933037893348-git-send-email-yi.zhu@intel.com>
 <11933037903508-git-send-email-yi.zhu@intel.com>
 <11933037922031-git-send-email-yi.zhu@intel.com>
 <11933037931724-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christoph Hellwig <hch@lst.de>

Currently the iwl3945 & iwl4965 drivers share some common Kconfig
symbols.  This split it up into options for the individual drivers
and gets rid of all the CONFIG_IWLWIFI cruft.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/Makefile                 |    3 +-
 drivers/net/wireless/iwlwifi/Kconfig          |  169 +++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945-io.h    |   34 +++---
 drivers/net/wireless/iwlwifi/iwl-3945.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h       |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-4965-debug.h |    6 +-
 drivers/net/wireless/iwlwifi/iwl-4965-io.h    |   34 +++---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c    |   38 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.c       |   90 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-4965.h       |   60 +++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |   72 ++++++------
 drivers/net/wireless/iwlwifi/iwl4965-base.c   |  168 ++++++++++++------------
 13 files changed, 367 insertions(+), 335 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 8d4c366..5f0d31f 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -55,7 +55,8 @@ obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
 obj-$(CONFIG_ADM8211)	+= adm8211.o
 
-obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
+obj-$(CONFIG_IWL3945)	+= iwlwifi/
+obj-$(CONFIG_IWL4965)	+= iwlwifi/
 
 obj-$(CONFIG_RT2X00)		+= rt2x00/
 
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 25cfc6c..c12120d 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,107 +1,95 @@
-config IWLWIFI
-	bool "Intel Wireless WiFi Link Drivers"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+config IWL4965
+	tristate "Intel Wireless WiFi 4965AGN"
+	depends on m && PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
-	default n
-	---help---
-	  Select to enable drivers based on the iwlwifi project.  This
-	  project provides a common foundation for Intel's wireless
-	  drivers designed to use the mac80211 subsystem.
-
-	  See <file:Documentation/networking/README.iwlwifi> for
-	  information on the capabilities currently enabled in this
-	  driver and for tips for debugging issues and problems.
-
-config IWLWIFI_DEBUG
-	bool "Enable full debugging output in iwlwifi drivers"
-	depends on IWLWIFI
-	default y
+	default m
 	---help---
-	  This option will enable debug tracing output for the iwlwifi
-	  drivers.
+	  Select to build the driver supporting the:
 
-	  This will result in the kernel module being ~100k larger.  You can
-	  control which debug output is sent to the kernel log by setting the
-	  value in
+	  Intel Wireless WiFi Link 4965AGN
 
-	          /sys/bus/pci/drivers/${DRIVER}/debug_level
+	  This driver uses the kernel's mac80211 subsystem.
 
-	  This entry will only exist if this option is enabled.
+	  See <file:Documentation/networking/README.iwlwifi> for
+	  information on the capabilities currently enabled in this
+	  driver and for tips for debugging any issues or problems.
 
-	  To set a value, simply echo an 8-byte hex value to the same file:
+	  In order to use this driver, you will need a microcode (uCode)
+	  image for it. You can obtain the microcode from:
 
-		  % echo 0x43fff > /sys/bus/pci/drivers/${DRIVER}/debug_level
+	          <http://intellinuxwireless.org/>.
 
-	  You can find the list of debug mask values in:
-		  drivers/net/wireless/mac80211/iwlwifi/iwl-debug.h
+	  See the above referenced README.iwlwifi for information on where
+	  to install the microcode images.
 
-	  If this is your first time using this driver, you should say Y here
-	  as the debug information can assist others in helping you resolve
-	  any problems you may encounter.
+	  If you want to compile the driver as a module ( = code which can be
+	  inserted in and remvoed from the running kernel whenever you want),
+	  say M here and read <file:Documentation/modules.txt>.  The module
+	  will be called iwl4965.ko.
 
-config IWLWIFI_SENSITIVITY
-	bool "Enable Sensitivity Calibration in iwlwifi drivers"
-	depends on IWLWIFI
+config IWL4965_QOS
+	bool "Enable Wireless QoS in iwl4965 driver"
+	depends on IWL4965
 	default y
 	---help---
-	  This option will enable sensitivity calibration for the iwlwifi
-	  drivers.
+	  This option will enable wireless quality of service (QoS) for the
+	  iw4965 driver.
 
-config IWLWIFI_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iwlwifi drivers"
-	depends on IWLWIFI
+config IWL4965_SPECTRUM_MEASUREMENT
+	bool "Enable Spectrum Measurement in iw4965 driver"
+	depends on IWL4965
 	default y
 	---help---
-	  This option will enable spectrum measurement for the iwlwifi drivers.
+	  This option will enable spectrum measurement for the iwl4965 driver.
 
-config IWLWIFI_QOS
-	bool "Enable Wireless QoS in iwlwifi drivers"
-	depends on IWLWIFI
+config IWL4965_SENSITIVITY
+	bool "Enable Sensitivity Calibration in iwl4965 driver"
+	depends on IWL4965
 	default y
 	---help---
-	  This option will enable wireless quality of service (QoS) for the
-	  iwlwifi drivers.
+	  This option will enable sensitivity calibration for the iwl4965
+	  driver.
 
-config IWLWIFI_HT
-	bool "Enable 802.11n HT features in iwlwifi drivers"
+config IWL4965_HT
+	bool "Enable 802.11n HT features in iwl4965 driver"
 	depends on EXPERIMENTAL
-	depends on IWLWIFI && MAC80211_HT
+	depends on IWL4965 && MAC80211_HT
 	default n
 	---help---
 	  This option enables IEEE 802.11n High Throughput features
-	  for the iwlwifi drivers.
+	  for the iwl4965 driver.
 
-config IWL4965
-	tristate "Intel Wireless WiFi 4965AGN"
-	depends on m && IWLWIFI && EXPERIMENTAL
-	default m
+config IWL4965_DEBUG
+	bool "Enable full debugging output in iwl4965 driver"
+	depends on IWL4965
+	default y
 	---help---
-	  Select to build the driver supporting the:
+	  This option will enable debug tracing output for the iwl4965
+	  driver.
 
-	  Intel Wireless WiFi Link 4965AGN
+	  This will result in the kernel module being ~100k larger.  You can
+	  control which debug output is sent to the kernel log by setting the
+	  value in
 
-	  This driver uses the kernel's mac80211 subsystem.
+	          /sys/bus/pci/drivers/${DRIVER}/debug_level
 
-	  See <file:Documentation/networking/README.iwlwifi> for
-	  information on the capabilities currently enabled in this
-	  driver and for tips for debugging any issues or problems.
+	  This entry will only exist if this option is enabled.
 
-	  In order to use this driver, you will need a microcode (uCode)
-	  image for it. You can obtain the microcode from:
+	  To set a value, simply echo an 8-byte hex value to the same file:
 
-	          <http://intellinuxwireless.org/>.
+		  % echo 0x43fff > /sys/bus/pci/drivers/${DRIVER}/debug_level
 
-	  See the above referenced README.iwlwifi for information on where
-	  to install the microcode images.
+	  You can find the list of debug mask values in:
+		  drivers/net/wireless/iwlwifi/iwl-4965-debug.h
 
-	  If you want to compile the driver as a module ( = code which can be
-	  inserted in and remvoed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called iwl4965.ko.
+	  If this is your first time using this driver, you should say Y here
+	  as the debug information can assist others in helping you resolve
+	  any problems you may encounter.
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
-	depends on m && IWLWIFI && EXPERIMENTAL
+	depends on m && PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select FW_LOADER
 	default m
 	---help---
 	  Select to build the driver supporting the:
@@ -126,3 +114,46 @@ config IWL3945
 	  inserted in and remvoed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/modules.txt>.  The module
 	  will be called iwl3945.ko.
+
+config IWL3945_QOS
+	bool "Enable Wireless QoS in iwl3945 driver"
+	depends on IWL3945
+	default y
+	---help---
+	  This option will enable wireless quality of service (QoS) for the
+	  iwl3945 driver.
+
+config IWL3945_SPECTRUM_MEASUREMENT
+	bool "Enable Spectrum Measurement in iwl3945 drivers"
+	depends on IWL3945
+	default y
+	---help---
+	  This option will enable spectrum measurement for the iwl3945 driver.
+
+config IWL3945_DEBUG
+	bool "Enable full debugging output in iwl3945 driver"
+	depends on IWL3945
+	default y
+	---help---
+	  This option will enable debug tracing output for the iwl3945
+	  driver.
+
+	  This will result in the kernel module being ~100k larger.  You can
+	  control which debug output is sent to the kernel log by setting the
+	  value in
+
+	          /sys/bus/pci/drivers/${DRIVER}/debug_level
+
+	  This entry will only exist if this option is enabled.
+
+	  To set a value, simply echo an 8-byte hex value to the same file:
+
+		  % echo 0x43fff > /sys/bus/pci/drivers/${DRIVER}/debug_level
+
+	  You can find the list of debug mask values in:
+		  drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+
+	  If this is your first time using this driver, you should say Y here
+	  as the debug information can assist others in helping you resolve
+	  any problems you may encounter.
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
index 72318d7..d0ea834 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
@@ -29,7 +29,7 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 extern u32 iwl_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (iwl_debug_level & (level)) \
@@ -47,7 +47,7 @@ static inline void IWL_DEBUG(int level, const char *fmt, ...)
 static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 {
 }
-#endif				/* CONFIG_IWLWIFI_DEBUG */
+#endif				/* CONFIG_IWL3945_DEBUG */
 
 /*
  * To use the debug system;
@@ -71,7 +71,7 @@ static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
  * you simply need to add your entry to the iwl_debug_levels array.
  *
  * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
+ * CONFIG_IWL3945_DEBUG defined in your kernel configuration
  *
  */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 89253e1..74a5179 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -60,7 +60,7 @@
  */
 
 #define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
 				 u32 ofs, u32 val)
 {
@@ -74,7 +74,7 @@ static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
 #endif
 
 #define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
@@ -99,7 +99,7 @@ static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 
 	return -ETIMEDOUT;
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl_poll_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
@@ -125,7 +125,7 @@ static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_set_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -142,7 +142,7 @@ static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_clear_bit(const char *f, u32 l,
 				   struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -160,7 +160,7 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 	int ret;
 	u32 gp_ctl;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
 #endif
@@ -191,13 +191,13 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 		return -EIO;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	atomic_inc(&priv->restrict_refcnt);
 #endif
 	return 0;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl_grab_nic_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
@@ -217,13 +217,13 @@ static inline int __iwl_grab_nic_access(const char *f, u32 l,
 
 static inline void _iwl_release_nic_access(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
 #endif
 		_iwl_clear_bit(priv, CSR_GP_CNTRL,
 			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_release_nic_access(const char *f, u32 l,
 					    struct iwl_priv *priv)
 {
@@ -244,7 +244,7 @@ static inline u32 _iwl_read_direct32(struct iwl_priv *priv, u32 reg)
 {
 	return _iwl_read32(priv, reg);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl_read_direct32(const char *f, u32 l,
 					struct iwl_priv *priv, u32 reg)
 {
@@ -266,7 +266,7 @@ static inline void _iwl_write_direct32(struct iwl_priv *priv,
 {
 	_iwl_write32(priv, reg, value);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static void __iwl_write_direct32(u32 line,
 				   struct iwl_priv *priv, u32 reg, u32 value)
 {
@@ -306,7 +306,7 @@ static inline int _iwl_poll_direct_bit(struct iwl_priv *priv,
 	return -ETIMEDOUT;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl_poll_direct_bit(const char *f, u32 l,
 					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
@@ -332,7 +332,7 @@ static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -353,7 +353,7 @@ static inline void _iwl_write_prph(struct iwl_priv *priv,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
 					      u32 addr, u32 val)
 {
@@ -370,7 +370,7 @@ static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
 
 #define _iwl_set_bits_prph(priv, reg, mask) \
 	_iwl_write_prph(priv, reg, (_iwl_read_prph(priv, reg) | mask))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
 					u32 reg, u32 mask)
 {
@@ -388,7 +388,7 @@ static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
 #define _iwl_set_bits_mask_prph(priv, reg, bits, mask) \
 	_iwl_write_prph(priv, reg, ((_iwl_read_prph(priv, reg) & mask) | bits))
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_set_bits_mask_prph(u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ce7ceb7..4e05844 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -369,7 +369,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 
 	network_packet = iwl_is_network_packet(priv, header);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & IWL_DL_STATS && net_ratelimit())
 		IWL_DEBUG_STATS
 		    ("[%c] %d RSSI: %d Signal: %u, Noise: %u, Rate: %u\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ab84122..d1616bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -445,7 +445,7 @@ union iwl_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL3945_HT
 #define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
 #define HT_IE_MAX_AMSDU_SIZE_4K     (0)
 #define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
@@ -468,9 +468,9 @@ struct sta_ht_info {
 	u8 tx_chan_width;
 	u8 chan_width_cap;
 };
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL3945_HT */
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 
 union iwl_qos_capabity {
 	struct {
@@ -499,7 +499,7 @@ struct iwl_qos_info {
 	union iwl_qos_capabity qos_cap;
 	struct iwl_qosparam_cmd def_qos_parm;
 };
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL3945_QOS */
 
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
@@ -598,7 +598,7 @@ extern int iwl_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl_power_init_handle(struct iwl_priv *priv);
 extern int iwl_eeprom_init(struct iwl_priv *priv);
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 extern void iwl_report_frame(struct iwl_priv *priv,
 			     struct iwl_rx_packet *pkt,
 			     struct ieee80211_hdr *header, int group100);
@@ -717,7 +717,7 @@ extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
 
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 enum {
 	MEASUREMENT_READY = (1 << 0),
@@ -745,7 +745,7 @@ struct iwl_priv {
 
 	const struct ieee80211_hw_mode *modes;
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
@@ -904,9 +904,9 @@ struct iwl_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	struct iwl_qos_info qos_data;
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL3945_QOS */
 
 	struct workqueue_struct *workqueue;
 
@@ -941,7 +941,7 @@ struct iwl_priv {
 	u32 pm_state[16];
 #endif
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	/* debugging info */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h b/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
index 72318d7..0c74883 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
@@ -29,7 +29,7 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 extern u32 iwl_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (iwl_debug_level & (level)) \
@@ -47,7 +47,7 @@ static inline void IWL_DEBUG(int level, const char *fmt, ...)
 static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 {
 }
-#endif				/* CONFIG_IWLWIFI_DEBUG */
+#endif				/* CONFIG_IWL4965_DEBUG */
 
 /*
  * To use the debug system;
@@ -71,7 +71,7 @@ static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
  * you simply need to add your entry to the iwl_debug_levels array.
  *
  * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
+ * CONFIG_IWL4965_DEBUG defined in your kernel configuration
  *
  */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-io.h b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
index 1ffa8f1..5c497e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-io.h
@@ -60,7 +60,7 @@
  */
 
 #define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
 				 u32 ofs, u32 val)
 {
@@ -74,7 +74,7 @@ static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
 #endif
 
 #define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
@@ -99,7 +99,7 @@ static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 
 	return -ETIMEDOUT;
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline int __iwl_poll_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
@@ -125,7 +125,7 @@ static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_set_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -142,7 +142,7 @@ static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_clear_bit(const char *f, u32 l,
 				   struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -160,7 +160,7 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 	int ret;
 	u32 gp_ctl;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
 #endif
@@ -191,13 +191,13 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 		return -EIO;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	atomic_inc(&priv->restrict_refcnt);
 #endif
 	return 0;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline int __iwl_grab_nic_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
@@ -217,13 +217,13 @@ static inline int __iwl_grab_nic_access(const char *f, u32 l,
 
 static inline void _iwl_release_nic_access(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
 #endif
 		_iwl_clear_bit(priv, CSR_GP_CNTRL,
 			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_release_nic_access(const char *f, u32 l,
 					    struct iwl_priv *priv)
 {
@@ -244,7 +244,7 @@ static inline u32 _iwl_read_direct32(struct iwl_priv *priv, u32 reg)
 {
 	return _iwl_read32(priv, reg);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline u32 __iwl_read_direct32(const char *f, u32 l,
 					struct iwl_priv *priv, u32 reg)
 {
@@ -266,7 +266,7 @@ static inline void _iwl_write_direct32(struct iwl_priv *priv,
 {
 	_iwl_write32(priv, reg, value);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static void __iwl_write_direct32(u32 line,
 				   struct iwl_priv *priv, u32 reg, u32 value)
 {
@@ -306,7 +306,7 @@ static inline int _iwl_poll_direct_bit(struct iwl_priv *priv,
 	return -ETIMEDOUT;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline int __iwl_poll_direct_bit(const char *f, u32 l,
 					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
@@ -332,7 +332,7 @@ static inline u32 _iwl_read_prph(struct iwl_priv *priv, u32 reg)
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	return _iwl_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline u32 __iwl_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -353,7 +353,7 @@ static inline void _iwl_write_prph(struct iwl_priv *priv,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
 	_iwl_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
 					      u32 addr, u32 val)
 {
@@ -370,7 +370,7 @@ static inline void __iwl_write_prph(u32 line, struct iwl_priv *priv,
 
 #define _iwl_set_bits_prph(priv, reg, mask) \
 	_iwl_write_prph(priv, reg, (_iwl_read_prph(priv, reg) | mask))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
 					u32 reg, u32 mask)
 {
@@ -388,7 +388,7 @@ static inline void __iwl_set_bits_prph(u32 line, struct iwl_priv *priv,
 #define _iwl_set_bits_mask_prph(priv, reg, bits, mask) \
 	_iwl_write_prph(priv, reg, ((_iwl_read_prph(priv, reg) & mask) | bits))
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_set_bits_mask_prph(u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 9d5712e..ecf8569 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -197,7 +197,7 @@ static inline u8 iwl_rate_get_rate(u32 rate_n_flags)
 static int rs_send_lq_cmd(struct iwl_priv *priv,
 			  struct iwl_link_quality_cmd *lq, u8 flags)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	int i;
 #endif
 	struct iwl_host_cmd cmd = {
@@ -218,7 +218,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 	IWL_DEBUG_RATE("lq dta 0x%X 0x%X\n",
 		       lq->general_params.single_stream_ant_msk,
 		       lq->general_params.dual_stream_ant_msk);
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		IWL_DEBUG_RATE("lq index %d 0x%X\n",
 				i, lq->rs_table[i].rate_n_flags);
@@ -442,13 +442,13 @@ static inline void rs_toggle_antenna(struct iwl_rate *new_rate,
 
 static inline u8 rs_use_green(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
 		return 0;
 
 	return ((priv->current_assoc_ht.is_green_field) &&
 	    !(priv->current_assoc_ht.operating_mode & 0x4));
-#endif	/*CONFIG_IWLWIFI_HT */
+#endif	/*CONFIG_IWL4965_HT */
 	return 0;
 }
 
@@ -826,7 +826,7 @@ static void rs_get_expected_tpt_table(struct iwl_rate_scale_priv *lq_data,
 		tbl->expected_tpt = expected_tpt_G;
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 static s32 rs_get_best_rate(struct iwl_priv *priv,
 			    struct iwl_rate_scale_priv *lq_data,
 			    struct iwl_scale_tbl_info *tbl,
@@ -879,7 +879,7 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 
 	return new_rate;
 }
-#endif				/* CONFIG_IWLWIFI_HT */
+#endif				/* CONFIG_IWL4965_HT */
 
 static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
 {
@@ -890,7 +890,7 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 			     struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
 	s32 rate;
 	s8 is_green = lq_data->is_green;
@@ -938,7 +938,7 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate.rate_n_flags, is_green);
 
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 	return 0;
 }
 
@@ -946,7 +946,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 			     struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
 	u8 is_green = lq_data->is_green;
 	s32 rate;
@@ -992,7 +992,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate.rate_n_flags, is_green);
 
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 	return 0;
 }
 
@@ -1568,7 +1568,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
 
 		if (is_legacy(tbl1->lq_type) &&
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 		    !priv->current_assoc_ht.is_ht &&
 #endif
 		    (lq_data->action_counter >= 1)) {
@@ -1579,14 +1579,14 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 		if (lq_data->enable_counter &&
 		    (lq_data->action_counter >= IWL_ACTION_LIMIT)) {
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 			if ((lq_data->last_tpt > TID_AGG_TPT_THREHOLD) &&
 			    (priv->lq_mngr.agg_ctrl.auto_agg)) {
 				priv->lq_mngr.agg_ctrl.tid_retry =
 				    TID_ALL_SPECIFIED;
 				schedule_work(&priv->agg_work);
 			}
-#endif /*CONFIG_IWLWIFI_HT_AGG */
+#endif /*CONFIG_IWL4965_HT_AGG */
 			lq_data->action_counter = 0;
 			rs_set_stay_in_table(0, lq_data);
 		}
@@ -1829,7 +1829,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	crl->active_rate &= ~(0x1000);
 	crl->active_rate_basic = priv->active_rate_basic;
 	crl->phymode = priv->phymode;
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	crl->active_siso_rate = (priv->current_assoc_ht.supp_rates[0] << 1);
 	crl->active_siso_rate |= (priv->current_assoc_ht.supp_rates[0] & 0x1);
 	crl->active_siso_rate &= ~((u16)0x2);
@@ -1841,7 +1841,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	crl->active_mimo_rate = crl->active_mimo_rate << IWL_FIRST_OFDM_RATE;
 	IWL_DEBUG_HT("MIMO RATE 0x%X SISO MASK 0x%X\n", crl->active_siso_rate,
 		     crl->active_mimo_rate);
-#endif /*CONFIG_IWLWIFI_HT*/
+#endif /*CONFIG_IWL4965_HT*/
 #ifdef CONFIG_MAC80211_DEBUGFS
 	crl->drv = priv;
 #endif
@@ -1960,12 +1960,12 @@ static void rs_clear(void *priv_rate)
 	IWL_DEBUG_RATE("enter\n");
 
 	priv->lq_mngr.lq_ready = 0;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	if (priv->lq_mngr.agg_ctrl.granted_ba)
 		iwl4965_turn_off_agg(priv, TID_ALL_SPECIFIED);
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	IWL_DEBUG_RATE("leave\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index aab0529..cc78aa2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -86,14 +86,14 @@ static int is_fat_channel(__le32 rxon_flags)
 
 static u8 is_single_stream(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht ||
 	    (priv->active_rate_ht[1] == 0) ||
 	    (priv->ps_mode == IWL_MIMO_PS_STATIC))
 		return 1;
 #else
 	return 1;
-#endif	/*CONFIG_IWLWIFI_HT */
+#endif	/*CONFIG_IWL4965_HT */
 	return 0;
 }
 
@@ -742,7 +742,7 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded\n");
 }
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 
 /* "false alarms" are signals that our DSP tries to lock onto,
  *   but then determines that they are either noise, or transmissions
@@ -1545,7 +1545,7 @@ static void iwl4965_bg_sensitivity_work(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 	return;
 }
-#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_SENSITIVITY*/
 
 static void iwl4965_bg_txpower_work(struct work_struct *work)
 {
@@ -1637,7 +1637,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	memset(&(priv->sensitivity_data), 0,
 	       sizeof(struct iwl_sensitivity_data));
 	memset(&(priv->chain_noise_data), 0,
@@ -1645,7 +1645,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	for (i = 0; i < NUM_RX_CHAINS; i++)
 		priv->chain_noise_data.delta_gain_code[i] =
 				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
-#endif /* CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /* CONFIG_IWL4965_SENSITIVITY*/
 	rc = iwl_grab_nic_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -2813,8 +2813,8 @@ void iwl4965_set_rxon_chain(struct iwl_priv *priv)
 	IWL_DEBUG_ASSOC("rx chain %X\n", priv->staging_rxon.rx_chain);
 }
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 /*
 	get the traffic load value for tid
 */
@@ -3148,8 +3148,8 @@ static void iwl4965_bg_agg_work(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
 	return;
 }
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 		   u8 sta_id, dma_addr_t txcmd_phys,
@@ -3164,11 +3164,11 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	u16 fc;
 	u16 rate_flags;
 	int rate_index = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	__le16 *qc;
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	unicast = !is_multicast_ether_addr(hdr->addr1);
 
@@ -3229,8 +3229,8 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	if (ieee80211_is_back_request(fc))
 		tx->tx_flags |= TX_CMD_FLG_ACK_MSK |
 			TX_CMD_FLG_IMM_BA_RSP_MASK;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc &&
 	    (priv->iw_mode != IEEE80211_IF_TYPE_IBSS)) {
@@ -3442,7 +3442,7 @@ void iwl_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwl4965_rx_calc_noise(priv);
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 		queue_work(priv->workqueue, &priv->sensitivity_work);
 #endif
 	}
@@ -3595,7 +3595,7 @@ static int iwl4965_calc_rssi(struct iwl4965_rx_phy_res *rx_resp)
 	return (max_rssi - agc - IWL_RSSI_OFFSET);
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 
 /* Parsed Information Elements */
 struct ieee802_11_elems {
@@ -3667,7 +3667,7 @@ static int parse_elems(u8 *start, size_t len, struct ieee802_11_elems *elems)
 
 	return 0;
 }
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT */
 
 static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
@@ -3727,9 +3727,9 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 		.antenna = 0,
 		.rate = iwl_hw_get_rate(rx_start->rate_n_flags),
 		.flag = 0,
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 		.ordered = 0
-#endif /* CONFIG_IWLWIFI_HT_AGG */
+#endif /* CONFIG_IWL4965_HT_AGG */
 	};
 	u8 network_packet;
 
@@ -3801,7 +3801,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	if (!iwl_is_associated(priv))
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	/* TODO:  Parts of iwl_report_frame are broken for 4965 */
 	if (iwl_debug_level & (IWL_DL_RX))
 		/* Set "1" to report good data frames in groups of 100 */
@@ -3865,10 +3865,10 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
 			if (network_packet) {
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 				u8 *pos = NULL;
 				struct ieee802_11_elems elems;
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 				struct ieee80211_mgmt *mgnt =
 					(struct ieee80211_mgmt *)header;
 
@@ -3877,7 +3877,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 				priv->assoc_capability =
 					le16_to_cpu(
 						mgnt->u.assoc_resp.capab_info);
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 				pos = mgnt->u.assoc_resp.variable;
 				if (!parse_elems(pos,
 						 len - (pos - (u8 *) mgnt),
@@ -3886,7 +3886,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 					    elems.ht_cap_param)
 						break;
 				}
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 				/* assoc_id is 0 no association */
 				if (!priv->assoc_id)
 					break;
@@ -3915,7 +3915,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 		break;
 
 	case IEEE80211_FTYPE_CTL:
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_BACK_REQ:
 			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
@@ -3972,7 +3972,7 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb)
 
 {
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_missed_beacon_notif *missed_beacon;
 
@@ -3987,11 +3987,11 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 		if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)))
 			queue_work(priv->workqueue, &priv->sensitivity_work);
 	}
-#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_SENSITIVITY*/
 }
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 
 static void iwl4965_set_tx_status(struct iwl_priv *priv, int txq_id, int idx,
 				  u32 status, u32 retry_count, u32 rate)
@@ -4257,8 +4257,8 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	return 0;
 }
 
-#endif/* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif/* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 /*
  * RATE SCALE CODE
  */
@@ -4321,7 +4321,7 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 			 &link_cmd);
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 
 static u8 iwl_is_channel_extension(struct iwl_priv *priv, int phymode,
 				   u16 channel, u8 extension_chan_offset)
@@ -4458,7 +4458,7 @@ void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index)
 	return;
 }
 
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 
 static void iwl4965_sta_modify_add_ba_tid(struct iwl_priv *priv,
 					  int sta_id, int tid, u16 ssn)
@@ -4627,8 +4627,8 @@ int iwl_mac_ht_rx_agg_stop(struct ieee80211_hw *hw, u8 *da,
 	return 0;
 }
 
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 /* Set up 4965-specific Rx frame reply handlers */
 void iwl_hw_rx_handler_setup(struct iwl_priv *priv)
@@ -4643,10 +4643,10 @@ void iwl_hw_rx_handler_setup(struct iwl_priv *priv)
 	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
 	    iwl4965_rx_missed_beacon_notif;
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl4965_rx_reply_compressed_ba;
-#endif /* CONFIG_IWLWIFI_AGG */
+#endif /* CONFIG_IWL4965_AGG */
 #endif /* CONFIG_IWLWIFI */
 }
 
@@ -4654,14 +4654,14 @@ void iwl_hw_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->txpower_work, iwl4965_bg_txpower_work);
 	INIT_WORK(&priv->statistics_work, iwl4965_bg_statistics_work);
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	INIT_WORK(&priv->sensitivity_work, iwl4965_bg_sensitivity_work);
 #endif
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	INIT_WORK(&priv->agg_work, iwl4965_bg_agg_work);
-#endif /* CONFIG_IWLWIFI_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_AGG */
+#endif /* CONFIG_IWL4965_HT */
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
 	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index bf174d3..d61cf0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -434,8 +434,8 @@ struct iwl_rx_queue {
 #define IWL_INVALID_RATE     0xFF
 #define IWL_INVALID_VALUE    -1
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 struct iwl_ht_agg {
 	u16 txq_id;
 	u16 frame_count;
@@ -445,16 +445,16 @@ struct iwl_ht_agg {
 	u32 bitmap1;
 	u32 rate_n_flags;
 };
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 struct iwl_tid_data {
 	u16 seq_number;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	struct iwl_ht_agg agg;
-#endif	/* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif	/* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 };
 
 struct iwl_hw_key {
@@ -471,7 +471,7 @@ union iwl_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 #define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
 #define HT_IE_MAX_AMSDU_SIZE_4K     (0)
 #define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
@@ -494,9 +494,9 @@ struct sta_ht_info {
 	u8 tx_chan_width;
 	u8 chan_width_cap;
 };
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 
 union iwl_qos_capabity {
 	struct {
@@ -525,7 +525,7 @@ struct iwl_qos_info {
 	union iwl_qos_capabity qos_cap;
 	struct iwl_qosparam_cmd def_qos_parm;
 };
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL4965_QOS */
 
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
@@ -617,7 +617,7 @@ extern int iwl_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl_power_init_handle(struct iwl_priv *priv);
 extern int iwl_eeprom_init(struct iwl_priv *priv);
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 extern void iwl_report_frame(struct iwl_priv *priv,
 			     struct iwl_rx_packet *pkt,
 			     struct ieee80211_hdr *header, int group100);
@@ -764,8 +764,8 @@ extern int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode,
 				u8 fat_extension_channel);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
 extern int iwl_mac_ht_rx_agg_start(struct ieee80211_hw *hw, u8 *da,
@@ -775,8 +775,8 @@ extern int iwl_mac_ht_rx_agg_stop(struct ieee80211_hw *hw, u8 *da,
 extern int iwl_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da,
 				  u16 tid, int generator);
 extern void iwl4965_turn_off_agg(struct iwl_priv *priv, u8 tid);
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /*CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /*CONFIG_IWL4965_HT */
 /* Structures, enum, and defines specific to the 4965 */
 
 #define IWL4965_KW_SIZE 0x1000	/*4k */
@@ -843,7 +843,7 @@ struct iwl_traffic_load {
 	u32 total;
 };
 
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 struct iwl_agg_control {
 	unsigned long next_retry;
 	u32 wait_for_agg_status;
@@ -855,10 +855,10 @@ struct iwl_agg_control {
 	u32 ba_timeout;
 	struct iwl_traffic_load traffic_load[TID_MAX_LOAD_COUNT];
 };
-#endif				/*CONFIG_IWLWIFI_HT_AGG */
+#endif				/*CONFIG_IWL4965_HT_AGG */
 
 struct iwl_lq_mngr {
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 	struct iwl_agg_control agg_ctrl;
 #endif
 	spinlock_t lock;
@@ -1040,7 +1040,7 @@ struct iwl_chain_noise_data {
 #define EEPROM_SEM_RETRY_LIMIT 1000
 
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 enum {
 	MEASUREMENT_READY = (1 << 0),
@@ -1068,7 +1068,7 @@ struct iwl_priv {
 
 	const struct ieee80211_hw_mode *modes;
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
@@ -1157,14 +1157,14 @@ struct iwl_priv {
 	u8 channel_width;	/* 0=20MHZ, 1=40MHZ */
 	u8 current_channel_width;
 	u8 valid_antenna;	/* Bit mask of antennas actually connected */
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
 	u8 start_calib;
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
-#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_SENSITIVITY*/
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	struct sta_ht_info current_assoc_ht;
 #endif
 	u8 active_rate_ht[2];
@@ -1253,9 +1253,9 @@ struct iwl_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	struct iwl_qos_info qos_data;
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL4965_QOS */
 
 	struct workqueue_struct *workqueue;
 
@@ -1290,20 +1290,20 @@ struct iwl_priv {
 	u32 pm_state[16];
 #endif
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	/* debugging info */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
 #endif
 
 	struct work_struct txpower_work;
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	struct work_struct sensitivity_work;
 #endif
 	struct work_struct statistics_work;
 	struct timer_list statistics_periodic;
 
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 	struct work_struct agg_work;
 #endif
 };				/*iwl_priv */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6d5d911..eedf051 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -59,7 +59,7 @@
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 u32 iwl_debug_level;
 #endif
 
@@ -89,13 +89,13 @@ int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 #define DRV_DESCRIPTION	\
 "Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 #define VD "d"
 #else
 #define VD
 #endif
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 #define VS "s"
 #else
 #define VS
@@ -180,7 +180,7 @@ static const char *iwl_escape_essid(const char *essid, u8 essid_len)
 
 static void iwl_print_hex_dump(int level, void *p, u32 len)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (!(iwl_debug_level & level))
 		return;
 
@@ -1582,7 +1582,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 
 /**
  * iwl_report_frame - dump frame to syslog during debug sessions
@@ -1862,7 +1862,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 /*
  * QoS  support
 */
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 static int iwl_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl_qosparam_cmd *qos)
 {
@@ -1991,7 +1991,7 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 	}
 }
 
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 /*
  * Power management (not Tx power!) functions
  */
@@ -2743,7 +2743,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
@@ -3186,7 +3186,7 @@ int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 	return 1;
 }
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
 
@@ -3512,7 +3512,7 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
@@ -3530,7 +3530,7 @@ static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
@@ -3576,7 +3576,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = beacon->beacon_notify_hdr.rate;
@@ -3599,7 +3599,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
@@ -4360,7 +4360,7 @@ static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 	return rc;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 {
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
@@ -4590,7 +4590,7 @@ static void iwl_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
 		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
@@ -4639,7 +4639,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -4657,7 +4657,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & IWL_DL_ISR) {
 		inta_mask = iwl_read32(priv, CSR_INT_MASK); /* just for debug */
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -4690,7 +4690,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_MAC_CLK_ACTV)
@@ -4786,7 +4786,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* Re-enable all interrupts */
 	iwl_enable_interrupts(priv);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -6789,9 +6789,9 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 	iwl_sequence_reset(priv);
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	iwl_activate_qos(priv, 0);
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7336,7 +7336,7 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	unsigned long flags;
 	int q;
 #endif /* CONFIG_IWL_QOS */
@@ -7353,7 +7353,7 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 		return 0;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	if (!priv->qos_data.qos_enable) {
 		priv->qos_data.qos_active = 0;
 		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
@@ -7382,7 +7382,7 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 
 	mutex_unlock(&priv->mutex);
 
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL3945_QOS */
 
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
@@ -7448,7 +7448,7 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	iwl_reset_qos(priv);
 #endif
 	cancel_delayed_work(&priv->post_associate);
@@ -7538,7 +7538,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	iwl_reset_qos(priv);
 #endif
 
@@ -7555,7 +7555,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -7588,7 +7588,7 @@ static ssize_t store_debug_level(struct device_driver *d,
 static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
 		   show_debug_level, store_debug_level);
 
-#endif /* CONFIG_IWLWIFI_DEBUG */
+#endif /* CONFIG_IWL3945_DEBUG */
 
 static ssize_t show_rf_kill(struct device *d,
 			    struct device_attribute *attr, char *buf)
@@ -7800,7 +7800,7 @@ static ssize_t store_tune(struct device *d,
 
 static DEVICE_ATTR(tune, S_IWUSR | S_IRUGO, show_tune, store_tune);
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -7871,7 +7871,7 @@ static ssize_t store_measurement(struct device *d,
 
 static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
 		   show_measurement, store_measurement);
-#endif /* CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT */
+#endif /* CONFIG_IWL3945_SPECTRUM_MEASUREMENT */
 
 static ssize_t show_rate(struct device *d,
 			 struct device_attribute *attr, char *buf)
@@ -8248,7 +8248,7 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_dump_events.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	&dev_attr_measurement.attr,
 #endif
 	&dev_attr_power_level.attr,
@@ -8326,7 +8326,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	priv->pci_dev = pdev;
 	priv->antenna = (enum iwl_antenna)iwl_param_antenna;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	iwl_debug_level = iwl_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
@@ -8441,7 +8441,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_iounmap;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	if (iwl_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
@@ -8449,7 +8449,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 
 	iwl_set_rxon_channel(priv, MODE_IEEE80211G, 6);
 	iwl_setup_deferred_work(priv);
@@ -8717,7 +8717,7 @@ static int __init iwl_init(void)
 		IWL_ERROR("Unable to initialize PCI module\n");
 		return ret;
 	}
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	ret = driver_create_file(&iwl_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
@@ -8731,7 +8731,7 @@ static int __init iwl_init(void)
 
 static void __exit iwl_exit(void)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	driver_remove_file(&iwl_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl_driver);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 572d639..0ee5063 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -59,7 +59,7 @@
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 u32 iwl_debug_level;
 #endif
 
@@ -88,13 +88,13 @@ int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link 4965AGN driver for Linux"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 #define VD "d"
 #else
 #define VD
 #endif
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 #define VS "s"
 #else
 #define VS
@@ -179,7 +179,7 @@ static const char *iwl_escape_essid(const char *essid, u8 essid_len)
 
 static void iwl_print_hex_dump(int level, void *p, u32 len)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (!(iwl_debug_level & level))
 		return;
 
@@ -506,12 +506,12 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 	station->sta.sta.sta_id = index;
 	station->sta.station_flags = 0;
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	/* BCAST station and IBSS stations do not work in HT mode */
 	if (index != priv->hw_setting.bcast_sta_id &&
 	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
 		iwl4965_set_ht_add_station(priv, index);
-#endif /*CONFIG_IWLWIFI_HT*/
+#endif /*CONFIG_IWL4965_HT*/
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 	iwl_send_add_station(priv, &station->sta, flags);
@@ -1110,13 +1110,13 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	/* station table will be cleared */
 	priv->assoc_station_added = 0;
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	priv->sensitivity_data.state = IWL_SENS_CALIB_NEED_REINIT;
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
 
 	iwl4965_init_sensitivity(priv, CMD_ASYNC, 1);
-#endif /* CONFIG_IWLWIFI_SENSITIVITY */
+#endif /* CONFIG_IWL4965_SENSITIVITY */
 
 	/* If we are currently associated and the new config requires
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
@@ -1160,13 +1160,13 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 
 	iwl_clear_stations_table(priv);
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
 
 	priv->sensitivity_data.state = IWL_SENS_CALIB_NEED_REINIT;
 	iwl4965_init_sensitivity(priv, CMD_ASYNC, 1);
-#endif /* CONFIG_IWLWIFI_SENSITIVITY */
+#endif /* CONFIG_IWL4965_SENSITIVITY */
 
 	memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 
@@ -1633,7 +1633,7 @@ done:
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 
 /**
  * iwl_report_frame - dump frame to syslog during debug sessions
@@ -1816,7 +1816,7 @@ static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 	return ret_rates;
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 void static iwl_set_ht_capab(struct ieee80211_hw *hw,
 			     struct ieee80211_ht_capability *ht_cap,
 			     u8 use_wide_chan);
@@ -1914,7 +1914,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	if (*pos > 0)
 		len += 2 + *pos;
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (is_direct && priv->is_ht_enabled) {
 		u8 use_wide_chan = 1;
 
@@ -1927,7 +1927,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 				 use_wide_chan);
 		len += 2 + sizeof(struct ieee80211_ht_capability);
 	}
-#endif  /*CONFIG_IWLWIFI_HT */
+#endif  /*CONFIG_IWL4965_HT */
 
  fill_end:
 	return (u16)len;
@@ -1936,7 +1936,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 /*
  * QoS  support
 */
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 static int iwl_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl_qosparam_cmd *qos)
 {
@@ -2053,10 +2053,10 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 		priv->qos_data.def_qos_parm.qos_flags |=
 			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (priv->is_ht_enabled && priv->current_assoc_ht.is_ht)
 		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT */
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -2070,7 +2070,7 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 	}
 }
 
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 /*
  * Power management (not Tx power!) functions
  */
@@ -2832,7 +2832,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
@@ -2868,13 +2868,13 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 			(hdr->seq_ctrl &
 				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
 		seq_number += 0x10;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 		/* aggregation is on for this <sta,tid> */
 		if (ctl->flags & IEEE80211_TXCTL_HT_MPDU_AGG)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 	}
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
@@ -3280,7 +3280,7 @@ int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 	return 1;
 }
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
 
@@ -3488,8 +3488,8 @@ static int iwl_is_tx_success(u32 status)
  * Generic RX handler implementations
  *
  ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 
 static inline int iwl_get_ra_sta_id(struct iwl_priv *priv,
 				    struct ieee80211_hdr *hdr)
@@ -3645,8 +3645,8 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	struct ieee80211_tx_status *tx_status;
 	struct iwl_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	int tid, sta_id;
 #endif
 #endif
@@ -3659,8 +3659,8 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwl_get_scd_ssn(tx_resp);
 		struct ieee80211_hdr *hdr =
@@ -3697,8 +3697,8 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 			iwl_tx_queue_reclaim(priv, txq_id, index);
 		}
 	} else {
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
 	tx_status->retry_count = tx_resp->failure_frame;
@@ -3720,11 +3720,11 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 	if (index != -1)
 		iwl_tx_queue_reclaim(priv, txq_id, index);
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	}
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
@@ -3806,7 +3806,7 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
@@ -3824,7 +3824,7 @@ static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
@@ -3870,7 +3870,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
@@ -3893,7 +3893,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
@@ -4691,7 +4691,7 @@ static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 	return rc;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 {
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
@@ -4913,7 +4913,7 @@ static void iwl_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
 		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
@@ -4962,7 +4962,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -4980,7 +4980,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & IWL_DL_ISR) {
 		inta_mask = iwl_read32(priv, CSR_INT_MASK); /* just for debug */
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -5013,7 +5013,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_MAC_CLK_ACTV)
@@ -5101,7 +5101,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* Re-enable all interrupts */
 	iwl_enable_interrupts(priv);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -7124,7 +7124,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (priv->is_ht_enabled && priv->current_assoc_ht.is_ht)
 		iwl4965_set_rxon_ht(priv, &priv->current_assoc_ht);
 	else {
@@ -7132,7 +7132,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 		priv->active_rate_ht[1] = 0;
 		priv->current_channel_width = IWL_CHANNEL_WIDTH_20MHZ;
 	}
-#endif /* CONFIG_IWLWIFI_HT*/
+#endif /* CONFIG_IWL4965_HT*/
 	iwl4965_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
@@ -7182,18 +7182,18 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 	iwl_sequence_reset(priv);
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	/* Enable Rx differential gain and sensitivity calibrations */
 	iwl4965_chain_noise_reset(priv);
 	priv->start_calib = 1;
-#endif /* CONFIG_IWLWIFI_SENSITIVITY */
+#endif /* CONFIG_IWL4965_SENSITIVITY */
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
 		priv->assoc_station_added = 1;
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	iwl_activate_qos(priv, 0);
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7372,7 +7372,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 		return -EINVAL;
 	}
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	/* if we are switching fron ht to 2.4 clear flags
 	 * from any ht related info since 2.4 does not
 	 * support ht */
@@ -7382,7 +7382,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 #endif
 	)
 		priv->staging_rxon.flags = 0;
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT */
 
 	iwl_set_rxon_channel(priv, conf->phymode, conf->channel);
 
@@ -7482,7 +7482,7 @@ static void iwl_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl_commit_rxon(priv);
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 		iwl_activate_qos(priv, 1);
 #endif
 		iwl_rxon_add_station(priv, BROADCAST_ADDR, 0);
@@ -7753,7 +7753,7 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	unsigned long flags;
 	int q;
 #endif /* CONFIG_IWL_QOS */
@@ -7770,7 +7770,7 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 		return 0;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	if (!priv->qos_data.qos_enable) {
 		priv->qos_data.qos_active = 0;
 		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
@@ -7799,7 +7799,7 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 
 	mutex_unlock(&priv->mutex);
 
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL4965_QOS */
 
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
@@ -7866,11 +7866,11 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211("enter\n");
 
 	priv->lq_mngr.lq_ready = 0;
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	spin_lock_irqsave(&priv->lock, flags);
 	memset(&priv->current_assoc_ht, 0, sizeof(struct sta_ht_info));
 	spin_unlock_irqrestore(&priv->lock, flags);
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 /*	if (priv->lq_mngr.agg_ctrl.granted_ba)
 		iwl4965_turn_off_agg(priv, TID_ALL_SPECIFIED);*/
 
@@ -7881,10 +7881,10 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	if (priv->lq_mngr.agg_ctrl.auto_agg)
 		priv->lq_mngr.agg_ctrl.requested_ba = TID_ALL_ENABLED;
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	iwl_reset_qos(priv);
 #endif
 
@@ -7976,7 +7976,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	iwl_reset_qos(priv);
 #endif
 
@@ -7987,7 +7987,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	return 0;
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 union ht_cap_info {
 	struct {
 		u16 advanced_coding_cap		:1;
@@ -8179,7 +8179,7 @@ static void iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
 	iwl_set_ht_capab(hw, ht_cap, use_wide_channel);
 	IWL_DEBUG_MAC80211("leave: \n");
 }
-#endif /*CONFIG_IWLWIFI_HT*/
+#endif /*CONFIG_IWL4965_HT*/
 
 /*****************************************************************************
  *
@@ -8187,7 +8187,7 @@ static void iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -8220,7 +8220,7 @@ static ssize_t store_debug_level(struct device_driver *d,
 static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
 		   show_debug_level, store_debug_level);
 
-#endif /* CONFIG_IWLWIFI_DEBUG */
+#endif /* CONFIG_IWL4965_DEBUG */
 
 static ssize_t show_rf_kill(struct device *d,
 			    struct device_attribute *attr, char *buf)
@@ -8432,7 +8432,7 @@ static ssize_t store_tune(struct device *d,
 
 static DEVICE_ATTR(tune, S_IWUSR | S_IRUGO, show_tune, store_tune);
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -8503,7 +8503,7 @@ static ssize_t store_measurement(struct device *d,
 
 static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
 		   show_measurement, store_measurement);
-#endif /* CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT */
+#endif /* CONFIG_IWL4965_SPECTRUM_MEASUREMENT */
 
 static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
@@ -8855,7 +8855,7 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_dump_events.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	&dev_attr_measurement.attr,
 #endif
 	&dev_attr_power_level.attr,
@@ -8892,16 +8892,16 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.get_tsf = iwl_mac_get_tsf,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.beacon_update = iwl_mac_beacon_update,
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	.conf_ht = iwl_mac_conf_ht,
 	.get_ht_capab = iwl_mac_get_ht_capab,
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 	.ht_tx_agg_start = iwl_mac_ht_tx_agg_start,
 	.ht_tx_agg_stop = iwl_mac_ht_tx_agg_stop,
 	.ht_rx_agg_start = iwl_mac_ht_rx_agg_start,
 	.ht_rx_agg_stop = iwl_mac_ht_rx_agg_stop,
-#endif  /* CONFIG_IWLWIFI_HT_AGG */
-#endif  /* CONFIG_IWLWIFI_HT */
+#endif  /* CONFIG_IWL4965_HT_AGG */
+#endif  /* CONFIG_IWL4965_HT */
 	.hw_scan = iwl_mac_hw_scan
 };
 
@@ -8941,7 +8941,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	priv->pci_dev = pdev;
 	priv->antenna = (enum iwl_antenna)iwl_param_antenna;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	iwl_debug_level = iwl_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
@@ -8962,11 +8962,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
 
 	hw->queues = 4;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	hw->queues = 16;
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	spin_lock_init(&priv->lock);
 	spin_lock_init(&priv->power_data.lock);
@@ -9047,7 +9047,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_iounmap;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	if (iwl_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
@@ -9055,7 +9055,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 
 	iwl_set_rxon_channel(priv, MODE_IEEE80211G, 6);
 	iwl_setup_deferred_work(priv);
@@ -9323,7 +9323,7 @@ static int __init iwl_init(void)
 		IWL_ERROR("Unable to initialize PCI module\n");
 		return ret;
 	}
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	ret = driver_create_file(&iwl_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
@@ -9337,7 +9337,7 @@ static int __init iwl_init(void)
 
 static void __exit iwl_exit(void)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	driver_remove_file(&iwl_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl_driver);
-- 
1.5.2
