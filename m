Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38861 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbcDENg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:36:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Apr 2016 19:06:25 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: remove MSI range support
In-Reply-To: <87oa9ob4m0.fsf@kamboji.qca.qualcomm.com>
References: <1459426522-25925-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87oa9ob4m0.fsf@kamboji.qca.qualcomm.com>
Message-ID: <be237b11cdc2472b67a1fd58e7860938@codeaurora.org> (sfid-20160405_153639_281582_AB63B704)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-05 18:21, Valo, Kalle wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
>> MSI-X is never well-tested, might contain bugs and generally isn't
>> really all that useful to maintain. Also ath10k is mainly used with
>> shared/singly-MSI interrupt systems. Hence removing MSI range support.
>> This change will be useful for further cleanup in copy engine lock
>> and to add NAPI support.
>> 
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> [...]
> 
>> @@ -171,14 +168,10 @@ struct ath10k_pci {
>>  	void __iomem *mem;
>>  	size_t mem_len;
>> 
>> -	/*
>> -	 * Number of MSI interrupts granted, 0 --> using legacy PCI line
>> -	 * interrupts.
>> -	 */
>> -	int num_msi_intrs;
>> +	/* Operating interrupt mode */
>> +	u8 oper_irq_mode;
> 
> Shouldn't this be enum ath10k_pci_irq_mode?

Yes.. Then the enum should be moved to pci.h. will send next version

-Rajkumar
