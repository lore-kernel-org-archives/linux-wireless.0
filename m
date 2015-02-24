Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59908 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311AbbBXRyt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 12:54:49 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: =?utf-8?Q?Thomas_H=C3=BChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <20150224102611.GA30806@w1.fi>
Date: Tue, 24 Feb 2015 18:54:47 +0100
Cc: Andrew McGregor <andrewmcgr@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Message-Id: <80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de> (sfid-20150224_185452_158547_357A1341)
References: <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com> <20150223171700.GA29730@w1.fi> <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com> <20150223213050.GA23232@w1.fi> <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com> <CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com> <20150223224305.GA30228@w1.fi> <21739.50662.902775.901924@gargle.gargle.HOWL> <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com> <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com> <20150224102611.GA30806@w1.fi>
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

Currently Minstrel_HT just skips EAPOL packets for its rate sampling on non-mrr chips by testing: (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
On mrr hardware it uses them for probing. 
But the general MRR-chain should look like this for ath5k and ath9k chips that support 4 mrr chains:

mrr[0]:= max_tp_rate[0]
mrr[1]:= max_tp_rate[1]
mrr[2]:= max_prob_rate
mrr[3]:= basic_rate

So for Minstrel Sampling Packets as well as for data packets, the 4th mrr stage should use the slowest rate in case all other 3 mrr stages failed with their retry attempts.

I do see two possible options for control frames like EAPOL to be send out in a more robust fashion:
 - exclude those frames from AMPDU aggragates 
 - change their mrr setup to be more conservative

What do you think about this ?

Greetings Thomas


> Am 24.02.2015 um 11:26 schrieb Jouni Malinen <j@w1.fi>:
> 
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
>  attempts at MCS 0, 2 attempts at MCS 0 (yes, identical to the previous
>  one) with total maximum of 5 attempts
> - the second EAPOL frame (msg 4/4) getting one attempt at MCS 9, 2
>  attempts at MCS 0, 2 attempts at MCS 0 with total maximum of 5
>  attempts
> - another data frame after this: 5 attempts at MCS 9, 5 attempts at MCS
>  3, 5 attempts at MCS 3 with total maximum of 15 attempts(!!)
> 
> This cannot be the best approach here.. For the
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

