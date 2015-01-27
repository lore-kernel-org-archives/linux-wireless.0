Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13672 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759040AbbA0Xyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 18:54:53 -0500
Message-ID: <54C824DC.5080804@qca.qualcomm.com> (sfid-20150128_005457_494974_AFA983AF)
Date: Tue, 27 Jan 2015 15:53:00 -0800
From: Peter Oh <poh@qca.qualcomm.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com> <20150127213349.GA24933@localhost>
In-Reply-To: <20150127213349.GA24933@localhost>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/27/2015 01:33 PM, Bob Copeland wrote:
> On Mon, Jan 26, 2015 at 02:25:18PM -0800, Peter Oh wrote:
>> Using ioread() to perform data sync is excessive.
>> Use compact API, wmb(), that intended to be used for the case.
>> It reduces total 14 CPU clocks per interrupt.
> Hi,
>
>>   	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_CLR_ADDRESS,
>>   			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
>>   
>> -	/* IMPORTANT: this extra read transaction is required to
>> -	 * flush the posted write buffer. */
>> -	(void)ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
>> -				PCIE_INTR_ENABLE_ADDRESS);
>> +	/* invoke data sync barrier */
>> +	wmb();
>>   }
> I am no expert in arcane PCI matters, but that looks suspicious to me.  I seem
> to recall wmb() only enforced ordering, and maybe not even memory-IO ordering
> on all platforms.  If you want to disable an irq, it really seems like you
> would want to flush posted writes so you know the hardware has seen it.
enforced ordering is happened by flush write buffer and wmb is commonly 
used to flush write buffer.
so that wmb guarantees ordering by flush write buffer. That's why it's 
called a memory barrier.
when wmb is used, it guarantees all memory accesses complete before wmb 
command completes.
for instance dsb is the corresponding command for wmb in arm and arm 
instruction guide says
"The DSB instruction completes when all explicit memory accesses before 
it complete."
Which means DSB instruction will hold the bus (usually AXI bus) and 
never returns until any memory or memory mapped I/O access complete
(dsb is for ARM and other platforms have the equivalent instruction such 
as sfence, sync, mf, and dcs).
Thanks,
Peter
