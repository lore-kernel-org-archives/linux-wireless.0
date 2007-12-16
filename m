Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761738AbXLPW6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:47 -0500
Subject: [PATCH 112/48] libertas: ensure response buffer size is always set for lbs_cmd_with_response
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42SE-00038p-2I@shinybook.infradead.org> (sfid-20071216_232047_577483_22898C6F)
Date: Sun, 16 Dec 2007 17:59:26 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 03:46:44 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c    |    4 +++-
 drivers/net/wireless/libertas/cmd.h    |    4 ++++
 drivers/net/wireless/libertas/if_usb.c |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 3079b3f..c3d7f60 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -115,6 +115,7 @@ int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria)
 	struct cmd_ds_host_sleep cmd_config;
 	int ret;
 
+	cmd_config.hdr.size = cpu_to_le16(sizeof(cmd_config));
 	cmd_config.criteria = cpu_to_le32(criteria);
 	cmd_config.gpio = priv->wol_gpio;
 	cmd_config.gap = priv->wol_gap;
@@ -1101,7 +1102,7 @@ int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
 
 	cmd->hdr.command = cpu_to_le16(CMD_MESH_ACCESS);
-	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_mesh_access) + S_DS_GEN);
+	cmd->hdr.size = cpu_to_le16(sizeof(*cmd));
 	cmd->hdr.result = 0;
 
 	cmd->action = cpu_to_le16(cmd_action);
@@ -1121,6 +1122,7 @@ int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan)
 	cmd.action = cpu_to_le16(enable);
 	cmd.channel = cpu_to_le16(chan);
 	cmd.type = cpu_to_le16(priv->mesh_tlv);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 
 	if (enable) {
 		cmd.length = cpu_to_le16(priv->mesh_ssid_len);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 2f4c1ec..e334f0e 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -9,6 +9,10 @@
 #define lbs_cmd(priv, cmdnr, cmd, cb, cb_arg)	\
 	__lbs_cmd(priv, cmdnr, &(cmd)->hdr, sizeof(*(cmd)), cb, cb_arg)
 
+
+/* lbs_cmd_with_response() infers the size of the command to be _sent_
+   and requires that the caller sets cmd->size to the (LE) size of
+   the _response_ buffer. */
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index cf88251..8bc23b3 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -106,6 +106,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 {
 	struct cmd_ds_set_boot2_ver b2_cmd;
 
+	b2_cmd.hdr.size = cpu_to_le16(sizeof(b2_cmd));
 	b2_cmd.action = 0;
 	b2_cmd.version = priv->boot2_version;
 
-- 
1.5.3.4

