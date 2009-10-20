Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:31145 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZJTMoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 08:44:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH, v2] libertas: sort and categorize entries in decl.h
Date: Tue, 20 Oct 2009 14:44:34 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <200910191527.04100.hs4233@mail.mn-solutions.de>
In-Reply-To: <200910191527.04100.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910201444.35005.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[PATCH, v2] libertas: sort and categorize entries in decl.h

This now makes decl.h only contain declarations for functions that don't
have their own *.h file.

No functional change.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---
v2: compilation fix

--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -8,46 +8,30 @@
 
 #include <linux/netdevice.h>
 
-#include "defs.h"
 
-
-extern const struct ethtool_ops lbs_ethtool_ops;
-
-/** Function Prototype Declaration */
 struct lbs_private;
 struct sk_buff;
 struct net_device;
-struct cmd_ctrl_node;
-struct cmd_ds_command;
 
-int lbs_suspend(struct lbs_private *priv);
-void lbs_resume(struct lbs_private *priv);
-
-void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count);
 
-void lbs_queue_event(struct lbs_private *priv, u32 event);
-void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
-int lbs_enter_auto_deep_sleep(struct lbs_private *priv);
-int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
+/* ethtool.c */
+extern const struct ethtool_ops lbs_ethtool_ops;
 
-u32 lbs_fw_index_to_data_rate(u8 index);
-u8 lbs_data_rate_to_fw_index(u32 rate);
 
-/** The proc fs interface */
+/* tx.c */
+void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count);
 netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *dev);
 
+/* rx.c */
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
-struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-	struct lbs_private *priv,
-	u8 band,
-	u16 channel);
 
 /* persistcfg.c */
 void lbs_persist_config_init(struct net_device *net);
 void lbs_persist_config_remove(struct net_device *net);
 
+
 /* main.c */
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
 void lbs_remove_card(struct lbs_private *priv);
@@ -55,5 +39,17 @@
 void lbs_stop_card(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
+int lbs_suspend(struct lbs_private *priv);
+void lbs_resume(struct lbs_private *priv);
+
+void lbs_queue_event(struct lbs_private *priv, u32 event);
+void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
+
+int lbs_enter_auto_deep_sleep(struct lbs_private *priv);
+int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
+
+u32 lbs_fw_index_to_data_rate(u8 index);
+u8 lbs_data_rate_to_fw_index(u32 rate);
+
 
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -12,10 +12,10 @@
 #include <net/lib80211.h>
 
 #include "host.h"
-#include "decl.h"
 #include "dev.h"
 #include "scan.h"
 #include "assoc.h"
+#include "wext.h"
 #include "cmd.h"
 
 //! Approximate amount of data needed to pass a scan result back to iwlist
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -10,4 +10,9 @@
 extern struct iw_handler_def lbs_handler_def;
 extern struct iw_handler_def mesh_handler_def;
 
+struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
+	struct lbs_private *priv,
+	u8 band,
+	u16 channel);
+
 #endif


-- 
http://www.holgerschurig.de
