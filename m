Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:16010 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078AbZKZJnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:43:55 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 2/6] libertas: move mesh-related definitions into mesh.h
Date: Thu, 26 Nov 2009 10:43:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261043.45001.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
+++ linux-wl/drivers/net/wireless/libertas/cmd.h
@@ -110,18 +110,6 @@ int lbs_set_snmp_mib(struct lbs_private 
 int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val);
 
 
-/* Mesh related */
-
-int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
-		    struct cmd_ds_mesh_access *cmd);
-
-int lbs_mesh_config_send(struct lbs_private *priv,
-			 struct cmd_ds_mesh_config *cmd,
-			 uint16_t action, uint16_t type);
-
-int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
-
-
 /* Commands only used in wext.c, assoc. and scan.c */
 
 int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.h
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -46,11 +46,20 @@ void lbs_mesh_set_txpd(struct lbs_privat
 /* Command handling */
 
 struct cmd_ds_command;
+struct cmd_ds_mesh_access;
+struct cmd_ds_mesh_config;
 
 int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
 	u16 cmd_action, void *pdata_buf);
 int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
 	u16 cmd_action, void *pdata_buf);
+int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
+		    struct cmd_ds_mesh_access *cmd);
+int lbs_mesh_config_send(struct lbs_private *priv,
+			 struct cmd_ds_mesh_config *cmd,
+			 uint16_t action, uint16_t type);
+int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
+
 
 
 /* Persistent configuration */

-- 
http://www.holgerschurig.de
