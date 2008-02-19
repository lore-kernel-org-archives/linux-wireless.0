Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41501 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYBSOlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 09:41:53 -0500
Message-ID: <47BAEAAE.7050805@tiscali.nl> (sfid-20080219_144158_554773_0E06109B)
Date: Tue, 19 Feb 2008 15:41:50 +0100
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: Convert to list_for_each_entry_rcu()
References: <47BA271D.9000806@tiscali.nl>
In-Reply-To: <47BA271D.9000806@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roel Kluin wrote:
> Please verify, this patch was not yet tested.
> ---
> Convert list_for_each_rcu() to list_for_each_entry_rcu()
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
Same mistake as in other patch, please ignore the previous patch
and consider the patch below.
---
Convert list_for_each_rcu() to list_for_each_entry_rcu()

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/strip.c b/drivers/net/wireless/strip.c
index 88efe1b..bced3fe 100644
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -962,12 +962,12 @@ static char *time_delta(char buffer[], long time)
 /* get Nth element of the linked list */
 static struct strip *strip_get_idx(loff_t pos) 
 {
-	struct list_head *l;
+	struct strip *str;
 	int i = 0;
 
-	list_for_each_rcu(l, &strip_list) {
+	list_for_each_entry_rcu(str, &strip_list, list) {
 		if (pos == i)
-			return list_entry(l, struct strip, list);
+			return str;
 		++i;
 	}
 	return NULL;
