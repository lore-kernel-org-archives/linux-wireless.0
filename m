Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:17762 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYENOat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 10:30:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: remove lbs_get_data_rate()
Date: Wed, 14 May 2008 16:27:18 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805141627.18368.hs4233@mail.mn-solutions.de> (sfid-20080514_164630_098380_A19CE8C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

lbs_get_data_rate() get's called, but no-one uses it's result.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-05-14 14:58:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-05-14 14:58:15.000000000 +0200
@@ -697,38 +697,6 @@ static int lbs_cmd_802_11_rate_adapt_rat
 }
 
 /**
- *  @brief Get the current data rate
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *
- *  @return 	   	The data rate on success, error on failure
- */
-int lbs_get_data_rate(struct lbs_private *priv)
-{
-	struct cmd_ds_802_11_data_rate cmd;
-	int ret = -1;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(CMD_ACT_GET_TX_RATE);
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
-	if (ret)
-		goto out;
-
-	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof (cmd));
-
-	ret = (int) lbs_fw_index_to_data_rate(cmd.rates[0]);
-	lbs_deb_cmd("DATA_RATE: current rate 0x%02x\n", ret);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-/**
  *  @brief Set the data rate
  *
  *  @param priv    	A pointer to struct lbs_private structure
Index: wireless-testing/drivers/net/wireless/libertas/cmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-05-14 14:59:07.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-05-14 14:59:11.000000000 +0200
@@ -34,7 +34,6 @@ int lbs_update_hw_spec(struct lbs_privat
 int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 		    struct cmd_ds_mesh_access *cmd);
 
-int lbs_get_data_rate(struct lbs_private *priv);
 int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 
 int lbs_get_channel(struct lbs_private *priv);
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-05-14 14:58:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-05-14 15:04:14.000000000 +0200
@@ -928,20 +928,10 @@ static int lbs_setup_firmware(struct lbs
 	 */
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 	ret = lbs_update_hw_spec(priv);
-	if (ret) {
-		ret = -1;
+	if (ret)
 		goto done;
-	}
 
 	lbs_set_mac_control(priv);
-
-	ret = lbs_get_data_rate(priv);
-	if (ret < 0) {
-		ret = -1;
-		goto done;
-	}
-
-	ret = 0;
 done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
 	return ret;
