Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:49697 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaL1GPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2014 01:15:36 -0500
Message-ID: <549FA005.7050802@lwfinger.net> (sfid-20141228_071545_235193_1E3909D8)
Date: Sun, 28 Dec 2014 00:15:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Stable <stable@vger.kernel.org>,
	Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 23/23 V2 for 3.19]  rtlwifi: Fix error when accessing
 unmapped memory in skb
References: <1419711457-21469-1-git-send-email-Larry.Finger@lwfinger.net> <87a928726w.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a928726w.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2014 11:50 PM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> These drivers use 9100-byte receive buffers, thus allocating an skb requires
>> an O(3) memory allocation. Under heavy memory loads and fragmentation, such
>> a request can fail. Previous versions of the driver have dropped the packet
>> and reused the old buffer; however, the new version introduced a bug in that
>> it released the old buffer before trying to allocate a new one. The previous
>> method is implemented here.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>  [v3.18]
>> Reported-by: Eric Biggers <ebiggers3@gmail.com>
>> Cc: Eric Biggers <ebiggers3@gmail.com>
>> ---
>>
>> V2 - Fixes an error in the logic of V1. Realtek is working on a change to
>>       the RX buffer allocation, but that is likely to be too invasive for
>>       a fix to -rc or stable. In the meantime, this will help.
>
> 23/23? Where are patches 1-22? I don't see them in patchwork:
>
> https://patchwork.kernel.org/project/linux-wireless/list/

Sorry. I forgot to edit the subject line. To get git to format that one patch, I 
had to generate a total of 23. There is only 1 of 1 that will be submitted.

Larry


