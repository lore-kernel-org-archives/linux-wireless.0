Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5405 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYDII0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 04:26:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: un-garbage various command structs
Date: Wed, 9 Apr 2008 10:23:31 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804091023.31707.hs4233@mail.mn-solutions.de> (sfid-20080409_092635_936007_258E5BB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some command structs contain reserved or unused fields, which the driver
send uninitialized down to the card.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-04-08 18:45:29.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-04-08 20:05:11.000000000 +0200
@@ -296,6 +296,7 @@ int lbs_cmd_802_11_set_wep(struct lbs_pr
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
+	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 
@@ -359,7 +360,9 @@ int lbs_cmd_802_11_enable_rsn(struct lbs
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(cmd_action);
 
-	if (cmd_action == CMD_ACT_SET) {
+	if (cmd_action == CMD_ACT_GET)
+		cmd.enable = 0;
+	else {
 		if (*enable)
 			cmd.enable = cpu_to_le16(CMD_ENABLE_RSN);
 		else
@@ -811,6 +814,7 @@ int lbs_get_channel(struct lbs_private *
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
+	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_GET);
 
@@ -858,6 +862,7 @@ int lbs_set_channel(struct lbs_private *
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
+	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_SET);
 	cmd.channel = cpu_to_le16(channel);
