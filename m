Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:52757 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXJZUJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:09:23 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out1.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVUg-0002aK-2D
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:09:22 +0200
Message-ID: <4722496E.1070301@tiscali.nl> (sfid-20071026_210924_924093_AB022BD4)
Date: Fri, 26 Oct 2007 22:09:18 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 2/8] fix 'and' typo's in atmel wireless
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

        Fix priority mistakes similar to '!x & y' in atmel wireless
    
        Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 059ce3f..57cc7e5 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -1759,7 +1759,7 @@ static int atmel_set_encode(struct net_device *dev,
 			priv->default_key = index;
 		} else
 			/* Don't complain if only change the mode */
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
