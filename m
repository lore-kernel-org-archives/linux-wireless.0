Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42993 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2BHJWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 04:22:01 -0500
Message-ID: <1328692916.2284.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> (sfid-20120208_102214_292873_4D9A71B3)
Subject: Re: [PATCH] skbuff: Add new tc classify variable
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jamal Hadi Salim <hadi@cyberus.ca>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Sven Eckelmann <sven@narfation.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2012 10:21:56 +0100
In-Reply-To: <20120207201633.GB26533@pandem0nium>
References: <1328639948-25232-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <20120207.135841.1753473725075272902.davem@davemloft.net>
	 <20120207201633.GB26533@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mardi 07 février 2012 à 21:16 +0100, Simon Wunderlich a écrit :
> Hello David,
> 
> On Tue, Feb 07, 2012 at 01:58:41PM -0500, David Miller wrote:
> > From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
> > Date: Tue,  7 Feb 2012 19:39:08 +0100
> > 
> > > The linux traffic control mechanism has different ways to select the
> > > correct class of a qdisc. A common way to do this is to use tc filters
> > > that are directly attached to a qdisc. Another approach is to use the
> > > iptables classify module. The latter one can reduce the amount of work
> > > necessary to process a packet when iptables is already involved in the
> > > packet classification.
> > 
> > Do not bloat up sk_buff any more.  Add this, and the other existing
> > tc_* members to the qdisc SKB control block instead.
> > 
> 
> Thanks for your feedback!
> 
> I guess you mean skb->cb, but this is also used within mac80211 for various things
> (quoting include/net/mac80211.h):
> 
>  * struct ieee80211_tx_info - skb transmit information
>  *
>  * This structure is placed in skb->cb for three uses:
>  *  (1) mac80211 TX control - mac80211 tells the driver what to do
>  *  (2) driver internal use (if applicable)
>  *  (3) TX status information - driver tells mac80211 what happened
> 
> We could give it a try, but we most probably run into conflicts again.
> 
> I've messed up the CCs in my initial mail (and just resent it) - sorry about that.
> Maybe the mac80211 guys have a suggestion as well :)
> 

I really dont understand what the conflict might be.

As long as skb is in Qdisc layer, Qdisc owns skb->cb[] (a part of it
actually, see current discussions about IB on netdev)

As soon as packet is given to device (mac80211), cb[] can be reused.

Or are you saying tc_class also might be needed by mac80211 in the
future ?



