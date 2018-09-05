Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43170 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbeIEPiR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 11:38:17 -0400
Message-ID: <1536145704.3528.8.camel@sipsolutions.net> (sfid-20180905_130835_791056_FBF3F79B)
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 05 Sep 2018 13:08:24 +0200
In-Reply-To: <871sa86w44.fsf@toke.dk>
References: <20180905080036.9177-1-johannes@sipsolutions.net>
         <87in3k6zti.fsf@toke.dk> <1536141045.3528.4.camel@sipsolutions.net>
         <87d0ts6zeb.fsf@toke.dk> <1536144985.3528.7.camel@sipsolutions.net>
         <871sa86w44.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 13:07 +0200, Toke Høiland-Jørgensen wrote:

> > Felix wasn't really convinced, I think. He also pointed out some drivers
> > use skb->priority without checking anything, but I'm not sure we can
> > really squash all the cases of setting skb priority easily?
> 
> ~/build/linux/drivers/net/wireless $ git grep 'skb->priority = '
> ath/ath9k/channel.c:		skb->priority = 7;
> broadcom/brcm80211/brcmfmac/core.c:		skb->priority = cfg80211_classify8021d(skb, NULL);
> broadcom/brcm80211/brcmutil/utils.c:		skb->priority = 0;
> intel/ipw2x00/libipw_tx.c:		skb->priority = libipw_classify(skb);
> marvell/mwifiex/cfg80211.c:	skb->priority = LOW_PRIO_TID;
> marvell/mwifiex/main.c:	skb->priority = cfg80211_classify8021d(skb, NULL);
> marvell/mwifiex/tdls.c:		skb->priority = MWIFIEX_PRIO_BK;
> marvell/mwifiex/tdls.c:		skb->priority = MWIFIEX_PRIO_VI;
> marvell/mwifiex/tdls.c:	skb->priority = MWIFIEX_PRIO_VI;
> rsi/rsi_91x_core.c:		skb->priority = q_num;
> rsi/rsi_91x_core.c:			skb->priority = TID_TO_WME_AC(tid);
> rsi/rsi_91x_core.c:			skb->priority = BE_Q;
> rsi/rsi_91x_core.c:			skb->priority = q_num;
> rsi/rsi_91x_hal.c:			skb->priority = VO_Q;
> rsi/rsi_91x_mgmt.c:	skb->priority = MGMT_SOFT_Q;
> ti/wlcore/main.c:	skb->priority = WL1271_TID_MGMT;
> 
> Doesn't seem *that* excessive? Obviously there could be other cases, and
> I haven't looked closer at any of those...

That's assignments. For assignments, I guess you'd have to look at
net/mac80211/. It's not that excessive either, but it's not in all
places trivial to determine ...

Whatever, I'll just try, give me a minute :)

> Does it matter for the drivers that don't use TXQs?

Probably.

johannes
