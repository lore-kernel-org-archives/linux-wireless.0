Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33281 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbbAETZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 14:25:41 -0500
Received: by mail-oi0-f41.google.com with SMTP id i138so44667781oig.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 11:25:40 -0800 (PST)
Message-ID: <54AAE532.6050104@lwfinger.net> (sfid-20150105_202545_105115_334FAC56)
Date: Mon, 05 Jan 2015 13:25:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= <francoisvalenduc@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Kernel crash while copying big files since kernel 3.18
References: <54AA3953.20603@gmail.com> <54AAC925.6050602@lwfinger.net> <54AADC22.9050105@gmail.com>
In-Reply-To: <54AADC22.9050105@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2015 12:46 PM, François Valenduc wrote:
> Le 05/01/15 18:25, Larry Finger a écrit :
>> On 01/05/2015 01:12 AM, François Valenduc wrote:
>>> Hello everybody,
>>>
>>> Since kernel 3.18, I encounter a kernel crash each time when I copy a
>>> big file (around 12 Gb) from an external USB drive to the harddrive of
>>> my laptop.
>>> I tried a bisection between kernels 3.17 and 3.18 and I was surprised to
>>> find that this has to do with the driver of the wireless card
>>> (rtl8188ee). However, I don't have problems if I copy the file while the
>>> rtl8188 module is not loaded. Unfortunately, the results of git-bisect
>>> are not totally conclusive because the kernel crash during boot when the
>>> wireless connection is established. Here are the last steps of the
>>> bisection:
>>>
>>> # bad: [c151aed6aa146e9587590051aba9da68b9370f9b] rtlwifi: rtl8188ee:
>>> Update driver to match Realtek release of 06282014
>>> git bisect bad c151aed6aa146e9587590051aba9da68b9370f9b
>>> # good: [fd09ff958777cf583d7541f180991c0fc50bd2f7] rtlwifi: Remove extra
>>> workqueue for enter/leave power state
>>> git bisect good fd09ff958777cf583d7541f180991c0fc50bd2f7
>>> # skip: [9afa2e44f4d8f9d031f815c32bb8f225f0f6746b] rtlwifi: Modify
>>> base.{c,h} for new drivers
>>> git bisect skip 9afa2e44f4d8f9d031f815c32bb8f225f0f6746b
>>> # skip: [3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd] rtlwifi: Modify
>>> cam.{c,h} and efuse.{c,h} for new drivers
>>> git bisect skip 3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd
>>> # skip: [f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8] rtlwifi: Modify
>>> core.c for new drivers
>>> git bisect skip f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8
>>> # skip: [d3feae41a3473a0f7b431d6af4e092865d586e52] rtlwifi: Update
>>> power-save routines for 062814 driver
>>> git bisect skip d3feae41a3473a0f7b431d6af4e092865d586e52
>>> # skip: [38506ecefab911785d5e1aa5889f6eeb462e0954] rtlwifi: rtl_pci:
>>> Start modification for new drivers
>>> git bisect skip 38506ecefab911785d5e1aa5889f6eeb462e0954
>>> # skip: [f3a97e93814aeac3f13e857a0071726acc9bd626] rtlwifi: Finish
>>> modifying core routines for new drivers
>>> git bisect skip f3a97e93814aeac3f13e857a0071726acc9bd626
>>> # only skipped commits left to test
>>> # possible first bad commit: [c151aed6aa146e9587590051aba9da68b9370f9b]
>>> rtlwifi: rtl8188ee: Update driver to match Realtek release of 06282014
>>> # possible first bad commit: [f3a97e93814aeac3f13e857a0071726acc9bd626]
>>> rtlwifi: Finish modifying core routines for new drivers
>>> # possible first bad commit: [d3feae41a3473a0f7b431d6af4e092865d586e52]
>>> rtlwifi: Update power-save routines for 062814 driver
>>> # possible first bad commit: [3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd]
>>> rtlwifi: Modify cam.{c,h} and efuse.{c,h} for new drivers
>>> # possible first bad commit: [9afa2e44f4d8f9d031f815c32bb8f225f0f6746b]
>>> rtlwifi: Modify base.{c,h} for new drivers
>>> # possible first bad commit: [f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8]
>>> rtlwifi: Modify core.c for new drivers
>>> # possible first bad commit: [38506ecefab911785d5e1aa5889f6eeb462e0954]
>>> rtlwifi: rtl_pci: Start modification for new drivers
>>>
>>> Can somebody explain what's happening ? I do the copy via Dolphin in KDE
>>> and the screen becomes black and the computer becomes totally
>>> unresponsive. So, I don't have access to the logs to see the trace of
>>> the problem.
>>>
>>> Thanks in advance for your help,
>>
>> There is a bug in 3.18 that is triggered when an O(3) memory
>> allocation fails. There is a patch to fix this at
>> http://marc.info/?l=linux-netdev&m=141999680927473&w=2 that has been
>> merged into wireless-drivers as commit
>> e9538cf4f90713eca71b1d6a74b4eae1d445c664. It will be applied to 3.18.X
>> when it makes it into mainline 3.19-rcY, but that has not yet happened.
>>
>> You could manually apply that patch to your kernel source, or you
>> could pull the git repo at http://github.com/lwfinger/rtlwifi_new.git.
>> That code has this patch already applied.
>>
>> If this patch does not fix the problem, you might be able to capture
>> at least part of the backtrace by starting the transfer and then
>> switching to the logging console. When a crash happens, photograph the
>> screen. On my system, I display it with CTRL-ALT-F10. I return to the
>> normal graphical console with CTRL-ALT-F7, but your distro may use
>> different virtual consoles.
>>
>> Larry
>>
>>
> Thanks for your help, it seems that your patch solves the problem. Now,
> the system doesn't crash anymore after copying the same large file than
> yesterday. I also see this message in the log:
> rtl_pci: Allocation of new skb failed in _rtl_pci_rx_interrupt which is
> added by your patch.
> Should I worry about this failure ? Or is it expected ?

That is the positive proof that the new patch worked. Getting to that condition 
without the patch would have crashed the system. That printk is there to see if 
we were actually getting the condition and recovering. As the code is obviously 
working now, that line will be removed soon.

Thanks,

Larry

