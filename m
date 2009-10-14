Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:24629 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077AbZJNOvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 10:51:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: make  __lbs_cmd_async() non-static
Date: Wed, 14 Oct 2009 16:49:53 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910141649.53697.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function will be needed for the cfg80211-enabled libertas driver.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -2119,7 +2119,7 @@
 }
 
 
-static struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
+struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 	uint16_t command, struct cmd_header *in_cmd, int in_cmd_size,
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	unsigned long callback_arg)
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
+++ linux-wl/drivers/net/wireless/libertas/cmd.h
@@ -26,6 +26,11 @@
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	      unsigned long callback_arg);
 
+struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
+	uint16_t command, struct cmd_header *in_cmd, int in_cmd_size,
+	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
+	unsigned long callback_arg);
+
 int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
 		int8_t p1, int8_t p2);
 
