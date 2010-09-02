Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37975 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab0IBNSK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:18:10 -0400
Message-ID: <4C7FA408.3010408@hauke-m.de>
Date: Thu, 02 Sep 2010 15:18:00 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH] compat: backport linux/pci-aspm.h
References: <1282934514-18160-1-git-send-email-hauke@hauke-m.de> <20100828210131.GA2422@tux> <4C7E6C1D.8050305@hauke-m.de> <AANLkTi=29wfzQz7CK8QX++n+S-KrHVGszW60AFS_vpbs@mail.gmail.com>
In-Reply-To: <AANLkTi=29wfzQz7CK8QX++n+S-KrHVGszW60AFS_vpbs@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 01.09.2010 17:12, schrieb Luis R. Rodriguez:
> On Wed, Sep 1, 2010 at 8:07 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> Am 28.08.2010 23:01, schrieb Luis R. Rodriguez:
>>> On Fri, Aug 27, 2010 at 11:41:54AM -0700, Hauke Mehrtens wrote:
>>>> pci-aspm.h was introduced in kernel 2.6.25 and is used by the ath5k driver.
>>>>
>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>> ---
>>>>  include/linux/pci-aspm.h |   55 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 files changed, 55 insertions(+), 0 deletions(-)
>>>>  create mode 100644 include/linux/pci-aspm.h
>>>>
>>>> diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
>>>> new file mode 100644
>>>> index 0000000..c791d00
>>>> --- /dev/null
>>>> +++ b/include/linux/pci-aspm.h
>>>
>>> So compat-wireless would have to copy this file over? We'd then have to synch
>>> this file for older kernels, and the real kernel header's own pci-aspm.h for
>>> kernels >= 2.6.25 would be using this version of the file. Can we just stuff
>>> the ASPM required stuff onto include/linux/compat-2.6.25.h ?
>>>
>>>   Luis
>> Hi,
>>
>> we can stuff the empty aspm functions into compat-2.6.25.h, but we need
>> include/linux/pci-aspm.h or we need an extra ifdef in compat-wireless
>> (not nice). Some drivers like drivers/net/wireless/ath/ath5k/base.c and
>> drivers/net/wireless/iwlwifi/iwl-agn.c are including pci-aspm.h, but it
>> is not there for kernels < 2.6.25.
> 
> Understood and good point.
> 
>> I will prepare a new patch for compat. With an mostly empty pci-aspm.h
>> with an include_next and some functions in compat-2.6.35.h.
> 
> Well so the issue is getting kernels newer than include their own
> kernel header's include/linux/pci-aspm.h rather than the one provided
> by compat. How will this be achieved?

#include_next includes the next file with this name.
http://www.delorie.com/gnu/docs/gcc/cpp_11.html (middle)
We can do it like it is done in include/linux/tracepoint.h in compat.
If something changes in pci-aspm.h in the kernel we do not have to
change anything for kernel > 2.6.25.

Hauke
