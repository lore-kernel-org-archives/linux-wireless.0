Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39797 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab1G0C10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 22:27:26 -0400
Subject: [PATCH 2/3] ath5k: clean up base.h and its use
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 22:26:59 -0400
Message-ID: <20110727022659.27981.44569.stgit@mj.roinet.com> (sfid-20110727_042730_163381_BAA489A9)
In-Reply-To: <20110727022652.27981.27951.stgit@mj.roinet.com>
References: <20110727022652.27981.27951.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary includes from base.h.  Add includes to other files as
necessary.  Don't include base.h unless needed.

Move declarations for functions in base.c from ath5k.h to base.h.

Use a better named define to protect base.h against double inclusion.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ani.c          |    1 
 drivers/net/wireless/ath/ath5k/ani.h          |    4 ++
 drivers/net/wireless/ath/ath5k/ath5k.h        |   34 ----------------
 drivers/net/wireless/ath/ath5k/attach.c       |    1 
 drivers/net/wireless/ath/ath5k/base.c         |    3 +
 drivers/net/wireless/ath/ath5k/base.h         |   54 +++++++++++++++++++------
 drivers/net/wireless/ath/ath5k/caps.c         |    2 -
 drivers/net/wireless/ath/ath5k/debug.c        |   15 +++----
 drivers/net/wireless/ath/ath5k/desc.c         |    1 
 drivers/net/wireless/ath/ath5k/dma.c          |    1 
 drivers/net/wireless/ath/ath5k/eeprom.c       |    1 
 drivers/net/wireless/ath/ath5k/gpio.c         |    1 
 drivers/net/wireless/ath/ath5k/initvals.c     |    1 
 drivers/net/wireless/ath/ath5k/led.c          |    1 
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +
 drivers/net/wireless/ath/ath5k/pcu.c          |    1 
 drivers/net/wireless/ath/ath5k/phy.c          |    2 -
 drivers/net/wireless/ath/ath5k/qcu.c          |    1 
 drivers/net/wireless/ath/ath5k/reset.c        |    1 
 drivers/net/wireless/ath/ath5k/rfkill.c       |    2 -
 drivers/net/wireless/ath/ath5k/sysfs.c        |    1 
 drivers/net/wireless/ath/ath5k/trace.h        |    3 +
 22 files changed, 62 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 603ae15..bea90e6 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -15,7 +15,6 @@
  */
 
 #include "ath5k.h"
-#include "base.h"
 #include "reg.h"
 #include "debug.h"
 #include "ani.h"
diff --git a/drivers/net/wireless/ath/ath5k/ani.h b/drivers/net/wireless/ath/ath5k/ani.h
index 0340153..7358b6c 100644
--- a/drivers/net/wireless/ath/ath5k/ani.h
+++ b/drivers/net/wireless/ath/ath5k/ani.h
@@ -16,6 +16,10 @@
 #ifndef ANI_H
 #define ANI_H
 
+#include "../ath.h"
+
+enum ath5k_phy_error_code;
+
 /* these thresholds are relative to the ATH5K_ANI_LISTEN_PERIOD */
 #define ATH5K_ANI_LISTEN_PERIOD		100
 #define ATH5K_ANI_OFDM_TRIG_HIGH	500
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 277d5cb..e918894 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -295,17 +295,6 @@ enum ath5k_radio {
  * Common silicon revision/version values
  */
 
-enum ath5k_srev_type {
-	AR5K_VERSION_MAC,
-	AR5K_VERSION_RAD,
-};
-
-struct ath5k_srev_name {
-	const char		*sr_name;
-	enum ath5k_srev_type	sr_type;
-	u_int			sr_val;
-};
-
 #define AR5K_SREV_UNKNOWN	0xffff
 
 #define AR5K_SREV_AR5210	0x00 /* Crete */
@@ -1327,36 +1316,13 @@ struct ath_bus_ops {
 extern const struct ieee80211_ops ath5k_hw_ops;
 
 /* Initialization and detach functions */
-int ath5k_init_softc(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops);
-void ath5k_deinit_softc(struct ath5k_hw *ah);
 int ath5k_hw_init(struct ath5k_hw *ah);
 void ath5k_hw_deinit(struct ath5k_hw *ah);
 
 int ath5k_sysfs_register(struct ath5k_hw *ah);
 void ath5k_sysfs_unregister(struct ath5k_hw *ah);
 
-/* base.c */
-struct ath5k_buf;
-struct ath5k_txq;
-
-void ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable);
-bool ath5k_any_vif_assoc(struct ath5k_hw *ah);
-void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
-		    struct ath5k_txq *txq);
-int ath5k_start(struct ieee80211_hw *hw);
-void ath5k_stop(struct ieee80211_hw *hw);
-void ath5k_mode_setup(struct ath5k_hw *ah, struct ieee80211_vif *vif);
-void ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
-					struct ieee80211_vif *vif);
-int ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan);
-void ath5k_beacon_update_timers(struct ath5k_hw *ah, u64 bc_tsf);
-int ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
-void ath5k_beacon_config(struct ath5k_hw *ah);
-void ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
-void ath5k_rxbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
-
 /*Chip id helper functions */
