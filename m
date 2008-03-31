Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965AbYDALfj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:35:39 -0400
Subject: Re: FW: [ipw3945-devel] iwl3945: disassociation from AP (reason=4)
	andtimeout, a solution
From: Dan Williams <dcbw@redhat.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net, abertensu@yahoo.com,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com>
References: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 17:41:36 -0400
Message-Id: <1206999696.20744.2.camel@localhost.localdomain> (sfid-20080401_123543_111919_8FD87668)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-31 at 14:17 -0700, Chatre, Reinette wrote:
> Forwarding this to linux-wireless where there is more knowledge about
> association. The attached patch is also to the mac80211 stack, so we
> need to involve the mac80211 maintainer.
> 
> Reinette
> 
> On Friday, March 28, 2008 4:00 PM, Andres Bertens  wrote:
> 
> > Hi,
> > 
> > Recently I moved from ipw3945 to iwl3945 and I was having an AP
> > association timeout after some inactivity.
> > Card is Intel 3945bg, router is DLink DI524, driver is
> > compat-wireless-2.6 (2008-03-28) or older and mode is (WEP, open) on
> > linux-2.6.24.4. It does not recover magically.
> > 
> > The trace is:
> > 
> > wlan0: RX disassociation from 00:17:9a:63:d2:21 (reason=4)
> > wlan0: disassociated
> > wlan0: associate with AP 00:17:9a:63:d2:21
> > wlan0: RX ReassocResp from 00:17:9a:63:d2:21 (capab=0x431 status=17
> > aid=1) wlan0: AP denied association (code=17)
> > wlan0: associate with AP 00:17:9a:63:d2:21
> > wlan0: RX AssocResp from 00:17:9a:63:d2:21 (capab=0x431 status=17
> > aid=1073) wlan0: AP denied association (code=17)
> > wlan0: associate with AP 00:17:9a:63:d2:21
> > wlan0: RX AssocResp from 00:17:9a:63:d2:21 (capab=0x431 status=17
> > aid=1073) wlan0: AP denied association (code=17)
> > wlan0: association with AP 00:17:9a:63:d2:21 timed out
> > 
> > After browsing the internet, I found a lot of people with the same
> > problem and no solution. So, I dived into the code and found a simple
> > solution: ignore disassociation. When a new request arrives to the
> > wireless, a reconnection is done automatically.

Ignoring the disassociation from the AP is suspect...  wouldn't the AP
be releasing resources associated with the station, requiring a
reassociate/reauth from the station?  Reason 4 seems to mean "Inactivity
timer expired and station was disassociated".

A better solution would be to queue up a reassocation worker if the AP
kicked you off for reason 4, maybe?

Dan

> > I patched the code, modifying net/mac80211/ieee80211_sta.c, and trace
> > is as follow:
> > 
> > wlan0: RX disassociation for reason=4 received from 00:17:9a:63:d2:21
> > - ignored
> > wlan0: RX deauthentication from 00:17:9a:63:d2:21 (reason=6)
> > wlan0: deauthenticated
> > wlan0: authenticate with AP 00:17:9a:63:d2:21
> > wlan0: RX authentication from 00:17:9a:63:d2:21 (alg=0 transaction=2
> > status=0)
> > wlan0: authenticated
> > wlan0: associate with AP 00:17:9a:63:d2:21
> > wlan0: RX ReassocResp from 00:17:9a:63:d2:21 (capab=0x431 status=0
> > aid=2) wlan0: associated
> > 
> > and these entries repeats in time. As you can see, the disassociation
> > still ocurrs but a new request afterwards generates a deauthentication
> > (reason=6) and a reconnection takes place (transparent to the user).
> > 
> > Attached is patch to compat-wireless-2.6 (2008-03-28).  Please note
> > that this is for iwl3945+dlink+WEP combination (according to other
> > people, it seems to work for other combinations).
> > 
> > Hope this help.
> > 
> > Regards,
> > Andres Bertens
> 
> 	
> plain text document attachment (compat-wireless-2.6-ap-timeout.patch),
> "compat-wireless-2.6-ap-timeout.patch"
> diff -Naur compat-wireless-2008-03-28/net/mac80211/ieee80211_sta.c compat-wireless-2008-03-28-new/net/mac80211/ieee80211_sta.c
> --- compat-wireless-2008-03-28/net/mac80211/ieee80211_sta.c	2008-03-28 01:14:15.000000000 -0400
> +++ compat-wireless-2008-03-28-new/net/mac80211/ieee80211_sta.c	2008-03-28 16:19:57.000000000 -0400
> @@ -1809,6 +1809,15 @@
>  
>  	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
>  
> +/* ABU */
> +	if( reason_code == 4 ) {
> +		printk(KERN_DEBUG "%s: RX disassociation for reason=4 "
> +			"received from %s - ignored\n",
> +			dev->name, print_mac(mac, mgmt->sa));
> +		return;
> +	}
> +/* ABU */
> +
>  	printk(KERN_DEBUG "%s: RX disassociation from %s"
>  	       " (reason=%d)\n",
>  	       dev->name, print_mac(mac, mgmt->sa), reason_code);
> 

