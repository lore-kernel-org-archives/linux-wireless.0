Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33173 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbcGSQlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 12:41:44 -0400
Received: by mail-pf0-f169.google.com with SMTP id y134so9010234pfg.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 09:41:43 -0700 (PDT)
Subject: Re: [PATCH 0/4] brcm80211: Misc coverity fixes
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
 <bdbaa850-4ec4-9faf-dbae-e2a6dcc54e7c@broadcom.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <578E5845.6030100@gmail.com> (sfid-20160719_184148_092900_1C55214E)
Date: Tue, 19 Jul 2016 09:41:41 -0700
MIME-Version: 1.0
In-Reply-To: <bdbaa850-4ec4-9faf-dbae-e2a6dcc54e7c@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2016 02:20 AM, Arend Van Spriel wrote:
> + Bob
> 
> On 19-7-2016 1:24, Florian Fainelli wrote:
>> Hi,
>>
>> This patch series addresses several coverity issues, they all seemed relevant
>> to me.
> 
> Hi Florian,
> 
> Been a while so nice to see coverity fixes popping up. Actually
> something that I have on my todo list to add our brcm80211 to coverity
> within Broadcom. So being curious as to whether this comes from a public
> coverity server like scan.coverity.com. Maybe bit redundant to setup
> internally if there is a good coverity analysis publicly available.

This is coming from the public coverity instance, if you create an
account there I could transfer to you the other bugs that affect the
brcm80211 drivers (hint: there is a ton of of them because of
brcmf_fil_iovar_int_get and friends).

> 
>> There is also a ton of warnings in Coverity caused by brcmf_fil_iovar_int_get()
>> and friends because of the initial access:
>>
>> __le32 data_le = cpu_to_le32(*data) which can utilize unitialized memory. I am
>> not sure if we actually care about any kind of initial, value, but if we don't,
>> then the fix should be fairly obvious.
> 
> If we are talking only about "get" variant than we mostly don't care.
> Some getters support filter variables to be passed towards firmware. I
> have not looked at the analysis to give any judgement here.

Alright, do you have a good way to test a patch that would just zero
initialize the data variable in brcmf_fil_iovar_int_get()? If so, I will
submit one with the appropriate CID references.

Thanks!
-- 
Florian
