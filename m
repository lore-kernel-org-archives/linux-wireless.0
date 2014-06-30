Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:39955 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802AbaF3FQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 01:16:07 -0400
Message-ID: <53B0F10D.7030801@dpets.co.uk> (sfid-20140630_071611_798372_F9F56EBB)
Date: Mon, 30 Jun 2014 06:09:33 +0100
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Firmware loading with static kernel and initramfs
References: <53B049A3.7000803@dpets.co.uk> <53B05B72.1010502@lwfinger.net> <53B066A5.4070003@dpets.co.uk> <53B08F07.3000308@lwfinger.net>
In-Reply-To: <53B08F07.3000308@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/06/14 23:11, Larry Finger wrote:
> On 06/29/2014 02:19 PM, John Talbut wrote:
>> I originally had the problem with a Broadcom BCM43225 wireless.  This
>> was with a
>> 3.8 kernel.  This was solved by a patch to the kernel brcmsmac driver
>> and this
>> is still working with a 3.14 kernel.
>
> What sort of patch was that? Driver brcmsmac is still using
> request_firmware().

I believe it was this patch:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c?id=25b5632fb35ca61b8ae3eee235edcdc2883f7a5e
>
>> Currently I have the problem with an Intel Centrino Wireless-N 130.
>> The problem
>> was present with a 3.11 kernel and currently with a 3.14 kernel.  udev
>> version
>> 204-5linuxmint.
>
> The current Intel drivers all use request_firmware_nowait(), but I'm not
> sure when they were changed.
>
>> A friend seems to have the problem with a Realtek 8129se wireless but
>> we are
>> still checking out that this is the problem.
>
> To my knowledge, there is no Realtek 8129se driver. Do you mean
> rtl8192se? If so, that one has used request_firmware_nowait() for some
> time.

Yes, the rtl8192se driver.

John
