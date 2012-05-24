Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61741 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2EXNZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 09:25:16 -0400
Received: by qcro28 with SMTP id o28so5600404qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2012 06:25:15 -0700 (PDT)
Message-ID: <4FBE36B8.8020208@lwfinger.net> (sfid-20120524_152522_370856_9A480943)
Date: Thu, 24 May 2012 08:25:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mourad De Clerck <bugs-wireless@aquazul.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com> <4FBDA4FE.6040603@lwfinger.net> <4FBDBB48.8080004@aquazul.com>
In-Reply-To: <4FBDBB48.8080004@aquazul.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2012 11:38 PM, Mourad De Clerck wrote:
>
> Well, I just tried it. It kinda works, but it seems a bit brittle.
>
> Just after recompiling and rebooting, by chance my system needed a fsck, which
> seemed to delay it enough for it to go beyond the loop count, and it failed to
> load the firmware.
>
> (Even without the fsck, my laptop could hang around indefinitely in early
> userspace waiting for me to type in my cryptoroot password)
>
> Anyway, the second time I rebooted, it was fast enough (without the fsck) to
> load the firmware.
>
> dmesg reported "********** loop count at exit 5" in that case.

I was afraid that it might be too fragile; however, after these tests, I have a 
solution. Only the first firmware file (ucodeXX.fw) needs to be loaded 
asynchronously. Once it is available, all the others can be loaded in a 
synchronous manner. Realizing that greatly simplifies the logic.

It may be a while before I sort out all the details of this fix. Until then, you 
can use either the temporary fix or compile b43 as a module. To increase the 
robustness, change the end of the for loop from "i < 10" to "i < 5000". I could 
never do that in final code as it would delay forever if the firmware were 
really missing, but it will delay long enough to handle an fsck on root, your 
entering of the password for the encrypted fs, or whatever slows the starting of 
userland.

I will send you a test patch when the next round is available.

I always have the wireless drivers built as modules. When making changes, one 
only needs to recompile, reinstall the new version, and unload/reload the 
module. If built into the kernel, a reboot is needed for every change. None the 
less, the code needs to handle all cases.

Larry
