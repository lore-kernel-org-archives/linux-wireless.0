Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3653 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759616Ab1FBIjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 04:39:08 -0400
Message-ID: <4DE74C1F.7040609@broadcom.com> (sfid-20110602_103915_916907_C090159C)
Date: Thu, 2 Jun 2011 10:38:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 42/83] staging: brcm80211: remove dependency on pci
 core difinitions from aiutils.c
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-42-git-send-email-rvossen@broadcom.com>
 <BANLkTikwxTCiG1nChMJKgWcUouk9A5_4qg@mail.gmail.com>
In-Reply-To: <BANLkTikwxTCiG1nChMJKgWcUouk9A5_4qg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2011 01:18 AM, Julian Calaby wrote:
> On Wed, Jun 1, 2011 at 21:45, Roland Vossen<rvossen@broadcom.com>  wrote:
>> From: Arend van Spriel<arend@broadcom.com>
>>
>> The file aiutils.c included the register definition includes for the
>> PCI and PCIe core. This was for two functions which have been partly
>> moved to nicpci.c. This means that nicpci.h is the only include file
>> to provide interface to aiutils.c for PCI core related functions.
>>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> Reviewed-by: Roland Vossen<rvossen@broadcom.com>
>> ---
>> diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
>> index bae40fe..43320b4 100644
>> --- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
>> +++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
>> @@ -1915,7 +1913,7 @@ void ai_pci_down(si_t *sih)
>>   void ai_pci_setup(si_t *sih, uint coremask)
>>   {
>>         si_info_t *sii;
>> -       struct sbpciregs *pciregs = NULL;
>> +       void *regs = NULL;
>>         u32 siflag = 0, w;
>>         uint idx = 0;
>>
> Is changing this to void* necessarily a good idea? - the regs variable
> appears to only be used by PCI code, so having it declared as a struct
> sdpciregs* isn't going to make it any less generic - and having it
> declared as a structure would help to spot bugs in the code.
>
> Thanks,

Hi Julian,

The separation I tried to accomplish was to have the knowledge of the 
pci core register layout in one file, ie. nicpci.c. So this step is to 
make aiutils.c unaware of that layout. Another solution would be to move 
the function itself to nicpci.c. I will look into this as tend to agree 
with you.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


