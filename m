Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52561 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaG1UuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 16:50:23 -0400
Message-ID: <53D6B78E.1070705@candelatech.com> (sfid-20140728_225026_055526_F9CC4A1D)
Date: Mon, 28 Jul 2014 13:50:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <12936014.DUEgOXk110@blech>
In-Reply-To: <12936014.DUEgOXk110@blech>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/31/2014 11:09 AM, Christian Lamparter wrote:
> Hello,
> 
> On Sunday, March 30, 2014 09:40:24 PM Ben Greear wrote:
>> Due to hardware/firmware limitations, it does not appear possible to
>> have a wifi NIC do hardware decrypt when using multiple stations on a single
>> NIC (and have both stations connected to the same AP).
>>
>> This just happens to be one of my favourite things to do, and it kills
>> performance compared to normal 'Open' throughput.
>>
>> I am curious if anyone knows of any way to accelerate rx-decrypt, perhaps by
>> using a specialized hardware board or maybe a feature of certain CPUs?
> 
> You could check if your CPU (bios and kernel) have support for AES-NI [0].
> AFAICT mac80211 utilizes the cryptoapi. Therefore anything that supports
> the proper crypto bindings can be used to accelerate the encryption and
> decryption process to some degree. And it just happens that thanks to
> AES-NI parts of math can be efficiently calculated by the CPU. 

I recently took a look at this again, and the Intel E5 I'm using
does use the aesni instructions/driver as far as I can tell.

Throughput is still around 500Mbps where open is around 800Mbps.

perf top shows this:

Samples: 37K of event 'cycles', Event count (approx.): 19360716192
 12.01%  [kernel]                                      [k] math_state_restore
 11.64%  [kernel]                                      [k] _aesni_enc1
  8.25%  [kernel]                                      [k] __save_init_fpu
  2.44%  [kernel]                                      [k] crypto_xor
  1.87%  [kernel]                                      [k] irq_fpu_usable
  1.30%  [kernel]                                      [k] aes_encrypt
  0.76%  [kernel]                                      [k] __kernel_fpu_end
....


Any other magic add-in cards that would somehow just make this all faster w/out
having to do any real programming work? :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

