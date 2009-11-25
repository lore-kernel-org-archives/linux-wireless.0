Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:8471 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbZKYMJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 07:09:38 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 2/5] libertas: introduce mesh.h
Date: Wed, 25 Nov 2009 13:09:32 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911251309.32155.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -6,6 +6,7 @@
 #ifndef _LBS_DEV_H_
 #define _LBS_DEV_H_
 
+#include "mesh.h"
 #include "scan.h"
 #include "assoc.h"
 
@@ -21,17 +22,6 @@
 	uint16_t sp_reserved;
 };
 
-/* Mesh statistics */
-struct lbs_mesh_stats {
-	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
-	u32	fwd_unicast_cnt;	/* Fwd: Unicast counter */
-	u32	fwd_drop_ttl;		/* Fwd: TTL zero */
-	u32	fwd_drop_rbt;		/* Fwd: Recently Broadcasted */
-	u32	fwd_drop_noroute; 	/* Fwd: No route to Destination */
-	u32	fwd_drop_nobuf;		/* Fwd: Run out of internal buffers */
-	u32	drop_blind;		/* Rx:  Dropped by blinding table */
-	u32	tx_failed_cnt;		/* Tx:  Failed transmissions */
-};
 
 /** Private structure for the MV device */
 struct lbs_private {
--- /dev/null
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -0,0 +1,32 @@
+/**
+  * Contains all definitions needed for the Libertas' MESH implementation.
+  */
+#ifndef _LBS_MESH_H_
+#define _LBS_MESH_H_
+
+
+#include <net/iw_handler.h>
+
+
+/* Mesh statistics */
+struct lbs_mesh_stats {
+	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
+	u32	fwd_unicast_cnt;	/* Fwd: Unicast counter */
+	u32	fwd_drop_ttl;		/* Fwd: TTL zero */
+	u32	fwd_drop_rbt;		/* Fwd: Recently Broadcasted */
+	u32	fwd_drop_noroute; 	/* Fwd: No route to Destination */
+	u32	fwd_drop_nobuf;		/* Fwd: Run out of internal buffers */
+	u32	drop_blind;		/* Rx:  Dropped by blinding table */
+	u32	tx_failed_cnt;		/* Tx:  Failed transmissions */
+};
+
+
+struct net_device;
+
+void lbs_persist_config_init(struct net_device *net);
+void lbs_persist_config_remove(struct net_device *net);
+
+extern struct iw_handler_def mesh_handler_def;
+
+
+#endif
--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -27,11 +27,6 @@
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
 
-/* persistcfg.c */
-void lbs_persist_config_init(struct net_device *net);
-void lbs_persist_config_remove(struct net_device *net);
-
-
 /* main.c */
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
 void lbs_remove_card(struct lbs_private *priv);
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -7,12 +7,11 @@
 void lbs_send_disconnect_notification(struct lbs_private *priv);
 void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
 
-extern struct iw_handler_def lbs_handler_def;
-extern struct iw_handler_def mesh_handler_def;
-
 struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
 	struct lbs_private *priv,
 	u8 band,
 	u16 channel);
 
+extern struct iw_handler_def lbs_handler_def;
+
 #endif

-- 
http://www.holgerschurig.de
