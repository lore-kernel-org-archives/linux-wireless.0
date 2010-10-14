Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40260 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab0JNTPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 15:15:15 -0400
Message-ID: <4CB756B8.4000308@candelatech.com>
Date: Thu, 14 Oct 2010 12:15:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: =?UTF-8?B?QmrDtnJuIFNtZWRtYW4=?= <bjorn.smedman@venatech.se>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com> <4CB4AA89.1070009@candelatech.com> <20101013053141.GA15798@vasanth-laptop> <4CB5E0A8.5020502@candelatech.com> <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com> <AANLkTi=b_SvDDgqbQ-Oft12bNumM7XuH6-_g7_w=koaG@mail.gmail.com>
In-Reply-To: <AANLkTi=b_SvDDgqbQ-Oft12bNumM7XuH6-_g7_w=koaG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/13/2010 01:03 PM, Luis R. Rodriguez wrote:
> 2010/10/13 Björn Smedman<bjorn.smedman@venatech.se>:
>> Hi Ben,
>>
>> First of all keep up the good work. :)
>>
>> On Wed, Oct 13, 2010 at 6:39 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> [snip]
>>> Either way, it seems safer to null out the bf_ampdu field after
>>> the memory is consumed..it could prevent some tricky bugs later.
>>
>> I think this is a good idea. But it probably wont be enough to null
>> out bf_mpdu. You also need to look at bf_buf_addr (which if I
>> understand correctly is the physical address the DMA engine will
>> actually write RXed frames to) and bf_dmacontext (which seems in most
>> cases to hold an identical address and may in fact be where the DMA
>> engine will really write the frame).
>
> See the TODO list for ath9k:
>
>    * Remove this redundancy crap: bf->bf_buf_addr = bf->bf_dmacontext;
>
> http://wireless.kernel.org/en/users/Drivers/ath9k/todo

I just posted a patch that attempts this.  It doesn't
fix the memory clobber issue, but maybe the code is a bit cleaner/safer
at least...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

