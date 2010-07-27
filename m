Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0G0SOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 14:14:51 -0400
Subject: [wt PATCH 15/16] libertas: rename lbs_get_cmd_ctrl_node() to
 lbs_get_free_cmd_node()
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:16:24 -0700
Message-ID: <1280261784.19686.40.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4946bce..7074592 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -15,8 +15,6 @@
 #define CAL_NF(nf)		((s32)(-(s32)(nf)))
 #define CAL_RSSI(snr, nf)	((s32)((s32)(snr) + CAL_NF(nf)))
 
-static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
-
 /**
  *  @brief Simple callback that copies response back into command
  *
@@ -1207,7 +1205,7 @@ done:
  *  @param priv		A pointer to struct lbs_private structure
  *  @return cmd_ctrl_node A pointer to cmd_ctrl_node structure or NULL
  */
-static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
+static struct cmd_ctrl_node *lbs_get_free_cmd_node(struct lbs_private *priv)
 {
 	struct cmd_ctrl_node *tempnode;
 	unsigned long flags;
@@ -1578,7 +1576,7 @@ struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 		}
 	}
 
-	cmdnode = lbs_get_cmd_ctrl_node(priv);
+	cmdnode = lbs_get_free_cmd_node(priv);
 	if (cmdnode == NULL) {
 		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
 
-- 
1.7.1.1


