Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailservices.uwaterloo.ca ([129.97.128.141]:39984 "EHLO
	minos.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758517AbaJ3QUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 12:20:46 -0400
Message-ID: <54526555.8020202@mailservices.uwaterloo.ca> (sfid-20141030_172053_935453_FF3A07C1)
Date: Thu, 30 Oct 2014 12:20:37 -0400
From: Ali Abedi <a2abedi@uwaterloo.ca>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: strange MPDU loss pattern
References: <544A7871.7020005@mailservices.uwaterloo.ca>	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>	<544AB9B8.9050407@mailservices.uwaterloo.ca>	<CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com>	<544BC1B5.1040107@mailservices.uwaterloo.ca>	<CAJ-Vmo=ceFvBDxL=HYSVmAMfEk0yxD_-a4MP3WjcvPAaupxPPw@mail.gmail.com>	<544C0995.8010507@mailservices.uwaterloo.ca>	<CAJ-VmonTjXvqPs2APB90pNgRyKwxPE2BJk+jxFGbLGw9uK2xHw@mail.gmail.com>	<54525DD8.6080506@mailservices.uwaterloo.ca> <CAJ-VmonkWf5q445fR2PnsQarnA5Vuu4t4jNckU3-YUd+nbUZvQ@mail.gmail.com>
In-Reply-To: <CAJ-VmonkWf5q445fR2PnsQarnA5Vuu4t4jNckU3-YUd+nbUZvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The paper mentioned that this happens when the client is mobile.
But I confirm Adrian's observation . This problem happens even
in stationary environments with dynamic channels (e.g., people moving in 
the vicinity
of the AP/Client).


Best,
Ali


On 14-10-30 12:11 PM, Adrian Chadd wrote:
> On 30 October 2014 08:48, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>> Hi Adrian,
>>
>>
>> We observed that this can happen for any rate for some SNR values.
>> If the SNR is strong enough for the given MCS this won't happen.
>> But when the SNR approaches the transition region when
>> error rate starts to increase, this problem will be observed.
>>
>> So this can happen even for MCS0->MCS4 when the client is far from the AP
>> and specially when it's moving.
> Right. That's the missing useful information here. :)
>
> Yes, I'd expect this happens whilst the client is moving. The training
> stuff is all done on the beginning of the packet and channel
> conditions aren't adjusted during packet reception - only upon the
> next received packet.
>
> (FYI - I've seen a similar pattern, but when i stand between the AP /
> STA at > MCS13 and start waving my hands around. Just that slight
> change in channel conditions == the above failure.)
>
> So thanks for reminding us that we should take A-MPDU length into
> account in our rate control code. :)
>
>
>
> -adrian

