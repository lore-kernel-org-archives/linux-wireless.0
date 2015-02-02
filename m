Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59205 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbBBXZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 18:25:31 -0500
Received: by mail-pa0-f42.google.com with SMTP id bj1so88446084pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 15:25:31 -0800 (PST)
Message-ID: <54D00764.40808@gmail.com> (sfid-20150203_002534_869366_8ED400C9)
Date: Mon, 02 Feb 2015 15:25:24 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
MIME-Version: 1.0
To: Peter Oh <poh@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org, Peter Oh <poh@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com> <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com> <20150128043005.GB24933@localhost> <54C875FD.3070101@qca.qualcomm.com> (sfid-20150128_064104_435635_7E681844) <1422430643.1973.1.camel@sipsolutions.net> <54CC0B71.9050301@codeaurora.org> <1422882133.1930.10.camel@sipsolutions.net> <54CFB4F4.1070807@qca.qualcomm.com> <1422903279.8755.1.camel@sipsolutions.net> <54CFCCCF.900@codeaurora.org> <1422904939.8755.3.camel@sipsolutions.net> <54CFD1D1.8060901@codeaurora.org> <1422906446.8755.4.camel@sipsolutions.net> <54CFF4E0.1040207@codeaurora.org>
In-Reply-To: <54CFF4E0.1040207@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/15 14:06, Peter Oh wrote:
> 
> On 02/02/2015 11:47 AM, Johannes Berg wrote:
>> On Mon, 2015-02-02 at 11:36 -0800, Peter Oh wrote:
>>> On 02/02/2015 11:22 AM, Johannes Berg wrote:
>>>>>> You basically have the following sequence:
>>>>>>
>>>>>> iowrite()
>>>>>> ioread()
>>>>>>
>>>>>> If you look, you'll see that iowrite() is actually done (or should
>> be,
>>>>>> or perhaps with appropriate syncs) on an uncached mapping.
>>>>> since it's mmio, iowrite will be map to write, not out which is
>> cached
>>>>> mapping.
>>>>> That's why we address "posted write" here.
>>>>> If it's un-cached mapping which is volatile, we don't even need
>> ioread.
>>>> No, this isn't true - "posted write" in the context of this discussion
>>>> is about the PCIe bus. Memory writes that go through cache aren't
>>>> referred to as "posted writes", those are just (cached) memory writes.
>>>>
>>>>>>     As a result,
>>>>>> the only thing you care about here is the PCIe bus, not the CPU
>> cache
>>>>>> flush. And from there on that's just a question of PCIe bus
>> semantics.
>>>>> So how does ioread guarantee PCIe bus transaction done?
>>>> That's how PCIe works, operations are serialized, and read() has to
>> wait
>>>> for a response from the device
>>> do you know which mechanism or which instruction set makes read() wait
>>> for a response from the device?
>> I have no idea. I assume it's just like a DRAM read, the CPU stalls
>> while there's no response.
> My explanation in this thread is all about how read() guarantees the
> wait for a response from the device, therefore why mb() - replace from
> wmb at patch set 2 - is compatible to read().
> Briefly speaking,
> read() -> dsb 'st' -> cpu (actually axi master in cpu) holding axi bus
> -> cpu post write buffer on axi bus -> axi bus (axi slave which is PCIe
> device) signals write completion when write transactions completed in
> write response channel ->  cpu release axi bus -> cpu program counter
> (pc) proceeds the next to read.
> 
> the exact same routines happen with mb().
> mb() -> dsb 'st' -> cpu (actually axi master in cpu) holding axi bus ->
> cpu post write buffer on axi bus -> axi bus (axi slave which is PCIe
> device) signals write completion when write transactions completed in
> write response channel ->  cpu release axi bus -> cpu program counter
> (pc) proceeds the next to read.
> 
> Since axi bus master is waiting (blocking) for write completion signal
> from axi slave (PCIe device), this is how read() and mb() guarantee
> write command reaches to the device.

PCIe writes are posted, so the only guarantee you can have by inserting
such barriers is that writes from CPU to the PCIe RC (targeting PCIe
device) is non-posted (as far as the busing between CPU and the PCIe RC
is concerned), but past the PCIe RC, there is no such guarantee, because
the PCIe specification allows for that and there is flow control, PCIe
switches or other things that can alter the way your PCIe device ends-up
being written to.

The only way to make a "portable" synchronization barrier is to do a
PCIe read from the same register you just wrote to, because then, the
PCIe RC needs to guarantee the transaction ordering on the PCIe bus itself.

You might just be lucky and/or have very good HW which ensures that the
ARM synchronization barriers are propagated to the memory region where
your PCIe device BARs are mapped from the CPU perspective, but you
definitively cannot rely on such assumptions, as there will be bogus HW
there, for which only a subsequent ioread32() will work.
-- 
Florian
