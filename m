Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.laptop.org ([18.85.2.166]:51128 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab2ICT5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 15:57:44 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com, dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: set mac control synchronously
Message-Id: <20120903194934.04E06FAA0A@dev.laptop.org> (sfid-20120903_215749_241785_5E968E95)
Date: Mon,  3 Sep 2012 15:49:33 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CMD_MAC_CONTROL is currently sent async to the firmware, and is sent
from the lbs_setup_firmware() path during device init.

This means that device init can complete with commands pending, and
the if_sdio driver will sometimes power down the device (after init)
with this command still pending.

This was causing an occasional spurious command timeout after init,
leading to a device reset.

Fix this by making CMD_MAC_CONTROL synchronous - there is currently
no reason for it to be async (although there may have been in 2008
when commit c97329e2 was made).

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cmd.c  | 6 ++++--
 drivers/net/wireless/libertas/cmd.h  | 2 +-
 drivers/net/wireless/libertas/main.c | 4 +++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 26e6832..df0e4af5 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1144,9 +1144,10 @@ out:
 	return ret;
 }
 
-void lbs_set_mac_control(struct lbs_private *priv)
+int lbs_set_mac_control(struct lbs_private *priv)
 {
 	struct cmd_ds_mac_control cmd;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -1154,9 +1155,10 @@ void lbs_set_mac_control(struct lbs_private *priv)
 	cmd.action = cpu_to_le16(priv->mac_control);
 	cmd.reserved = 0;
 
-	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
+	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
 
 	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
 }
 
 /**
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index ab07608..43df4c4 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -95,7 +95,7 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv);
 
 int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
 
-void lbs_set_mac_control(struct lbs_private *priv);
+int lbs_set_mac_control(struct lbs_private *priv);
 
 int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
 		     s16 *maxlevel);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index fe1ea43..b878b45 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -682,8 +682,10 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 
 	/* Send cmd to FW to enable 11D function */
 	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
+	if (ret)
+		goto done;
 
-	lbs_set_mac_control(priv);
+	ret = lbs_set_mac_control(priv);
 done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
 	return ret;
-- 
1.7.11.4

