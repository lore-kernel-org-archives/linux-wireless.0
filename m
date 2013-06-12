Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:35760 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3FLVT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 17:19:57 -0400
Message-ID: <51B8E5FA.9040400@wwwdotorg.org> (sfid-20130612_232001_378635_C0FB25A0)
Date: Wed, 12 Jun 2013 15:19:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: Regression in 9390ace brcmfmac: free net device when registration
 fails
References: <51AD1F22.2080004@wwwdotorg.org> <51ADE47D.50700@broadcom.com> <51B0FAC0.4080709@broadcom.com> <51B100C2.8070905@wwwdotorg.org>
In-Reply-To: <51B100C2.8070905@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2013 03:36 PM, Stephen Warren wrote:
> On 06/06/2013 03:10 PM, Arend van Spriel wrote:
>> On 06/04/13 14:58, Arend van Spriel wrote:
>>> On 06/04/2013 12:56 AM, Stephen Warren wrote:
>>>> (John, note that this commit is part of the pull request you sent to
>>>> Dave today)
>>>>
>>>> Arend,
>>>>
>>>> Commit 9390ace "brcmfmac: free net device when registration fails"
>>>> causes a regression.
>>>>
>>>> I had the BCM4330 firmware present in my root fs, whereas my HW is a
>>>> BCM4329. With this patch applied, I get a kernel panic on boot. With it
>>>> reverted, I see that no issues of that nature. This is true in
>>>> next-20130531 (and also 5/30 and 6/1 but not earlier). A bisect of
>>>> Linus's tree followed by a merge of John's wireless pull request from
>>>> today pointed at this same commit.
>>>
>>> Thanks, Stephen
>>>
>>> I will look into this.
>>
>> Hi Stephen,
>>
>> Can you try the attached patch? If it does not solve the issue, could
>> you provide a log.
> 
> Yes, that works great, thanks.
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>

Did this patch get applied anywhere? I was hoping it'd go into 3.10-rc*
given it's a user-triggerable backtrace introduced in 3.10-rc*.
