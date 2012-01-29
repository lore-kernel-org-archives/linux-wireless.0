Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58959 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2A2SAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 13:00:49 -0500
Received: by yhoo21 with SMTP id o21so1451304yho.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jan 2012 10:00:48 -0800 (PST)
Message-ID: <4F25894C.9080206@lwfinger.net> (sfid-20120129_190102_057744_D79A3E54)
Date: Sun, 29 Jan 2012 12:00:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Drivers that use synchronous firmware loading
References: <4F24BF84.1020209@lwfinger.net> <87mx96csyd.fsf@purkki.adurom.net>
In-Reply-To: <87mx96csyd.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2012 11:35 AM, Kalle Valo wrote:
> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>
>> To all wireless developers:
>>
>> As you may have noticed, the udev layer is being changed. One of the
>> side effects is that the kernel may timeout when a driver uses
>> synchronous firmware loading. My rtlwifi drivers were affected, and a
>> kernel bugzilla has been logged against rtl8192se. I suggest that the
>> maintainers should be proactive, and convert to asynchronous loading
>> as soon as possible.
>
> Thanks for the summary, this was really useful.
>
>> In wireless-testing, the files listed below contain calls to
>> read_firmware() rather than read_firmware_nowait():
>>
>> drivers/net/wireless/at76c50x-usb.c
>> drivers/net/wireless/ath/ath6kl/init.c
>> drivers/net/wireless/ath/ath9k/hif_usb.c
>> drivers/net/wireless/atmel.c
>> drivers/net/wireless/b43/main.c
>> drivers/net/wireless/b43legacy/main.c
>> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> drivers/net/wireless/ipw2x00/ipw2100.c
>> drivers/net/wireless/iwlegacy/3945-mac.c
>> drivers/net/wireless/iwlegacy/4965-mac.c
>> drivers/net/wireless/iwlwifi/iwl-agn.c
>> drivers/net/wireless/libertas/main.c
>> drivers/net/wireless/libertas/if_usb.c
>> drivers/net/wireless/libertas_tf/if_usb.c
>> drivers/net/wireless/mwifiex/main.c
>> drivers/net/wireless/mwl8k.c
>> drivers/net/wireless/orinoco/fw.c
>> drivers/net/wireless/orinoco/orinoco_usb.c
>> drivers/net/wireless/p54/p54spi.c
>> drivers/net/wireless/p54/p54usb.c
>> drivers/net/wireless/p54/p54pci.c
>> drivers/net/wireless/prism54/islpci_dev.c
>> drivers/net/wireless/rt2x00/rt2x00firmware.c
>> drivers/net/wireless/wl1251/main.c
>> drivers/net/wireless/zd1201.c
>> drivers/net/wireless/zd1211rw/zd_usb.c
>>
>> Some of the drivers above may be exempt as their firmware is built
>> into the kernel. I did not check for that case.
>
> But isn't the issue only when a firmware is requested synchronously
> during module init? For example, IIRC wl1251 loads the module during
> hw start and that should be safe, even when making a synchronous call.
> Or did I misunderstood something?

As I understand the situation, if userland is running when the firmware is 
requested synchronously, then the request should be OK. Certainly, when firmware 
loading is triggered from the probe routine, it will cause trouble.

I was just contacted this morning about problems with r8712u on Arch Linux. 
Another driver for me to fix.

Larry

