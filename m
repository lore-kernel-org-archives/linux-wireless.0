Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gretel.risen.be ([78.46.99.137]:44123 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2EXEjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:39:00 -0400
Message-ID: <4FBDBB48.8080004@aquazul.com> (sfid-20120524_063914_146745_D1F69E89)
Date: Thu, 24 May 2012 06:38:32 +0200
From: Mourad De Clerck <bugs-wireless@aquazul.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com> <4FBDA4FE.6040603@lwfinger.net>
In-Reply-To: <4FBDA4FE.6040603@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24/05/12 05:03, Larry Finger wrote:
> The second solution is to make multiple tries of the read of the first
> firmware file. If the driver is a module, the first read will succeed,
> thus there is no penalty for that case. If the read fails, the code
> sleeps for 2000 ms, then retries the read. On my system, the 3rd try
> works, thus the loop count is set to 10.
>
> Please try the patch below on your system. If it works, please report
> the number in the line from the dmesg output that states "**********
> loop count at exit 2".

Well, I just tried it. It kinda works, but it seems a bit brittle.

Just after recompiling and rebooting, by chance my system needed a fsck, 
which seemed to delay it enough for it to go beyond the loop count, and 
it failed to load the firmware.

(Even without the fsck, my laptop could hang around indefinitely in 
early userspace waiting for me to type in my cryptoroot password)

Anyway, the second time I rebooted, it was fast enough (without the 
fsck) to load the firmware.

dmesg reported "********** loop count at exit 5" in that case.

-- M
