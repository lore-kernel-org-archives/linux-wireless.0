Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:58192 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbZAHSYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:24:30 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1066904eye.37
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 10:24:27 -0800 (PST)
Message-ID: <496644D0.6050301@gmail.com> (sfid-20090108_192434_372765_7A1F04CE)
Date: Thu, 08 Jan 2009 18:24:16 +0000
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] orinoco: take the driver lock in the rx tasklet
References: <1231287835-17707-1-git-send-email-kilroyd@googlemail.com> <200901081128.30143.arvidjaar@mail.ru>
In-Reply-To: <200901081128.30143.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On 07 January 2009 03:23:55 David Kilroy wrote:
>> Fix the warning reproduced below.
>>
>> We add to rx_list in interrupt context and remove elements in tasklet
>> context. While removing elements we need to prevent the interrupt
>> modifying the list.
>>
>> Note that commit 31afcef385bb8bf528c6fbe05b359af9f456f02a did not
>> preserve locking semantics on what is now orinoco_rx.
>>
>> This patch reinstates the locking semantics and ensures it covers
>> rx_list as well. 
> [...]
>> --- a/drivers/net/wireless/orinoco/orinoco.c
>> +++ b/drivers/net/wireless/orinoco/orinoco.c
>> @@ -1613,6 +1613,16 @@ static void orinoco_rx_isr_tasklet(unsigned
> [...]
>> +	if (orinoco_lock(priv, &flags) != 0)
>> +		return;
>>
> 
> this effectively serializes rx list processing with the rest of driver 
> (specifically orinoco_interrupt) eliminating any benefit from doing it 
> in separate tasklet. It is more simple and less confusing to just revert 
> commit 31afcef385bb8bf528c6fbe05b359af9f456f02a then.

[adding orinoco-devel, who I missed of the original patch submission]

The move to the RX tasklet was not motivated by improved performance,
but the requirements of the crypto library (can't call from interrupt)
and the need to do MIC calculations on RX.

Unless the crypto routines have changed, reverting that commit will
break WPA support.



Regards,

Dave.
