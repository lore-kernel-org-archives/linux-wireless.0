Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60797 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbeIEPmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 11:42:11 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
In-Reply-To: <1536145704.3528.8.camel@sipsolutions.net>
References: <20180905080036.9177-1-johannes@sipsolutions.net> <87in3k6zti.fsf@toke.dk> <1536141045.3528.4.camel@sipsolutions.net> <87d0ts6zeb.fsf@toke.dk> <1536144985.3528.7.camel@sipsolutions.net> <871sa86w44.fsf@toke.dk> <1536145704.3528.8.camel@sipsolutions.net>
Date: Wed, 05 Sep 2018 13:12:24 +0200
Message-ID: <87y3cg5hbb.fsf@toke.dk> (sfid-20180905_131229_088353_00014BFE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-09-05 at 13:07 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> > Felix wasn't really convinced, I think. He also pointed out some drive=
rs
>> > use skb->priority without checking anything, but I'm not sure we can
>> > really squash all the cases of setting skb priority easily?
>>=20
>> ~/build/linux/drivers/net/wireless $ git grep 'skb->priority =3D '
>> ath/ath9k/channel.c:		skb->priority =3D 7;
>> broadcom/brcm80211/brcmfmac/core.c:		skb->priority =3D cfg80211_classify=
8021d(skb, NULL);
>> broadcom/brcm80211/brcmutil/utils.c:		skb->priority =3D 0;
>> intel/ipw2x00/libipw_tx.c:		skb->priority =3D libipw_classify(skb);
>> marvell/mwifiex/cfg80211.c:	skb->priority =3D LOW_PRIO_TID;
>> marvell/mwifiex/main.c:	skb->priority =3D cfg80211_classify8021d(skb, NU=
LL);
>> marvell/mwifiex/tdls.c:		skb->priority =3D MWIFIEX_PRIO_BK;
>> marvell/mwifiex/tdls.c:		skb->priority =3D MWIFIEX_PRIO_VI;
>> marvell/mwifiex/tdls.c:	skb->priority =3D MWIFIEX_PRIO_VI;
>> rsi/rsi_91x_core.c:		skb->priority =3D q_num;
>> rsi/rsi_91x_core.c:			skb->priority =3D TID_TO_WME_AC(tid);
>> rsi/rsi_91x_core.c:			skb->priority =3D BE_Q;
>> rsi/rsi_91x_core.c:			skb->priority =3D q_num;
>> rsi/rsi_91x_hal.c:			skb->priority =3D VO_Q;
>> rsi/rsi_91x_mgmt.c:	skb->priority =3D MGMT_SOFT_Q;
>> ti/wlcore/main.c:	skb->priority =3D WL1271_TID_MGMT;
>>=20
>> Doesn't seem *that* excessive? Obviously there could be other cases, and
>> I haven't looked closer at any of those...
>
> That's assignments. For assignments, I guess you'd have to look at
> net/mac80211/. It's not that excessive either, but it's not in all
> places trivial to determine ...

Ah, sorry, I read that as "some drivers *set* skb->priority without
checking"...

-Toke
