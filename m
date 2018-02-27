Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:39242 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbeB0R5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 12:57:16 -0500
Received: by mail-wr0-f170.google.com with SMTP id w77so25763550wrc.6
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 09:57:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vaeihlwy.fsf@codeaurora.org>
References: <HE1PR0501MB23969FCE58F1EE7634D412F0F6F50@HE1PR0501MB2396.eurprd05.prod.outlook.com>
 <1518607856.21268.3.camel@sipsolutions.net> <4f048d04-5f25-caa1-51b3-dcb14baf36da@sieb.net>
 <CALLGbRLL-tnptVDuFt5E3QoTZ8Wn4K=2wLp3TCNvDJemkGVyKg@mail.gmail.com>
 <87h8qdldfq.fsf@purkki.adurom.net> <1519032404.7832.84.camel@coelho.fi>
 <1519039105.7832.94.camel@coelho.fi> <87vaeihlwy.fsf@codeaurora.org>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 27 Feb 2018 09:56:35 -0800
Message-ID: <CALLGbRKYp_uUXHBFNSB6gkjCk0r05xf=B1eJyaqAMJqqtVK87Q@mail.gmail.com> (sfid-20180227_185720_929567_77F6A8A6)
Subject: Re: Max clients on wifi access point with 7265
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Luca Coelho <luca@coelho.fi>, Samuel Sieb <samuel@sieb.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 12:33 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Luca Coelho <luca@coelho.fi> writes:
>
>>> > We do have wiphy::max_ap_assoc_sta, but I see only ath10k, qtnfmac
>>> > and
>>> > rsi_91x setting it. I wish all drivers would use that.
>>> >
>>> >  * @max_ap_assoc_sta: maximum number of associated stations
>>> > supported in AP mode
>>> >  * (including P2P GO) or 0 to indicate no such limit is advertised.
>>> > The
>>> >  * driver is allowed to advertise a theoretical limit that it can
>>> > reach in
>>> >  * some cases, but may not always reach.
>>>
>>> Cool, I hadn't noticed this before.  I'll add a patch to iwlwifi to
>>> add it.
>>
>> Actually this is not so straightforward, because every time we add a
>> p2p vif, we lose one more station.  So the max_ap_assoc_sta value must
>> be dynamic (or we can state the theoretical lowest number to start
>> with, which would not be very nice).
>>
>> I don't think this feature is worth the trouble, so I'll skip it for
>> now.
>
> I think the documentation answers that part pretty well:
>
>   "The driver is allowed to advertise a theoretical limit that it can
>    reach in some cases, but may not always reach."
>
> So I still thank having the drivers to advertise the theoretical maximum
> numbers of client is useful, even if it would not be always 100%
> correct. For example, an average user most likely will not have any clue
> if the limit is 10, 50 or 100 clients. And besides, very few people use
> P2P anyway ;)
>
> But of course this is just nice-to-have category cand we have far more
> important things to fix first.
>

>From a practical point-of-view, many chipsets don't advertise this
information. Luca was able to look the limit up or knew it for his
chip. For example, on the ath6kl chips I most commonly have worked
with, the number is not specified by QCA and was only determined by us
via experimentation. And even on the same chip, it'll change with
firmware version as the necessary resources get consumed by new
features or fixes. If the firmware can send that number up to the
driver (or the driver can reliably know it because it can't change),
then expose it, but otherwise I'd advise publishing a value of 0. I'd
rather see the unknown flag rather than relying on a number that may
or may not be accurate.

- Steve

--
Steve deRosier
Cal-Sierra Consulting LLC
https://www.cal-sierra.com/
