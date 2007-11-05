Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:59799 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXKEAnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2007 19:43:16 -0500
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out0.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1Ioq3e-0000cY-W6
	for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2007 01:43:15 +0100
Message-ID: <472E671F.80907@tiscali.nl> (sfid-20071105_004320_951770_BD1F6965)
Date: Mon, 05 Nov 2007 01:43:11 +0100
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] postfix decrement error in ipw2100_start_adapter(); drivers/net/wireless/ipw2100.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If i reaches zero, the loop ends, but the postfix decrement subtracts it to -1.
Testing for 'i == 0', later in the function, will not fulfill its purpose.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index a6c7904..84870f4 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -1267,7 +1267,7 @@ static int ipw2100_start_adapter(struct ipw2100_priv *priv)
 				       IPW2100_INTA_FATAL_ERROR |
 				       IPW2100_INTA_PARITY_ERROR);
 		}
-	} while (i--);
+	} while (--i);
 
 	/* Clear out any pending INTAs since we aren't supposed to have
 	 * interrupts enabled at this point... */