-const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
 int ath5k_hw_read_srev(struct ath5k_hw *ah);
 
 /* LED functions */
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index f8a6b38..f50530d 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -25,7 +25,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 /**
  * ath5k_hw_post - Power On Self Test helper function
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a74d286..58b478f 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -51,6 +51,7 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/etherdevice.h>
+#include <linux/nl80211.h>
 
 #include <net/ieee80211_radiotap.h>
 
@@ -60,6 +61,8 @@
 #include "reg.h"
 #include "debug.h"
 #include "ani.h"
+#include "ath5k.h"
+#include "../regd.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index a81f28d..1eb2db8 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -38,19 +38,27 @@
 /*
  * Definitions for the Atheros Wireless LAN controller driver.
  */
-#ifndef _DEV_ATH_ATHVAR_H
-#define _DEV_ATH_ATHVAR_H
+#ifndef _DEV_ATH5K_BASE_H
+#define _DEV_ATH5K_BASE_H
 
-#include <linux/interrupt.h>
-#include <linux/list.h>
-#include <linux/wireless.h>
-#include <linux/if_ether.h>
-#include <linux/rfkill.h>
-#include <linux/workqueue.h>
+struct ieee80211_vif;
+struct ieee80211_hw;
+struct ath5k_hw;
+struct ath5k_txq;
+struct ieee80211_channel;
+struct ath_bus_ops;
+enum nl80211_iftype;
 
-#include "ath5k.h"
-#include "../regd.h"
-#include "../ath.h"
+enum ath5k_srev_type {
+	AR5K_VERSION_MAC,
+	AR5K_VERSION_RAD,
+};
+
+struct ath5k_srev_name {
+	const char		*sr_name;
+	enum ath5k_srev_type	sr_type;
+	u_int			sr_val;
+};
 
 struct ath5k_buf {
 	struct list_head	list;
@@ -78,8 +86,30 @@ struct ath5k_vif_iter_data {
 	enum nl80211_iftype opmode;
 	int n_stas;
 };
+
 void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif);
+bool ath5k_any_vif_assoc(struct ath5k_hw *ah);
+
+int ath5k_start(struct ieee80211_hw *hw);
+void ath5k_stop(struct ieee80211_hw *hw);
+
+void ath5k_beacon_update_timers(struct ath5k_hw *ah, u64 bc_tsf);
+int ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+void ath5k_beacon_config(struct ath5k_hw *ah);
+void ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable);
+
+void ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
+					struct ieee80211_vif *vif);
+int ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan);
+void ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
+void ath5k_rxbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
+void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
+		    struct ath5k_txq *txq);
+
+const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
 
+int ath5k_init_softc(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops);
+void ath5k_deinit_softc(struct ath5k_hw *ah);
 
 /* Check whether BSSID mask is supported */
 #define ath5k_hw_hasbssidmask(_ah) (ah->ah_version == AR5K_AR5212)
@@ -87,4 +117,4 @@ void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif);
 /* Check whether virtual EOL is supported */
 #define ath5k_hw_hasveol(_ah) (ah->ah_version != AR5K_AR5210)
 
-#endif
+#endif	/* _DEV_ATH5K_BASE_H */
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index eefe670..810fba9 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -24,7 +24,7 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
+#include "../regd.h"
 
 /*
  * Fill the capabilities struct
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index ccca724..fce8c90 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -58,19 +58,18 @@
  * THE POSSIBILITY OF SUCH DAMAGES.
  */
 
