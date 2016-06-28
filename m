Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33475 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbcF1OTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 10:19:54 -0400
Subject: Re: [PATCH] rtlwifi: Create _rtl_dbg_trace function to reduce
 RT_TRACE code size
To: Joe Perches <joe@perches.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
References: <90cd7c8f12b51571db565fd496a2fcf610e2e484.1466894688.git.joe@perches.com>
 <5771CA6C.1060403@lwfinger.net> <1467086116.24287.11.camel@perches.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <57728787.8060400@lwfinger.net> (sfid-20160628_162018_561977_832CC980)
Date: Tue, 28 Jun 2016 09:19:51 -0500
MIME-Version: 1.0
In-Reply-To: <1467086116.24287.11.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2016 10:55 PM, Joe Perches wrote:
> On Mon, 2016-06-27 at 19:53 -0500, Larry Finger wrote:
>> On 06/25/2016 05:46 PM, Joe Perches wrote:
>>>
>>> This debugging macro can expand to a lot of code.
>>> Make it a function to reduce code size.
>>>
>>> (x86-64 defconfig w/ all rtlwifi drivers and allyesconfig)
>>> $ size drivers/net/wireless/realtek/rtlwifi/built-in.o*
>>>      text	   data	    bss	    dec	    hex	filename
>>>    900083	 200499	   1907	1102489	 10d299	drivers/net/wireless/realtek/rtlwifi/built-in.o.defconfig.new
>>> 1113597	 200499	   1907	1316003	 1414a3	drivers/net/wireless/realtek/rtlwifi/built-in.o.defconfig.old
>>> 1746879	 453503	   8512	2208894	 21b47e	drivers/net/wireless/realtek/rtlwifi/built-in.o.new
>>> 2051965	 503311	   8512	2563788	 271ecc	drivers/net/wireless/realtek/rtlwifi/built-in.o.old
>>>
>>> Signed-off-by: Joe Perches <joe@perches.com>
>> I acked this before; however there is a bug that breaks the build if
>> CONFIG_RTLWIFI_DEBUG is not defined. The rest of the code calls
>> _rtl_dbg_trace(), but that symbol is never defined. The problem can be fixed in
>> debug.c or debug.h.
>
> Confused a bit.  What breaks again?

Nothing breaks and your patch is OK. I had ported it to a GitHub repo of these 
drivers, which had a different debug.h. That led to the missing global when 
CONFIG_RTLWIFI_DEBUG was not defined. That has now been fixed.

Sorry for the confusion.

Larry


