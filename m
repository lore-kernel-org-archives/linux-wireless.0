Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:28005 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYJVL7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 07:59:35 -0400
Received: by yw-out-2324.google.com with SMTP id 9so530179ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 04:59:33 -0700 (PDT)
Message-ID: <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com> (sfid-20081022_135940_417886_0407AA84)
Date: Wed, 22 Oct 2008 13:59:33 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <m.sujith@gmail.com>, Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <1224669827.28639.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	 <1224669827.28639.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 12:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-20 at 23:46 +0200, Tomas Winkler wrote:
>
>> > Immediate Block-Ack is mandatory for 11n, delayed BA is optional.
>> > ath9k currently maintains the BA window state internally too.
>> > Another candidate that can be moved to mac80211, IMO.
>> >
>>
>> TX or RX side?

>
> Both? What exactly does your firmware do, say of the list that Sujith
> posted?
>

It answers BA i n RX path and interpret BA in TX Scheduling
retransmission of not acked frames is done in HW (not firmware) no
need to requeue them. In corner case when retries are exhausted  BA
request is issued from mac80211 to advance RX side window.



>> >> What I could also imagine is that mac80211 simply does pretty much
>> >> everything and hands a number of skbs to the driver at once with some
>> >> additional information about how to aggregate them, what sort of spacing
>> >> to use, etc. It should be able to calculate all the required stuff since
>> >> it knows from the rate control algorithm what's happening there.
>>
>> What you need is to compute how many frames can be transmitted within
>> TXOP i think we can provide the calculation
>> depending on the current state. Just with the retransmission down
>> scaling need to be taken into account.
>
> We really need TXOP handling in mac80211 anyway, no? Right now we won't
> handle frames that are too long for the TXOP, for example.
>
>>  That
>> >> might leave Intel out a bit, but I'm starting to think that we want to
>> >> special-case them a bit anyway.
>>
>> Let's see first mvel and bcom implementation :)
>
> Like I said, from what I can tell bcom is really similar, and I'd like
> to not have to re-implement all this first. mac80211 used to have a more
> push-model, which we've deviated from with the HT stuff you did, but for
> most hardware the push-model is still appropriate, so imho we should try
> to go to one even with HT and then see.

Works for me. What I stumble upon is retransmission from within TX
response  path
how this go together with context of regular TX path. Even in iwlwifi
we need to be able to kick/start the internal aggregation queue?

We've since reworked rate
> control to be able to cope with HT too, so mac80211 can have much more
> information about what's going on and should be able to make many of the
> necessary decisions.

What to remind that iwl-agn-rs update rates scale out of band meaning
TX packet doesn't bear the rate scale information. The reasoning
behind is that appropriate rate is picked up when packet is ready to
go on the air and not when it's somewhere deep in the queue.
Otherwise it's regular multiretry algorithm.

Tomas
