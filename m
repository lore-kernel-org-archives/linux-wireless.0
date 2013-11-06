Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:48943 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3KFKQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:16:12 -0500
Received: by mail-we0-f180.google.com with SMTP id q59so4735423wes.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 02:16:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383724794.14307.2.camel@jlt4.sipsolutions.net>
References: <CABPxzY++gCivs1u8nDtAeB5=p+ZkGHXmOnqud1hkh=TWB5Xprg@mail.gmail.com>
 <1383724794.14307.2.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 6 Nov 2013 15:45:50 +0530
Message-ID: <CABPxzYLYZ=M=a7of-0HyNnJb_g9jP2wNXp378RN5ai-BjngQOw@mail.gmail.com> (sfid-20131106_111623_188907_4E2F642C)
Subject: Re: [Query] Decryption and Monitor Mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: radiotap@netbsd.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 6, 2013 at 1:29 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2013-11-06 at 01:22 +0530, Krishna Chaitanya wrote:
>
>> With this wireshark is not able to decode the packets, even thought
>> they are decrypted. I propose 2 solutions
>
> Well, you can say "ignore protected bit (with IV)" in the settings of
> wireshark. But I agree that this is cumbersome, and previously floated
> the idea of addings bits to radiotap to make this auto-detected.
>

yeah, that piece of code looks messy.

>> Radiotap and Wireshark:
>>
>> 1) Add 2 flags to the radiotap RX Flags (HW Decrypted the packet,
>> Packet has security Header (for some chipsets which consume the
>> security header as well..??).)
>>
>> Based on these the wireshark dissector decodes the packet accordingly.
>>
>> mac80211:
>>
>> 2) Remove the security header information in the monitor path as well
>> based on the existing RX_FLAGS.
>>
>>
>> Solutions 2 looks more elegant and simple, any comments?
>
> Solution 2 drops information and makes the kernel code more expensive,
> so I don't think we want that.
>
> I think the radiotap bits would be better.
>
Ok, then i will proceed and add those 2 flags to the RX Flags (we have
enough bits to use).
