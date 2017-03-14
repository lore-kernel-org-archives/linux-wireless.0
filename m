Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37948 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbdCNL2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 07:28:32 -0400
Message-ID: <1489490906.28373.3.camel@sipsolutions.net> (sfid-20170314_122835_221002_EEFCAAB8)
Subject: Re: brcmfmac and WIPHY_FLAG_NETNS_OK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Mark Asselstine <mark.asselstine@windriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 14 Mar 2017 12:28:26 +0100
In-Reply-To: <df16691e-62f7-4c95-0534-48d1dea4f5ba@broadcom.com> (sfid-20170314_105145_213435_11AD40CE)
References: <2253234.njokx7NVYT@yow-masselst-lx1>
         <df16691e-62f7-4c95-0534-48d1dea4f5ba@broadcom.com>
         (sfid-20170314_105145_213435_11AD40CE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> It never came up with any projects so far. I doubt that the patch
> below is sufficient. I suspect something more is needed. Using git
> blame I ended up finding these commits:
> 
> a272a72 mac80211: allow using network namespaces

This is needed in brcm drivers.

> 463d018 cfg80211: make aware of net namespaces

This has no impact on brcm drivers :)

> 5061b0c mac80211: cooperate more with network namespaces

This shouldn't be needed, you're not referring to init_net in brcm
drivers.

> I think what is required from brcmfmac is to set netns for each
> netdev that we create to the same netns as the wiphy instance using
> wiphy_net().

Yes, like the mac80211 patch above.

> Not sure if there is more to consider, but hopefully Johannes can
> comment on this although the mentioned commits have been around for a
> while.

I don't think there's anything else.

> >         wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
> >                         WIPHY_FLAG_OFFCHAN_TX |
> > -                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
> > +                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
> > +                       WIPHY_FLAG_NETNS_OK;

This is not sufficient, you still have to set the netns for newly
created netdevs.

johannes
