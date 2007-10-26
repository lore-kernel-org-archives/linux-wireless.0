Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:34873 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbXJZUIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:08:04 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out2.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVTN-0008Cs-Ld
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:08:01 +0200
Message-ID: <4722491F.6000404@tiscali.nl> (sfid-20071026_210808_624179_84022B8B)
Date: Fri, 26 Oct 2007 22:07:59 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 1/8] fix 'and' typo's in airo wireless
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

        Fix priority mistakes similar to '!x & y' in airo wireless
    
        Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 074055e..e3eca6d 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -6407,7 +6407,7 @@ static int airo_set_encode(struct net_device *dev,
 			set_wep_key(local, index, NULL, 0, perm, 1);
 		} else
 			/* Don't complain if only change the mode */
-			if(!dwrq->flags & IW_ENCODE_MODE) {
+			if(!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
