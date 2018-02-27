Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbeB0IdW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 03:33:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Steve deRosier <derosier@gmail.com>, Samuel Sieb <samuel@sieb.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Max clients on wifi access point with 7265
References: <HE1PR0501MB23969FCE58F1EE7634D412F0F6F50@HE1PR0501MB2396.eurprd05.prod.outlook.com>
        <1518607856.21268.3.camel@sipsolutions.net>
        <4f048d04-5f25-caa1-51b3-dcb14baf36da@sieb.net>
        <CALLGbRLL-tnptVDuFt5E3QoTZ8Wn4K=2wLp3TCNvDJemkGVyKg@mail.gmail.com>
        <87h8qdldfq.fsf@purkki.adurom.net>
        <1519032404.7832.84.camel@coelho.fi>
        <1519039105.7832.94.camel@coelho.fi>
Date: Tue, 27 Feb 2018 10:33:17 +0200
In-Reply-To: <1519039105.7832.94.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 19 Feb 2018 13:18:25 +0200")
Message-ID: <87vaeihlwy.fsf@codeaurora.org> (sfid-20180227_093332_145258_AC5562CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

>> > We do have wiphy::max_ap_assoc_sta, but I see only ath10k, qtnfmac
>> > and
>> > rsi_91x setting it. I wish all drivers would use that.
>> > 
>> >  * @max_ap_assoc_sta: maximum number of associated stations
>> > supported in AP mode
>> >  * (including P2P GO) or 0 to indicate no such limit is advertised.
>> > The
>> >  * driver is allowed to advertise a theoretical limit that it can
>> > reach in
>> >  * some cases, but may not always reach.
>> 
>> Cool, I hadn't noticed this before.  I'll add a patch to iwlwifi to
>> add it.
>
> Actually this is not so straightforward, because every time we add a
> p2p vif, we lose one more station.  So the max_ap_assoc_sta value must
> be dynamic (or we can state the theoretical lowest number to start
> with, which would not be very nice).
>
> I don't think this feature is worth the trouble, so I'll skip it for
> now.

I think the documentation answers that part pretty well:

  "The driver is allowed to advertise a theoretical limit that it can
   reach in some cases, but may not always reach."

So I still thank having the drivers to advertise the theoretical maximum
numbers of client is useful, even if it would not be always 100%
correct. For example, an average user most likely will not have any clue
if the limit is 10, 50 or 100 clients. And besides, very few people use
P2P anyway ;)

But of course this is just nice-to-have category cand we have far more
important things to fix first.

-- 
Kalle Valo
