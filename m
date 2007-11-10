Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2001 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbXKJAIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 19:08:45 -0500
Subject: Re: [PATCH] Fix infinite loop on dev_mc_unsync()
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
	David Miller <davem@davemloft.net>
In-Reply-To: <4734E962.3010603@trash.net>
References: <20071109151135.GA12982@pogo> <20071109183733.GA22714@pogo>
	 <1194635236.19522.3.camel@localhost> <20071109192033.GB22714@pogo>
	 <4734E962.3010603@trash.net>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 16:08:40 -0800
Message-Id: <1194653320.19522.28.camel@localhost> (sfid-20071110_000849_969861_2BB26BB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-10 at 00:12 +0100, Patrick McHardy wrote:
> This may cause a use-after-free since __dev_addr_delete frees the address
> when all references are gone.

How about a comment then?  Perhaps:

diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
index ae35405..63576aa 100644
--- a/net/core/dev_mcast.c
+++ b/net/core/dev_mcast.c
@@ -165,16 +165,23 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 	netif_tx_lock_bh(from);
 	netif_tx_lock_bh(to);
 
+	/*
+	  This while loop can't be written as
+		for (da = from->mc_list; da; da = da->next)
+	  da = from->mc_list and __dev_addr_delete can kfree(from->mc_list)
+	  which could cause a use-after-free of da->next
+	*/
+
 	da = from->mc_list;
 	while (da != NULL) {
 		next = da->next;
-		if (!da->da_synced)
-			continue;
-		__dev_addr_delete(&to->mc_list, &to->mc_count,
-				  da->da_addr, da->da_addrlen, 0);
-		da->da_synced = 0;
-		__dev_addr_delete(&from->mc_list, &from->mc_count,
-				  da->da_addr, da->da_addrlen, 0);
+		if (da->da_synced) {
+			__dev_addr_delete(&to->mc_list, &to->mc_count,
+					  da->da_addr, da->da_addrlen, 0);
+			da->da_synced = 0;
+			__dev_addr_delete(&from->mc_list, &from->mc_count,
+					  da->da_addr, da->da_addrlen, 0);
+		}
 		da = next;
 	}
 	__dev_set_rx_mode(to);


