Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:20934 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484AbZJPPfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 11:35:20 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] libertas: make lbs_get_channel() static
Date: Fri, 16 Oct 2009 17:33:56 +0200
Cc: Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910161733.56111.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -880,7 +880,7 @@
  *
  *  @return 	   	The channel on success, error on failure
  */
-int lbs_get_channel(struct lbs_private *priv)
+static int lbs_get_channel(struct lbs_private *priv)
 {
 	struct cmd_ds_802_11_rf_channel cmd;
 	int ret = 0;
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
+++ linux-wl/drivers/net/wireless/libertas/cmd.h
@@ -82,8 +82,6 @@
 
 int lbs_update_hw_spec(struct lbs_private *priv);
 
-int lbs_get_channel(struct lbs_private *priv);
-
 int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
 int lbs_update_channel(struct lbs_private *priv);

-- 
http://www.holgerschurig.de
