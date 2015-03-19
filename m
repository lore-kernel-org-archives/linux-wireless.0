Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:33358 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbbCSI57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 04:57:59 -0400
Received: by ladw1 with SMTP id w1so56520801lad.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2015 01:57:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5509D1F9.5000609@broadcom.com>
References: <550952B4.4050400@broadcom.com> <1426706320.3001.21.camel@sipsolutions.net>
 <5509D1F9.5000609@broadcom.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 19 Mar 2015 10:57:42 +0200
Message-ID: <CA+XVXff7ZHeEUqg0z1HsBCqSQGQRb+56xMsPJYkuzSU1GcVxOw@mail.gmail.com> (sfid-20150319_095804_612503_F71D4F78)
Subject: Re: wiphy band information
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 18, 2015 at 9:28 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 03/18/15 20:18, Johannes Berg wrote:
>>
>> Hi Arend,
>>
>>> Is it ok to update the wiphy band information after registration.
>>
>>
>> I believe this will cause issues.
>>
>>> In
>>> brcmfmac the firmware is queried to obtain the supported channels.
>>> However, it returns the channels for the current country set in
>>> firmware. So after probe/registration iw shows:
>>
>>
>>> Looks fine apart from the power levels so it made me wonder if what I am
>>> doing is allowed. Any opinion on this?
>>
>>
>> I think the regulatory flags will also break, since some are
>> pre-processed during wiphy registration.
>>
>>> I assume the supported band info is intended to show what hardware can
>>> do regardless of the configured country, but I have no way to pull that
>>> info from the device.
>>
>>
>> I'd recommend finding (and hard-coding) a superset of all the channels
>> that the hardware could supported, and then dynamically setting the
>> disabled flag on those channels that the (current) regulatory
>> information cannot do.
>
>
> Depending on your reply that was the plan.

btw, this is what's done in iwlwifi (iwlmvm) - all supported channels
are registered with regulatory flags=0. Later on when specific
countries are set, some channels are disabled/limited.

Arik
