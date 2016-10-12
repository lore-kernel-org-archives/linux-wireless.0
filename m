Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32951 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932993AbcJLPjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 11:39:12 -0400
Subject: Re: [PATCH] rtlwifi: Fix regression caused by commit d86e64768859
To: Kalle Valo <kvalo@codeaurora.org>
References: <20161010233211.13519-1-Larry.Finger@lwfinger.net>
 <87r37mf1gi.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        "Stable [ 4 . 8+ ]" <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Thorsten Leemhuis <regressions@leemhuis.info>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <704f3dc4-a9b6-3c00-edec-b1499a2c4c60@lwfinger.net> (sfid-20161012_173916_406590_D41E7162)
Date: Wed, 12 Oct 2016 10:39:09 -0500
MIME-Version: 1.0
In-Reply-To: <87r37mf1gi.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2016 02:53 AM, Kalle Valo wrote:
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
>
> This should be:
>
> Cc: Stable <stable@vger.kernel.org> # 4.8

I know that info should be at the end of the Cc for Stable; however, versions of 
git since 2.6 are incorrectly mangling the line and producing the following:

Stable <stable@vger.kernel.org#4.8+>

Of course, the smtp server refuses to send that mail, thus I got creative with 
my formatting.

Thanks for Thorsten's address. I will try to keep him notified of any future 
regressions that I find. Thus far, I have only communicated with him indirectly 
through LKML.

Larry
