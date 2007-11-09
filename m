Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:10778 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbXKITZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 14:25:11 -0500
Received: by wx-out-0506.google.com with SMTP id h31so479051wxd
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2007 11:25:10 -0800 (PST)
Date: Fri, 9 Nov 2007 14:21:54 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>,
	David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Fix infinite loop on dev_mc_unsync()
Message-ID: <20071109192033.GB22714@pogo> (sfid-20071109_192526_966112_6A21A882)
References: <20071109151135.GA12982@pogo> <20071109183733.GA22714@pogo> <1194635236.19522.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1194635236.19522.3.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 09, 2007 at 11:07:16AM -0800, Joe Perches wrote:
> On Fri, 2007-11-09 at 13:51 -0500, Luis R. Rodriguez wrote:
> > While reviewing net/core/dev_mcast.c I found what I think is an 
> > infinite loop on dev_mc_unsync(). This fixes it. We make use of
> > this guy on mac80211 in ieee80211_stop(). This is untested.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> > 
> > diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
> > index 15241cf..5373c03 100644
> > --- a/net/core/dev_mcast.c
> > +++ b/net/core/dev_mcast.c
> > @@ -168,8 +168,10 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
> >  	da = from->mc_list;
> >  	while (da != NULL) {
> >  		next = da->next;
> > -		if (!da->da_synced)
> > +		if (!da->da_synced) {
> > +			da = next;
> >  			continue;
> > +		}
> >  		__dev_addr_delete(&to->mc_list, &to->mc_count,
> >  				  da->da_addr, da->da_addrlen, 0);
> >  		da->da_synced = 0;
> > -
> > To unsubscribe from this list: send the line "unsubscribe netdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Perhaps this is clearer as:
> 
> void dev_mc_unsync(struct net_device *to, struct net_device *from)
> {
> 	struct dev_addr_list *da;
> 
> 	netif_tx_lock_bh(from);
> 	netif_tx_lock_bh(to);
> 
> 	da = from->mc_list;
> 	while (da) {
> 		if (da->da_synced) {
> 			__dev_addr_delete(&to->mc_list, &to->mc_count,
> 					  da->da_addr, da->da_addrlen, 0);
> 			__dev_addr_delete(&from->mc_list, &from->mc_count,
> 					  da->da_addr, da->da_addrlen, 0);
> 			da->da_synced = 0;
> 		}
> 		da = da->next;
> 	}
> 
> 	__dev_set_rx_mode(to);
> 
> 	netif_tx_unlock_bh(to);
> 	netif_tx_unlock_bh(from);
> }
> EXPORT_SYMBOL(dev_mc_unsync);

Sure, or better with a for loop and do away with next pointer then:

void dev_mc_unsync(struct net_device *to, struct net_device *from)
{
        struct dev_addr_list *da;

        netif_tx_lock_bh(from);
        netif_tx_lock_bh(to);

        for (da = from->mc_list; da; da = da->next) {
                if (!da->da_synced)
                        continue;
                __dev_addr_delete(&to->mc_list, &to->mc_count,
                                  da->da_addr, da->da_addrlen, 0);
                da->da_synced = 0;
                __dev_addr_delete(&from->mc_list, &from->mc_count,
                                  da->da_addr, da->da_addrlen, 0);
        }
        __dev_set_rx_mode(to);

        netif_tx_unlock_bh(to);
        netif_tx_unlock_bh(from);
}
EXPORT_SYMBOL(dev_mc_unsync);

Patch below.

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
index 15241cf..2aea8e1 100644
--- a/net/core/dev_mcast.c
+++ b/net/core/dev_mcast.c
@@ -160,14 +160,12 @@ EXPORT_SYMBOL(dev_mc_sync);
  */
 void dev_mc_unsync(struct net_device *to, struct net_device *from)
 {
-	struct dev_addr_list *da, *next;
+	struct dev_addr_list *da;
 
 	netif_tx_lock_bh(from);
 	netif_tx_lock_bh(to);
 
-	da = from->mc_list;
-	while (da != NULL) {
-		next = da->next;
+	for (da = from->mc_list; da; da = da->next) {
 		if (!da->da_synced)
 			continue;
 		__dev_addr_delete(&to->mc_list, &to->mc_count,
@@ -175,7 +173,6 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 		da->da_synced = 0;
 		__dev_addr_delete(&from->mc_list, &from->mc_count,
 				  da->da_addr, da->da_addrlen, 0);
-		da = next;
 	}
 	__dev_set_rx_mode(to);
 
