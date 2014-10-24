Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailservices.uwaterloo.ca ([129.97.128.141]:45322 "EHLO
	minos.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752397AbaJXUms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 16:42:48 -0400
Message-ID: <544AB9B8.9050407@mailservices.uwaterloo.ca> (sfid-20141024_224251_603253_AD241DDA)
Date: Fri, 24 Oct 2014 16:42:32 -0400
From: Ali Abedi <a2abedi@uwaterloo.ca>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: strange MPDU loss pattern
References: <544A7871.7020005@mailservices.uwaterloo.ca> <CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
In-Reply-To: <CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't use a rate adaptation at this moment (i.e., fixed rate) and the 
setup
  is stationary. So we expect to see relatively stable channel 
conditions. Even if the channel
conditions change during the aggregated frame. The first half of the MPDUs
have the same chance of experiencing worse channel conditions.

Thank,
Ali


On 14-10-24 03:13 PM, Adrian Chadd wrote:
> It's not completely unsurprising - the initial channel estimate and
> such is done at the beginning of each packet and stays constant. So if
> there's some varying channel conditions that change that during the
> duration of a packet, the tail end is going to end up having less SNR
> and may end up getting more errors.
>
>
> -adrian
>
> On 24 October 2014 09:04, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>> Hello,
>>
>> We study the effects of 802.11n frame aggregation on throughput. We noticed
>> a
>> strange pattern in the MPDU loss within an aggregated frame. It seems that
>> the
>> second half of the MPDUs (those with higher sequence numbers) in an
>> aggregated frame
>> are more likely to be lost. Is this a known fact or is there any explanation
>> for it?
>>
>> For example if 32 frames are aggregated with sequence numbers 100 to 131.
>> Frames with sequence numbers 100-115 are more likely to be received
>> correctly
>> than 116-131.
>>
>>
>> Best,
>> Ali
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

