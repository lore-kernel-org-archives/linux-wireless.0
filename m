Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.2.166]:59524 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab2IKPiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 11:38:12 -0400
From: Daniel Drake <dsd@laptop.org>
To: dcbw@redhat.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: set mac control synchronously during init
Message-Id: <20120911153812.08740FAA7C@dev.laptop.org> (sfid-20120911_173818_290555_F5FF33C0)
Date: Tue, 11 Sep 2012 11:38:11 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CMD_MAC_CONTROL is currently sent async to the firmware, and is sent
from the lbs_setup_firmware() path during device init.

This means that device init can complete with commands pending, and
the if_sdio driver will sometimes power down the device (after init)
with this command still pending.

This was causing an occasional spurious command timeout after init,
leading to a device reset.

Fix this by making CMD_MAC_CONTROL synchronous when called from the
lbs_setup_firmware() path.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cmd.c  | 16 ++++++++++++++++
 drivers/net/wireless/libertas/cmd.h  |  1 +
 drivers/net/wireless/libertas/main.c |  4 +++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 26e6832..aaa2973 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1159,6 +1159,22 @@ void lbs_set_mac_control(struct lbs_private *priv)
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
+int lbs_set_mac_control_sync(struct lbs_private *priv)
+{
+	struct cmd_ds_mac_control cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(priv->mac_control);
+	cmd.reserved = 0;
+	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
+}
+
 /**
  *  lbs_allocate_cmd_buffer - allocates the command buffer and links
  *  it to command free queue
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index ab07608..4279e8a 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -96,6 +96,7 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv);
 int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
 
 void lbs_set_mac_control(struct lbs_private *priv);
+int lbs_set_mac_control_sync(struct lbs_private *priv);
 
 int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
 		     s16 *maxlevel);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index fe1ea43..0c02f04 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -682,8 +682,10 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 
 	/* Send cmd to FW to enable 11D function */
 	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
+	if (ret)
+		goto done;
 
-	lbs_set_mac_control(priv);
+	ret = lbs_set_mac_control_sync(priv);
 done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
 	return ret;
-- 
1.7.11.4

