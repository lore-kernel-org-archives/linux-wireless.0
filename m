Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57095 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbbBYFAh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 00:00:37 -0500
Message-ID: <54ED56D8.9030806@openwrt.org> (sfid-20150225_060040_819406_8957C6DA)
Date: Wed, 25 Feb 2015 18:00:08 +1300
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
References: <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>	<20150223213050.GA23232@w1.fi>	<CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>	<CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>	<20150223224305.GA30228@w1.fi>	<21739.50662.902775.901924@gargle.gargle.HOWL>	<CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>	<CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com>	<20150224102611.GA30806@w1.fi>	<80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de> <20150224181454.GA30859@w1.fi>
In-Reply-To: <20150224181454.GA30859@w1.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-02-25 07:14, Jouni Malinen wrote:
> On Tue, Feb 24, 2015 at 06:54:47PM +0100, Thomas Hühn wrote:
>> Currently Minstrel_HT just skips EAPOL packets for its rate sampling on non-mrr chips by testing: (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
> 
> Yeah, I noticed that when going through the implementation, but it was
> indeed only for cases other than ath9k-like drivers.
> 
>> On mrr hardware it uses them for probing. 
>> But the general MRR-chain should look like this for ath5k and ath9k chips that support 4 mrr chains:
>> 
>> mrr[0]:= max_tp_rate[0]
>> mrr[1]:= max_tp_rate[1]
>> mrr[2]:= max_prob_rate
>> mrr[3]:= basic_rate
> 
> Where is that mrr[3] part implemented? I did not find it when reviewing
> the design (hw->max_rates >= 3 is used, but not >= 4) and this does not
> match my experiments either when printing out all four values from
> ath9k. In every single case I observed, the last entry was unused (idx =
> -1) and only MCS values were used (i.e., not even a single case of basic
> rate visible; basic rates being 6, 12, 24 Mbps OFDM in this specific
> case with the AP that I used in the tests).
Minstrel_ht does *NOT* use mrr[3], nor should it. For normal data
packets, a little packet loss under tough conditions is good, otherwise
we risk lots of wasted airtime and bufferbloat.

>> So for Minstrel Sampling Packets as well as for data packets, the 4th mrr stage should use the slowest rate in case all other 3 mrr stages failed with their retry attempts.
>> 
>> I do see two possible options for control frames like EAPOL to be send out in a more robust fashion:
>>  - exclude those frames from AMPDU aggragates 
> 
> ath9k does that for IEEE80211_TX_CTL_RATE_CTRL_PROBE which seemed to
> get set for the initial EAPOL frames. I guess this could be done more
> generically for all EAPOL frames.
I agree.

>>  - change their mrr setup to be more conservative
> 
> That mrr[3]:= basic_rate is the part I was really asking for as far as
> EAPOL frames are concerned.
I don't think we need that. If we just exclude EAPOL from both probing
and aggregation, it should be safe. While it's connecting, that leaves
in low rates in the retry chain anyway.

If it still fails often enough to be noticeable under normal conditions,
there must be something seriously wrong outside of rate control, and we
should not paper over it with a crude band-aid workaround.

- Felix
