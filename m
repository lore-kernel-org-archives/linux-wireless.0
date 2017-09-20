Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49686 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbdITMRv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:17:51 -0400
Message-ID: <1505909866.3026.16.camel@sipsolutions.net> (sfid-20170920_141758_732364_2AE6C294)
Subject: Re: [PATCH v2 1/2] mac80211: Add rcu read side critical sections
From: Johannes Berg <johannes@sipsolutions.net>
To: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date: Wed, 20 Sep 2017 14:17:46 +0200
In-Reply-To: <20170920121137.GZ4914@intel.com>
References: <20170918195919.15860-1-ville.syrjala@linux.intel.com>
         <20170920101123.23312-1-ville.syrjala@linux.intel.com>
         <1505903964.3026.14.camel@sipsolutions.net>
         <20170920121137.GZ4914@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-09-20 at 15:11 +0300, Ville Syrjälä wrote:
> 
> > I guess since the outer pointer isn't protected, only the inner ...
> 
> I think just the fact that even the pointers in ieee80211_tx_data
> don't have the __rcu annotation makes it rather hard to see what is
> really rcu protected and what isn't. If every user of those pointers
> would have to do the rcu_dereference() things would be rather more
> explicit.

It wouldn't make sense though, because those users don't need to
provide the protection, and they don't need to make sure to use the
pointer in an RCU safe manner (access once etc.) since they're in code
that can't really go wrong... mostly.

> > Therefore, this patch is wrong.
> 
> OK, so the problem is in ath9k then.

I agree.

> > I actually think the same is true for ieee80211_tx_dequeue(), but 
[...]
> Well, I think this is as far as I want to dig into the matter. I can
> respin the patch once more with just tx_dequeue() fix in there, if
> you want (not sure you do if you think it's wrong as well). After
> that I'll leave it to someone who actually knows what they're doing
> with mac80211 ;)

:-)
I think we should rather document that RCU is required for that
function, I think for some usages it may be OK without but with keys
I'm pretty sure you'll need it.

johannes
