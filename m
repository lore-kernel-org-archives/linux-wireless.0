Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17572 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbXKISvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 13:51:49 -0500
Received: by nf-out-0910.google.com with SMTP id g13so563749nfb
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2007 10:51:47 -0800 (PST)
Date: Fri, 9 Nov 2007 13:51:48 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
	David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Fix infinite loop on dev_mc_unsync()
Message-ID: <20071109183733.GA22714@pogo> (sfid-20071109_185157_703561_6DF75029)
References: <20071109151135.GA12982@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071109151135.GA12982@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, forgot to CC David.

On Fri, Nov 09, 2007 at 10:11:35AM -0500, Luis R. Rodriguez wrote:

While reviewing net/core/dev_mcast.c I found what I think is an 
infinite loop on dev_mc_unsync(). This fixes it. We make use of
this guy on mac80211 in ieee80211_stop(). This is untested.

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
index 15241cf..5373c03 100644
--- a/net/core/dev_mcast.c
+++ b/net/core/dev_mcast.c
@@ -168,8 +168,10 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 	da = from->mc_list;
 	while (da != NULL) {
 		next = da->next;
-		if (!da->da_synced)
+		if (!da->da_synced) {
+			da = next;
 			continue;
+		}
 		__dev_addr_delete(&to->mc_list, &to->mc_count,
 				  da->da_addr, da->da_addrlen, 0);
 		da->da_synced = 0;
