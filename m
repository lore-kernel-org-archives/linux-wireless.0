Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54655 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHLNP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 07:13:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	<87d2cbz3wy.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkF3+-1ded_dj63BGH7-bdD_uxLSkTZjGMb654yPzbtnA@mail.gmail.com>
Date: Fri, 8 Aug 2014 14:13:10 +0300
In-Reply-To: <CA+BoTQkF3+-1ded_dj63BGH7-bdD_uxLSkTZjGMb654yPzbtnA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 8 Aug 2014 12:24:48 +0200")
Message-ID: <87mwbfxmih.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_131318_685663_A6B5A2B0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> Based on Joe's suggestion, I'm planning to change the macro like below.
>> Are you ok with that?
>>
>> It actually adds a new checkpatch warning but I'm going to ignore that
>> for now:
>>
>> drivers/net/wireless/ath/ath10k/wmi.h:177: ERROR: Macros with complex values should be enclosed in parenthesis
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
>> index 109ea684f88f..e70836586756 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>> @@ -174,46 +174,48 @@ enum wmi_main_service {
>>
>>  static inline char *wmi_service_name(int service_id)
>>  {
>> -#define SVCSTR(x) { case x: return #x; }
>> +#define SVCSTR(x) case x: return #x
>> +
> [...]
>
> This was the checkpatch warning I originally fixed by using { .. } :-)

Hehe, I was actually thinking maybe that's why you added the braces :)

> Anyway, I don't see a problem with the macro change you suggest.
> Apparently we're doomed to have a checkpatch warning either way unless
> we don't use a macro at all.

Yeah. And it's not like that we need to have 0 checkpatch warnings. For
example, I already have a long list of errors I ignore:

MSLEEP,USLEEP_RANGE,PRINTK_WITHOUT_KERN_LEVEL,NETWORKING_BLOCK_COMMENT_STYLE,LINUX_VERSION_CODE,COMPLEX_MACRO

checkpatch just a good tool to catch some of the style issues and makes
my work easier, especially when newbies send patches.

-- 
Kalle Valo
