Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab0G0SDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 14:03:44 -0400
Subject: [wt PATCH 11/16] libertas: remove unused indirect command response
 handler
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:05:16 -0700
Message-ID: <1280261116.19686.28.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmdresp.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 26a30db..a4e147a 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -54,28 +54,6 @@ void lbs_mac_event_disconnected(struct lbs_private *priv)
 	lbs_deb_leave(LBS_DEB_ASSOC);
 }
 
-static inline int handle_cmd_response(struct lbs_private *priv,
-				      struct cmd_header *cmd_response)
-{
-	struct cmd_ds_command *resp = (struct cmd_ds_command *) cmd_response;
-	int ret = 0;
-	uint16_t respcmd = le16_to_cpu(resp->command);
-
-	lbs_deb_enter(LBS_DEB_HOST);
-
-	switch (respcmd) {
-	case CMD_RET(CMD_802_11_BEACON_STOP):
-		break;
-
-	default:
-		lbs_pr_err("CMD_RESP: unknown cmd response 0x%04x\n",
-			   le16_to_cpu(resp->command));
-		break;
-	}
-	lbs_deb_leave(LBS_DEB_HOST);
-	return ret;
-}
-
 int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 {
 	uint16_t respcmd, curcmd;
@@ -216,8 +194,7 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 	if (priv->cur_cmd && priv->cur_cmd->callback) {
 		ret = priv->cur_cmd->callback(priv, priv->cur_cmd->callback_arg,
 				resp);
-	} else
-		ret = handle_cmd_response(priv, resp);
+	}
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
-- 
1.7.1.1


