Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0G0R4i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:56:38 -0400
Subject: [wt PATCH 6/16] libertas: remove Beacon Control
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:58:08 -0700
Message-ID: <1280260688.19686.19.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now; it's a pretty easy command to hook up and whenever OLPC
figures out how they want the userspace interface to look (ie,
not iwpriv commands) we can easily add it back in.  Since the
cfg80211 conversion it wasn't working anyway.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.h     |    4 ----
 drivers/net/wireless/libertas/cmd.c     |    3 ---
 drivers/net/wireless/libertas/cmdresp.c |    3 ---
 drivers/net/wireless/libertas/host.h    |    3 ++-
 4 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.h b/drivers/net/wireless/libertas/cfg.h
index e7ba4d8..4f46bb7 100644
--- a/drivers/net/wireless/libertas/cfg.h
+++ b/drivers/net/wireless/libertas/cfg.h
@@ -13,10 +13,6 @@ void lbs_cfg_free(struct lbs_private *priv);
 int lbs_reg_notifier(struct wiphy *wiphy,
 		struct regulatory_request *request);
 
-/* All of those are TODOs: */
-#define lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action) (0)
-#define lbs_ret_802_11_bcn_ctrl(priv, resp) (0)
-
 void lbs_send_disconnect_notification(struct lbs_private *priv);
 void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 15cfc52..a09ee6b 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1216,9 +1216,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 
 #endif
 
-	case CMD_802_11_BEACON_CTRL:
-		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
-		break;
 	case CMD_802_11_DEEP_SLEEP:
 		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
 		cmdptr->size = cpu_to_le16(sizeof(struct cmd_header));
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index c3cbc8a..6196e54 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -130,9 +130,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 			       sizeof(resp->params.fwt));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
-	case CMD_RET(CMD_802_11_BEACON_CTRL):
-		ret = lbs_ret_802_11_bcn_ctrl(priv, resp);
-		break;
 
 	default:
 		lbs_pr_err("CMD_RESP: unknown cmd response 0x%04x\n",
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 76bbcec..680a5f5 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -595,6 +595,8 @@ struct cmd_ds_802_11_radio_control {
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_beacon_control {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le16 beacon_enable;
 	__le16 beacon_period;
@@ -972,7 +974,6 @@ struct cmd_ds_command {
 
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
-		struct cmd_ds_802_11_beacon_control bcn_ctrl;
 	} params;
 } __attribute__ ((packed));
 #endif
-- 
1.7.1.1


