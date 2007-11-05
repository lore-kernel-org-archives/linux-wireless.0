Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:33400 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbXKEWzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 17:55:08 -0500
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out2.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IpAqY-0001GX-Q2
	for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2007 23:55:06 +0100
Message-ID: <472F9F46.3030604@tiscali.nl> (sfid-20071105_225515_040659_0616C516)
Date: Mon, 05 Nov 2007 23:55:02 +0100
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] postfix decrement error in ipw2100_start_adapter(); drivers/net/wireless/ipw2100.c
References: <472E671F.80907@tiscali.nl>
In-Reply-To: <472E671F.80907@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It appears there was another. The patch below includes both fixes.
--
If i reaches zero, the loop ends, but the postfix decrement subtracts it to -1.
Testing for 'i == 0', later in the function, will not fulfill its purpose.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index a6c7904..14632d8 100644
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
@@ -1339,7 +1339,7 @@ static int ipw2100_power_cycle_adapter(struct ipw2100_priv *priv)
 
 		if (reg & IPW_AUX_HOST_RESET_REG_MASTER_DISABLED)
 			break;
-	} while (i--);
+	} while (--i);
 
 	priv->status &= ~STATUS_RESET_PENDING;
 

