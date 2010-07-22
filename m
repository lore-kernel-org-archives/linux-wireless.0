Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42285 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0GVJVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 05:21:18 -0400
Received: by bwz1 with SMTP id 1so735882bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 02:21:17 -0700 (PDT)
Message-ID: <4C480D94.9090401@adurom.com>
Date: Thu, 22 Jul 2010 11:21:24 +0200
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>	 <4C48053A.6080504@adurom.com> <1279788739.2322.39.camel@powerslave>
In-Reply-To: <1279788739.2322.39.camel@powerslave>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2010 10:52 AM, Luciano Coelho wrote:
> On Thu, 2010-07-22 at 10:45 +0200, ext Kalle Valo wrote:
>> Hi John,
>>
>> On 07/21/2010 06:31 PM, John W. Linville wrote:
>>> @@ -225,7 +225,7 @@ static void wl1251_boot_set_ecpu_ctrl(struct wl1251 *wl, u32 flag)
>>>  int wl1251_boot_run_firmware(struct wl1251 *wl)
>>>  {
>>>  	int loop, ret;
>>> -	u32 chip_id, interrupt;
>>> +	u32 chip_id, acx_intr;
>>
>> I don't get why you did this change. I don't object renaming the
>> variable, but I can't figure out the reasoning behind it.
> 
> Sparse complains that interrupt is shadowing the definition in hw_irq.h:
> 
>> drivers/net/wireless/wl12xx/wl1251_boot.c:228:22: warning: symbol
>> 'interrupt' shadows an earlier one
>> /home/linville/git/wireless-next-2.6/arch/x86/include/asm/hw_irq.h:132:13: originally declared here
> 
> So, it's just a cosmetic change, I guess.

Ah, I was blind as usual. It makes all sense now, thanks.

Kalle


