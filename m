Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43259 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbeIEPhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 11:37:09 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
In-Reply-To: <1536144985.3528.7.camel@sipsolutions.net>
References: <20180905080036.9177-1-johannes@sipsolutions.net> <87in3k6zti.fsf@toke.dk> <1536141045.3528.4.camel@sipsolutions.net> <87d0ts6zeb.fsf@toke.dk> <1536144985.3528.7.camel@sipsolutions.net>
Date: Wed, 05 Sep 2018 13:07:23 +0200
Message-ID: <871sa86w44.fsf@toke.dk> (sfid-20180905_130728_083718_4EDA80B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-09-05 at 11:56 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> > So basically this gets rid of a corner case that we shouldn't have.
>> > Either we should decide that using different TXQs is *always* correct
>> > for non-QoS, or - what I thought - that this isn't worth it, and then =
we
>> > should *never* do it.
>>=20
>> Yeah, I agree that this is not worth it. The queue is already
>> FQ-CoDel'ed, which gives us most of the benefit of QoS anyway :)
>
> So do I read that as a tentative ack? :)

Yeah, guess so :)

> Felix wasn't really convinced, I think. He also pointed out some drivers
> use skb->priority without checking anything, but I'm not sure we can
> really squash all the cases of setting skb priority easily?

~/build/linux/drivers/net/wireless $ git grep 'skb->priority =3D '
ath/ath9k/channel.c:		skb->priority =3D 7;
broadcom/brcm80211/brcmfmac/core.c:		skb->priority =3D cfg80211_classify802=
1d(skb, NULL);
broadcom/brcm80211/brcmutil/utils.c:		skb->priority =3D 0;
intel/ipw2x00/libipw_tx.c:		skb->priority =3D libipw_classify(skb);
marvell/mwifiex/cfg80211.c:	skb->priority =3D LOW_PRIO_TID;
marvell/mwifiex/main.c:	skb->priority =3D cfg80211_classify8021d(skb, NULL);
marvell/mwifiex/tdls.c:		skb->priority =3D MWIFIEX_PRIO_BK;
marvell/mwifiex/tdls.c:		skb->priority =3D MWIFIEX_PRIO_VI;
marvell/mwifiex/tdls.c:	skb->priority =3D MWIFIEX_PRIO_VI;
rsi/rsi_91x_core.c:		skb->priority =3D q_num;
rsi/rsi_91x_core.c:			skb->priority =3D TID_TO_WME_AC(tid);
rsi/rsi_91x_core.c:			skb->priority =3D BE_Q;
rsi/rsi_91x_core.c:			skb->priority =3D q_num;
rsi/rsi_91x_hal.c:			skb->priority =3D VO_Q;
rsi/rsi_91x_mgmt.c:	skb->priority =3D MGMT_SOFT_Q;
ti/wlcore/main.c:	skb->priority =3D WL1271_TID_MGMT;

Doesn't seem *that* excessive? Obviously there could be other cases, and
I haven't looked closer at any of those...

Does it matter for the drivers that don't use TXQs?

-Toke
