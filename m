Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:56115 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbBXQ6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 11:58:36 -0500
Received: by mail-oi0-f45.google.com with SMTP id i138so20379672oig.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 08:58:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150224102611.GA30806@w1.fi>
References: <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<20150223171700.GA29730@w1.fi>
	<CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
	<20150223213050.GA23232@w1.fi>
	<CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
	<CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
	<20150223224305.GA30228@w1.fi>
	<21739.50662.902775.901924@gargle.gargle.HOWL>
	<CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>
	<CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com>
	<20150224102611.GA30806@w1.fi>
Date: Tue, 24 Feb 2015 08:58:35 -0800
Message-ID: <CAA93jw6uQhcSmK7r_YK=0iS07N18_eyngP4xTardRkHgyuQqfA@mail.gmail.com> (sfid-20150224_175840_107054_CB7574EB)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: Dave Taht <dave.taht@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Andrew McGregor <andrewmcgr@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2015 at 2:26 AM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Feb 24, 2015 at 01:29:27PM +1100, Andrew McGregor wrote:
>> Over the weekend I found a bug in minstrel-ht that might well be
>> implicated here.
>>
>> The last retransmit rate is meant to be a 'get the packet there
>> reliably' rate; minstrel-ht doesn't do that right, and can pick a
>> fairly flaky rate instead.
>>
>> Can't generate a proper patch right now, so this diff might not apply
>> cleanly, but the fix is simply to change 75 to 99 in the two places
>> below:
>
> While this may indeed be helpful, I don't think it is sufficient for
> this EAPOL frame related issue. What I would like to see is minstrel_ht
> using a basic rate (something non-HT) at the end of the retry series for
> EAPOL frames.
>
> The current behavior looks very suspicious to me. The early EAPOL frames
> after association are being used to probe for higher rates. This results
> in the total number of retry attempts actually getting smaller than any
> other frame, i.e., minstrel_ht seems to be using significantly _less_
> robust choices for the EAPOL frames than following "normal" data frames!
> This should really be the other way around..
>
> As an example, I'm seeing this on 5 GHz band (with the 75 to 99 change
> in place, but behavior was more or less identical without it):
> - the first EAPOL frame (msg 2/4) getting one attempt at MCS 3, 2
>   attempts at MCS 0, 2 attempts at MCS 0 (yes, identical to the previous
>   one) with total maximum of 5 attempts
> - the second EAPOL frame (msg 4/4) getting one attempt at MCS 9, 2
>   attempts at MCS 0, 2 attempts at MCS 0 with total maximum of 5
>   attempts
> - another data frame after this: 5 attempts at MCS 9, 5 attempts at MCS
>   3, 5 attempts at MCS 3 with total maximum of 15 attempts(!!)

I would in general prefer that the excessive retries in the present
driver layers in wifi be
dramatically reduced, the packet dropped and the problem punted to
higher layers.

> This cannot be the best approach here..

Falling back faster to the lowest possible rate with minimum retries,
and then giving up sooner would be better. 15 attempts? jeeze....

> For the
> IEEE80211_TX_CTRL_PORT_CTRL_PROTO cases, there are identified issues
> where failing to deliver the frame results is significant issues either
> in getting connected in the first place or getting disconnected if
> rekeying fails.
>
> I'm not sure how this would be implemented cleanly in minstrel_ht or
> whether that is even the best place (i.e., rate.c could do this
> instead), but I'd like that third attempt for control port cases to be
> dropped to use a (lowish) basic rate and non-MCS at that since there may
> be some interop issues with HT MCS early during association.
> Alternatively with drivers like ath9k that support 4 rate values, it
> would also be fine to add this basic rate attempt (or well, I'd have
> multiple, say 4, such attempts) as an additional 4th entry which does
> not currently seem to get used with minstrel at all.
>
> The "(lowish) basic rate" here could be defined as 6 Mbps OFDM for 5 GHz
> band and either that or maybe even 2 Mbps or 5.5 Mbps on 2.4 GHz (if
> included by the AP in basic rate set).
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel



-- 
Dave Täht
Let's make wifi fast, less jittery and reliable again!

https://plus.google.com/u/0/107942175615993706558/posts/TVX3o84jjmb
