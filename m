Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailservices.uwaterloo.ca ([129.97.128.141]:54524 "EHLO
	minos.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492AbaJYTFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:05:50 -0400
Message-ID: <544BC1B5.1040107@mailservices.uwaterloo.ca> (sfid-20141025_210553_241765_36B84F2C)
Date: Sat, 25 Oct 2014 11:28:53 -0400
From: Ali Abedi <a2abedi@uwaterloo.ca>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: strange MPDU loss pattern
References: <544A7871.7020005@mailservices.uwaterloo.ca>	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>	<544AB9B8.9050407@mailservices.uwaterloo.ca> <CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com>
In-Reply-To: <CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

We have a high end spectrum analyzer. So we are sure there is no 
background interference
We run our experiments in the 5 GHZ spectrum. The channel conditions can 
still vary due to
the movement of the people in the vicinity of the experiment setup. We 
select a rate that
experiences at least 20% error on average. Since if the error is 100% or 
0% it's not interesting
for us.

My point is if the channel conditions change the distribution of failed 
packets should be uniform.
The first and second  half of the packets have the same chance to be 
received successfully.


Thanks,
Ali


On 25/10/2014 11:19 AM, Adrian Chadd wrote:
> On 24 October 2014 13:42, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>> We don't use a rate adaptation at this moment (i.e., fixed rate) and the
>> setup
>>   is stationary. So we expect to see relatively stable channel conditions.
>> Even if the channel
>> conditions change during the aggregated frame. The first half of the MPDUs
>> have the same chance of experiencing worse channel conditions.
> How do you /know/ you have stable channel conditions?
>
> There are a lot of things that could be going on inside the devices
> you're testing on. It doesn't have to be channel noise coming in an
> antenna. For example, your computer could be generating rapidly
> changing noise spurs from some clocking sources.
>
> Try firing up the spectral scan mode on the NIC and plot the data. See
> if there are any abnormal peaks going on over time.
>
> And a large / long A-MPDU could be measured in milliseconds of length.
> the original poster didn't say which rate(s) they are trying with and
> how much margin (SNR) the receiver is seeing. Pulling out EVM from the
> received A-MPDU frames would also be helpful.
>
> Thanks,
>
>
>
> -adrian
>
>
>
>
> -adrian

