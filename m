Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36114 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755353AbcJLSx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 14:53:58 -0400
Subject: Re: [PATCH] rtlwifi: Fix regression caused by commit d86e64768859
To: Kalle Valo <kvalo@codeaurora.org>
References: <20161010233211.13519-1-Larry.Finger@lwfinger.net>
 <87zim9cxtt.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        "Stable [ 4 . 8+ ]" <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6dad1453-e82d-49bb-4556-f8c0af4a4dfc@lwfinger.net> (sfid-20161012_205403_287698_3D3D44AC)
Date: Wed, 12 Oct 2016 13:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <87zim9cxtt.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2016 11:54 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> In commit d86e64768859 ("rtlwifi: rtl818x: constify local structures"),
>> the configuration struct for most of the drivers was changed to be
>> constant. The problem is that five of the modified drivers need to be
>> able to update the firmware name based on the exact model of the card.
>> As the file names were stored in one of the members of that struct,
>> these drivers would fail with a kernel BUG splat when they tried to
>> update the firmware name.
>>
>> Rather than reverting the previous commit, I used a suggestion by
>> Johannes Berg and made the firmware file name pointers be local to
>> the routines that update the software variables.
>>
>> The configuration struct of rtl8192cu, which was not touched in the
>> previous patch, is now constantfied.
>>
>> Fixes: d86e64768859 ("rtlwifi: rtl818x: constify local structures")
>> Suggested-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable [4.8+] <stable@vger.kernel.org>
>> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
>
> I got warnings and after a quick look they look valid but not sure:
>
> drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c: In function 'rtl92c_init_sw_vars':
> drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c:179:6: warning: 'fw_name' may be used uninitialized in this function [-Wuninitialized]
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c: In function 'rtl8723e_init_sw_vars':
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c:187:6: warning: 'fw_name' may be used uninitialized in this function [-Wuninitialized]
>
> (Sending manually for the second time as I don't see my first mail
> anywhere.)

Kalle,

I did receive the first one. My compiler failed to show that warning, but I have 
modified the patch to fix the warnings you see. In fact, the new version is a 
bit cleaner in that "if () ... else if () ..." constructions are replaced by 
simple if statements.

V2 will be sent shortly.

Larry
