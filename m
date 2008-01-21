Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:38699 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901AbYAUQK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 11:10:57 -0500
Received: by ug-out-1314.google.com with SMTP id z38so898404ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2008 08:10:55 -0800 (PST)
Message-ID: <4794C341.2020300@gmail.com> (sfid-20080121_161106_933556_2130F70A)
Date: Mon, 21 Jan 2008 18:07:29 +0200
From: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org, Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH] WEXT: Correct the size of the buffer to be copied to
 user-space in standard GET WE ioctls.
References: <4793935F.2000102@gmail.com> <43e72e890801201104o5d2e395du558037179156e80b@mail.gmail.com>
In-Reply-To: <43e72e890801201104o5d2e395du558037179156e80b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Adding Jean.
> 
>   Luis
> 
> On Jan 20, 2008 1:30 PM, Volodymyr G. Lukiianyk <volodymyrgl@gmail.com> wrote:
>> For the most of standard WE GET ioctls the size of the buffer to store driver's
>> response is calculated on base of the call's descriptor (.token_size and
>> .max_tokens fields) without taking into consideration the size of the buffer
>> provided by application in struct iwreq. But when the response is being copied to
>> userspace, its size is calculated from the length provided by application. This
>> can lead to kernel internal data leak into userspace, and oopses when the buffer
>> is located near the end of the available memory. To prevent these situations the
>> size used during copying is set to the same one used during allocation.
>>
>>
>> Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
>> ---
>>
>> I've actually seen those oopses on the system with 32MB of memory, when 1k
>> object at address c1fffc00 was returned by the SLAB while handling request for
>> allocating 568 bytes buffer (struct iw_range). Later, copy_to_user() (instructed
>> to copy 1136 bytes, since iwlist uses 2x buffer) crashed trying to access
>> c2000000, which is beyond the bounds of available 32MB.
>>
>> The patch attached is against the Linus's tree.
>>
>>
>> diff --git a/net/wireless/wext.c b/net/wireless/wext.c
>> index 47e80cc..c6ce59b 100644
>> --- a/net/wireless/wext.c
>> +++ b/net/wireless/wext.c
>> @@ -866,8 +866,7 @@ static int ioctl_standard_call(struct net_device *  dev,
>>                         }
>>
>>                         err = copy_to_user(iwr->u.data.pointer, extra,
>> -                                          iwr->u.data.length *
>> -                                          descr->token_size);
>> +                                          extra_size);
>>                         if (err)
>>                                 ret =  -EFAULT;
>>                 }
>>
>>
> 


Please, ignore this patch. I didn't notice that the driver's handler should set
iwr->u.data.length appropriately. But is there any possibility for compiler to
temporarily save the value of this field in the register and not re-read it after
handler call?

