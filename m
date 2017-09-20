Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:24532 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751660AbdITMLl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:11:41 -0400
Date: Wed, 20 Sep 2017 15:11:37 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mac80211: Add rcu read side critical sections
Message-ID: <20170920121137.GZ4914@intel.com> (sfid-20170920_141144_539527_4A22A0FA)
References: <20170918195919.15860-1-ville.syrjala@linux.intel.com>
 <20170920101123.23312-1-ville.syrjala@linux.intel.com>
 <1505903964.3026.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1505903964.3026.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 20, 2017 at 12:39:24PM +0200, Johannes Berg wrote:
> On Wed, 2017-09-20 at 13:11 +0300, Ville Syrjala wrote:
> 
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -1770,15 +1770,21 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
> >  	struct ieee80211_tx_data tx;
> >  	struct sk_buff *skb2;
> >  
> > -	if (ieee80211_tx_prepare(sdata, &tx, NULL, skb) == TX_DROP)
> > +	rcu_read_lock();
> 
> The documentation says:
> 
> /**
>  * ieee80211_tx_prepare_skb - prepare an 802.11 skb for transmission
>  * @hw: pointer as obtained from ieee80211_alloc_hw()
>  * @vif: virtual interface
>  * @skb: frame to be sent from within the driver
>  * @band: the band to transmit on
>  * @sta: optional pointer to get the station to send the frame to
>  *
>  * Note: must be called under RCU lock
>  */
> 
> You can't even argue that it should be the function itself doing it,
> because the (admittedly optional) sta pointer would otherwise not have
> proper protection after you leave the function ... You can't pass out a
> sta pointer that's RCU protected.

Yeah, I suppose that would need rcu_handoff+some other mechanism to
make sure it stays around after that.

> 
> Side note: Perhaps some annotation should be there? not sure it's
> possible - would have to be something like
> 	struct ieee80211_sta * __rcu *sta;
> 
> I guess since the outer pointer isn't protected, only the inner ...

I think just the fact that even the pointers in ieee80211_tx_data don't
have the __rcu annotation makes it rather hard to see what is really rcu
protected and what isn't. If every user of those pointers would have to
do the rcu_dereference() things would be rather more explicit.

> Therefore, this patch is wrong.

OK, so the problem is in ath9k then.

> I actually think the same is true for ieee80211_tx_dequeue(), but I'm
> less sure about it - the sta pointer there clearly is somehow safely
> passed in (even if it's w/o RCU, the driver can potentially make that
> safe), but the key pointer seems unsafe in this case (as well) if
> there's no outer RCU protection.

Well, I think this is as far as I want to dig into the matter. I can
respin the patch once more with just tx_dequeue() fix in there, if you
want (not sure you do if you think it's wrong as well). After that I'll
leave it to someone who actually knows what they're doing with mac80211 ;)

-- 
Ville Syrjälä
Intel OTC
