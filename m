Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:34565 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdCNNhz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 09:37:55 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac and WIPHY_FLAG_NETNS_OK
Date: Tue, 14 Mar 2017 09:37:49 -0400
Message-ID: <11746680.tvDfvcmMav@yow-masselst-lx1> (sfid-20170314_143857_291506_DF5C5E40)
In-Reply-To: <97ddefbb-12a8-50e6-faf3-001271ac669e@broadcom.com>
References: <2253234.njokx7NVYT@yow-masselst-lx1> <4310845.fn2SnuB68N@yow-masselst-lx1> <97ddefbb-12a8-50e6-faf3-001271ac669e@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 14, 2017 2:27:53 PM EDT Arend Van Spriel wrote:
> On 14-3-2017 14:21, Mark Asselstine wrote:
> > On Tuesday, March 14, 2017 1:41:02 PM EDT Arend Van Spriel wrote:
> >> On 14-3-2017 12:28, Johannes Berg wrote:
> >>>> It never came up with any projects so far.
> > 
> > Myself and one of my colleagues had thought that this might be the case.
> > On
> > the bright side this matches my inability to find any discussions on the
> > matter and that there is the possibility to get this functionality added.
> > 
> >>>> I doubt that the patch
> >>>> below is sufficient. I suspect something more is needed. Using git
> >>>> blame I ended up finding these commits:
> >>>> 
> >>>> a272a72 mac80211: allow using network namespaces
> >>> 
> >>> This is needed in brcm drivers.
> > 
> > I will have a closer look, thanks for the pointer to this patch.
> > 
> >>>> 463d018 cfg80211: make aware of net namespaces
> >>> 
> >>> This has no impact on brcm drivers :)
> >>> 
> >>>> 5061b0c mac80211: cooperate more with network namespaces
> >>> 
> >>> This shouldn't be needed, you're not referring to init_net in brcm
> >>> drivers.
> >>> 
> >>>> I think what is required from brcmfmac is to set netns for each
> >>>> netdev that we create to the same netns as the wiphy instance using
> >>>> wiphy_net().
> >>> 
> >>> Yes, like the mac80211 patch above.
> >>> 
> >>>> Not sure if there is more to consider, but hopefully Johannes can
> >>>> comment on this although the mentioned commits have been around for a
> >>>> while.
> >>> 
> >>> I don't think there's anything else.
> >>> 
> >>>>>         wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
> >>>>>         
> >>>>>                         WIPHY_FLAG_OFFCHAN_TX |
> >>>>> 
> >>>>> -                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
> >>>>> +                       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
> >>>>> +                       WIPHY_FLAG_NETNS_OK;
> >>> 
> >>> This is not sufficient, you still have to set the netns for newly
> >>> created netdevs.
> > 
> > Ah, that is something I had not tested out. I moved an existing phy and
> > its
> > associated vif and things worked as expected and also destroying the NS
> > had
> > things move back as expected. I did not however create any new vifs
> > 
> >> Thanks for confirming my suspicion.
> >> 
> >> Regards,
> >> Arend
> > 
> > Thanks for the quick pointers, not being all that familiar with the
> > wireless code I appreciate the discussion. I will have a closer look and
> > see if I can get a patch out for review.
> 
> Hi Mark,
> 
> I looked at it and preparing a patch. Will send it out shortly to give
> it a try.

Oh perfect thanks. I wasn't intending to create work for you but I will not 
protest. Your expert eye might catch things I would have missed, only to be 
caught in review.

Mark

> 
> Regards,
> Arend
