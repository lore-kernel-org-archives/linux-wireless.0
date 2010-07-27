Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab0G0SNb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 14:13:31 -0400
Subject: [wt PATCH 13/16] libertas: convert DEEP_SLEEP timer to a direct
 command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:15:01 -0700
Message-ID: <1280261701.19686.38.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Other uses were already used direct command paths.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c  |    4 ----
 drivers/net/wireless/libertas/main.c |   14 ++++++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 5c7bb35..f19a36f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1208,10 +1208,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	cmdptr->result = 0;
 
 	switch (cmd_no) {
-	case CMD_802_11_DEEP_SLEEP:
-		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
-		cmdptr->size = cpu_to_le16(sizeof(struct cmd_header));
-		break;
 	default:
 		lbs_pr_err("PREP_CMD: unknown command 0x%04x\n", cmd_no);
 		ret = -1;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 6c0e814..960799f 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -658,7 +658,6 @@ out:
 static void auto_deepsleep_timer_fn(unsigned long data)
 {
 	struct lbs_private *priv = (struct lbs_private *)data;
-	int ret;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -666,14 +665,15 @@ static void auto_deepsleep_timer_fn(unsigned long data)
 		priv->is_activity_detected = 0;
 	} else {
 		if (priv->is_auto_deep_sleep_enabled &&
-				(!priv->wakeup_dev_required) &&
-				(priv->connect_status != LBS_CONNECTED)) {
+		    (!priv->wakeup_dev_required) &&
+		    (priv->connect_status != LBS_CONNECTED)) {
+			struct cmd_header cmd;
+
 			lbs_deb_main("Entering auto deep sleep mode...\n");
-			ret = lbs_prepare_and_send_command(priv,
-					CMD_802_11_DEEP_SLEEP, 0,
-					0, 0, NULL);
-			if (ret)
-				lbs_pr_err("Enter Deep Sleep command failed\n");
+			memset(&cmd, 0, sizeof(cmd));
+			cmd.size = cpu_to_le16(sizeof(cmd));
+			lbs_cmd_async(priv, CMD_802_11_DEEP_SLEEP, &cmd,
+					sizeof(cmd));
 		}
 	}
 	mod_timer(&priv->auto_deepsleep_timer , jiffies +
-- 
1.7.1.1


