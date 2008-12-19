Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbYLSCp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:29 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 28/43] iwl3945: replaces iwl3945_priv with iwl_priv
Date: Fri, 19 Dec 2008 10:37:28 +0800
Message-Id: <1229654263-21454-29-git-send-email-yi.zhu@intel.com> (sfid-20081219_034614_402027_DF6EE095)
In-Reply-To: <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch replaces iwl3945_priv to iwl_priv. It adds 3945 specific
data members to iwl_priv.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h  |   58 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |   26 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |   22 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   24 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   98 ++++----
 drivers/net/wireless/iwlwifi/iwl-3945.h     |  333 ++++-------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   51 +++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  398 +++++++++++++-------------
 8 files changed, 416 insertions(+), 594 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index d49dfd1..0b84815 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -61,7 +61,7 @@
 
 #define _iwl3945_write32(priv, ofs, val) iowrite32((val), (priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_write32(const char *f, u32 l, struct iwl3945_priv *priv,
+static inline void __iwl3945_write32(const char *f, u32 l, struct iwl_priv *priv,
 				 u32 ofs, u32 val)
 {
 	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
@@ -75,7 +75,7 @@ static inline void __iwl3945_write32(const char *f, u32 l, struct iwl3945_priv *
 
 #define _iwl3945_read32(priv, ofs) ioread32((priv)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl3945_priv *priv, u32 ofs)
+static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
 	return _iwl3945_read32(priv, ofs);
@@ -85,7 +85,7 @@ static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl3945_priv *priv, u3
 #define iwl3945_read32(p, o) _iwl3945_read32(p, o)
 #endif
 
-static inline int _iwl3945_poll_bit(struct iwl3945_priv *priv, u32 addr,
+static inline int _iwl3945_poll_bit(struct iwl_priv *priv, u32 addr,
 				u32 bits, u32 mask, int timeout)
 {
 	int i = 0;
@@ -101,7 +101,7 @@ static inline int _iwl3945_poll_bit(struct iwl3945_priv *priv, u32 addr,
 }
 #ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl3945_poll_bit(const char *f, u32 l,
-				 struct iwl3945_priv *priv, u32 addr,
+				 struct iwl_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
 {
 	int ret = _iwl3945_poll_bit(priv, addr, bits, mask, timeout);
@@ -116,13 +116,13 @@ static inline int __iwl3945_poll_bit(const char *f, u32 l,
 #define iwl3945_poll_bit(p, a, b, m, t) _iwl3945_poll_bit(p, a, b, m, t)
 #endif
 
-static inline void _iwl3945_set_bit(struct iwl3945_priv *priv, u32 reg, u32 mask)
+static inline void _iwl3945_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl3945_write32(priv, reg, _iwl3945_read32(priv, reg) | mask);
 }
 #ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl3945_set_bit(const char *f, u32 l,
-				 struct iwl3945_priv *priv, u32 reg, u32 mask)
+				 struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl3945_read32(priv, reg) | mask;
 	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
@@ -133,13 +133,13 @@ static inline void __iwl3945_set_bit(const char *f, u32 l,
 #define iwl3945_set_bit(p, r, m) _iwl3945_set_bit(p, r, m)
 #endif
 
-static inline void _iwl3945_clear_bit(struct iwl3945_priv *priv, u32 reg, u32 mask)
+static inline void _iwl3945_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	_iwl3945_write32(priv, reg, _iwl3945_read32(priv, reg) & ~mask);
 }
 #ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl3945_clear_bit(const char *f, u32 l,
-				   struct iwl3945_priv *priv, u32 reg, u32 mask)
+				   struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl3945_read32(priv, reg) & ~mask;
 	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
@@ -150,7 +150,7 @@ static inline void __iwl3945_clear_bit(const char *f, u32 l,
 #define iwl3945_clear_bit(p, r, m) _iwl3945_clear_bit(p, r, m)
 #endif
 
-static inline int _iwl3945_grab_nic_access(struct iwl3945_priv *priv)
+static inline int _iwl3945_grab_nic_access(struct iwl_priv *priv)
 {
 	int ret;
 #ifdef CONFIG_IWL3945_DEBUG
@@ -176,7 +176,7 @@ static inline int _iwl3945_grab_nic_access(struct iwl3945_priv *priv)
 
 #ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl3945_grab_nic_access(const char *f, u32 l,
-					       struct iwl3945_priv *priv)
+					       struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt))
 		IWL_DEBUG_INFO("Grabbing access while already held at "
@@ -192,7 +192,7 @@ static inline int __iwl3945_grab_nic_access(const char *f, u32 l,
 	_iwl3945_grab_nic_access(priv)
 #endif
 
-static inline void _iwl3945_release_nic_access(struct iwl3945_priv *priv)
+static inline void _iwl3945_release_nic_access(struct iwl_priv *priv)
 {
 #ifdef CONFIG_IWL3945_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
@@ -202,7 +202,7 @@ static inline void _iwl3945_release_nic_access(struct iwl3945_priv *priv)
 }
 #ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl3945_release_nic_access(const char *f, u32 l,
-					    struct iwl3945_priv *priv)
+					    struct iwl_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt) <= 0)
 		IWL_ERROR("Release unheld nic access at line %d.\n", l);
@@ -217,13 +217,13 @@ static inline void __iwl3945_release_nic_access(const char *f, u32 l,
 	_iwl3945_release_nic_access(priv)
 #endif
 
-static inline u32 _iwl3945_read_direct32(struct iwl3945_priv *priv, u32 reg)
+static inline u32 _iwl3945_read_direct32(struct iwl_priv *priv, u32 reg)
 {
 	return _iwl3945_read32(priv, reg);
 }
 #ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl3945_read_direct32(const char *f, u32 l,
-					struct iwl3945_priv *priv, u32 reg)
+					struct iwl_priv *priv, u32 reg)
 {
 	u32 value = _iwl3945_read_direct32(priv, reg);
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -238,14 +238,14 @@ static inline u32 __iwl3945_read_direct32(const char *f, u32 l,
 #define iwl3945_read_direct32 _iwl3945_read_direct32
 #endif
 
-static inline void _iwl3945_write_direct32(struct iwl3945_priv *priv,
+static inline void _iwl3945_write_direct32(struct iwl_priv *priv,
 					 u32 reg, u32 value)
 {
 	_iwl3945_write32(priv, reg, value);
 }
 #ifdef CONFIG_IWL3945_DEBUG
 static void __iwl3945_write_direct32(u32 line,
-				   struct iwl3945_priv *priv, u32 reg, u32 value)
+				   struct iwl_priv *priv, u32 reg, u32 value)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Nic access not held from line %d\n", line);
@@ -257,7 +257,7 @@ static void __iwl3945_write_direct32(u32 line,
 #define iwl3945_write_direct32 _iwl3945_write_direct32
 #endif
 
-static inline void iwl3945_write_reg_buf(struct iwl3945_priv *priv,
+static inline void iwl3945_write_reg_buf(struct iwl_priv *priv,
 					       u32 reg, u32 len, u32 *values)
 {
 	u32 count = sizeof(u32);
@@ -268,7 +268,7 @@ static inline void iwl3945_write_reg_buf(struct iwl3945_priv *priv,
 	}
 }
 
-static inline int _iwl3945_poll_direct_bit(struct iwl3945_priv *priv,
+static inline int _iwl3945_poll_direct_bit(struct iwl_priv *priv,
 					   u32 addr, u32 mask, int timeout)
 {
 	return _iwl3945_poll_bit(priv, addr, mask, mask, timeout);
@@ -276,7 +276,7 @@ static inline int _iwl3945_poll_direct_bit(struct iwl3945_priv *priv,
 
 #ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl3945_poll_direct_bit(const char *f, u32 l,
-					    struct iwl3945_priv *priv,
+					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
 {
 	int ret  = _iwl3945_poll_direct_bit(priv, addr, mask, timeout);
@@ -295,14 +295,14 @@ static inline int __iwl3945_poll_direct_bit(const char *f, u32 l,
 #define iwl3945_poll_direct_bit _iwl3945_poll_direct_bit
 #endif
 
-static inline u32 _iwl3945_read_prph(struct iwl3945_priv *priv, u32 reg)
+static inline u32 _iwl3945_read_prph(struct iwl_priv *priv, u32 reg)
 {
 	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	rmb();
 	return _iwl3945_read_direct32(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl3945_read_prph(u32 line, struct iwl3945_priv *priv, u32 reg)
+static inline u32 __iwl3945_read_prph(u32 line, struct iwl_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Nic access not held from line %d\n", line);
@@ -315,7 +315,7 @@ static inline u32 __iwl3945_read_prph(u32 line, struct iwl3945_priv *priv, u32 r
 #define iwl3945_read_prph _iwl3945_read_prph
 #endif
 
-static inline void _iwl3945_write_prph(struct iwl3945_priv *priv,
+static inline void _iwl3945_write_prph(struct iwl_priv *priv,
 					     u32 addr, u32 val)
 {
 	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_WADDR,
@@ -324,7 +324,7 @@ static inline void _iwl3945_write_prph(struct iwl3945_priv *priv,
 	_iwl3945_write_direct32(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_write_prph(u32 line, struct iwl3945_priv *priv,
+static inline void __iwl3945_write_prph(u32 line, struct iwl_priv *priv,
 					      u32 addr, u32 val)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -341,7 +341,7 @@ static inline void __iwl3945_write_prph(u32 line, struct iwl3945_priv *priv,
 #define _iwl3945_set_bits_prph(priv, reg, mask) \
 	_iwl3945_write_prph(priv, reg, (_iwl3945_read_prph(priv, reg) | mask))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl3945_set_bits_prph(u32 line, struct iwl3945_priv *priv,
+static inline void __iwl3945_set_bits_prph(u32 line, struct iwl_priv *priv,
 					u32 reg, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
@@ -360,7 +360,7 @@ static inline void __iwl3945_set_bits_prph(u32 line, struct iwl3945_priv *priv,
 
 #ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl3945_set_bits_mask_prph(u32 line,
-		struct iwl3945_priv *priv, u32 reg, u32 bits, u32 mask)
+		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Nic access not held from line %d\n", line);
@@ -372,28 +372,28 @@ static inline void __iwl3945_set_bits_mask_prph(u32 line,
 #define iwl3945_set_bits_mask_prph _iwl3945_set_bits_mask_prph
 #endif
 
-static inline void iwl3945_clear_bits_prph(struct iwl3945_priv
+static inline void iwl3945_clear_bits_prph(struct iwl_priv
 						 *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl3945_read_prph(priv, reg);
 	_iwl3945_write_prph(priv, reg, (val & ~mask));
 }
 
-static inline u32 iwl3945_read_targ_mem(struct iwl3945_priv *priv, u32 addr)
+static inline u32 iwl3945_read_targ_mem(struct iwl_priv *priv, u32 addr)
 {
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_RADDR, addr);
 	rmb();
 	return iwl3945_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 }
 
-static inline void iwl3945_write_targ_mem(struct iwl3945_priv *priv, u32 addr, u32 val)
+static inline void iwl3945_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
 {
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
 	wmb();
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
-static inline void iwl3945_write_targ_mem_buf(struct iwl3945_priv *priv, u32 addr,
+static inline void iwl3945_write_targ_mem_buf(struct iwl_priv *priv, u32 addr,
 					  u32 len, u32 *values)
 {
 	iwl3945_write_direct32(priv, HBUS_TARG_MEM_WADDR, addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 1ef21b6..165da9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -67,7 +67,7 @@ static const struct {
 #define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /*Exclude Solid on*/
 #define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
 
-static int iwl3945_led_cmd_callback(struct iwl3945_priv *priv,
+static int iwl3945_led_cmd_callback(struct iwl_priv *priv,
 				    struct iwl3945_cmd *cmd,
 				    struct sk_buff *skb)
 {
@@ -80,7 +80,7 @@ static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
 }
 
 /* Send led command */
-static int iwl_send_led_cmd(struct iwl3945_priv *priv,
+static int iwl_send_led_cmd(struct iwl_priv *priv,
 			    struct iwl_led_cmd *led_cmd)
 {
 	struct iwl3945_host_cmd cmd = {
@@ -97,7 +97,7 @@ static int iwl_send_led_cmd(struct iwl3945_priv *priv,
 
 
 /* Set led on command */
-static int iwl3945_led_pattern(struct iwl3945_priv *priv, int led_id,
+static int iwl3945_led_pattern(struct iwl_priv *priv, int led_id,
 			       unsigned int idx)
 {
 	struct iwl_led_cmd led_cmd = {
@@ -115,7 +115,7 @@ static int iwl3945_led_pattern(struct iwl3945_priv *priv, int led_id,
 
 
 /* Set led on command */
-static int iwl3945_led_on(struct iwl3945_priv *priv, int led_id)
+static int iwl3945_led_on(struct iwl_priv *priv, int led_id)
 {
 	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
@@ -127,7 +127,7 @@ static int iwl3945_led_on(struct iwl3945_priv *priv, int led_id)
 }
 
 /* Set led off command */
-static int iwl3945_led_off(struct iwl3945_priv *priv, int led_id)
+static int iwl3945_led_off(struct iwl_priv *priv, int led_id)
 {
 	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
@@ -142,7 +142,7 @@ static int iwl3945_led_off(struct iwl3945_priv *priv, int led_id)
 /*
  * brightness call back function for Tx/Rx LED
  */
-static int iwl3945_led_associated(struct iwl3945_priv *priv, int led_id)
+static int iwl3945_led_associated(struct iwl_priv *priv, int led_id)
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    !test_bit(STATUS_READY, &priv->status))
@@ -163,7 +163,7 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 {
 	struct iwl3945_led *led = container_of(led_cdev,
 					       struct iwl3945_led, led_dev);
-	struct iwl3945_priv *priv = led->priv;
+	struct iwl_priv *priv = led->priv;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -199,7 +199,7 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 /*
  * Register led class with the system
  */
-static int iwl3945_led_register_led(struct iwl3945_priv *priv,
+static int iwl3945_led_register_led(struct iwl_priv *priv,
 				   struct iwl3945_led *led,
 				   enum led_type type, u8 set_led,
 				   char *trigger)
@@ -231,7 +231,7 @@ static int iwl3945_led_register_led(struct iwl3945_priv *priv,
 /*
  * calculate blink rate according to last 2 sec Tx/Rx activities
  */
-static inline u8 get_blink_rate(struct iwl3945_priv *priv)
+static inline u8 get_blink_rate(struct iwl_priv *priv)
 {
 	int index;
 	u64 current_tpt = priv->rxtxpackets;
@@ -250,7 +250,7 @@ static inline u8 get_blink_rate(struct iwl3945_priv *priv)
 	return index;
 }
 
-static inline int is_rf_kill(struct iwl3945_priv *priv)
+static inline int is_rf_kill(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
 		test_bit(STATUS_RF_KILL_SW, &priv->status);
@@ -261,7 +261,7 @@ static inline int is_rf_kill(struct iwl3945_priv *priv)
  * happen very frequent we postpone led command to be called from
  * REPLY handler so we know ucode is up
  */
-void iwl3945_led_background(struct iwl3945_priv *priv)
+void iwl3945_led_background(struct iwl_priv *priv)
 {
 	u8 blink_idx;
 
@@ -301,7 +301,7 @@ void iwl3945_led_background(struct iwl3945_priv *priv)
 
 
 /* Register all led handler */
-int iwl3945_led_register(struct iwl3945_priv *priv)
+int iwl3945_led_register(struct iwl_priv *priv)
 {
 	char *trigger;
 	int ret;
@@ -399,7 +399,7 @@ static void iwl3945_led_unregister_led(struct iwl3945_led *led, u8 set_led)
 }
 
 /* Unregister all led handlers */
-void iwl3945_led_unregister(struct iwl3945_priv *priv)
+void iwl3945_led_unregister(struct iwl_priv *priv)
 {
 	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_ASSOC], 0);
 	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_RX], 0);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index b697c89..859bb9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -27,34 +27,34 @@
 #ifndef IWL3945_LEDS_H
 #define IWL3945_LEDS_H
 
-struct iwl3945_priv;
+struct iwl_priv;
 
 #ifdef CONFIG_IWL3945_LEDS
 
 #include "iwl-led.h"
 
 struct iwl3945_led {
-	struct iwl3945_priv *priv;
+	struct iwl_priv *priv;
 	struct led_classdev led_dev;
 	char name[32];
 
-	int (*led_on) (struct iwl3945_priv *priv, int led_id);
-	int (*led_off) (struct iwl3945_priv *priv, int led_id);
-	int (*led_pattern) (struct iwl3945_priv *priv, int led_id,
+	int (*led_on) (struct iwl_priv *priv, int led_id);
+	int (*led_off) (struct iwl_priv *priv, int led_id);
+	int (*led_pattern) (struct iwl_priv *priv, int led_id,
 			    unsigned int idx);
 
 	enum led_type type;
 	unsigned int registered;
 };
 
-extern int iwl3945_led_register(struct iwl3945_priv *priv);
-extern void iwl3945_led_unregister(struct iwl3945_priv *priv);
-extern void iwl3945_led_background(struct iwl3945_priv *priv);
+extern int iwl3945_led_register(struct iwl_priv *priv);
+extern void iwl3945_led_unregister(struct iwl_priv *priv);
+extern void iwl3945_led_background(struct iwl_priv *priv);
 
 #else
-static inline int iwl3945_led_register(struct iwl3945_priv *priv) { return 0; }
-static inline void iwl3945_led_unregister(struct iwl3945_priv *priv) {}
-static inline void iwl3945_led_background(struct iwl3945_priv *priv) {}
+static inline int iwl3945_led_register(struct iwl_priv *priv) { return 0; }
+static inline void iwl3945_led_unregister(struct iwl_priv *priv) {}
+static inline void iwl3945_led_background(struct iwl_priv *priv) {}
 #endif /* CONFIG_IWL3945_LEDS */
 
 #endif /* IWL3945_LEDS_H */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 7d3fb4f..ba1acc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -52,7 +52,7 @@ struct iwl3945_rate_scale_data {
 
 struct iwl3945_rs_sta {
 	spinlock_t lock;
-	struct iwl3945_priv *priv;
+	struct iwl_priv *priv;
 	s32 *expected_tpt;
 	unsigned long last_partial_flush;
 	unsigned long last_flush;
@@ -183,7 +183,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 	int unflushed = 0;
 	int i;
 	unsigned long flags;
-	struct iwl3945_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv = rs_sta->priv;
 
 	/*
 	 * For each rate, if we have collected data on that rate
@@ -216,7 +216,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 static void iwl3945_bg_rate_scale_flush(unsigned long data)
 {
 	struct iwl3945_rs_sta *rs_sta = (void *)data;
-	struct iwl3945_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv = rs_sta->priv;
 	int unflushed = 0;
 	unsigned long flags;
 	u32 packet_count, duration, pps;
@@ -290,7 +290,7 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 {
 	unsigned long flags;
 	s32 fail_count;
-	struct iwl3945_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv = rs_sta->priv;
 
 	if (!retries) {
 		IWL_DEBUG_RATE("leave: retries == 0 -- should be at least 1\n");
@@ -344,7 +344,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 			 struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_r;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	int i;
 
 	IWL_DEBUG_RATE("enter\n");
@@ -388,7 +388,7 @@ static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct iwl3945_rs_sta *rs_sta;
 	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
-	struct iwl3945_priv *priv = iwl_priv;
+	struct iwl_priv *priv = iwl_priv;
 	int i;
 
 	/*
@@ -438,7 +438,7 @@ static void rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 {
 	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
-	struct iwl3945_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv = rs_sta->priv;
 
 	psta->rs_sta = NULL;
 
@@ -452,7 +452,7 @@ static void rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 /**
  * rs_tx_status - Update rate control values based on Tx results
  *
- * NOTE: Uses iwl3945_priv->retry_rate for the # of retries attempted by
+ * NOTE: Uses iwl_priv->retry_rate for the # of retries attempted by
  * the hardware for each rate.
  */
 static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband,
@@ -462,7 +462,7 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 	s8 retries = 0, current_count;
 	int scale_rate_index, first_index, last_index;
 	unsigned long flags;
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
@@ -556,7 +556,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
 {
 	u8 high = IWL_RATE_INVALID;
 	u8 low = IWL_RATE_INVALID;
-	struct iwl3945_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv = rs_sta->priv;
 
 	/* 802.11A walks to the next literal adjacent rate in
 	 * the rate table */
@@ -650,7 +650,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	u16 fc, rate_mask;
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_r;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	DECLARE_MAC_BUF(mac);
 
@@ -883,7 +883,7 @@ static struct rate_control_ops rs_ops = {
 
 void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	s32 rssi = 0;
 	unsigned long flags;
 	struct iwl3945_rs_sta *rs_sta;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index be682cd..35477d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -93,7 +93,7 @@ const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT_3945] = {
  * Use for only special debugging.  This function is just a placeholder as-is,
  *   you'll need to provide the special bits! ...
  *   ... and set IWL_EVT_DISABLE to 1. */
-void iwl3945_disable_events(struct iwl3945_priv *priv)
+void iwl3945_disable_events(struct iwl_priv *priv)
 {
 	int ret;
 	int i;
@@ -206,7 +206,7 @@ static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
  * IWL_ANTENNA_MAIN      - Force MAIN antenna
  * IWL_ANTENNA_AUX       - Force AUX antenna
  */
-__le32 iwl3945_get_antenna_flags(const struct iwl3945_priv *priv)
+__le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 {
 	switch (priv->antenna) {
 	case IWL_ANTENNA_DIVERSITY:
@@ -268,7 +268,7 @@ static inline const char *iwl3945_get_tx_fail_reason(u32 status)
  * for A and B mode we need to overright prev
  * value
  */
-int iwl3945_rs_next_rate(struct iwl3945_priv *priv, int rate)
+int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate)
 {
 	int next_rate = iwl3945_get_prev_ieee_rate(rate);
 
@@ -302,7 +302,7 @@ int iwl3945_rs_next_rate(struct iwl3945_priv *priv, int rate)
  * need to be reclaimed. As result, some free space forms. If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
-static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
+static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 				     int txq_id, int index)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
@@ -329,7 +329,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
 /**
  * iwl3945_rx_reply_tx - Handle Tx response
  */
-static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
+static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 			    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -389,7 +389,7 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
  *
  *****************************************************************************/
 
-void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl_rx_mem_buffer *rxb)
+void iwl3945_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
@@ -417,7 +417,7 @@ void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl_rx_mem_buffe
  * including selective frame dumps.
  * group100 parameter selects whether to show 1 out of 100 good frames.
  */
-static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
+static void iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
@@ -545,7 +545,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
 }
 #else
-static inline void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
+static inline void iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
@@ -553,7 +553,7 @@ static inline void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 #endif
 
 /* This is necessary only for a number of statistics, see the caller. */
-static int iwl3945_is_network_packet(struct iwl3945_priv *priv,
+static int iwl3945_is_network_packet(struct iwl_priv *priv,
 		struct ieee80211_hdr *header)
 {
 	/* Filter incoming packets to determine if they are targeted toward
@@ -570,7 +570,7 @@ static int iwl3945_is_network_packet(struct iwl3945_priv *priv,
 	}
 }
 
-static void iwl3945_pass_packet_to_mac80211(struct iwl3945_priv *priv,
+static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				   struct iwl_rx_mem_buffer *rxb,
 				   struct ieee80211_rx_status *stats)
 {
@@ -613,7 +613,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl3945_priv *priv,
 
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
-static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
+static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 	struct ieee80211_hdr *header;
@@ -723,7 +723,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
 }
 
-int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl3945_priv *priv, void *ptr,
+int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 				 dma_addr_t addr, u16 len)
 {
 	int count;
@@ -755,7 +755,7 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl3945_priv *priv, void *ptr,
  *
  * Does NOT advance any indexes
  */
-int iwl3945_hw_txq_free_tfd(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
+int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 {
 	struct iwl3945_tfd_frame *bd_tmp = (struct iwl3945_tfd_frame *)&txq->bd[0];
 	struct iwl3945_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
@@ -793,7 +793,7 @@ int iwl3945_hw_txq_free_tfd(struct iwl3945_priv *priv, struct iwl3945_tx_queue *
 	return 0;
 }
 
-u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *addr)
+u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *addr)
 {
 	int i, start = IWL_AP_ID;
 	int ret = IWL_INVALID_STATION;
@@ -827,7 +827,7 @@ u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *addr)
  * iwl3945_hw_build_tx_cmd_rate - Add rate portion to TX_CMD:
  *
 */
-void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
+void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 			      struct iwl3945_cmd *cmd,
 			      struct ieee80211_tx_info *info,
 			      struct ieee80211_hdr *hdr, int sta_id, int tx_id)
@@ -897,7 +897,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 		       cmd->cmd.tx.supp_rates[1], cmd->cmd.tx.supp_rates[0]);
 }
 
-u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id, u16 tx_rate, u8 flags)
+u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 {
 	unsigned long flags_spin;
 	struct iwl3945_station_entry *station;
@@ -920,7 +920,7 @@ u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id, u16 tx_rate, u8 flags
 	return sta_id;
 }
 
-static int iwl3945_nic_set_pwr_src(struct iwl3945_priv *priv, int pwr_max)
+static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 {
 	int rc;
 	unsigned long flags;
@@ -962,7 +962,7 @@ static int iwl3945_nic_set_pwr_src(struct iwl3945_priv *priv, int pwr_max)
 	return rc;
 }
 
-static int iwl3945_rx_init(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
+static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int rc;
 	unsigned long flags;
@@ -998,7 +998,7 @@ static int iwl3945_rx_init(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
 	return 0;
 }
 
-static int iwl3945_tx_reset(struct iwl3945_priv *priv)
+static int iwl3945_tx_reset(struct iwl_priv *priv)
 {
 	int rc;
 	unsigned long flags;
@@ -1047,7 +1047,7 @@ static int iwl3945_tx_reset(struct iwl3945_priv *priv)
  *
  * Destroys all DMA structures and initialize them again
  */
-static int iwl3945_txq_ctx_reset(struct iwl3945_priv *priv)
+static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 {
 	int rc;
 	int txq_id, slots_num;
@@ -1078,7 +1078,7 @@ static int iwl3945_txq_ctx_reset(struct iwl3945_priv *priv)
 	return rc;
 }
 
-int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
+int iwl3945_hw_nic_init(struct iwl_priv *priv)
 {
 	u8 rev_id;
 	int rc;
@@ -1219,7 +1219,7 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
  *
  * Destroy all TX DMA queues and structures
  */
-void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv)
+void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 {
 	int txq_id;
 
@@ -1228,7 +1228,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv)
 		iwl3945_tx_queue_free(priv, &priv->txq39[txq_id]);
 }
 
-void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv)
+void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 {
 	int txq_id;
 	unsigned long flags;
@@ -1257,7 +1257,7 @@ void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv)
 	iwl3945_hw_txq_ctx_free(priv);
 }
 
-int iwl3945_hw_nic_stop_master(struct iwl3945_priv *priv)
+int iwl3945_hw_nic_stop_master(struct iwl_priv *priv)
 {
 	int rc = 0;
 	u32 reg_val;
@@ -1289,7 +1289,7 @@ int iwl3945_hw_nic_stop_master(struct iwl3945_priv *priv)
 	return rc;
 }
 
-int iwl3945_hw_nic_reset(struct iwl3945_priv *priv)
+int iwl3945_hw_nic_reset(struct iwl_priv *priv)
 {
 	int rc;
 	unsigned long flags;
@@ -1357,7 +1357,7 @@ static inline int iwl3945_hw_reg_temp_out_of_range(int temperature)
 	return ((temperature < -260) || (temperature > 25)) ? 1 : 0;
 }
 
-int iwl3945_hw_get_temperature(struct iwl3945_priv *priv)
+int iwl3945_hw_get_temperature(struct iwl_priv *priv)
 {
 	return iwl3945_read32(priv, CSR_UCODE_DRV_GP2);
 }
@@ -1366,7 +1366,7 @@ int iwl3945_hw_get_temperature(struct iwl3945_priv *priv)
  * iwl3945_hw_reg_txpower_get_temperature
  * get the current temperature by reading from NIC
 */
-static int iwl3945_hw_reg_txpower_get_temperature(struct iwl3945_priv *priv)
+static int iwl3945_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
 {
 	int temperature;
 
@@ -1402,7 +1402,7 @@ static int iwl3945_hw_reg_txpower_get_temperature(struct iwl3945_priv *priv)
  * records new temperature in tx_mgr->temperature.
  * replaces tx_mgr->last_temperature *only* if calib needed
  *    (assumes caller will actually do the calibration!). */
-static int is_temp_calib_needed(struct iwl3945_priv *priv)
+static int is_temp_calib_needed(struct iwl_priv *priv)
 {
 	int temp_diff;
 
@@ -1617,7 +1617,7 @@ static inline u8 iwl3945_hw_reg_fix_power_index(int index)
  * Set (in our channel info database) the direct scan Tx power for 1 Mbit (CCK)
  * or 6 Mbit (OFDM) rates.
  */
-static void iwl3945_hw_reg_set_scan_power(struct iwl3945_priv *priv, u32 scan_tbl_index,
+static void iwl3945_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_index,
 			       s32 rate_index, const s8 *clip_pwrs,
 			       struct iwl_channel_info *ch_info,
 			       int band_index)
@@ -1673,7 +1673,7 @@ static void iwl3945_hw_reg_set_scan_power(struct iwl3945_priv *priv, u32 scan_tb
  * Configures power settings for all rates for the current channel,
  * using values from channel info struct, and send to NIC
  */
-int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv)
+int iwl3945_hw_reg_send_txpower(struct iwl_priv *priv)
 {
 	int rate_idx, i;
 	const struct iwl_channel_info *ch_info = NULL;
@@ -1748,7 +1748,7 @@ int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv)
  *	 properly fill out the scan powers, and actual h/w gain settings,
  *	 and send changes to NIC
  */
-static int iwl3945_hw_reg_set_new_power(struct iwl3945_priv *priv,
+static int iwl3945_hw_reg_set_new_power(struct iwl_priv *priv,
 			     struct iwl_channel_info *ch_info)
 {
 	struct iwl3945_channel_power_info *power_info;
@@ -1839,7 +1839,7 @@ static int iwl3945_hw_reg_get_ch_txpower_limit(struct iwl_channel_info *ch_info)
  *
  * If RxOn is "associated", this sends the new Txpower to NIC!
  */
-static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
+static int iwl3945_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch_info = NULL;
 	int delta_index;
@@ -1900,7 +1900,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
 	return iwl3945_hw_reg_send_txpower(priv);
 }
 
-int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power)
+int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 {
 	struct iwl_channel_info *ch_info;
 	s8 max_power;
@@ -1943,7 +1943,7 @@ int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power)
 }
 
 /* will add 3945 channel switch cmd handling later */
-int iwl3945_hw_channel_switch(struct iwl3945_priv *priv, u16 channel)
+int iwl3945_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	return 0;
 }
@@ -1958,7 +1958,7 @@ int iwl3945_hw_channel_switch(struct iwl3945_priv *priv, u16 channel)
  *     -- send new set of gain settings to NIC
  * NOTE:  This should continue working, even when we're not associated,
  *   so we can keep our internal table of scan powers current. */
-void iwl3945_reg_txpower_periodic(struct iwl3945_priv *priv)
+void iwl3945_reg_txpower_periodic(struct iwl_priv *priv)
 {
 	/* This will kick in the "brute force"
 	 * iwl3945_hw_reg_comp_txpower_temp() below */
@@ -1977,7 +1977,7 @@ void iwl3945_reg_txpower_periodic(struct iwl3945_priv *priv)
 
 static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
 {
-	struct iwl3945_priv *priv = container_of(work, struct iwl3945_priv,
+	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 					     thermal_periodic.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -1999,7 +1999,7 @@ static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
  *	 on A-band, EEPROM's "group frequency" entries represent the top
  *	 channel in each group 1-4.  Group 5 All B/G channels are in group 0.
  */
-static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl3945_priv *priv,
+static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl_priv *priv,
 				       const struct iwl_channel_info *ch_info)
 {
 	struct iwl3945_eeprom_txpower_group *ch_grp = &priv->eeprom39.groups[0];
@@ -2033,7 +2033,7 @@ static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl3945_priv *priv,
  * Interpolate to get nominal (i.e. at factory calibration temperature) index
  *   into radio/DSP gain settings table for requested power.
  */
-static int iwl3945_hw_reg_get_matched_power_index(struct iwl3945_priv *priv,
+static int iwl3945_hw_reg_get_matched_power_index(struct iwl_priv *priv,
 				       s8 requested_power,
 				       s32 setting_index, s32 *new_index)
 {
@@ -2081,7 +2081,7 @@ static int iwl3945_hw_reg_get_matched_power_index(struct iwl3945_priv *priv,
 	return 0;
 }
 
-static void iwl3945_hw_reg_init_channel_groups(struct iwl3945_priv *priv)
+static void iwl3945_hw_reg_init_channel_groups(struct iwl_priv *priv)
 {
 	u32 i;
 	s32 rate_index;
@@ -2161,7 +2161,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl3945_priv *priv)
  *
  * This does *not* write values to NIC, just sets up our internal table.
  */
-int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv)
+int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch_info = NULL;
 	struct iwl3945_channel_power_info *pwr_info;
@@ -2285,7 +2285,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv)
 	return 0;
 }
 
-int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv)
+int iwl3945_hw_rxq_stop(struct iwl_priv *priv)
 {
 	int rc;
 	unsigned long flags;
@@ -2309,7 +2309,7 @@ int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv)
 	return 0;
 }
 
-int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
+int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 {
 	int rc;
 	unsigned long flags;
@@ -2343,7 +2343,7 @@ int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv, struct iwl3945_tx_queue
 	return 0;
 }
 
-int iwl3945_hw_get_rx_read(struct iwl3945_priv *priv)
+int iwl3945_hw_get_rx_read(struct iwl_priv *priv)
 {
 	struct iwl3945_shared *shared_data = priv->shared_virt;
 
@@ -2353,7 +2353,7 @@ int iwl3945_hw_get_rx_read(struct iwl3945_priv *priv)
 /**
  * iwl3945_init_hw_rate_table - Initialize the hardware rate fallback table
  */
-int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv)
+int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 {
 	int rc, i, index, prev_index;
 	struct iwl3945_rate_scaling_cmd rate_cmd = {
@@ -2430,7 +2430,7 @@ int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv)
 }
 
 /* Called when initializing driver */
-int iwl3945_hw_set_hw_params(struct iwl3945_priv *priv)
+int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 {
 	memset((void *)&priv->hw_params, 0,
 	       sizeof(struct iwl_hw_params));
@@ -2457,7 +2457,7 @@ int iwl3945_hw_set_hw_params(struct iwl3945_priv *priv)
 	return 0;
 }
 
-unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
+unsigned int iwl3945_hw_get_beacon_cmd(struct iwl_priv *priv,
 			  struct iwl3945_frame *frame, u8 rate)
 {
 	struct iwl3945_tx_beacon_cmd *tx_beacon_cmd;
@@ -2490,19 +2490,19 @@ unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
 	return sizeof(struct iwl3945_tx_beacon_cmd) + frame_size;
 }
 
-void iwl3945_hw_rx_handler_setup(struct iwl3945_priv *priv)
+void iwl3945_hw_rx_handler_setup(struct iwl_priv *priv)
 {
 	priv->rx_handlers[REPLY_TX] = iwl3945_rx_reply_tx;
 	priv->rx_handlers[REPLY_3945_RX] = iwl3945_rx_reply_rx;
 }
 
-void iwl3945_hw_setup_deferred_work(struct iwl3945_priv *priv)
+void iwl3945_hw_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_DELAYED_WORK(&priv->thermal_periodic,
 			  iwl3945_bg_reg_txpower_periodic);
 }
 
-void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv)
+void iwl3945_hw_cancel_deferred_work(struct iwl_priv *priv)
 {
 	cancel_delayed_work(&priv->thermal_periodic);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 788cd9c..098ac76 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -148,13 +148,13 @@ struct iwl3945_frame {
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 
 struct iwl3945_cmd;
-struct iwl3945_priv;
+struct iwl_priv;
 
 struct iwl3945_cmd_meta {
 	struct iwl3945_cmd_meta *source;
 	union {
 		struct sk_buff *skb;
-		int (*callback)(struct iwl3945_priv *priv,
+		int (*callback)(struct iwl_priv *priv,
 				struct iwl3945_cmd *cmd, struct sk_buff *skb);
 	} __attribute__ ((packed)) u;
 
@@ -270,31 +270,31 @@ struct iwl3945_ibss_seq {
  *
  *****************************************************************************/
 struct iwl3945_addsta_cmd;
-extern int iwl3945_send_add_station(struct iwl3945_priv *priv,
+extern int iwl3945_send_add_station(struct iwl_priv *priv,
 				struct iwl3945_addsta_cmd *sta, u8 flags);
-extern u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *bssid,
+extern u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *bssid,
 			  int is_ap, u8 flags);
-extern int iwl3945_power_init_handle(struct iwl3945_priv *priv);
-extern int iwl3945_eeprom_init(struct iwl3945_priv *priv);
-extern int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv);
-extern void iwl3945_rx_queue_reset(struct iwl3945_priv *priv,
+extern int iwl3945_power_init_handle(struct iwl_priv *priv);
+extern int iwl3945_eeprom_init(struct iwl_priv *priv);
+extern int iwl3945_rx_queue_alloc(struct iwl_priv *priv);
+extern void iwl3945_rx_queue_reset(struct iwl_priv *priv,
 			       struct iwl_rx_queue *rxq);
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
 extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
-extern int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
+extern int iwl3945_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl3945_tx_queue *txq, int count, u32 id);
 extern void iwl3945_rx_replenish(void *data);
-extern void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq);
-extern int iwl3945_send_cmd_pdu(struct iwl3945_priv *priv, u8 id, u16 len,
+extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue *txq);
+extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
-extern int __must_check iwl3945_send_cmd(struct iwl3945_priv *priv,
+extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
 		struct iwl3945_host_cmd *cmd);
-extern unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
+extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
-extern int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv,
+extern int iwl3945_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl_rx_queue *q);
-extern int iwl3945_send_statistics_request(struct iwl3945_priv *priv);
-extern void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
+extern int iwl3945_send_statistics_request(struct iwl_priv *priv);
+extern void iwl3945_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
 
@@ -302,7 +302,7 @@ extern void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff
  * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
  * call this... todo... fix that.
 */
-extern u8 iwl3945_sync_station(struct iwl3945_priv *priv, int sta_id,
+extern u8 iwl3945_sync_station(struct iwl_priv *priv, int sta_id,
 			   u16 tx_rate, u8 flags);
 
 /******************************************************************************
@@ -321,36 +321,36 @@ extern u8 iwl3945_sync_station(struct iwl3945_priv *priv, int sta_id,
  * iwl3945_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
-extern void iwl3945_hw_rx_handler_setup(struct iwl3945_priv *priv);
-extern void iwl3945_hw_setup_deferred_work(struct iwl3945_priv *priv);
-extern void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv);
-extern int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv);
-extern int iwl3945_hw_set_hw_params(struct iwl3945_priv *priv);
-extern int iwl3945_hw_nic_init(struct iwl3945_priv *priv);
-extern int iwl3945_hw_nic_stop_master(struct iwl3945_priv *priv);
-extern void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv);
-extern void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv);
-extern int iwl3945_hw_nic_reset(struct iwl3945_priv *priv);
-extern int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl3945_priv *priv, void *tfd,
+extern void iwl3945_hw_rx_handler_setup(struct iwl_priv *priv);
+extern void iwl3945_hw_setup_deferred_work(struct iwl_priv *priv);
+extern void iwl3945_hw_cancel_deferred_work(struct iwl_priv *priv);
+extern int iwl3945_hw_rxq_stop(struct iwl_priv *priv);
+extern int iwl3945_hw_set_hw_params(struct iwl_priv *priv);
+extern int iwl3945_hw_nic_init(struct iwl_priv *priv);
+extern int iwl3945_hw_nic_stop_master(struct iwl_priv *priv);
+extern void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv);
+extern void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv);
+extern int iwl3945_hw_nic_reset(struct iwl_priv *priv);
+extern int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
-extern int iwl3945_hw_txq_free_tfd(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq);
-extern int iwl3945_hw_get_temperature(struct iwl3945_priv *priv);
-extern int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv,
+extern int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq);
+extern int iwl3945_hw_get_temperature(struct iwl_priv *priv);
+extern int iwl3945_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl3945_tx_queue *txq);
-extern unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
+extern unsigned int iwl3945_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl3945_frame *frame, u8 rate);
-extern int iwl3945_hw_get_rx_read(struct iwl3945_priv *priv);
-extern void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
+extern int iwl3945_hw_get_rx_read(struct iwl_priv *priv);
+extern void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				     struct iwl3945_cmd *cmd,
 				     struct ieee80211_tx_info *info,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
-extern int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv);
-extern int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power);
-extern void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv,
+extern int iwl3945_hw_reg_send_txpower(struct iwl_priv *priv);
+extern int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
+extern void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb);
-extern void iwl3945_disable_events(struct iwl3945_priv *priv);
-extern int iwl4965_get_temperature(const struct iwl3945_priv *priv);
+extern void iwl3945_disable_events(struct iwl_priv *priv);
+extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 
 /**
  * iwl3945_hw_find_station - Find station id for a given BSSID
@@ -360,262 +360,43 @@ extern int iwl4965_get_temperature(const struct iwl3945_priv *priv);
  * not yet been merged into a single common layer for managing the
  * station tables.
  */
-extern u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *bssid);
+extern u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
 
-extern int iwl3945_hw_channel_switch(struct iwl3945_priv *priv, u16 channel);
+extern int iwl3945_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
-extern __le32 iwl3945_get_antenna_flags(const struct iwl3945_priv *priv);
-extern int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv);
-extern void iwl3945_reg_txpower_periodic(struct iwl3945_priv *priv);
-extern int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv);
-extern u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id,
+extern __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv);
+extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
+extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
+extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
+extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
 
 #ifdef CONFIG_IWL3945_RFKILL
-struct iwl3945_priv;
+struct iwl_priv;
 
-void iwl3945_rfkill_set_hw_state(struct iwl3945_priv *priv);
-void iwl3945_rfkill_unregister(struct iwl3945_priv *priv);
-int iwl3945_rfkill_init(struct iwl3945_priv *priv);
+void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv);
+void iwl3945_rfkill_unregister(struct iwl_priv *priv);
+int iwl3945_rfkill_init(struct iwl_priv *priv);
 #else
-static inline void iwl3945_rfkill_set_hw_state(struct iwl3945_priv *priv) {}
-static inline void iwl3945_rfkill_unregister(struct iwl3945_priv *priv) {}
-static inline int iwl3945_rfkill_init(struct iwl3945_priv *priv) { return 0; }
+static inline void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv) {}
+static inline void iwl3945_rfkill_unregister(struct iwl_priv *priv) {}
+static inline int iwl3945_rfkill_init(struct iwl_priv *priv) { return 0; }
 #endif
 
-
-struct iwl3945_priv {
-
-	/* ieee device used by generic ieee processing code */
-	struct ieee80211_hw *hw;
-	struct ieee80211_channel *ieee_channels;
-	struct ieee80211_rate *ieee_rates;
-	struct iwl_cfg *cfg; /* device configuration */
-
-	/* temporary frame storage list */
-	struct list_head free_frames;
-	int frames_count;
-
-	enum ieee80211_band band;
-	int alloc_rxb_skb;
-
-	void (*rx_handlers[REPLY_MAX])(struct iwl3945_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb);
-
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
-
-#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-	/* spectrum measurement report caching */
-	struct iwl_spectrum_notification measure_report;
-	u8 measurement_status;
-#endif
-	/* ucode beacon time */
-	u32 ucode_beacon_time;
-
-	/* we allocate array of iwl3945_channel_info for NIC's valid channels.
-	 *    Access via channel # using indirect index array */
-	struct iwl_channel_info *channel_info;	/* channel info array */
-	u8 channel_count;	/* # of channels */
-
-	/* each calibration channel group in the EEPROM has a derived
-	 * clip setting for each rate. */
-	const struct iwl3945_clip_group clip39_groups[5];
-
-	/* thermal calibration */
-	s32 temperature;	/* degrees Kelvin */
-	s32 last_temperature;
-
-	/* Scan related variables */
-	unsigned long last_scan_jiffies;
-	unsigned long next_scan_jiffies;
-	unsigned long scan_start;
-	unsigned long scan_pass_start;
-	unsigned long scan_start_tsf;
-	int scan_bands;
-	int one_direct_scan;
-	u8 direct_ssid_len;
-	u8 direct_ssid[IW_ESSID_MAX_SIZE];
-	struct iwl3945_scan_cmd *scan39;
-
-	/* spinlock */
-	spinlock_t lock;	/* protect general shared data */
-	spinlock_t hcmd_lock;	/* protect hcmd */
-	struct mutex mutex;
-
-	/* basic pci-network driver stuff */
-	struct pci_dev *pci_dev;
-
-	/* pci hardware address support */
-	void __iomem *hw_base;
-
-	/* uCode images, save to reload in case of failure */
-	u32 ucode_ver;			/* ucode version, copy of
-					   iwl_ucode.ver */
-	struct fw_desc ucode_code;	/* runtime inst */
-	struct fw_desc ucode_data;	/* runtime data original */
-	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
-	struct fw_desc ucode_init;	/* initialization inst */
-	struct fw_desc ucode_init_data;	/* initialization data */
-	struct fw_desc ucode_boot;	/* bootstrap inst */
-
-
-	struct iwl_rxon_time_cmd rxon_timing;
-
-	/* We declare this const so it can only be
-	 * changed via explicit cast within the
-	 * routines that actually update the physical
-	 * hardware */
-	const struct iwl3945_rxon_cmd active39_rxon;
-	struct iwl3945_rxon_cmd staging39_rxon;
-
-	int error_recovering;
-	struct iwl3945_rxon_cmd recovery39_rxon;
-
-	/* 1st responses from initialize and runtime uCode images.
-	 * 4965's initialize alive response contains some calibration data. */
-	/* FIXME: 4965 uses bigger structure for init */
-	struct iwl_alive_resp card_alive_init;
-	struct iwl_alive_resp card_alive;
-
-#ifdef CONFIG_IWL3945_RFKILL
-	struct rfkill *rfkill;
-#endif
-
-#ifdef CONFIG_IWL3945_LEDS
-	struct iwl3945_led led39[IWL_LED_TRG_MAX];
-	unsigned long last_blink_time;
-	u8 last_blink_rate;
-	u8 allow_blinking;
-	unsigned int rxtxpackets;
-	u64 led_tpt;
-#endif
-
-
-	u16 active_rate;
-	u16 active_rate_basic;
-
-	u32 sta_supp_rates;
-
-	u8 call_post_assoc_from_beacon;
-	/* Rate scaling data */
-	s8 data_retry_limit;
-	u8 retry_rate;
-
-	wait_queue_head_t wait_command_queue;
-
-	int activity_timer_active;
-
-	/* Rx and Tx DMA processing queues */
-	struct iwl_rx_queue rxq;
-	struct iwl3945_tx_queue txq39[IWL39_MAX_NUM_QUEUES];
-
-	unsigned long status;
-
-	int last_rx_rssi;	/* From Rx packet statisitics */
-	int last_rx_noise;	/* From beacon statistics */
-
-	struct iwl3945_power_mgr power_data_39;
-
-	struct iwl3945_notif_statistics statistics_39;
-	unsigned long last_statistics_time;
-
-	/* context information */
-	u16 rates_mask;
-
-	u32 power_mode;
-	u32 antenna;
-	u8 bssid[ETH_ALEN];
-	u16 rts_threshold;
-	u8 mac_addr[ETH_ALEN];
-
-	/*station table variables */
-	spinlock_t sta_lock;
-	int num_stations;
-	struct iwl3945_station_entry stations_39[IWL_STATION_COUNT];
-
-	/* Indication if ieee80211_ops->open has been called */
-	u8 is_open;
-
-	u8 mac80211_registered;
-
-	/* Rx'd packet timing information */
-	u32 last_beacon_time;
-	u64 last_tsf;
-
-	/* eeprom */
-	struct iwl3945_eeprom eeprom39;
-
-	enum nl80211_iftype iw_mode;
-
-	struct sk_buff *ibss_beacon;
-
-	/* Last Rx'd beacon timestamp */
-	u64 timestamp;
-	u16 beacon_int;
-	void *shared_virt;
-	dma_addr_t shared_phys;
-	struct iwl_hw_params hw_params;
-	struct ieee80211_vif *vif;
-
-	/* Current association information needed to configure the
-	 * hardware */
-	u16 assoc_id;
-	u16 assoc_capability;
-	u8 ps_mode;
-
-	struct iwl_qos_info qos_data;
-
-	struct workqueue_struct *workqueue;
-
-	struct work_struct up;
-	struct work_struct restart;
-	struct work_struct calibrated_work;
-	struct work_struct scan_completed;
-	struct work_struct rx_replenish;
-	struct work_struct rf_kill;
-	struct work_struct abort_scan;
-	struct work_struct update_link_led;
-	struct work_struct auth_work;
-	struct work_struct report_work;
-	struct work_struct request_scan;
-	struct work_struct beacon_update;
-
-	struct tasklet_struct irq_tasklet;
-
-	struct delayed_work init_alive_start;
-	struct delayed_work alive_start;
-	struct delayed_work activity_timer;
-	struct delayed_work thermal_periodic;
-	struct delayed_work gather_stats;
-	struct delayed_work scan_check;
-
-#define IWL_DEFAULT_TX_POWER 0x0F
-	s8 user_txpower_limit;
-	s8 max_channel_txpower_limit;
-
-
-#ifdef CONFIG_IWL3945_DEBUG
-	/* debugging info */
-	u32 debug_level;
-	u32 framecnt_to_us;
-	atomic_t restrict_refcnt;
-#endif
-};				/*iwl3945_priv */
-
-static inline int iwl3945_is_associated(struct iwl3945_priv *priv)
+static inline int iwl3945_is_associated(struct iwl_priv *priv)
 {
 	return (priv->active39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
 extern const struct iwl_channel_info *iwl3945_get_channel_info(
-	const struct iwl3945_priv *priv, enum ieee80211_band band, u16 channel);
+	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
-extern int iwl3945_rs_next_rate(struct iwl3945_priv *priv, int rate);
+extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
 
-/* Requires full declaration of iwl3945_priv before including */
+/* Requires full declaration of iwl_priv before including */
 #include "iwl-3945-io.h"
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9904406..5cc6c5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -40,6 +40,7 @@
 #include "iwl-eeprom.h"
 #include "iwl-4965-hw.h"
 #include "iwl-3945-hw.h"
+#include "iwl-3945-led.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-debug.h"
@@ -835,7 +836,7 @@ struct iwl_priv {
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
-#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
+#if defined(CONFIG_IWLAGN_SPECTRUM_MEASUREMENT) || defined(CONFIG_IWL3945_SPECTRUM_MEASUREMENT)
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
@@ -916,18 +917,25 @@ struct iwl_priv {
 	 * 4965's initialize alive response contains some calibration data. */
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;
-#ifdef CONFIG_IWLWIFI_RFKILL
+#if defined(CONFIG_IWLWIFI_RFKILL) || defined(CONFIG_IWL3945_RFKILL)
 	struct rfkill *rfkill;
 #endif
 
-#ifdef CONFIG_IWLWIFI_LEDS
-	struct iwl_led led[IWL_LED_TRG_MAX];
+#if defined(CONFIG_IWLWIFI_LEDS) || defined(CONFIG_IWL3945_LEDS)
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
 	u8 allow_blinking;
 	u64 led_tpt;
 #endif
 
+#ifdef CONFIG_IWLWIFI_LEDS
+	struct iwl_led led[IWL_LED_TRG_MAX];
+#endif
+
+#ifdef CONFIG_IWL3945_LEDS
+	struct iwl3945_led led39[IWL_LED_TRG_MAX];
+	unsigned int rxtxpackets;
+#endif
 	u16 active_rate;
 	u16 active_rate_basic;
 
@@ -1048,12 +1056,16 @@ struct iwl_priv {
 	struct delayed_work init_alive_start;
 	struct delayed_work alive_start;
 	struct delayed_work scan_check;
+
+	/*For 3945 only*/
+	struct delayed_work thermal_periodic;
+
 	/* TX Power */
 	s8 tx_power_user_lmt;
 	s8 tx_power_channel_lmt;
 
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWL3945_DEBUG)
 	/* debugging info */
 	u32 debug_level;
 	u32 framecnt_to_us;
@@ -1070,6 +1082,35 @@ struct iwl_priv {
 	u32 disable_tx_power_cal;
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
+
+	/*For 3945*/
+#define IWL_DEFAULT_TX_POWER 0x0F
+	s8 user_txpower_limit;
+	s8 max_channel_txpower_limit;
+
+	struct iwl3945_scan_cmd *scan39;
+
+	/* We declare this const so it can only be
+	 * changed via explicit cast within the
+	 * routines that actually update the physical
+	 * hardware */
+	const struct iwl3945_rxon_cmd active39_rxon;
+	struct iwl3945_rxon_cmd staging39_rxon;
+	struct iwl3945_rxon_cmd recovery39_rxon;
+
+	struct iwl3945_tx_queue txq39[IWL39_MAX_NUM_QUEUES];
+
+	struct iwl3945_power_mgr power_data_39;
+	struct iwl3945_notif_statistics statistics_39;
+
+	struct iwl3945_station_entry stations_39[IWL_STATION_COUNT];
+
+	/* eeprom */
+	struct iwl3945_eeprom eeprom39;
+
+	u32 sta_supp_rates;
+	u8 call_post_assoc_from_beacon;
+
 }; /*iwl_priv */
 
 static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 00c22f5..fbf800f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -55,7 +55,7 @@
 #include "iwl-core.h"
 #include "iwl-dev.h"
 
-static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
+static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl3945_tx_queue *txq);
 
 /******************************************************************************
@@ -103,7 +103,7 @@ MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
 static const struct ieee80211_supported_band *iwl3945_get_band(
-		struct iwl3945_priv *priv, enum ieee80211_band band)
+		struct iwl_priv *priv, enum ieee80211_band band)
 {
 	return priv->hw->wiphy->bands[band];
 }
@@ -143,7 +143,7 @@ int iwl3945_x2_queue_used(const struct iwl_queue *q, int i)
 /**
  * iwl3945_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl_queue *q,
+static int iwl3945_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
@@ -174,7 +174,7 @@ static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl_queue *q,
 /**
  * iwl3945_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
  */
-static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
+static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
 			      struct iwl3945_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
@@ -217,7 +217,7 @@ static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
 /**
  * iwl3945_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
-int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
+int iwl3945_tx_queue_init(struct iwl_priv *priv,
 		      struct iwl3945_tx_queue *txq, int slots_num, u32 txq_id)
 {
 	struct pci_dev *dev = priv->pci_dev;
@@ -269,7 +269,7 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
+void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 {
 	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
@@ -315,7 +315,7 @@ void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *t
  *
  * NOTE:  This does not remove station from device's station table.
  */
-static u8 iwl3945_remove_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap)
+static u8 iwl3945_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
 	int i;
@@ -357,7 +357,7 @@ out:
  *
  * NOTE:  This does not clear or otherwise alter the device's station table.
  */
-static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
+static void iwl3945_clear_stations_table(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
@@ -372,7 +372,7 @@ static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
 /**
  * iwl3945_add_station - Add station to station tables in driver and device
  */
-u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8 flags)
+u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 {
 	int i;
 	int index = IWL_INVALID_STATION;
@@ -443,7 +443,7 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
 
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
-static inline int iwl3945_is_ready(struct iwl3945_priv *priv)
+static inline int iwl3945_is_ready(struct iwl_priv *priv)
 {
 	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
 	 * set but EXIT_PENDING is not */
@@ -452,33 +452,33 @@ static inline int iwl3945_is_ready(struct iwl3945_priv *priv)
 	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
 }
 
-static inline int iwl3945_is_alive(struct iwl3945_priv *priv)
+static inline int iwl3945_is_alive(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_ALIVE, &priv->status);
 }
 
-static inline int iwl3945_is_init(struct iwl3945_priv *priv)
+static inline int iwl3945_is_init(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_INIT, &priv->status);
 }
 
-static inline int iwl3945_is_rfkill_sw(struct iwl3945_priv *priv)
+static inline int iwl3945_is_rfkill_sw(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_RF_KILL_SW, &priv->status);
 }
 
-static inline int iwl3945_is_rfkill_hw(struct iwl3945_priv *priv)
+static inline int iwl3945_is_rfkill_hw(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_RF_KILL_HW, &priv->status);
 }
 
-static inline int iwl3945_is_rfkill(struct iwl3945_priv *priv)
+static inline int iwl3945_is_rfkill(struct iwl_priv *priv)
 {
 	return iwl3945_is_rfkill_hw(priv) ||
 		iwl3945_is_rfkill_sw(priv);
 }
 
-static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
+static inline int iwl3945_is_ready_rf(struct iwl_priv *priv)
 {
 
 	if (iwl3945_is_rfkill(priv))
@@ -501,7 +501,7 @@ static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
  * failed. On success, it turns the index (> 0) of command in the
  * command queue.
  */
-static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq39[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
@@ -580,7 +580,7 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
 	return ret ? ret : idx;
 }
 
-static int iwl3945_send_cmd_async(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_send_cmd_async(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	int ret;
 
@@ -604,7 +604,7 @@ static int iwl3945_send_cmd_async(struct iwl3945_priv *priv, struct iwl3945_host
 	return 0;
 }
 
-static int iwl3945_send_cmd_sync(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
@@ -692,7 +692,7 @@ out:
 	return ret;
 }
 
-int iwl3945_send_cmd(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
+int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl3945_send_cmd_async(priv, cmd);
@@ -700,7 +700,7 @@ int iwl3945_send_cmd(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
 	return iwl3945_send_cmd_sync(priv, cmd);
 }
 
-int iwl3945_send_cmd_pdu(struct iwl3945_priv *priv, u8 id, u16 len, const void *data)
+int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
 {
 	struct iwl3945_host_cmd cmd = {
 		.id = id,
@@ -711,7 +711,7 @@ int iwl3945_send_cmd_pdu(struct iwl3945_priv *priv, u8 id, u16 len, const void *
 	return iwl3945_send_cmd_sync(priv, &cmd);
 }
 
-static int __must_check iwl3945_send_cmd_u32(struct iwl3945_priv *priv, u8 id, u32 val)
+static int __must_check iwl3945_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
 {
 	struct iwl3945_host_cmd cmd = {
 		.id = id,
@@ -722,7 +722,7 @@ static int __must_check iwl3945_send_cmd_u32(struct iwl3945_priv *priv, u8 id, u
 	return iwl3945_send_cmd_sync(priv, &cmd);
 }
 
-int iwl3945_send_statistics_request(struct iwl3945_priv *priv)
+int iwl3945_send_statistics_request(struct iwl_priv *priv)
 {
 	return iwl3945_send_cmd_u32(priv, REPLY_STATISTICS_CMD, 0);
 }
@@ -737,7 +737,7 @@ int iwl3945_send_statistics_request(struct iwl3945_priv *priv)
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the band
  */
-static int iwl3945_set_rxon_channel(struct iwl3945_priv *priv,
+static int iwl3945_set_rxon_channel(struct iwl_priv *priv,
 				    enum ieee80211_band band,
 				    u16 channel)
 {
@@ -771,7 +771,7 @@ static int iwl3945_set_rxon_channel(struct iwl3945_priv *priv,
  * be #ifdef'd out once the driver is stable and folks aren't actively
  * making changes
  */
-static int iwl3945_check_rxon_cmd(struct iwl3945_priv *priv)
+static int iwl3945_check_rxon_cmd(struct iwl_priv *priv)
 {
 	int error = 0;
 	int counter = 1;
@@ -852,7 +852,7 @@ static int iwl3945_check_rxon_cmd(struct iwl3945_priv *priv)
  * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
  * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
-static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
+static int iwl3945_full_rxon_required(struct iwl_priv *priv)
 {
 
 	/* These items are only settable from the full RXON command */
@@ -887,7 +887,7 @@ static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
 	return 0;
 }
 
-static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
+static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct iwl_rx_packet *res = NULL;
@@ -939,7 +939,7 @@ static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
+static int iwl3945_commit_rxon(struct iwl_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
 	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active39_rxon;
@@ -1058,7 +1058,7 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 	return 0;
 }
 
-static int iwl3945_send_bt_config(struct iwl3945_priv *priv)
+static int iwl3945_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
 		.flags = 3,
@@ -1072,7 +1072,7 @@ static int iwl3945_send_bt_config(struct iwl3945_priv *priv)
 					sizeof(bt_cmd), &bt_cmd);
 }
 
-static int iwl3945_send_scan_abort(struct iwl3945_priv *priv)
+static int iwl3945_send_scan_abort(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct iwl_rx_packet *res;
@@ -1113,7 +1113,7 @@ static int iwl3945_send_scan_abort(struct iwl3945_priv *priv)
 	return rc;
 }
 
-static int iwl3945_card_state_sync_callback(struct iwl3945_priv *priv,
+static int iwl3945_card_state_sync_callback(struct iwl_priv *priv,
 					struct iwl3945_cmd *cmd,
 					struct sk_buff *skb)
 {
@@ -1130,7 +1130,7 @@ static int iwl3945_card_state_sync_callback(struct iwl3945_priv *priv,
  * When in the 'halt' state, the card is shut down and must be fully
  * restarted to come back on.
  */
-static int iwl3945_send_card_state(struct iwl3945_priv *priv, u32 flags, u8 meta_flag)
+static int iwl3945_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 {
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_CARD_STATE_CMD,
@@ -1145,7 +1145,7 @@ static int iwl3945_send_card_state(struct iwl3945_priv *priv, u32 flags, u8 meta
 	return iwl3945_send_cmd(priv, &cmd);
 }
 
-static int iwl3945_add_sta_sync_callback(struct iwl3945_priv *priv,
+static int iwl3945_add_sta_sync_callback(struct iwl_priv *priv,
 				     struct iwl3945_cmd *cmd, struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
@@ -1173,7 +1173,7 @@ static int iwl3945_add_sta_sync_callback(struct iwl3945_priv *priv,
 	return 1;
 }
 
-int iwl3945_send_add_station(struct iwl3945_priv *priv,
+int iwl3945_send_add_station(struct iwl_priv *priv,
 			 struct iwl3945_addsta_cmd *sta, u8 flags)
 {
 	struct iwl_rx_packet *res = NULL;
@@ -1220,7 +1220,7 @@ int iwl3945_send_add_station(struct iwl3945_priv *priv,
 	return rc;
 }
 
-static int iwl3945_update_sta_key_info(struct iwl3945_priv *priv,
+static int iwl3945_update_sta_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
@@ -1258,7 +1258,7 @@ static int iwl3945_update_sta_key_info(struct iwl3945_priv *priv,
 	return 0;
 }
 
-static int iwl3945_clear_sta_key_info(struct iwl3945_priv *priv, u8 sta_id)
+static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 {
 	unsigned long flags;
 
@@ -1276,7 +1276,7 @@ static int iwl3945_clear_sta_key_info(struct iwl3945_priv *priv, u8 sta_id)
 	return 0;
 }
 
-static void iwl3945_clear_free_frames(struct iwl3945_priv *priv)
+static void iwl3945_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
 
@@ -1297,7 +1297,7 @@ static void iwl3945_clear_free_frames(struct iwl3945_priv *priv)
 	}
 }
 
-static struct iwl3945_frame *iwl3945_get_free_frame(struct iwl3945_priv *priv)
+static struct iwl3945_frame *iwl3945_get_free_frame(struct iwl_priv *priv)
 {
 	struct iwl3945_frame *frame;
 	struct list_head *element;
@@ -1317,13 +1317,13 @@ static struct iwl3945_frame *iwl3945_get_free_frame(struct iwl3945_priv *priv)
 	return list_entry(element, struct iwl3945_frame, list);
 }
 
-static void iwl3945_free_frame(struct iwl3945_priv *priv, struct iwl3945_frame *frame)
+static void iwl3945_free_frame(struct iwl_priv *priv, struct iwl3945_frame *frame)
 {
 	memset(frame, 0, sizeof(*frame));
 	list_add(&frame->list, &priv->free_frames);
 }
 
-unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
+unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 				struct ieee80211_hdr *hdr,
 				int left)
 {
@@ -1341,7 +1341,7 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-static u8 iwl3945_rate_get_lowest_plcp(struct iwl3945_priv *priv)
+static u8 iwl3945_rate_get_lowest_plcp(struct iwl_priv *priv)
 {
 	u8 i;
 	int rate_mask;
@@ -1365,7 +1365,7 @@ static u8 iwl3945_rate_get_lowest_plcp(struct iwl3945_priv *priv)
 		return IWL_RATE_6M_PLCP;
 }
 
-static int iwl3945_send_beacon_cmd(struct iwl3945_priv *priv)
+static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl3945_frame *frame;
 	unsigned int frame_size;
@@ -1398,7 +1398,7 @@ static int iwl3945_send_beacon_cmd(struct iwl3945_priv *priv)
  *
  ******************************************************************************/
 
-static void get_eeprom_mac(struct iwl3945_priv *priv, u8 *mac)
+static void get_eeprom_mac(struct iwl_priv *priv, u8 *mac)
 {
 	memcpy(mac, priv->eeprom39.mac_address, 6);
 }
@@ -1411,7 +1411,7 @@ static void get_eeprom_mac(struct iwl3945_priv *priv, u8 *mac)
  * simply claims ownership, which should be safe when this function is called
  * (i.e. before loading uCode!).
  */
-static inline int iwl3945_eeprom_acquire_semaphore(struct iwl3945_priv *priv)
+static inline int iwl3945_eeprom_acquire_semaphore(struct iwl_priv *priv)
 {
 	_iwl3945_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
 	return 0;
@@ -1424,7 +1424,7 @@ static inline int iwl3945_eeprom_acquire_semaphore(struct iwl3945_priv *priv)
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
-int iwl3945_eeprom_init(struct iwl3945_priv *priv)
+int iwl3945_eeprom_init(struct iwl_priv *priv)
 {
 	u16 *e = (u16 *)&priv->eeprom39;
 	u32 gp = iwl3945_read32(priv, CSR_EEPROM_GP);
@@ -1472,7 +1472,7 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 	return 0;
 }
 
-static void iwl3945_unset_hw_params(struct iwl3945_priv *priv)
+static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 {
 	if (priv->shared_virt)
 		pci_free_consistent(priv->pci_dev,
@@ -1513,7 +1513,7 @@ static u16 iwl3945_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 /**
  * iwl3945_fill_probe_req - fill in all required fields and IE for probe request
  */
-static u16 iwl3945_fill_probe_req(struct iwl3945_priv *priv,
+static u16 iwl3945_fill_probe_req(struct iwl_priv *priv,
 			      struct ieee80211_mgmt *frame,
 			      int left)
 {
@@ -1593,7 +1593,7 @@ static u16 iwl3945_fill_probe_req(struct iwl3945_priv *priv,
 /*
  * QoS  support
 */
-static int iwl3945_send_qos_params_command(struct iwl3945_priv *priv,
+static int iwl3945_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl_qosparam_cmd *qos)
 {
 
@@ -1601,7 +1601,7 @@ static int iwl3945_send_qos_params_command(struct iwl3945_priv *priv,
 				sizeof(struct iwl_qosparam_cmd), qos);
 }
 
-static void iwl3945_reset_qos(struct iwl3945_priv *priv)
+static void iwl3945_reset_qos(struct iwl_priv *priv)
 {
 	u16 cw_min = 15;
 	u16 cw_max = 1023;
@@ -1692,7 +1692,7 @@ static void iwl3945_reset_qos(struct iwl3945_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
+static void iwl3945_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
 
@@ -1762,7 +1762,7 @@ static struct iwl_power_vec_entry range_1[IWL39_POWER_AC] = {
 		 SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
-int iwl3945_power_init_handle(struct iwl3945_priv *priv)
+int iwl3945_power_init_handle(struct iwl_priv *priv)
 {
 	int rc = 0, i;
 	struct iwl3945_power_mgr *pow_data;
@@ -1801,7 +1801,7 @@ int iwl3945_power_init_handle(struct iwl3945_priv *priv)
 	return rc;
 }
 
-static int iwl3945_update_power_cmd(struct iwl3945_priv *priv,
+static int iwl3945_update_power_cmd(struct iwl_priv *priv,
 				struct iwl_powertable_cmd *cmd, u32 mode)
 {
 	int rc = 0, i;
@@ -1865,7 +1865,7 @@ static int iwl3945_update_power_cmd(struct iwl3945_priv *priv,
 	return rc;
 }
 
-static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode)
+static int iwl3945_send_power_mode(struct iwl_priv *priv, u32 mode)
 {
 	u32 uninitialized_var(final_mode);
 	int rc;
@@ -1905,7 +1905,7 @@ static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode)
  *
  * NOTE: priv->mutex is not required before calling this function
  */
-static int iwl3945_scan_cancel(struct iwl3945_priv *priv)
+static int iwl3945_scan_cancel(struct iwl_priv *priv)
 {
 	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
 		clear_bit(STATUS_SCANNING, &priv->status);
@@ -1933,7 +1933,7 @@ static int iwl3945_scan_cancel(struct iwl3945_priv *priv)
  *
  * NOTE: priv->mutex must be held before calling this function
  */
-static int iwl3945_scan_cancel_timeout(struct iwl3945_priv *priv, unsigned long ms)
+static int iwl3945_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
 	unsigned long now = jiffies;
 	int ret;
@@ -1968,7 +1968,7 @@ static __le16 iwl3945_adjust_beacon_interval(u16 beacon_val)
 	return cpu_to_le16(new_val);
 }
 
-static void iwl3945_setup_rxon_timing(struct iwl3945_priv *priv)
+static void iwl3945_setup_rxon_timing(struct iwl_priv *priv)
 {
 	u64 interval_tm_unit;
 	u64 tsf, result;
@@ -2021,7 +2021,7 @@ static void iwl3945_setup_rxon_timing(struct iwl3945_priv *priv)
 		le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
+static int iwl3945_scan_initiate(struct iwl_priv *priv)
 {
 	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
@@ -2053,7 +2053,7 @@ static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
 	return 0;
 }
 
-static int iwl3945_set_rxon_hwcrypto(struct iwl3945_priv *priv, int hw_decrypt)
+static int iwl3945_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
 	struct iwl3945_rxon_cmd *rxon = &priv->staging39_rxon;
 
@@ -2065,7 +2065,7 @@ static int iwl3945_set_rxon_hwcrypto(struct iwl3945_priv *priv, int hw_decrypt)
 	return 0;
 }
 
-static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv,
+static void iwl3945_set_flags_for_phymode(struct iwl_priv *priv,
 					  enum ieee80211_band band)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
@@ -2092,7 +2092,7 @@ static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv,
 /*
  * initialize rxon structure with default values from eeprom
  */
-static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
+static void iwl3945_connection_init_rx_config(struct iwl_priv *priv,
 					      int mode)
 {
 	const struct iwl_channel_info *ch_info;
@@ -2162,7 +2162,7 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
 	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
 }
 
-static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
+static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 {
 	if (mode == NL80211_IFTYPE_ADHOC) {
 		const struct iwl_channel_info *ch_info;
@@ -2199,7 +2199,7 @@ static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 	return 0;
 }
 
-static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
+static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_info *info,
 				      struct iwl3945_cmd *cmd,
 				      struct sk_buff *skb_frag,
@@ -2249,7 +2249,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
 /*
  * handle build REPLY_TX command notification.
  */
-static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
+static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 				  struct iwl3945_cmd *cmd,
 				  struct ieee80211_tx_info *info,
 				  struct ieee80211_hdr *hdr,
@@ -2316,7 +2316,7 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 /**
  * iwl3945_get_sta_id - Find station's index within station table
  */
-static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *hdr)
+static int iwl3945_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 {
 	int sta_id;
 	u16 fc = le16_to_cpu(hdr->frame_control);
@@ -2375,7 +2375,7 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 /*
  * start REPLY_TX command process
  */
-static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
+static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -2600,7 +2600,7 @@ drop:
 	return -1;
 }
 
-static void iwl3945_set_rate(struct iwl3945_priv *priv)
+static void iwl3945_set_rate(struct iwl_priv *priv)
 {
 	const struct ieee80211_supported_band *sband = NULL;
 	struct ieee80211_rate *rate;
@@ -2654,7 +2654,7 @@ static void iwl3945_set_rate(struct iwl3945_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-static void iwl3945_radio_kill_sw(struct iwl3945_priv *priv, int disable_radio)
+static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 {
 	unsigned long flags;
 
@@ -2704,7 +2704,7 @@ static void iwl3945_radio_kill_sw(struct iwl3945_priv *priv, int disable_radio)
 	return;
 }
 
-void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
+void iwl3945_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 			    u32 decrypt_res, struct ieee80211_rx_status *stats)
 {
 	u16 fc =
@@ -2789,7 +2789,7 @@ static __le32 iwl3945_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
 	return cpu_to_le32(res);
 }
 
-static int iwl3945_get_measurement(struct iwl3945_priv *priv,
+static int iwl3945_get_measurement(struct iwl_priv *priv,
 			       struct ieee80211_measurement_params *params,
 			       u8 type)
 {
@@ -2868,7 +2868,7 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 }
 #endif
 
-static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
+static void iwl3945_rx_reply_alive(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2904,7 +2904,7 @@ static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
 		IWL_WARNING("uCode did not respond OK.\n");
 }
 
-static void iwl3945_rx_reply_add_sta(struct iwl3945_priv *priv,
+static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2913,7 +2913,7 @@ static void iwl3945_rx_reply_add_sta(struct iwl3945_priv *priv,
 	return;
 }
 
-static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
+static void iwl3945_rx_reply_error(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2929,7 +2929,7 @@ static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active39_rxon;
@@ -2940,7 +2940,7 @@ static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl_rx_mem_buffer *
 	priv->staging39_rxon.channel = csa->channel;
 }
 
-static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
@@ -2958,7 +2958,7 @@ static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
 #endif
 }
 
-static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
@@ -2969,7 +2969,7 @@ static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
 #endif
 }
 
-static void iwl3945_rx_pm_debug_statistics_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2982,8 +2982,8 @@ static void iwl3945_rx_pm_debug_statistics_notif(struct iwl3945_priv *priv,
 
 static void iwl3945_bg_beacon_update(struct work_struct *work)
 {
-	struct iwl3945_priv *priv =
-		container_of(work, struct iwl3945_priv, beacon_update);
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, beacon_update);
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
@@ -3005,7 +3005,7 @@ static void iwl3945_bg_beacon_update(struct work_struct *work)
 	iwl3945_send_beacon_cmd(priv);
 }
 
-static void iwl3945_rx_beacon_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
@@ -3028,7 +3028,7 @@ static void iwl3945_rx_beacon_notif(struct iwl3945_priv *priv,
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
-static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
+static void iwl3945_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
@@ -3041,7 +3041,7 @@ static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
 }
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
-static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_scan_start_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3058,7 +3058,7 @@ static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
-static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_scan_results_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3083,7 +3083,7 @@ static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
-static void iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3146,7 +3146,7 @@ reschedule:
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static void iwl3945_rx_card_state_notif(struct iwl3945_priv *priv,
+static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3191,7 +3191,7 @@ static void iwl3945_rx_card_state_notif(struct iwl3945_priv *priv,
  * This function chains into the hardware specific files for them to setup
  * any hardware specific handlers as well.
  */
-static void iwl3945_setup_rx_handlers(struct iwl3945_priv *priv)
+static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 {
 	priv->rx_handlers[REPLY_ALIVE] = iwl3945_rx_reply_alive;
 	priv->rx_handlers[REPLY_ADD_STA] = iwl3945_rx_reply_add_sta;
@@ -3229,7 +3229,7 @@ static void iwl3945_setup_rx_handlers(struct iwl3945_priv *priv)
  * When FW advances 'R' index, all entries between old and new 'R' index
  * need to be reclaimed.
  */
-static void iwl3945_cmd_queue_reclaim(struct iwl3945_priv *priv,
+static void iwl3945_cmd_queue_reclaim(struct iwl_priv *priv,
 				      int txq_id, int index)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
@@ -3264,7 +3264,7 @@ static void iwl3945_cmd_queue_reclaim(struct iwl3945_priv *priv,
  * will be executed.  The attached skb (if present) will only be freed
  * if the callback returns 1
  */
-static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
+static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
@@ -3379,7 +3379,7 @@ static int iwl3945_rx_queue_space(const struct iwl_rx_queue *q)
 /**
  * iwl3945_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  */
-int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl_rx_queue *q)
+int iwl3945_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 {
 	u32 reg = 0;
 	int rc = 0;
@@ -3425,7 +3425,7 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl_rx_q
 /**
  * iwl3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
-static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl3945_priv *priv,
+static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl_priv *priv,
 					  dma_addr_t dma_addr)
 {
 	return cpu_to_le32((u32)dma_addr);
@@ -3442,7 +3442,7 @@ static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl3945_priv *priv,
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
+static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -3494,7 +3494,7 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
  * Also restock the Rx queue via iwl3945_rx_queue_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
+static void iwl3945_rx_allocate(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -3544,7 +3544,7 @@ static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
  */
 static void __iwl3945_rx_replenish(void *data)
 {
-	struct iwl3945_priv *priv = data;
+	struct iwl_priv *priv = data;
 
 	iwl3945_rx_allocate(priv);
 	iwl3945_rx_queue_restock(priv);
@@ -3553,7 +3553,7 @@ static void __iwl3945_rx_replenish(void *data)
 
 void iwl3945_rx_replenish(void *data)
 {
-	struct iwl3945_priv *priv = data;
+	struct iwl_priv *priv = data;
 	unsigned long flags;
 
 	iwl3945_rx_allocate(priv);
@@ -3568,7 +3568,7 @@ void iwl3945_rx_replenish(void *data)
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
-static void iwl3945_rx_queue_free(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
+static void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
@@ -3585,7 +3585,7 @@ static void iwl3945_rx_queue_free(struct iwl3945_priv *priv, struct iwl_rx_queue
 	rxq->bd = NULL;
 }
 
-int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv)
+int iwl3945_rx_queue_alloc(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct pci_dev *dev = priv->pci_dev;
@@ -3612,7 +3612,7 @@ int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv)
 	return 0;
 }
 
-void iwl3945_rx_queue_reset(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
+void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	unsigned long flags;
 	int i;
@@ -3726,7 +3726,7 @@ int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm)
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
-static void iwl3945_rx_handle(struct iwl3945_priv *priv)
+static void iwl3945_rx_handle(struct iwl_priv *priv)
 {
 	struct iwl_rx_mem_buffer *rxb;
 	struct iwl_rx_packet *pkt;
@@ -3834,7 +3834,7 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 /**
  * iwl3945_tx_queue_update_write_ptr - Send new write index to hardware
  */
-static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
+static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl3945_tx_queue *txq)
 {
 	u32 reg = 0;
@@ -3878,7 +3878,7 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
 }
 
 #ifdef CONFIG_IWL3945_DEBUG
-static void iwl3945_print_rx_config_cmd(struct iwl3945_priv *priv,
+static void iwl3945_print_rx_config_cmd(struct iwl_priv *priv,
 					struct iwl3945_rxon_cmd *rxon)
 {
 	DECLARE_MAC_BUF(mac);
@@ -3901,7 +3901,7 @@ static void iwl3945_print_rx_config_cmd(struct iwl3945_priv *priv,
 }
 #endif
 
-static void iwl3945_enable_interrupts(struct iwl3945_priv *priv)
+static void iwl3945_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
@@ -3910,7 +3910,7 @@ static void iwl3945_enable_interrupts(struct iwl3945_priv *priv)
 
 
 /* call this function to flush any scheduled tasklet */
-static inline void iwl_synchronize_irq(struct iwl3945_priv *priv)
+static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 {
 	/* wait to make sure we flush pending tasklet*/
 	synchronize_irq(priv->pci_dev->irq);
@@ -3918,7 +3918,7 @@ static inline void iwl_synchronize_irq(struct iwl3945_priv *priv)
 }
 
 
-static inline void iwl3945_disable_interrupts(struct iwl3945_priv *priv)
+static inline void iwl3945_disable_interrupts(struct iwl_priv *priv)
 {
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
 
@@ -3955,7 +3955,7 @@ static const char *desc_lookup(int i)
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
 #define ERROR_ELEM_SIZE     (7 * sizeof(u32))
 
-static void iwl3945_dump_nic_error_log(struct iwl3945_priv *priv)
+static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 {
 	u32 i;
 	u32 desc, time, count, base, data1;
@@ -4018,7 +4018,7 @@ static void iwl3945_dump_nic_error_log(struct iwl3945_priv *priv)
  *
  * NOTE: Must be called with iwl3945_grab_nic_access() already obtained!
  */
-static void iwl3945_print_event_log(struct iwl3945_priv *priv, u32 start_idx,
+static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
 {
 	u32 i;
@@ -4056,7 +4056,7 @@ static void iwl3945_print_event_log(struct iwl3945_priv *priv, u32 start_idx,
 	}
 }
 
-static void iwl3945_dump_nic_event_log(struct iwl3945_priv *priv)
+static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 {
 	int rc;
 	u32 base;       /* SRAM byte address of event log header */
@@ -4111,7 +4111,7 @@ static void iwl3945_dump_nic_event_log(struct iwl3945_priv *priv)
 /**
  * iwl3945_irq_handle_error - called for HW or SW error interrupt from card
  */
-static void iwl3945_irq_handle_error(struct iwl3945_priv *priv)
+static void iwl3945_irq_handle_error(struct iwl_priv *priv)
 {
 	/* Set the FW error flag -- cleared on iwl3945_down */
 	set_bit(STATUS_FW_ERROR, &priv->status);
@@ -4146,7 +4146,7 @@ static void iwl3945_irq_handle_error(struct iwl3945_priv *priv)
 	}
 }
 
-static void iwl3945_error_recovery(struct iwl3945_priv *priv)
+static void iwl3945_error_recovery(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
@@ -4163,7 +4163,7 @@ static void iwl3945_error_recovery(struct iwl3945_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
+static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 {
 	u32 inta, handled = 0;
 	u32 inta_fh;
@@ -4305,7 +4305,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 
 static irqreturn_t iwl3945_isr(int irq, void *data)
 {
-	struct iwl3945_priv *priv = data;
+	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
 	u32 inta_fh;
 	if (!priv)
@@ -4413,7 +4413,7 @@ static const u8 iwl3945_eeprom_band_5[] = {	/* 5725-5825MHz */
 	145, 149, 153, 157, 161, 165
 };
 
-static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int band,
+static void iwl3945_init_band_reference(const struct iwl_priv *priv, int band,
 				    int *eeprom_ch_count,
 				    const struct iwl_eeprom_channel
 				    **eeprom_ch_info,
@@ -4457,7 +4457,7 @@ static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int ban
  * Based on band and channel number.
  */
 const struct iwl_channel_info *
-iwl3945_get_channel_info(const struct iwl3945_priv *priv,
+iwl3945_get_channel_info(const struct iwl_priv *priv,
 			 enum ieee80211_band band, u16 channel)
 {
 	int i;
@@ -4487,7 +4487,7 @@ iwl3945_get_channel_info(const struct iwl3945_priv *priv,
 /**
  * iwl3945_init_channel_map - Set up driver's info for all possible channels
  */
-static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
+static int iwl3945_init_channel_map(struct iwl_priv *priv)
 {
 	int eeprom_ch_count = 0;
 	const u8 *eeprom_ch_index = NULL;
@@ -4606,7 +4606,7 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 /*
  * iwl3945_free_channel_map - undo allocations in iwl3945_init_channel_map
  */
-static void iwl3945_free_channel_map(struct iwl3945_priv *priv)
+static void iwl3945_free_channel_map(struct iwl_priv *priv)
 {
 	kfree(priv->channel_info);
 	priv->channel_count = 0;
@@ -4640,7 +4640,7 @@ static void iwl3945_free_channel_map(struct iwl3945_priv *priv)
 
 #define IWL_SCAN_PROBE_MASK(n)	 (BIT(n) | (BIT(n) - BIT(1)))
 
-static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv,
+static inline u16 iwl3945_get_active_dwell_time(struct iwl_priv *priv,
 						enum ieee80211_band band,
 						u8 n_probes)
 {
@@ -4652,7 +4652,7 @@ static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv,
 			IWL_ACTIVE_DWELL_FACTOR_24GHZ * (n_probes + 1);
 }
 
-static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
+static u16 iwl3945_get_passive_dwell_time(struct iwl_priv *priv,
 					  enum ieee80211_band band)
 {
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
@@ -4672,7 +4672,7 @@ static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
 	return passive;
 }
 
-static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
+static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 					 enum ieee80211_band band,
 				     u8 is_active, u8 n_probes,
 				     struct iwl3945_scan_channel *scan_ch)
@@ -4766,7 +4766,7 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 	return added;
 }
 
-static void iwl3945_init_hw_rates(struct iwl3945_priv *priv,
+static void iwl3945_init_hw_rates(struct iwl_priv *priv,
 			      struct ieee80211_rate *rates)
 {
 	int i;
@@ -4789,7 +4789,7 @@ static void iwl3945_init_hw_rates(struct iwl3945_priv *priv,
 /**
  * iwl3945_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
-static int iwl3945_init_geos(struct iwl3945_priv *priv)
+static int iwl3945_init_geos(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch;
 	struct ieee80211_supported_band *sband;
@@ -4911,7 +4911,7 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 /*
  * iwl3945_free_geos - undo allocations in iwl3945_init_geos
  */
-static void iwl3945_free_geos(struct iwl3945_priv *priv)
+static void iwl3945_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
@@ -4924,7 +4924,7 @@ static void iwl3945_free_geos(struct iwl3945_priv *priv)
  *
  ******************************************************************************/
 
-static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
+static void iwl3945_dealloc_ucode_pci(struct iwl_priv *priv)
 {
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_code);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data);
@@ -4938,7 +4938,7 @@ static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
  * iwl3945_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
-static int iwl3945_verify_inst_full(struct iwl3945_priv *priv, __le32 *image, u32 len)
+static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 len)
 {
 	u32 val;
 	u32 save_len = len;
@@ -4985,7 +4985,7 @@ static int iwl3945_verify_inst_full(struct iwl3945_priv *priv, __le32 *image, u3
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl3945_verify_inst_sparse(struct iwl3945_priv *priv, __le32 *image, u32 len)
+static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 {
 	u32 val;
 	int rc = 0;
@@ -5028,7 +5028,7 @@ static int iwl3945_verify_inst_sparse(struct iwl3945_priv *priv, __le32 *image,
  * iwl3945_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl3945_verify_ucode(struct iwl3945_priv *priv)
+static int iwl3945_verify_ucode(struct iwl_priv *priv)
 {
 	__le32 *image;
 	u32 len;
@@ -5075,7 +5075,7 @@ static int iwl3945_verify_ucode(struct iwl3945_priv *priv)
 
 
 /* check contents of special bootstrap uCode SRAM */
-static int iwl3945_verify_bsm(struct iwl3945_priv *priv)
+static int iwl3945_verify_bsm(struct iwl_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -5137,7 +5137,7 @@ static int iwl3945_verify_bsm(struct iwl3945_priv *priv)
  * the runtime uCode instructions and the backup data cache into SRAM,
  * and re-launches the runtime uCode from where it left off.
  */
-static int iwl3945_load_bsm(struct iwl3945_priv *priv)
+static int iwl3945_load_bsm(struct iwl_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -5223,7 +5223,7 @@ static int iwl3945_load_bsm(struct iwl3945_priv *priv)
 	return 0;
 }
 
-static void iwl3945_nic_start(struct iwl3945_priv *priv)
+static void iwl3945_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
 	iwl3945_write32(priv, CSR_RESET, 0);
@@ -5234,7 +5234,7 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
  *
  * Copy into buffers for card to fetch via bus-mastering
  */
-static int iwl3945_read_ucode(struct iwl3945_priv *priv)
+static int iwl3945_read_ucode(struct iwl_priv *priv)
 {
 	struct iwl_ucode *ucode;
 	int ret = -EINVAL, index;
@@ -5475,7 +5475,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
  * We need to replace them to load runtime uCode inst and data,
  * and to save runtime data when powering down.
  */
-static int iwl3945_set_ucode_ptrs(struct iwl3945_priv *priv)
+static int iwl3945_set_ucode_ptrs(struct iwl_priv *priv)
 {
 	dma_addr_t pinst;
 	dma_addr_t pdata;
@@ -5520,7 +5520,7 @@ static int iwl3945_set_ucode_ptrs(struct iwl3945_priv *priv)
  *
  * Tell "initialize" uCode to go ahead and load the runtime uCode.
  */
-static void iwl3945_init_alive_start(struct iwl3945_priv *priv)
+static void iwl3945_init_alive_start(struct iwl_priv *priv)
 {
 	/* Check alive response for "valid" sign from uCode */
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
@@ -5566,7 +5566,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw,
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by iwl3945_init_alive_start()).
  */
-static void iwl3945_alive_start(struct iwl3945_priv *priv)
+static void iwl3945_alive_start(struct iwl_priv *priv)
 {
 	int rc = 0;
 	int thermal_spin = 0;
@@ -5678,9 +5678,9 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-static void iwl3945_cancel_deferred_work(struct iwl3945_priv *priv);
+static void iwl3945_cancel_deferred_work(struct iwl_priv *priv);
 
-static void __iwl3945_down(struct iwl3945_priv *priv)
+static void __iwl3945_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
@@ -5779,7 +5779,7 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 	iwl3945_clear_free_frames(priv);
 }
 
-static void iwl3945_down(struct iwl3945_priv *priv)
+static void iwl3945_down(struct iwl_priv *priv)
 {
 	mutex_lock(&priv->mutex);
 	__iwl3945_down(priv);
@@ -5790,7 +5790,7 @@ static void iwl3945_down(struct iwl3945_priv *priv)
 
 #define MAX_HW_RESTARTS 5
 
-static int __iwl3945_up(struct iwl3945_priv *priv)
+static int __iwl3945_up(struct iwl_priv *priv)
 {
 	int rc, i;
 
@@ -5894,8 +5894,8 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 
 static void iwl3945_bg_init_alive_start(struct work_struct *data)
 {
-	struct iwl3945_priv *priv =
-	    container_of(data, struct iwl3945_priv, init_alive_start.work);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, init_alive_start.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -5907,8 +5907,8 @@ static void iwl3945_bg_init_alive_start(struct work_struct *data)
 
 static void iwl3945_bg_alive_start(struct work_struct *data)
 {
-	struct iwl3945_priv *priv =
-	    container_of(data, struct iwl3945_priv, alive_start.work);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, alive_start.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -5920,7 +5920,7 @@ static void iwl3945_bg_alive_start(struct work_struct *data)
 
 static void iwl3945_bg_rf_kill(struct work_struct *work)
 {
-	struct iwl3945_priv *priv = container_of(work, struct iwl3945_priv, rf_kill);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
 
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -5954,8 +5954,8 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 
 static void iwl3945_bg_scan_check(struct work_struct *data)
 {
-	struct iwl3945_priv *priv =
-	    container_of(data, struct iwl3945_priv, scan_check.work);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, scan_check.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -5975,8 +5975,8 @@ static void iwl3945_bg_scan_check(struct work_struct *data)
 
 static void iwl3945_bg_request_scan(struct work_struct *data)
 {
-	struct iwl3945_priv *priv =
-	    container_of(data, struct iwl3945_priv, request_scan);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, request_scan);
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl3945_scan_cmd),
@@ -6171,7 +6171,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 static void iwl3945_bg_up(struct work_struct *data)
 {
-	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv, up);
+	struct iwl_priv *priv = container_of(data, struct iwl_priv, up);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6184,7 +6184,7 @@ static void iwl3945_bg_up(struct work_struct *data)
 
 static void iwl3945_bg_restart(struct work_struct *data)
 {
-	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv, restart);
+	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6195,8 +6195,8 @@ static void iwl3945_bg_restart(struct work_struct *data)
 
 static void iwl3945_bg_rx_replenish(struct work_struct *data)
 {
-	struct iwl3945_priv *priv =
-	    container_of(data, struct iwl3945_priv, rx_replenish);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, rx_replenish);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6208,7 +6208,7 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
-static void iwl3945_post_associate(struct iwl3945_priv *priv)
+static void iwl3945_post_associate(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
@@ -6302,7 +6302,7 @@ static void iwl3945_post_associate(struct iwl3945_priv *priv)
 
 static void iwl3945_bg_abort_scan(struct work_struct *work)
 {
-	struct iwl3945_priv *priv = container_of(work, struct iwl3945_priv, abort_scan);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
 	if (!iwl3945_is_ready(priv))
 		return;
@@ -6319,8 +6319,8 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed);
 
 static void iwl3945_bg_scan_completed(struct work_struct *work)
 {
-	struct iwl3945_priv *priv =
-	    container_of(work, struct iwl3945_priv, scan_completed);
+	struct iwl_priv *priv =
+	    container_of(work, struct iwl_priv, scan_completed);
 
 	IWL_DEBUG(IWL_DL_INFO | IWL_DL_SCAN, "SCAN complete scan\n");
 
@@ -6349,7 +6349,7 @@ static void iwl3945_bg_scan_completed(struct work_struct *work)
 
 static int iwl3945_mac_start(struct ieee80211_hw *hw)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int ret;
 
 	IWL_DEBUG_MAC80211("enter\n");
@@ -6428,7 +6428,7 @@ out_disable_msi:
 
 static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -6461,7 +6461,7 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 
 static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -6478,7 +6478,7 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
@@ -6520,7 +6520,7 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
  */
 static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
 	unsigned long flags;
@@ -6603,7 +6603,7 @@ out:
 	return ret;
 }
 
-static void iwl3945_config_ap(struct iwl3945_priv *priv)
+static void iwl3945_config_ap(struct iwl_priv *priv)
 {
 	int rc = 0;
 
@@ -6664,7 +6664,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
 	int rc;
 
@@ -6767,7 +6767,7 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 				 unsigned int *total_flags,
 				 int mc_count, struct dev_addr_list *mc_list)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	__le32 *filter_flags = &priv->staging39_rxon.filter_flags;
 
 	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
@@ -6811,7 +6811,7 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_if_init_conf *conf)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -6838,7 +6838,7 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("changes = 0x%X\n", changes);
 
@@ -6890,7 +6890,7 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
 	unsigned long flags;
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	DECLARE_SSID_BUF(ssid_buf);
 
 	IWL_DEBUG_MAC80211("enter\n");
@@ -6943,7 +6943,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int rc = 0;
 	u8 sta_id;
 
@@ -7003,7 +7003,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 	int q;
 
@@ -7049,7 +7049,7 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 				struct ieee80211_tx_queue_stats *stats)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	int i, avail;
 	struct iwl3945_tx_queue *txq;
 	struct iwl_queue *q;
@@ -7083,7 +7083,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 
 static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
@@ -7142,7 +7142,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 
 static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct iwl3945_priv *priv = hw->priv;
+	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
 	IWL_DEBUG_MAC80211("enter\n");
@@ -7195,7 +7195,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 static ssize_t show_debug_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = d->driver_data;
+	struct iwl_priv *priv = d->driver_data;
 
 	return sprintf(buf, "0x%08X\n", priv->debug_level);
 }
@@ -7203,7 +7203,7 @@ static ssize_t store_debug_level(struct device *d,
 				struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl3945_priv *priv = d->driver_data;
+	struct iwl_priv *priv = d->driver_data;
 	unsigned long val;
 	int ret;
 
@@ -7225,7 +7225,7 @@ static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
@@ -7238,7 +7238,7 @@ static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
 static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	return sprintf(buf, "%d\n", priv->user_txpower_limit);
 }
 
@@ -7246,7 +7246,7 @@ static ssize_t store_tx_power(struct device *d,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	char *p = (char *)buf;
 	u32 val;
 
@@ -7265,7 +7265,7 @@ static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
 static ssize_t show_flags(struct device *d,
 			  struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n", priv->active39_rxon.flags);
 }
@@ -7274,7 +7274,7 @@ static ssize_t store_flags(struct device *d,
 			   struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	u32 flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
@@ -7299,7 +7299,7 @@ static DEVICE_ATTR(flags, S_IWUSR | S_IRUGO, show_flags, store_flags);
 static ssize_t show_filter_flags(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n",
 		le32_to_cpu(priv->active39_rxon.filter_flags));
@@ -7309,7 +7309,7 @@ static ssize_t store_filter_flags(struct device *d,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
@@ -7338,7 +7338,7 @@ static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct iwl_spectrum_notification measure_report;
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
 	u8 *data = (u8 *)&measure_report;
@@ -7371,7 +7371,7 @@ static ssize_t store_measurement(struct device *d,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct ieee80211_measurement_params params = {
 		.channel = le16_to_cpu(priv->active39_rxon.channel),
 		.start_time = cpu_to_le64(priv->last_tsf),
@@ -7410,7 +7410,7 @@ static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 
 	priv->retry_rate = simple_strtoul(buf, NULL, 0);
 	if (priv->retry_rate <= 0)
@@ -7422,7 +7422,7 @@ static ssize_t store_retry_rate(struct device *d,
 static ssize_t show_retry_rate(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "%d", priv->retry_rate);
 }
 
@@ -7433,7 +7433,7 @@ static ssize_t store_power_level(struct device *d,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	int rc;
 	int mode;
 
@@ -7488,7 +7488,7 @@ static const s32 period_duration[] = {
 static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	int level = IWL_POWER_LEVEL(priv->power_mode);
 	char *p = buf;
 
@@ -7532,7 +7532,7 @@ static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 	u32 size = sizeof(struct iwl3945_notif_statistics);
 	u32 len = 0, ofs = 0;
 	u8 *data = (u8 *)&priv->statistics_39;
@@ -7570,7 +7570,7 @@ static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
 static ssize_t show_antenna(struct device *d,
 			    struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 
 	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
@@ -7583,7 +7583,7 @@ static ssize_t store_antenna(struct device *d,
 			     const char *buf, size_t count)
 {
 	int ant;
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl_priv *priv = dev_get_drvdata(d);
 
 	if (count == 0)
 		return 0;
@@ -7608,7 +7608,7 @@ static DEVICE_ATTR(antenna, S_IWUSR | S_IRUGO, show_antenna, store_antenna);
 static ssize_t show_status(struct device *d,
 			   struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
 	return sprintf(buf, "0x%08x\n", (int)priv->status);
@@ -7623,7 +7623,7 @@ static ssize_t dump_error_log(struct device *d,
 	char *p = (char *)buf;
 
 	if (p[0] == '1')
-		iwl3945_dump_nic_error_log((struct iwl3945_priv *)d->driver_data);
+		iwl3945_dump_nic_error_log((struct iwl_priv *)d->driver_data);
 
 	return strnlen(buf, count);
 }
@@ -7637,7 +7637,7 @@ static ssize_t dump_event_log(struct device *d,
 	char *p = (char *)buf;
 
 	if (p[0] == '1')
-		iwl3945_dump_nic_event_log((struct iwl3945_priv *)d->driver_data);
+		iwl3945_dump_nic_event_log((struct iwl_priv *)d->driver_data);
 
 	return strnlen(buf, count);
 }
@@ -7650,7 +7650,7 @@ static DEVICE_ATTR(dump_events, S_IWUSR, NULL, dump_event_log);
  *
  *****************************************************************************/
 
-static void iwl3945_setup_deferred_work(struct iwl3945_priv *priv)
+static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->workqueue = create_workqueue(DRV_NAME);
 
@@ -7674,7 +7674,7 @@ static void iwl3945_setup_deferred_work(struct iwl3945_priv *priv)
 		     iwl3945_irq_tasklet, (unsigned long)priv);
 }
 
-static void iwl3945_cancel_deferred_work(struct iwl3945_priv *priv)
+static void iwl3945_cancel_deferred_work(struct iwl_priv *priv)
 {
 	iwl3945_hw_cancel_deferred_work(priv);
 
@@ -7731,7 +7731,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
-	struct iwl3945_priv *priv;
+	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	unsigned long flags;
@@ -7743,7 +7743,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
-	hw = ieee80211_alloc_hw(sizeof(struct iwl3945_priv), &iwl3945_hw_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwl3945_hw_ops);
 	if (hw == NULL) {
 		printk(KERN_ERR DRV_NAME "Can not allocate network device\n");
 		err = -ENOMEM;
@@ -8006,7 +8006,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	unsigned long flags;
 
 	if (!priv)
@@ -8069,7 +8069,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	if (priv->is_open) {
 		set_bit(STATUS_IN_SUSPEND, &priv->status);
@@ -8084,7 +8084,7 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int iwl3945_pci_resume(struct pci_dev *pdev)
 {
-	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
 
@@ -8102,7 +8102,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 /* software rf-kill from user */
 static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 {
-	struct iwl3945_priv *priv = data;
+	struct iwl_priv *priv = data;
 	int err = 0;
 
 	if (!priv->rfkill)
@@ -8135,7 +8135,7 @@ out_unlock:
 	return err;
 }
 
-int iwl3945_rfkill_init(struct iwl3945_priv *priv)
+int iwl3945_rfkill_init(struct iwl_priv *priv)
 {
 	struct device *device = wiphy_dev(priv->hw->wiphy);
 	int ret = 0;
@@ -8178,7 +8178,7 @@ error:
 	return ret;
 }
 
-void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
+void iwl3945_rfkill_unregister(struct iwl_priv *priv)
 {
 	if (priv->rfkill)
 		rfkill_unregister(priv->rfkill);
@@ -8187,7 +8187,7 @@ void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
 }
 
 /* set rf-kill to the right state. */
-void iwl3945_rfkill_set_hw_state(struct iwl3945_priv *priv)
+void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv)
 {
 
 	if (!priv->rfkill)
-- 
1.5.3.6

