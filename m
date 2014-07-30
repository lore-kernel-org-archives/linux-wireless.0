Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43470 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbaG3TIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 15:08:34 -0400
Message-ID: <53D942B0.1010409@candelatech.com> (sfid-20140730_210837_700688_FCBB0AFE)
Date: Wed, 30 Jul 2014 12:08:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <3302077.5sUEMiqNRr@debian64> <53D82540.5060403@candelatech.com> <2968058.2zJHmYrLUV@debian64>
In-Reply-To: <2968058.2zJHmYrLUV@debian64>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2014 11:59 AM, Christian Lamparter wrote:
> On Tuesday, July 29, 2014 03:50:40 PM Ben Greear wrote:
>> On 07/29/2014 03:29 PM, Christian Lamparter wrote:
>>> On Monday, July 28, 2014 01:50:22 PM Ben Greear wrote:
>>>> On 03/31/2014 11:09 AM, Christian Lamparter wrote:
>>>>> Hello,
>>>>>
>>>>> On Sunday, March 30, 2014 09:40:24 PM Ben Greear wrote:
>>>>>> Due to hardware/firmware limitations, it does not appear possible to
>>>>>> have a wifi NIC do hardware decrypt when using multiple stations on a single
>>>>>> NIC (and have both stations connected to the same AP).
>>>>>>
>>>>>> This just happens to be one of my favourite things to do, and it kills
>>>>>> performance compared to normal 'Open' throughput.
>>>>>>
>>>>>> I am curious if anyone knows of any way to accelerate rx-decrypt, perhaps by
>>>>>> using a specialized hardware board or maybe a feature of certain CPUs?
>>>>>
>>>>> You could check if your CPU (bios and kernel) have support for AES-NI [0].
>>>>> AFAICT mac80211 utilizes the cryptoapi. Therefore anything that supports
>>>>> the proper crypto bindings can be used to accelerate the encryption and
>>>>> decryption process to some degree. And it just happens that thanks to
>>>>> AES-NI parts of math can be efficiently calculated by the CPU. 
>>>>
>>>> I recently took a look at this again, and the Intel E5 I'm using
>>>> does use the aesni instructions/driver as far as I can tell.
>>> Which E5 exactly? There are many different E5. 
> 
>> model name	: Intel(R) Xeon(R) CPU E5-1660 v2 @ 3.70GHz
>> stepping	: 4
>> microcode	: 0x427
>> cpu MHz		: 2163.054
> Thanks. 500Mbps should not be a issue though. At 3,70GHz one single
> core should be able to encrypt/decrypt several Gbps.
> 
>>>> Throughput is still around 500Mbps where open is around 800Mbps.
>>> I can't test ath10k or your multiple station on a single NIC thing. But
>>> can you run a test for a "simple" single station - single AP wpa2 setup?
>>> I want to know how close to the 800Mbps it actually goes.
> Any data for the single station, single AP, wpa2 setup? I would like to know
> what ath10k is able to achieve in this case.

I will run this when I get a chance and let you know.

But, exact same setup (same number of stations, etc), but just with
open authentication, runs 800+Mbps.

>>>> perf top shows this:
>>>>
>>>> Samples: 37K of event 'cycles', Event count (approx.): 19360716192
>>>>  12.01%  [kernel]                                      [k] math_state_restore
>>>>  11.64%  [kernel]                                      [k] _aesni_enc1
>>>>   8.25%  [kernel]                                      [k] __save_init_fpu
>>>>   2.44%  [kernel]                                      [k] crypto_xor
>>>>   1.87%  [kernel]                                      [k] irq_fpu_usable
>>>>   1.30%  [kernel]                                      [k] aes_encrypt
>>>>   0.76%  [kernel]                                      [k] __kernel_fpu_end
>>>> ....
>>> Yes, aesni is doing some of the heavy lifting! But in your original post,
>>> you said you are interested in accelerate rx-decrypt... Now it's about 
>>> encryption offload?! [please make up your mind :-D]
>>
>> The perf top results above are from receiving (and decoding) wpa2 wifi
>> frames that were not decoded by the NIC because NIC rx-decrypt logic was
>> disabled.  I think this means I want to accelerate the rx-decrypt.
> Wait.
> 
> If you have disabled rx-decrypt logic of ath10k, then why isn't _aesni_dec1
> or aes_decrypt listed in the perf top result? I think they should be. Have you
> removed them from the "perf top results" or are they really absent 
> altogether? 
> 
> Because, from this perf result, it looks like your CPU is not burden by the
> incoming RX at all?! Instead it is busy with the encryption of frames
> it will be transmitting (in case of tcp, this could be tcp acks).
> 
> It could be that I missed something important about the setup.
> For example, I assumed that you have a dedicated 802.11ac AP
> and the perf results are coming from the E5 machine with the ath10k
> in multi-station mode. The AP would be transmitting, whereas
> the E5 would be receiving. Is this assumption correct or not?

My setup is where AP is transmitting and E5 is receiving.

Test case is UDP, so very little upstream traffic.

I did not trim anything off the top of perf top, and did not notice
any other aesni calls listed.  I do not particularly know why it is
doing aesni_encl, I had assumed that was how it decoded.

I will double-check all of this and try to figure out why
it is calling the encl instead of decl logic.  Possibly I
have something that is actually configured differently than
I think it is.

Also, good to hear my E5 should be able to handle higher
speeds, gives me something to hope for :)

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

