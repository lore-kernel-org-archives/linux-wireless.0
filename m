Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40222 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbcDZUKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 16:10:13 -0400
Subject: Re: [PATCH v2] ath10k: remove VHT capabilities from 2.4GHz
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com>
 <5718EE7A.4030503@candelatech.com>
 <1461654272.16188.4.camel@sipsolutions.net>
 <87mvogy3ux.fsf@kamboji.qca.qualcomm.com>
 <CABPxzYL=sQg=HczxM3gdERHRD-3-KaOG455wsqjpZ6YZDkybmw@mail.gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <571FCB22.5000305@candelatech.com> (sfid-20160426_221017_982413_B1FCA331)
Date: Tue, 26 Apr 2016 13:10:10 -0700
MIME-Version: 1.0
In-Reply-To: <CABPxzYL=sQg=HczxM3gdERHRD-3-KaOG455wsqjpZ6YZDkybmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2016 01:07 PM, Krishna Chaitanya wrote:
> On Tue, Apr 26, 2016 at 5:33 PM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>
>>> On Thu, 2016-04-21 at 08:15 -0700, Ben Greear wrote:
>>>
>>>> The thing is, it actually works just fine with the patch I posted
>>>> to fix mac80211, and at any rate, even if the mac80211 patch isn't
>>>> applied, the ath10k driver works just fine in HT mode.
>>>
>>> This patch has no implications on HT, and I wasn't planning on applying
>>> the mac80211 patch.
>>
>> Yeah, makes sense. I'm planning to apply this soon.
>>
>>> As I said, I have no objections to doing the (Broadcom) vendor specific
>>> IEs for "VHT" in 2.4 GHz band, but I don't think we should advertise
>>> the spec IEs when they're explicitly specified to be used only in the
>>> 5.2 GHz band.
>>
>> But we really should have this, any volunteers? :) I think it shouldn't
>> be too hard to do so this would be a good project for someone looking
>> for a simple, but useful, task on wireless stack.
> Are these Broadcom IEs documented somewhere? If yes,
> then its a matter of parsing them and adding support to
> minstrel_ht, isn't it? major work would be in minstrel.
>

For ath10k, rate-ctrl is done in the firmware, so
no work at all in minstrel-ht.

The end result, as far as I can tell,
is you would just have to tell mac80211 to allow
VHT on 2.4Ghz, and revert this patch that Kalle is proposing.

Maybe someone that actually knows about these IEs can explain why
they are worth using?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

