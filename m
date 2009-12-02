Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65310 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZLBO36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 09:29:58 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so217224bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 06:30:05 -0800 (PST)
Message-Id: <20091202142931.307135635@gmail.com>
References: <20091202142555.654873300@gmail.com>
Date: Wed, 02 Dec 2009 15:25:58 +0100
From: Holger Schurig <holgerschurig@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 03/10] libertas: move mesh-related definitions into mesh.h
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
