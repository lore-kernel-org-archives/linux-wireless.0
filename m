Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54479 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2KTVFg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:05:36 -0500
Message-ID: <50ABF095.4020502@hauke-m.de> (sfid-20121120_220549_611576_A63A2155)
Date: Tue, 20 Nov 2012 22:05:25 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: John Crispin <john@phrozen.org>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org,
	zajec5@gmail.com, m@bues.ch
Subject: Re: [PATCH 1/8] bcma: add locking around GPIO register accesses
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de> <1353365877-11131-2-git-send-email-hauke@hauke-m.de> <50AB3AFF.2000001@phrozen.org>
In-Reply-To: <50AB3AFF.2000001@phrozen.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2012 09:10 AM, John Crispin wrote:
> Hi Hauke
> 
>> u32 bcma_chipco_gpio_in(struct bcma_drv_cc *cc, u32 mask)
>>   {
>> -    return bcma_cc_read32(cc, BCMA_CC_GPIOIN)&  mask;
>> +    unsigned long flags;
>> +    u32 res;
>> +
>> +    spin_lock_irqsave(&cc->gpio_lock, flags);
>> +    res = bcma_cc_read32(cc, BCMA_CC_GPIOIN)&  mask;
>> +    spin_unlock_irqrestore(&cc->gpio_lock, flags);
>> +
>> +    return res;
>>   }
>>
> 
> Hi Hauke,
> 
> do you need to lock the read access ?
> 
> if bcma_cc_read32() is a simple memory read wrapper you most likely wont
> need the lock
> 
>     John
Yes you are right, I do not need it here, it is just needed for the
masked write to the other GPIO registers.

Hauke
