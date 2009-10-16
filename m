Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:33560 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbZJPPet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 11:34:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] libertas: harmonize cmd.h
Date: Fri, 16 Oct 2009 17:33:23 +0200
Cc: Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910161733.23868.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* move declarations for functions of cmd.c/cmdresp.c into cmd.h
* move declarations from cmd.h that are in main.c to decl.h
* group command functions

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
+++ linux-wl/drivers/net/wireless/libertas/cmd.h
@@ -6,8 +6,27 @@
 #include "host.h"
 #include "dev.h"
 
+
+/* Command & response transfer between host and card */
+
+struct cmd_ctrl_node {
+	struct list_head list;
+	int result;
+	/* command response */
+	int (*callback)(struct lbs_private *,
+			unsigned long,
+			struct cmd_header *);
+	unsigned long callback_arg;
+	/* command data */
+	struct cmd_header *cmdbuf;
+	/* wait queue */
+	u16 cmdwaitqwoken;
+	wait_queue_head_t cmdwait_q;
+};
+
+
 /* lbs_cmd() infers the size of the buffer to copy data back into, from
-   the size of the target of the pointer. Since the command to be sent 
+   the size of the target of the pointer. Since the command to be sent
    may often be smaller, that size is set in cmd->size by the caller.*/
 #define lbs_cmd(priv, cmdnr, cmd, cb, cb_arg)	({		\
 	uint16_t __sz = le16_to_cpu((cmd)->hdr.size);		\
@@ -18,6 +37,11 @@
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
 
+int lbs_prepare_and_send_command(struct lbs_private *priv,
+	u16 cmd_no,
+	u16 cmd_action,
+	u16 wait_option, u32 cmd_oid, void *pdata_buf);
+
 void lbs_cmd_async(struct lbs_private *priv, uint16_t command,
 	struct cmd_header *in_cmd, int in_cmd_size);
 
@@ -31,62 +55,102 @@
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	unsigned long callback_arg);
 
-int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
-		int8_t p1, int8_t p2);
+int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
+		     struct cmd_header *resp);
 
-int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
-		int8_t p2, int usesnr);
+int lbs_allocate_cmd_buffer(struct lbs_private *priv);
+int lbs_free_cmd_buffer(struct lbs_private *priv);
 
-int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
-		int8_t p1, int8_t p2);
+int lbs_execute_next_command(struct lbs_private *priv);
+void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
+			  int result);
+int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len);
 
-int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
-		int8_t p2, int usesnr);
 
-int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
-		     struct cmd_header *resp);
+/* From cmdresp.c */
 
-int lbs_update_hw_spec(struct lbs_private *priv);
+void lbs_mac_event_disconnected(struct lbs_private *priv);
 
-int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
-		    struct cmd_ds_mesh_access *cmd);
 
-int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
+
+/* Events */
+
+int lbs_process_event(struct lbs_private *priv, u32 event);
+
+
+/* Actual commands */
+
+int lbs_update_hw_spec(struct lbs_private *priv);
 
 int lbs_get_channel(struct lbs_private *priv);
+
 int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
+int lbs_update_channel(struct lbs_private *priv);
+
+int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
+		struct wol_config *p_wol_config);
+
+int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
+				struct sleep_params *sp);
+
+void lbs_ps_sleep(struct lbs_private *priv, int wait_option);
+
+void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
+
+void lbs_ps_confirm_sleep(struct lbs_private *priv);
+
+int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
+
+void lbs_set_mac_control(struct lbs_private *priv);
+
+int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
+		     s16 *maxlevel);
+
+int lbs_set_snmp_mib(struct lbs_private *priv, u32 oid, u16 val);
+
+int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val);
+
+
+/* Mesh related */
+
+int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
+		    struct cmd_ds_mesh_access *cmd);
+
 int lbs_mesh_config_send(struct lbs_private *priv,
 			 struct cmd_ds_mesh_config *cmd,
 			 uint16_t action, uint16_t type);
+
 int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
 
