Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45928 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004AbbA1Fk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 00:40:59 -0500
Message-ID: <54C875FD.3070101@qca.qualcomm.com> (sfid-20150128_064104_435635_7E681844)
Date: Tue, 27 Jan 2015 21:39:09 -0800
From: Peter Oh <poh@qca.qualcomm.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com> <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com> <20150128043005.GB24933@localhost>
In-Reply-To: <20150128043005.GB24933@localhost>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/27/2015 08:30 PM, Bob Copeland wrote:
> On Tue, Jan 27, 2015 at 03:53:00PM -0800, Peter Oh wrote:
>>>> -	/* IMPORTANT: this extra read transaction is required to
>>>> -	 * flush the posted write buffer. */
>>>> -	(void)ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
>>>> -				PCIE_INTR_ENABLE_ADDRESS);
>>>> +	/* invoke data sync barrier */
>>>> +	wmb();
>>>>   }
>>> I am no expert in arcane PCI matters, but that looks suspicious to me.  I seem
>>> to recall wmb() only enforced ordering, and maybe not even memory-IO ordering
>>> on all platforms.  If you want to disable an irq, it really seems like you
>>> would want to flush posted writes so you know the hardware has seen it.
>> enforced ordering is happened by flush write buffer and wmb is
>> commonly used to flush write buffer.
>> so that wmb guarantees ordering by flush write buffer. That's why
>> it's called a memory barrier.
> Ok, sure, but I/O ordering two different writes, and ensuring device
> has seen a posted write, are related but different things, no?
yes, they are different and wmb guarantees both.
>    So if
> you are disabling an interrupt and want to be really sure interrupts
> are off when function returns, I think you still want the read.
the mechanism that  read is using to make sure write work done is the 
same mechanism that wmb is using.
> Anyway, it's your driver, just pointing out that the "IMPORTANT"
> read might still be important to someone.
I really appreciate your opinion.
>
Regards,
Peter
