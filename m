Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40616 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab2I1QlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 12:41:24 -0400
Message-ID: <5065D32F.9090107@lwfinger.net> (sfid-20120928_184129_932197_BB417DDA)
Date: Fri, 28 Sep 2012 11:41:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Joe Perches <joe@perches.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: use %*ph[C] to dump small buffers
References: <1348667852-5957-1-git-send-email-andriy.shevchenko@linux.intel.com> <1348677946.15175.8.camel@joe-AO722> <5064D318.6090705@lwfinger.net> <1348802023.3030.11.camel@joe-AO722> <AE90C24D6B3A694183C094C60CF0A2F6026B700D@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B700D@saturn3.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2012 04:04 AM, David Laight wrote:
>>> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
>>> ===================================================================
>>> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
>>> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
>>> @@ -1964,8 +1965,9 @@ static void rtl92ce_update_hal_rate_mask
>>>
>>>           RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
>>>                    "ratr_bitmap :%x\n", ratr_bitmap);
>>> -       *(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) |
>>> -                                    (ratr_index << 28);
>>> +       for (i = 0; i < 3; i++)
>>> +               rate_mask[i] = ratr_bitmap & (0xff << (i * 4));
>>
>> rate_mask is u8, doesn't this needs (calc) >> (i * 8)
>>
>>> +       rate_mask[3] = (ratr_bitmap & 0x0f000000) | (ratr_index << 28);
>>
>> Perhaps you meant:
>>
>> 		((ratr_bitmap & 0x0f000000) >> 24) | (ratr_index << 4)
>
> I'd just do:
> 	rate_mask[0] = ratr_bitmap;
> 	rate_mask[1] = ratr_bitmap >>= 8;
> 	rate_mask[2] = ratr_bitmap >>= 8;
> 	rate_mask[3] = (ratr_bitmap >> 8) & 0xf | ratr_index << 4;
> which is, of course, little endian.
> Which means it is different from the original code on big-endian systems.
> So changing this here ought to require a change when the data is read.
> So this either fixes, or adds, an endianness bug.

Yes, the rate_mask array is little endian after this fragment is run, but the 
only use of the byte array is to write it to the device, and LE is what it needs 
no matter the platform. This change fixes an endianness bug.

As I tend to get confused when doing these things, I wrote a small test program 
and ran it on x86_64 and PPC-32 to confirm the result.

Thanks for teaching me about a = b >>= 8. I was not aware that C could do that.

Larry