-int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
-		struct wol_config *p_wol_config);
-int lbs_suspend(struct lbs_private *priv);
-void lbs_resume(struct lbs_private *priv);
+
+/* Commands only used in wext.c, assoc. and scan.c */
+
+int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
+		int8_t p1, int8_t p2);
+
+int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
+		int8_t p2, int usesnr);
+
+int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 
 int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
 				      uint16_t cmd_action);
+
 int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
 				      uint16_t cmd_action, uint16_t *timeout);
-int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
-				struct sleep_params *sp);
+
 int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
 			   struct assoc_request *assoc);
+
 int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
 			      uint16_t *enable);
+
 int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
 				struct assoc_request *assoc);
 
-int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
-		     s16 *maxlevel);
 int lbs_set_tx_power(struct lbs_private *priv, s16 dbm);
 
-int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
-
-int lbs_set_snmp_mib(struct lbs_private *priv, u32 oid, u16 val);
-
-int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val);
+int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep);
 
 #endif /* _LBS_CMD_H */
--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -17,23 +17,13 @@
 struct cmd_ctrl_node;
 struct cmd_ds_command;
 
-void lbs_set_mac_control(struct lbs_private *priv);
+int lbs_suspend(struct lbs_private *priv);
+void lbs_resume(struct lbs_private *priv);
 
 void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count);
 
-int lbs_free_cmd_buffer(struct lbs_private *priv);
-
-int lbs_prepare_and_send_command(struct lbs_private *priv,
-	u16 cmd_no,
-	u16 cmd_action,
-	u16 wait_option, u32 cmd_oid, void *pdata_buf);
-
-int lbs_allocate_cmd_buffer(struct lbs_private *priv);
-int lbs_execute_next_command(struct lbs_private *priv);
-int lbs_process_event(struct lbs_private *priv, u32 event);
 void lbs_queue_event(struct lbs_private *priv, u32 event);
 void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
-int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep);
 int lbs_enter_auto_deep_sleep(struct lbs_private *priv);
 int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
 
@@ -41,26 +31,17 @@
 u8 lbs_data_rate_to_fw_index(u32 rate);
 
 /** The proc fs interface */
-int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len);
-void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
-			  int result);
 netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *dev);
 int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
 
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
-void lbs_ps_sleep(struct lbs_private *priv, int wait_option);
-void lbs_ps_confirm_sleep(struct lbs_private *priv);
-void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
-
 struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
 	struct lbs_private *priv,
 	u8 band,
 	u16 channel);
 
-void lbs_mac_event_disconnected(struct lbs_private *priv);
-
 void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
 
 /* persistcfg.c */
@@ -76,6 +57,5 @@
 void lbs_stop_card(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
-int lbs_update_channel(struct lbs_private *priv);
 
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/host.h
+++ linux-wl/drivers/net/wireless/libertas/host.h
@@ -374,21 +374,6 @@
 	__le16 result;
 } __attribute__ ((packed));
 
-struct cmd_ctrl_node {
-	struct list_head list;
-	int result;
-	/* command response */
-	int (*callback)(struct lbs_private *,
-			unsigned long,
-			struct cmd_header *);
-	unsigned long callback_arg;
-	/* command data */
-	struct cmd_header *cmdbuf;
-	/* wait queue */
-	u16 cmdwaitqwoken;
-	wait_queue_head_t cmdwait_q;
-};
-
 /* Generic structure to hold all key types. */
 struct enc_key {
 	u16 len;
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -11,6 +11,7 @@
 
 #include "host.h"
 #include "decl.h"
+#include "cmd.h"
 #include "defs.h"
 #include "dev.h"
 #include "assoc.h"
--- linux-wl.orig/drivers/net/wireless/libertas/11d.c
+++ linux-wl/drivers/net/wireless/libertas/11d.c
@@ -6,6 +6,7 @@
 #include <linux/wireless.h>
 
 #include "host.h"
+#include "cmd.h"
 #include "decl.h"
 #include "11d.h"
 #include "dev.h"

-- 
http://www.holgerschurig.de
