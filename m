Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64774 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbCRT3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 15:29:03 -0400
Message-ID: <5509D1F9.5000609@broadcom.com> (sfid-20150318_202907_644986_4B7D622E)
Date: Wed, 18 Mar 2015 20:28:57 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wiphy band information
References: <550952B4.4050400@broadcom.com> <1426706320.3001.21.camel@sipsolutions.net>
In-Reply-To: <1426706320.3001.21.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/15 20:18, Johannes Berg wrote:
> Hi Arend,
>
>> Is it ok to update the wiphy band information after registration.
>
> I believe this will cause issues.
>
>> In
>> brcmfmac the firmware is queried to obtain the supported channels.
>> However, it returns the channels for the current country set in
>> firmware. So after probe/registration iw shows:
>
>> Looks fine apart from the power levels so it made me wonder if what I am
>> doing is allowed. Any opinion on this?
>
> I think the regulatory flags will also break, since some are
> pre-processed during wiphy registration.
>
>> I assume the supported band info is intended to show what hardware can
>> do regardless of the configured country, but I have no way to pull that
>> info from the device.
>
> I'd recommend finding (and hard-coding) a superset of all the channels
> that the hardware could supported, and then dynamically setting the
> disabled flag on those channels that the (current) regulatory
> information cannot do.

Depending on your reply that was the plan.

> This is something that needs to be handled throughout the code since
> regulatory information can already change, but adding/removing channels
> is something I'd really recommend against.

I had my suspicions. Thanks.

Gr. AvS
