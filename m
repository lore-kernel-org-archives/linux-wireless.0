Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34250 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbcD0Jhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 05:37:46 -0400
Received: by mail-qk0-f195.google.com with SMTP id i7so2844631qkd.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2016 02:37:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160427091653.GB4345@w1.fi>
References: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com>
 <5718EE7A.4030503@candelatech.com> <1461654272.16188.4.camel@sipsolutions.net>
 <87mvogy3ux.fsf@kamboji.qca.qualcomm.com> <CABPxzYL=sQg=HczxM3gdERHRD-3-KaOG455wsqjpZ6YZDkybmw@mail.gmail.com>
 <571FCB22.5000305@candelatech.com> <CABPxzY+UuCABUcFbV0EpdoRaSzpgGvMani_j7xvg2a=xh-Bw0g@mail.gmail.com>
 <20160427091653.GB4345@w1.fi>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 27 Apr 2016 15:07:26 +0530
Message-ID: <CABPxzYJz59wOXjK2fCK_Tp05g0g1FY+VWscFKz9fG+D1swZGBA@mail.gmail.com> (sfid-20160427_113754_123494_95941457)
Subject: Re: [PATCH v2] ath10k: remove VHT capabilities from 2.4GHz
To: Jouni Malinen <j@w1.fi>
Cc: Ben Greear <greearb@candelatech.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2016 at 2:46 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Apr 27, 2016 at 12:13:46PM +0530, Krishna Chaitanya wrote:
>> On Wed, Apr 27, 2016 at 1:40 AM, Ben Greear <greearb@candelatech.com> wrote:
>> > On 04/26/2016 01:07 PM, Krishna Chaitanya wrote:
>> >> Are these Broadcom IEs documented somewhere? If yes,
>> >> then its a matter of parsing them and adding support to
>> >> minstrel_ht, isn't it? major work would be in minstrel.
>
>> > The end result, as far as I can tell,
>> > is you would just have to tell mac80211 to allow
>> > VHT on 2.4Ghz, and revert this patch that Kalle is proposing.
>>
>> Ideally as this is vendor specific it makes sense to implement this
>> at Driver/FW level rather than implementing it at a common stack
>> like mac80211.
>>
>> > Maybe someone that actually knows about these IEs can explain why
>> > they are worth using?
>>
>> These IE's can be parsed in the driver without any mac80211 involvement.
>
> Sure, these are vendor specific elements, but they are simply
> encapsulating the standard VHT elements that we already handle within
> mac80211 for STA functionality and hostapd for AP functionality. I don't
> see why we would make this any more complex for 2.4 GHz 256-QAM support
> than extending the existing locations that support the VHT elements.
>
> The main reason for me in using these particular vendor specific
> elements is in them being already supported by number of deployed
> devices. There is also support for these in hostapd (vendor_vht=1 in
> hostapd.conf) and as far as I know, this used to work with ath10k for AP
> mode (and this patch we discuss here may break that). The main missing
> functionality is for the matching STA side support with mac80211 and
> that's where the changes, IMHO, would fit in nicely in mac80211 next to
> the places where we handle the matching standard VHT elements in the 5
> GHz band.
If many vendors need this support, then mac80211 appraoch would be good.
If not, we should stick to driver approach.
