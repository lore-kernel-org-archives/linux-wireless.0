Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8248 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYEWOE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 10:04:29 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: before sleeping, check for a command result
Date: Fri, 23 May 2008 16:04:13 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805231604.13144.hs4233@mail.mn-solutions.de> (sfid-20080523_160433_150634_54F6C290)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we don't check for a command response early, but rather sleep,
then we might sleep despite an already-received command response.
This will lead to a command-timeout.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-05-23 14:25:16.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-05-23 14:25:51.000000000 +0200
@@ -722,14 +722,14 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* Something is en route to the device already */
 		else if (priv->tx_pending_len > 0)
 			shouldsleep = 0;	/* We've a packet to send */
+		else if (priv->resp_len[priv->resp_idx])
+			shouldsleep = 0;	/* We have a command response */
 		else if (priv->cur_cmd)
 			shouldsleep = 1;	/* Can't send a command; one already running */
 		else if (!list_empty(&priv->cmdpendingq))
 			shouldsleep = 0;	/* We have a command to send */
 		else if (__kfifo_len(priv->event_fifo))
 			shouldsleep = 0;	/* We have an event to process */
-		else if (priv->resp_len[priv->resp_idx])
-			shouldsleep = 0;	/* We have a command response */
 		else
 			shouldsleep = 1;	/* No command */
 
