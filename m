Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41388 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZAFBFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 20:05:07 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LK0NS-0006p6-Vz
	for linux-wireless@vger.kernel.org; Tue, 06 Jan 2009 01:05:03 +0000
Received: from s0106000c41bb86e1.ss.shawcable.net ([70.76.47.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 01:05:02 +0000
Received: from hancockr by s0106000c41bb86e1.ss.shawcable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 01:05:02 +0000
To: linux-wireless@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
Date: Mon, 05 Jan 2009 18:32:52 -0600
Message-ID: <4962A6B4.7060309@shaw.ca> (sfid-20090106_020511_663190_69282B3C)
References: <200901052005.12428.arvidjaar@mail.ru> <49626E4D.3010705@gmail.com> <49628964.806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <49628964.806@gmail.com>
Cc: orinoco-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby wrote:
> On 01/05/2009 09:32 PM, Dave wrote:
>> --- a/drivers/net/wireless/orinoco/orinoco.c
>> +++ b/drivers/net/wireless/orinoco/orinoco.c
>> @@ -1616,9 +1616,15 @@ static void orinoco_rx_isr_tasklet(unsigned long
>> data)
>>
>>         /* extract desc and skb from queue */
>>         list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
>> +               unsigned long flags;
>> +
>>                 desc = rx_data->desc;
>>                 skb = rx_data->skb;
>> +
>> +               local_irq_save(flags);
>>                 list_del(&rx_data->list);
>> +               local_irq_restore(flags);
>> +
> 
> Hi,
> 
> another processor still can see inconsistent state, spinlock should be taken.
> Or, am I missing something?

Think you're right, this should be spin_lock_irq or spin_lock_irqsave on 
some lock. Otherwise the interrupt could still occur on some other CPU 
and hit the race.

