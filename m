Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49710 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbbAORFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 12:05:23 -0500
Message-ID: <54B7F350.4040203@lwfinger.net> (sfid-20150115_180530_467760_426AB5A3)
Date: Thu, 15 Jan 2015 11:05:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	netdev@vger.kernel.org
Subject: Re: [PATCH for 3.19 3/3] rtlwifi: rtl8192ee: Fix several bugs
References: <1421257036-5382-1-git-send-email-Larry.Finger@lwfinger.net>	<1421257036-5382-4-git-send-email-Larry.Finger@lwfinger.net> <87bnm0xoar.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bnm0xoar.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2015 05:42 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Troy Tan <troy_tan@realsil.com.cn>
>>
>> The following bugs are fixed in this driver:
>> 1. Problems parsing C2H CMD
>> 2. An ad-hoc connection can cause a TX freeze.
>> 3. There are additional conditions that cause a TX freeze.
>> 4. The previous code failed to handle situations where an RX
>>     descriptor was unavailable.
>>
>> Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Is this really so important that it should go to 3.19? A patch titled
> "Fix several bugs" immediately makes me cautious and then I look at the
> patch itself I see rewriting functions instead of simple bug fixes. From
> a quick look this looks more -next material than 3.19.

It is not a simple rewrite of functions. Tho mishandling of the descriptor ring 
buffer locks up the device and requires a cold boot. These patches prevent that 
from happening.

Yes, the patches are rather larger than I would like at the -rc4 stage, and I 
defer to your judgement. At least we have an external source of corrected code 
for users of 3.18 and 3.19.

Larry


