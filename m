Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:61790 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaF3IWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 04:22:15 -0400
Message-ID: <53B11E34.60601@broadcom.com> (sfid-20140630_102223_742799_6BC83C2C)
Date: Mon, 30 Jun 2014 10:22:12 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: John Talbut <jt@dpets.co.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: Firmware loading with static kernel and initramfs
References: <53B049A3.7000803@dpets.co.uk> <53B05B72.1010502@lwfinger.net> <53B066A5.4070003@dpets.co.uk> <53B08F07.3000308@lwfinger.net> <53B0F10D.7030801@dpets.co.uk>
In-Reply-To: <53B0F10D.7030801@dpets.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30-06-14 07:09, John Talbut wrote:
> On 29/06/14 23:11, Larry Finger wrote:
>> On 06/29/2014 02:19 PM, John Talbut wrote:
>>> I originally had the problem with a Broadcom BCM43225 wireless.  This
>>> was with a
>>> 3.8 kernel.  This was solved by a patch to the kernel brcmsmac driver
>>> and this
>>> is still working with a 3.14 kernel.
>>
>> What sort of patch was that? Driver brcmsmac is still using
>> request_firmware().
> 
> I believe it was this patch:
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c?id=25b5632fb35ca61b8ae3eee235edcdc2883f7a5e

Correct. IFF_UP was recommended event to consider user-space ready to
handle request_firmware. However, this may not work for drivers that
initialize the wiphy information based on info retrieved from firmware.

Regards,
Arend

>>
>>> Currently I have the problem with an Intel Centrino Wireless-N 130.
>>> The problem
>>> was present with a 3.11 kernel and currently with a 3.14 kernel.  udev
>>> version
>>> 204-5linuxmint.
>>
>> The current Intel drivers all use request_firmware_nowait(), but I'm not
>> sure when they were changed.
>>
>>> A friend seems to have the problem with a Realtek 8129se wireless but
>>> we are
>>> still checking out that this is the problem.
>>
>> To my knowledge, there is no Realtek 8129se driver. Do you mean
>> rtl8192se? If so, that one has used request_firmware_nowait() for some
>> time.
> 
> Yes, the rtl8192se driver.
> 
> John
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

