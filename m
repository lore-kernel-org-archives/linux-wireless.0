Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1216 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcGWJpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2016 05:45:25 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>,
	"nbd@nbd.name" <nbd@nbd.name>
Subject: Re: [PATCH] ath10k: fix system hang at qca99x0 probe on x86 platform
Date: Sat, 23 Jul 2016 09:45:12 +0000
Message-ID: <1469267112032.61173@qti.qualcomm.com> (sfid-20160723_114537_983656_0CA04C48)
References: <20160614061728.570-1-rmanohar@qti.qualcomm.com>
 <5792A189.5050807@candelatech.com>,<6495e664-5da8-a11b-0bd5-15dc24c51edf@dd-wrt.com>
In-Reply-To: <6495e664-5da8-a11b-0bd5-15dc24c51edf@dd-wrt.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> from my point of view this patch is just shit. it trunkates the maximum
> allocated memory to a certain value.
> so firmware requests 800 kb memory but just gets 256kb. so out of bound
> memory access is guaranteed at all.
> 
Even with current logic, If the memory chunk allocation fails for bigger size, then it tries
to allocate smaller chunks. So anyway it is guaranteed for oob access. no?

        while (!vaddr && num_units) {
                pool_size = num_units * round_up(unit_len, 4);
                if (!pool_size)
                        return -EINVAL;

                vaddr = kzalloc(pool_size, GFP_KERNEL | __GFP_NOWARN);
                if (!vaddr)
                        num_units /= 2;
        }

Actually the commit "ath10k: do not use coherent memory for allocated device memory chunks"
is causing system hang on non VT/d x86 platform. Better to revert the commit until it is properly
root caused

-Rajkumar    

Am 23.07.2016 um 00:43 schrieb Ben Greear:
> On 06/13/2016 11:17 PM, Rajkumar Manoharan wrote:
>> commit b057886524be ("ath10k: do not use coherent memory for allocated
>> device memory chunks") replaced coherent memory allocation for memory
>> chunks to fix low memory platforms. Unfortunately this is causing system
>> freeze on x86 platform while bringing up qca99x0 device. The system
>> hangs while DMA mapping bigger memory chunks (689816/865444 bytes). Fix
>> this by limiting maximum memory chunk size to 256 KiB per request.
>>
>> Cc: Felix Fietkau <nbd@nbd.name>
>> Fixes: b057886524be ("ath10k: do not use coherent memory for
>> allocated device memory chunks")
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/wmi.c | 6 ++++++
>>   drivers/net/wireless/ath/ath10k/wmi.h | 1 +
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
>> b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 6279ab4a760e..7c15f65fe5ed 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -4411,6 +4411,12 @@ static int ath10k_wmi_alloc_chunk(struct
>> ath10k *ar, u32 req_id,
>>           if (!pool_size)
>>               return -EINVAL;
>>
>> +        if (pool_size > WMI_MAX_MEM_CHUNK_SIZE) {
>> +            num_units = WMI_MAX_MEM_CHUNK_SIZE /
>> +                    round_up(unit_len, 4);
>> +            pool_size = num_units * round_up(unit_len, 4);
>> +        }
>
> I started testing my 9980 x86-64 system with VT/d enabled today.
> With this patch in my tree, it crashes on bootup (with my firmware).
> Works fine without this patch.
>
> I don't see the exact place it is crashing in the firmware, though I
> could
> probably narrow it down with some effort.  It is in the early startup
> code,
> at least, which makes debugging more difficult.
>
> This patch works fine with a slightly newer firmware compiled for
> 9984.  That
> same firmware compiled for 9980 crashes, but I am not certain it is
> the same issue
> as the older 9980.  It appears similar, at least.
>
> Looks to me like there are lots of variances in how firmware and chip
> revisions
> deal with this particular code, so we are going to have to test on
> lots of chips
> and platforms to know if a 'fix' is really a fix or not.
>
> Thanks,
> Ben
>
>


--
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

