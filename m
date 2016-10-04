Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42435 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753565AbcJDNZz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 09:25:55 -0400
Message-ID: <1475587551.5324.57.camel@sipsolutions.net> (sfid-20161004_152558_169669_C0633797)
Subject: Re: [PATCH] cfg80211: Add HT and VHT information in start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Xu, Peng" <pxu@qca.qualcomm.com>
Date: Tue, 04 Oct 2016 15:25:51 +0200
In-Reply-To: <20161003211523.GA6585@jouni.qca.qualcomm.com>
References: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
         <1471330367.16783.23.camel@sipsolutions.net>
         <20160816123441.GA3678@jouni.qca.qualcomm.com>
         <1472198948.390.20.camel@sipsolutions.net>
         <1473674982.29016.10.camel@sipsolutions.net>
         <20161003211523.GA6585@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The main goal of this was to see if we can reduce actual driver
> implementation size and maybe even more so to prepare for 802.11ax
> changes (i.e., see what we are doing currently for configuring HT/VHT
> in a way that could be done better).

Fair enough.

> Looking at the current in-tree drivers, it looks like following
> approaches have been used:
> 
> ath6kl:
> Use cfg80211_get_chandef_type(&info->chandef) != NL80211_CHAN_NO_HT
> to determine whether HT is enabled. No VHT support. HT-required case
> not covered. No parsing of HT/VHT IEs used.

Hmm. Wouldn't the supported rates IE still advertise the cookie for HT
only, to make sure HT-required was done?

[snip other drivers]

> So I guess there could be some code sharing and cleanup done with the
> existing in-tree drivers. Especially the mwifiex example looks like
> something that triggered us to look at this. I'm not sure we'd
> propose adding any new driver with the driver code itself doing
> HT/VHT IE parsing and since ath6kl did not do this either, I don't
> see us changing existing in-tree drivers to use this either.

Maybe Marvell folks would like to change something there.

> I'm not sure there would really be enough justification to add this
> specific patch due to the assumed user space update. Adding some of
> the HT/VHT element parsing in cfg80211 might benefit on or two of the
> in-tree drivers if their maintainers are interested in that.

Right, I agree. If we want to unify/combine anything, the best place to
do that would just be cfg80211 at this point. Adding both the API and
the parsing seems fairly pointless now, and evidently drivers can live
with the status quo.

>  That said, without additional interest, I'm starting to lean towards
> using this as an example of what type of parameters we need to add
> for HE from the beginning and not merge this patch.

Ok. I agree that for HE we should consider this more carefully. I
haven't looked at HE AP side yet, so I don't really know what might be
needed there, but when we get to it we can discuss it.

I'll drop this patch then, and if Broadcom or you (ath6kl) want to add
more parsing to the respective drivers we can consider code sharing
with mwifiex that seems to have a more (but not fully) complete version
in there - probably would have to be rewritten for cfg80211, but still.

johannes
