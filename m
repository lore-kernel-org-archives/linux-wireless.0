Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:46834 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaBMKqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 05:46:06 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [net-next 3/3] cfg80211: add MPLS and 802.21 classification
Date: Thu, 13 Feb 2014 11:46:01 +0100
Cc: netdev@vger.kernel.org, davem@davemloft.net,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de
References: <1392202386-8826-1-git-send-email-sw@simonwunderlich.de> <1392202386-8826-4-git-send-email-sw@simonwunderlich.de> <1392205783.1868.5.camel@joe-AO722>
In-Reply-To: <1392205783.1868.5.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201402131146.01749.sw@simonwunderlich.de> (sfid-20140213_114614_833220_F10F8B9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Joe,

thanks for the comments!

> On Wed, 2014-02-12 at 11:53 +0100, Simon Wunderlich wrote:
> > MPLS labels may contain traffic control information, which should be
> > evaluated and used by the wireless subsystem if present.
> 
> trivial notes:
> > diff --git a/net/wireless/util.c b/net/wireless/util.c
> 
> []
> 
> > @@ -11,6 +11,7 @@
> > 
> >  #include <net/ip.h>
> >  #include <net/dsfield.h>
> >  #include <linux/if_vlan.h>
> > 
> > +#include <uapi/linux/mpls.h>
> 
> Please try not to #include uapi files.
> 

why not? The packet definition header has been put in UAPI, so I need that 
there ... or should we move that to some place else? Other protocol definition 
headers like IP, udp, tcp have been defined in uapi too the same way, so I 
figured that would be the right position.

> > @@ -710,6 +711,29 @@ unsigned int cfg80211_classify8021d(struct sk_buff
> > *skb,
> > 
> >  			return vlan_priority;
> >  	
> >  	}
> > 
> > +	if (skb_headlen(skb) >= sizeof(struct ethhdr)) {
> > +		struct ethhdr *eh = (struct ethhdr *) skb->data;
> > +		struct mpls_label_stack mpls_tmp, *mpls;
> > +
> > +		switch (eh->h_proto) {
> > +		case __constant_htons(ETH_P_MPLS_UC):
> 
> > +		case __constant_htons(ETH_P_MPLS_MC):
> __constant_ isn't necessary for these labels.
> 

OK, I will change that.

> >  	switch (skb->protocol) {
> >  	
> >  	case htons(ETH_P_IP):
> >  		dscp = ipv4_get_dsfield(ip_hdr(skb)) & 0xfc;
> 
> like this, just case htons(ETH_<FOO>) is enough.

OK.

I can rework and resend this particular patch - probably to linux wireless. If 
the other patches are ok, would you guys merge the first two patches to net-
next then?

Thanks,
    Simon
