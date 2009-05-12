Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61306 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbZELWTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 18:19:05 -0400
Received: by bwz22 with SMTP id 22so266800bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 15:19:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242166545.14227.13.camel@johannes.local>
References: <1242158740.14227.12.camel@johannes.local> <69e28c910905121513t5436ec52u47d0c49657000090@mail.gmail.com>
	<1242166545.14227.13.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 13 May 2009 00:18:44 +0200
Message-ID: <69e28c910905121518p44889103k4282fc3bf60e44f8@mail.gmail.com>
Subject: Re: [PATCH] mac80211: make noack test available
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/13 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2009-05-13 at 00:13 +0200, G=E1bor Stefanik wrote:
>> On Tue, May 12, 2009 at 10:05 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > There's this internal wifi_wme_noack_test variable that
>> > we use to set the QoS control if set. For one, it is
>> > unlikely that it is set. Secondly, if set it needs to
>> > influence the IEEE80211_TX_CTL_NO_ACK TX control flag,
>> > and finally we should also be able to set it at all, so
>> > make it available in debugfs.
>> >
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> > ---
>> > =A0net/mac80211/debugfs.c =A0 =A0 | =A0 38 +++++++++++++++++++++++=
+++++++++++++++
>> > =A0net/mac80211/ieee80211_i.h | =A0 =A01 +
>> > =A0net/mac80211/tx.c =A0 =A0 =A0 =A0 =A0| =A0 =A05 ++++-
>> > =A0net/mac80211/wme.c =A0 =A0 =A0 =A0 | =A0 =A02 +-
>> > =A04 files changed, 44 insertions(+), 2 deletions(-)
>> >
>> > --- wireless-testing.orig/net/mac80211/tx.c =A0 =A0 2009-05-12 21:=
44:01.000000000 +0200
>> > +++ wireless-testing/net/mac80211/tx.c =A02009-05-12 22:03:26.0000=
00000 +0200
>> > @@ -1087,7 +1087,10 @@ __ieee80211_tx_prepare(struct ieee80211_
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0info->flags |=3D IEEE80211_TX_CTL_N=
O_ACK;
>> > =A0 =A0 =A0 =A0} else {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tx->flags |=3D IEEE80211_TX_UNICAST=
;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 info->flags &=3D ~IEEE80211_TX_CTL_N=
O_ACK;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(local->wifi_wme_noack_t=
est))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 info->flags |=3D IEE=
E80211_TX_CTL_NO_ACK;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 info->flags &=3D ~IE=
EE80211_TX_CTL_NO_ACK;
>> > =A0 =A0 =A0 =A0}
>>
>> While you are at it, why not clean up this code completely?
>
> Because I'm lazy.
>
>> IMHO the
>> unset-bit operations are useless, given that both TX_UNICAST and
>> TX_CTL_NO_ACK are initialized to zero at the beginning of
>> __ieee80211_tx_prepare.
>
> Probably. But it works, why change it :)
>
>> This also makes it possible to set
>> TX_CTL_NO_ACK in a TX handler, which is IMO much nicer (not to menti=
on
>> that it significantly simplifies the work needed to support Radiotap=
's
>> TX flags once they land).
>
> That seems to serve only you ;)

I mean, you can put the noack_test check in a more relevant part of
the code if we don't re-zero these bits in tx_prepare.

>
>> (BTW should we implement the already-stable parts of TX flags now, o=
r
>> is it a better idea to wait till it is final?)
>
> Wait until it's final please.
>
> johannes
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
