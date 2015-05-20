Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34046 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbETPeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 11:34:18 -0400
Message-ID: <555CA977.70902@lwfinger.net> (sfid-20150520_173428_360743_BD09096D)
Date: Wed, 20 May 2015 10:34:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org,
	Vincent Fann <vincent_fann@realtek.com>,
	Shao Fu <shaofu@realtek.com>, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.1] rtlwifi: Remove the clear interrupt routine from
 all drivers
References: <1431743367-10059-1-git-send-email-Larry.Finger@lwfinger.net> <877fs39wy8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fs39wy8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/2015 08:53 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Vincent Fann <vincent_fann@realtek.com>
>>
>> Several of these drivers have there TX randomly blocked for 3~5 seconds while
>> measuring tx throughput (iperf). The root couse happens in rtl_pci_flush().
>> The function uses a while-loop to wait for TX queue length to decrease to 0.
>> The TX queue length counts the number of packets that are queued in the driver.
>> The driver relys on the TX OK interrupt to return skb and reduce TX queue length.
>>
>> The interrupt subroutine disables interupts, reads the interrupt registers, and
>> then clears the registers in the beginning of _rtl_pci_interrupt(). After all
>> interupts process are finished, the driver invokes enable_interrupt() to enable
>> interupts. This behavior is normal for an interrupt subroutine.
>>
>> But enable_interrupt() invokes clear_interrupt() again. This unexpected interrupt
>> clearing may cleari me fresh TX OK interrupts. These missing interrupts cause TX
>> queue length to never reduce to 0i, which causes rtl_pci_flush() to be stuck in
>> unterminated while-loop.
>>
>> This patch removes clear_interrupt() in enable_interrupt() to avoid this behavior.
>>
>> Signed-off-by: Vincent Fann <vincent_fann@realtek.com>
>> Signed-off-by: Shao Fu <shaofu@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org> [3.18+]
>> ---
>>
>> Kalle,
>>
>> This patch is a little large for the current kernel and stable; however, it only
>> deletes code that is clearly wrong. I hope it will be OK.
>
> This isn't a recent regression nor a crasher (or similar) so I can't
> really justify to send this to 4.1 this late. The way I see it this
> could easily wait for 4.2, right?

OK. If any user complains about the 3-5 second hang, I'll refer then to the 
out-of-kernel repo for a fix.

Larry


