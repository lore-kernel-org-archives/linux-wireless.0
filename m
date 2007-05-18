Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:1811 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754934AbXERWnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 18:43:18 -0400
Message-ID: <464E1B4A.8050105@linux.intel.com>
Date: Fri, 18 May 2007 14:31:54 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <464B7B7C.5080800@linux.intel.com> <20070516203505.556df4f9.randy.dunlap@oracle.com> <464E0DB5.5010802@linux.intel.com> <464E233A.6060209@garzik.org>
In-Reply-To: <464E233A.6060209@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> James Ketrenos wrote:
>> Randy Dunlap wrote:
>>> 2.  Use of bitfields:  bitfields are not (guaranteed to be) portable
>>> across a wire interface to some other CPU architecture.
>>> Are all bitfield uses always local to the running driver?
>>> They should be.
>>
>> The bitfields are between the hw/ucode (__le) and the driver.  Are you 
>> saying the bitfields won't be compatible if the driver is compiled and 
>> running on big endian?  Shouldn't le16_to_cpu() fix that?  I just 
>> noticed the types in iwl-4965-hw.h weren't endian specific; I've 
>> updated that (u16, u32, u64 -> __le16, __le32, __le64)
> 
> Use of bitfields, as defined in the C standard, should be avoided at all 
> costs.  It requires you to define structures twice -- once for LE, and 
> once for BE.  It generates demonstrably sub-optimal code on all known 
> compilers.  And in general, people tend to screw them up.
> 
> Drivers should be using bitwise integer math rather than bitfields.
> 
> As for u8/u16/u32/u64 integer mixes, you must still pay attention to 
> structure layout and compiler padding, in addition to endian issues 
> (which are lessened once bitfields are gone).

Alright; I'll add replacing the bitfields with bitwise access to the todo list.

Are you OK with us marking the driver as not working on big endian for now and getting this one fixed over time?

>>> 3.  What are all of those "volatile" C keywords doing in struct
>>> iwl_shared?
>>> See http://lwn.net/Articles/232961/ : "The trouble with volatile"
>>
>> If a reference shared through memory mapped IO with a device that can 
>> change the value at any time, doesn't it need to be volatile?  'struct 
>> iwl_shared' is allocated with pci_alloc_consistent and the physical 
>> address is provided to the hardware for it to update whenever it sees 
>> fit.
> 
> volatile should not be in your driver at all.
> 
> See the innumerable threads on LKML, including one current one.

I tried reading through the thread.  From what I gathered, it sounds like if I want to read a value from a memory location where the adapter could be writing to it I would just call rmb() before I access the memory?  And when writing to a value, call wmb() immediately after I write to it?  And expunge 'volatile' from my vocabulary.

> 
>>> 8.  Too many BUG_ON()s.  Try to recover or return -ERRORs instead.
>>
>> I pulled out two that shouldn't have been there.
>>
>> The rest are currently there map to bugs which are easily introduced 
>> through code changes but which may not cause an immediately visible 
>> bug at run-time.  Typically they are placed where an eventual printk() 
>> at that location during debugging of a user bug resulted in the 
>> critical "ah-ha!" that led to fixing it.  I've added comments to the 
>> BUG_ON's that didn't have comments already.
>>
>> I suppose we could try and introduce a new driver recovery mechanism 
>> that, upon detection, throws a stack trace and then shuts down the 
>> driver (vs. throwing a kernel OOPs) requiring user space to unload and 
>> reload the driver.  That would still be a sucky situation, but at 
>> least it wouldn't cause a system failure requiring a reboot...  does 
>> such a mechanism already exist?
> 
> In general, you should not be checking for programmer mistakes at every 
> level.  Only use BUG_ON() for mistakes that have happened in the past in 
> this driver, AND are likely to occur in the future, AND do not cause 
> problems easily detectable simply by allowing the code to screw up.

That has been the general goal in where the BUG_ONs are.  

There were a couple that weren't doing that (which were yanked).  

I've updated iwl_send_cmd which was using BUG_ON but could use printk and return a failure code.

James
