Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38324 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756237AbcJWCeA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 22:34:00 -0400
Message-ID: <580C2197.6080103@candelatech.com> (sfid-20161023_043412_324131_2D4D8821)
Date: Sat, 22 Oct 2016 19:33:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: Re: crypto: aesni - add ccm(aes) algorithm implementation
References: <1476895046-16549-1-git-send-email-greearb@candelatech.com> <3e0552f3-b7f5-2ff3-1f63-9001bceb96f0@candelatech.com> <4298972.T1UOBYP9Tx@debian64>
In-Reply-To: <4298972.T1UOBYP9Tx@debian64>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/22/2016 12:15 PM, Christian Lamparter wrote:
> On Wednesday, October 19, 2016 9:39:49 AM CEST Ben Greear wrote:
>> On 10/19/2016 09:37 AM, greearb@candelatech.com wrote:
>>> From: Yauhen Kharuzhy <jekhor@gmail.com>
>>>
>>> Add ccm(aes) implementation from linux-wireless mailing list (see
>>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
>>>
>>> This eliminates FPU context store/restore overhead existing in more
>>> general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
>>>
>>> Convert this patch to new AEAD API.
>>>
>>> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> I've been using this patch or something similar for a while and it
>> significantly helps me with sw-crypt performance.  One version or another
>> has been around the internet for some time, and I am not the originator
>> of this code, but would still be happy to see it upstream if someone
>> can review and bless it.
>
> No. I don't think this will ever fly by the crypto folks in this
> form due to the CRYPTO_ALGO_ASYNC fallback parts which are necessary
> to get it to work with mac80211.
>
> It would be a great if mac80211 would do to the encryption and
> decryption asynchronously. As this would work for other ciphers
> and also allows crypto offload to dedicated crypto hardware.

Does it actually hurt some existing code or functionality?

It definitely helps with wifi software crypt.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
