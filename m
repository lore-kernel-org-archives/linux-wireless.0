Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48847 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638Ab2AaXQF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 18:16:05 -0500
Received: by obcva7 with SMTP id va7so548785obc.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 15:16:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F27F4DC.6080101@gmail.com>
References: <4F1F0810.2000306@gmail.com> <4F25BCAE.3040709@hauke-m.de> <4F27F4DC.6080101@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 31 Jan 2012 15:15:45 -0800
Message-ID: <CAB=NE6WzrBy+yEzgtNbS7yAyuVkXDumMG-XEwQ96P6ztzV=iEg@mail.gmail.com> (sfid-20120201_001609_445408_49E270B1)
Subject: Re: [compat-wireless] modprobe -l is legacy compatibility mode and is
 being removed from some distros
To: Richard Farina <sidhayn@gmail.com>,
	Rusty Russell <rusty@rustcorp.com.au>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 6:04 AM, Richard Farina <sidhayn@gmail.com> wrote:
> On 01/29/2012 04:39 PM, Hauke Mehrtens wrote:
>>
>> On 01/24/2012 08:35 PM, Richard Farina wrote:
>>>
>>> module-init-tools has been deprecated in favor of kmod in Arch Linux,
>>> and kmod doesn't have the legacy --list option for modprobe.
>>> This patch fixes the areas of the Makefile which actually needed the
>>> output of modprobe -l. The other 100's of uses are just to echo info to
>>> the screen which in this case will simply fail in an extremely noisy
>>> fashion yet non-fatal way.
>>>
>>> Please apply to all branches.
>>>
>>> Signed-of-By: Rick Farina<sidhayn@gmail.com>
>>>
>>> diff -Naur compat-wireless-3.3-rc1-2/Makefile
>>> compat-wireless-3.3-rc1-2-modinfo-migration/Makefile
>>> --- compat-wireless-3.3-rc1-2/Makefile    2012-01-21 02:00:21.000000000
>>> -0500
>>> +++ compat-wireless-3.3-rc1-2-modinfo-migration/Makefile    2012-01-24
>>> 14:27:20.000000000 -0500
>>> @@ -9,11 +9,6 @@
>>>  # Sometimes not available in the path
>>>  MODPROBE := /sbin/modprobe
>>>
>>> -ifneq ($(wildcard $(MODPROBE)),)
>>> -MADWIFI=$(shell $(MODPROBE) -l ath_pci)
>>> -OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
>>> -endif
>>> -
>>
>> What happens if modinfo is not available? I do not know on what systems
>> this is the case, but I do not think that modinfo is available when
>> modprobe is not.
>
> AFAIK this is never the case.  modinfo is packaged with module-init-tools
> and on Arch module-init-tools has been replaced by KMOD which also includes
> modinfo.  It would seem to me that at this point modinfo is a required tool
> and is always packaged with modprobe.

Rusty, should all Linux distributions that carry modprobe also have modinfo ?

  Luis
