Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4443 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab3FMIKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 04:10:07 -0400
Message-ID: <51B97E56.4030701@broadcom.com> (sfid-20130613_101015_923550_CC1E7FF7)
Date: Thu, 13 Jun 2013 10:09:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stephen Warren" <swarren@wwwdotorg.org>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: Regression in 9390ace brcmfmac: free net device when
 registration fails
References: <51AD1F22.2080004@wwwdotorg.org>
 <51ADE47D.50700@broadcom.com> <51B0FAC0.4080709@broadcom.com>
 <51B100C2.8070905@wwwdotorg.org> <51B8E5FA.9040400@wwwdotorg.org>
In-Reply-To: <51B8E5FA.9040400@wwwdotorg.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2013 11:19 PM, Stephen Warren wrote:
> On 06/06/2013 03:36 PM, Stephen Warren wrote:
>> On 06/06/2013 03:10 PM, Arend van Spriel wrote:
>>> On 06/04/13 14:58, Arend van Spriel wrote:
>>>> On 06/04/2013 12:56 AM, Stephen Warren wrote:
>>>>> (John, note that this commit is part of the pull request you sent to
>>>>> Dave today)
>>>>>
>>>>> Arend,
>>>>>
>>>>> Commit 9390ace "brcmfmac: free net device when registration fails"
>>>>> causes a regression.
>>>>>
>>>>> I had the BCM4330 firmware present in my root fs, whereas my HW is a
>>>>> BCM4329. With this patch applied, I get a kernel panic on boot. With it
>>>>> reverted, I see that no issues of that nature. This is true in
>>>>> next-20130531 (and also 5/30 and 6/1 but not earlier). A bisect of
>>>>> Linus's tree followed by a merge of John's wireless pull request from
>>>>> today pointed at this same commit.
>>>>
>>>> Thanks, Stephen
>>>>
>>>> I will look into this.
>>>
>>> Hi Stephen,
>>>
>>> Can you try the attached patch? If it does not solve the issue, could
>>> you provide a log.
>>
>> Yes, that works great, thanks.
>>
>> Tested-by: Stephen Warren <swarren@nvidia.com>
>
> Did this patch get applied anywhere? I was hoping it'd go into 3.10-rc*
> given it's a user-triggerable backtrace introduced in 3.10-rc*.

Hi Stephen,

The patch went into the wireless-next tree. Given recent events with our 
patch series I am a bit more carsful to tag patches for 3.10. Your issue 
is user-triggerable but the scenario to get there can be avoided. But 
you are right it was introduced in the 3.10-rc cycle. I leave it to John 
to decide.

Regards,
Arend


