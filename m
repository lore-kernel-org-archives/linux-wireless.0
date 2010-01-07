Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2173 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab0AGTmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 14:42:51 -0500
Message-ID: <4B463953.1030806@canonical.com>
Date: Thu, 07 Jan 2010 12:43:15 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Martin Pitt <martin.pitt@canonical.com>
CC: mb@bu3sch.de, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Declare all possible firmware files.
References: <20100107183517.A322FF88D8@sepang.rtg.net> <4B463088.1020000@lwfinger.net> <4B4633CE.30906@canonical.com> <4B46367F.2020306@lwfinger.net>
In-Reply-To: <4B46367F.2020306@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 01/07/2010 01:19 PM, Tim Gardner wrote:
>> Larry Finger wrote:
>>> On 01/07/2010 12:35 PM, Tim Gardner wrote:
>>>> The following changes since commit 2c1f1895ef2aa8f0e5497893eff71304aef332e1:
>>>>   Linus Torvalds (1):
>>>>         Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6
>>>>
>>>> are available in the git repository at:
>>>>
>>>>   git://kernel.ubuntu.com/rtg/linux-2.6 b43
>>>>
>>>> Tim Gardner (1):
>>>>       b43: Declare all possible firmware files.
>>>>
>>>>  drivers/net/wireless/b43/main.c |   34 ++++++++++++++++++++++++++++++++--
>>>>  1 files changed, 32 insertions(+), 2 deletions(-)
>>>>
>>>> >From def1157eaeb397f0afab25b91db8bab3fcb8816c Mon Sep 17 00:00:00 2001
>>>> From: Tim Gardner <tim.gardner@canonical.com>
>>>> Date: Thu, 7 Jan 2010 11:10:38 -0700
>>>> Subject: [PATCH] b43: Declare all possible firmware files.
>>>>
>>>> BugLink: http://bugs.launchpad.net/bugs/488636
>>>>
>>>> Enhances module information with the names of the firmware files
>>>> that could be used by this driver. This helps tools like Jockey to
>>>> correctly detect and/or install the firmware files relevant to
>>>> this driver.
>>>>
>>>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>>>> ---
>>> How does Jockey do the firmware installation? I'm not familiar with this tool.
>>>
>>> Larry
>>>
>> Jockey is the codename for the Ubuntu Hardware Manager tool developed
>> and maintained by Martin Pitt. Its primary purpose is to assist with the
>> installation of not-completely open source components. Examples include
>> nVidia and Broadcom 'wl'. In this case, I believe jockey offers a choice
>> of b43 or wl (if the PCI IDs overlap).
>>
>> Cc'ing Martin.
> 
> Assuming that Jockey does not violate Broadcom's copyright on these firmware
> files, this approach is going to get a bit messy. There are two new kinds of
> devices that are currently undergoing reverse engineering. Once code is
> available for them, the number of firmware files will be increased by quite a
> bit. My current /lib/firmware/b43 has 93 files in it. Having that many
> MODULE_FIRMWARE macros seems wrong.
> 
> Larry
> 

AFAIK Jockey only needs to be able to tell if _any_ of the firmware
files have been installed and could therefore make an install decision
based on just one firmware file name.

Martin - if thats the case, then we need only list one firmware file in
the modinfo, correct?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