-#include "base.h"
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/list.h>
 #include "debug.h"
+#include "ath5k.h"
+#include "reg.h"
+#include "base.h"
 
 static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
 
 
-#ifdef CONFIG_ATH5K_DEBUG
-
-#include <linux/seq_file.h>
-#include "reg.h"
-#include "ani.h"
-
 static int ath5k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -1031,5 +1030,3 @@ ath5k_debug_printtxbuf(struct ath5k_hw *ah, struct ath5k_buf *bf)
 		td->tx_stat.tx_status_0, td->tx_stat.tx_status_1,
 		done ? ' ' : (ts.ts_status == 0) ? '*' : '!');
 }
-
-#endif /* ifdef CONFIG_ATH5K_DEBUG */
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 846535f..7e88dda 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -24,7 +24,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 
 /************************\
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 0d5d403..2481f9c 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -35,7 +35,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 
 /*********\
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 9068b91..0324f26 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -26,7 +26,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 
 /******************\
diff --git a/drivers/net/wireless/ath/ath5k/gpio.c b/drivers/net/wireless/ath/ath5k/gpio.c
index bc90503..8592978 100644
--- a/drivers/net/wireless/ath/ath5k/gpio.c
+++ b/drivers/net/wireless/ath/ath5k/gpio.c
@@ -23,7 +23,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 /*
  * Set led state
diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 5ab607f..1ffecc0 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -22,7 +22,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 /*
  * Mode-independent initial register writes
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 8c17a00..c1151c7 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -41,7 +41,6 @@
 
 #include <linux/pci.h>
 #include "ath5k.h"
-#include "base.h"
 
 #define ATH_SDEVICE(subv, subd) \
 	.vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 2a715ca..b68469b 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -41,8 +41,10 @@
  *
  */
 
+#include <net/mac80211.h>
 #include <asm/unaligned.h>
 
+#include "ath5k.h"
 #include "base.h"
 #include "reg.h"
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 0673138..83d23c4 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -29,7 +29,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 /*
  * AR5212+ can use higher rates for ack transmission
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 81e465e..e22bb7b 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -26,9 +26,9 @@
 
 #include "ath5k.h"
 #include "reg.h"
-#include "base.h"
 #include "rfbuffer.h"
 #include "rfgain.h"
+#include "../regd.h"
 
 
 /******************\
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 65f1039..6232bb7 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -23,7 +23,6 @@ Queue Control Unit, DFS Control Unit Functions
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
-#include "base.h"
 
 
 /******************\
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 0686c5d..f098b40 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -30,7 +30,6 @@
 #include <linux/platform_device.h>
 #include "ath5k.h"
 #include "reg.h"
-#include "base.h"
 #include "debug.h"
 
 
diff --git a/drivers/net/wireless/ath/ath5k/rfkill.c b/drivers/net/wireless/ath/ath5k/rfkill.c
index 945fc9f..270a319 100644
--- a/drivers/net/wireless/ath/ath5k/rfkill.c
+++ b/drivers/net/wireless/ath/ath5k/rfkill.c
@@ -33,7 +33,7 @@
  * THE POSSIBILITY OF SUCH DAMAGES.
  */
 
-#include "base.h"
+#include "ath5k.h"
 
 
 static inline void ath5k_rfkill_disable(struct ath5k_hw *ah)
diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index 0244a36..9364da7 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -1,7 +1,6 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 
-#include "base.h"
 #include "ath5k.h"
 #include "reg.h"
 
diff --git a/drivers/net/wireless/ath/ath5k/trace.h b/drivers/net/wireless/ath/ath5k/trace.h
index c741c87..39f002e 100644
--- a/drivers/net/wireless/ath/ath5k/trace.h
+++ b/drivers/net/wireless/ath/ath5k/trace.h
@@ -2,7 +2,6 @@
 #define __TRACE_ATH5K_H
 
 #include <linux/tracepoint.h>
-#include "base.h"
 
 #ifndef CONFIG_ATH5K_TRACER
 #undef TRACE_EVENT
@@ -11,6 +10,8 @@ static inline void trace_ ## name(proto) {}
 #endif
 
 struct sk_buff;
+struct ath5k_txq;
+struct ath5k_tx_status;
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM ath5k
