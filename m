Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36282 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030333AbbKDVgB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 16:36:01 -0500
Message-ID: <1446672958.13649.4.camel@sipsolutions.net> (sfid-20151104_223610_516002_DC4D9628)
Subject: Re: [PATCH v2 1/4] ipv4: add option to drop unicast encapsulated in
 L2 multicast
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Anastasov <ja@ssi.bg>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 04 Nov 2015 22:35:58 +0100
In-Reply-To: <alpine.LFD.2.11.1511042215570.2194@ja.home.ssi.bg>
References: <1446654127-26826-1-git-send-email-johannes@sipsolutions.net>
	 <alpine.LFD.2.11.1511042215570.2194@ja.home.ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-11-04 at 22:59 +0200, Julian Anastasov wrote:
> 
>         Patches 1 and 3 look correct to me,
> 
> Reviewed-by: Julian Anastasov <ja@ssi.bg>

Thanks for checking!

>         If the patches are lost in the merge window you
> can also consider one minor optimization, see below...

Oh, yeah, they probably are - sorry Dave.

> > -     } else if (rt->rt_type == RTN_BROADCAST)
> > +     } else if (rt->rt_type == RTN_BROADCAST) {
> >               IP_UPD_PO_STATS_BH(net, IPSTATS_MIB_INBCAST, skb-
> >len);
> > +     } else {
> 
>         } else if (unlikely(skb->pkt_type != PACKET_HOST)) {
> 
>         May be such check can save some cycles because
> it is more common to see PACKET_HOST packets...

I had thought about that based on your earlier comments, but then I
didn't quite see the point. However, perhaps we could invert the check
below to check the pkt_type first, hoping it'll have some kind of cache
effect?

johannes
