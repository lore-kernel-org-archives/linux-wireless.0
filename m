Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35490 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbeBSGH5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 01:07:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Steve deRosier <derosier@gmail.com>
Cc: Samuel Sieb <samuel@sieb.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Max clients on wifi access point with 7265
References: <HE1PR0501MB23969FCE58F1EE7634D412F0F6F50@HE1PR0501MB2396.eurprd05.prod.outlook.com>
        <1518607856.21268.3.camel@sipsolutions.net>
        <4f048d04-5f25-caa1-51b3-dcb14baf36da@sieb.net>
        <CALLGbRLL-tnptVDuFt5E3QoTZ8Wn4K=2wLp3TCNvDJemkGVyKg@mail.gmail.com>
Date: Mon, 19 Feb 2018 08:07:53 +0200
In-Reply-To: <CALLGbRLL-tnptVDuFt5E3QoTZ8Wn4K=2wLp3TCNvDJemkGVyKg@mail.gmail.com>
        (Steve deRosier's message of "Wed, 14 Feb 2018 14:38:10 -0800")
Message-ID: <87h8qdldfq.fsf@purkki.adurom.net> (sfid-20180219_070802_067475_2726E533)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> On Wed, Feb 14, 2018 at 2:04 PM, Samuel Sieb <samuel@sieb.net> wrote:
>> On 02/14/2018 03:30 AM, Johannes Berg wrote:
>>>
>>> On Wed, 2018-02-14 at 10:55 +0000, Micka=C3=ABl PANNEQUIN wrote:
>>>
>>>>
>>>> Do you know the limit of the number of users connected at the same
>>>> time on the wifi? Works fine with 14 connected devices but not more.
>>>>
>>>> How to increase it?
>>>
>>>
>>> You can't.
>>>
>>>> This limit is hardware?
>>>
>>>
>>> More or less, yes. The HW/FW can support 16 STAs, but needs two for
>>> other bookkeeping.
>>
>>
>> As a general question, is there a standard way to determine this limit f=
or
>> any particular hardware?
>
>
> Yes, but there's no easy way. Put it in AP mode and connect clients to
> it until it starts rejecting new clients or dropping the old ones.
> Usually while watching it with a sniffer. That's how I've always had
> to do it.
>
> Different chips will have different limits, and there's no reliable
> way to determine the limit across all chips other than trial and
> error. It seems a common desire of people to try to use client chips
> as poor-man APs. While it will work for very limited number of
> clients, they're not intended as AP chips. If you want something to
> work as an AP, I recommend you choose an AP chip.

We do have wiphy::max_ap_assoc_sta, but I see only ath10k, qtnfmac and
rsi_91x setting it. I wish all drivers would use that.

 * @max_ap_assoc_sta: maximum number of associated stations supported in AP=
 mode
 * (including P2P GO) or 0 to indicate no such limit is advertised. The
 * driver is allowed to advertise a theoretical limit that it can reach in
 * some cases, but may not always reach.

--=20
Kalle Valo
