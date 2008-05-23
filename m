Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10352 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYEWIIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 04:08:14 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: don't spin_unlock_irq() twice
Date: Fri, 23 May 2008 10:07:56 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805231007.56665.hs4233@mail.mn-solutions.de> (sfid-20080523_100827_656638_EBBEBC4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->driver_lock has already been unlocked some lines above. This patch
fixes the sparse warning:

drivers/net/wireless/libertas/main.c:792:6: warning: context problem in 'lbs_thread': '_spin_unlock_irq' expected different context
drivers/net/wireless/libertas/main.c:792:6:    context 'lock': wanted >= 1, got 0

Signed-of-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-05-23 08:43:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-05-23 08:43:22.000000000 +0200
@@ -788,11 +788,8 @@ static int lbs_thread(void *data)
 					le16_to_cpu(cmdnode->cmdbuf->command));
 				lbs_complete_command(priv, cmdnode, -ETIMEDOUT);
 				priv->nr_retries = 0;
-				if (priv->reset_card) {
-					spin_unlock_irq(&priv->driver_lock);
+				if (priv->reset_card)
 					priv->reset_card(priv);
-					spin_lock_irq(&priv->driver_lock);
-				}
 			} else {
 				priv->cur_cmd = NULL;
 				priv->dnld_sent = DNLD_RES_RECEIVED;
