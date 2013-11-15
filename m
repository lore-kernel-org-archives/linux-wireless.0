Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51803 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab3KOOS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 09:18:28 -0500
Received: from [192.168.1.100] ([79.218.105.41]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MF5FT-1VwQNF3aaB-00GIQs for
 <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 15:18:26 +0100
Message-ID: <52862D32.3010601@rempel-privat.de> (sfid-20131115_151831_787787_560E43C4)
Date: Fri, 15 Nov 2013 15:18:26 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Proffit, Jerome" <jproffit@qca.qualcomm.com>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Biard, David" <dbiard@qca.qualcomm.com>,
	ath9k_htc_fw@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc: Target is unresponsive
References: <39E4555519E9C54593B1BE31E24CB79A39B12884@nasanexd02a.na.qualcomm.com> <20131115134752.GQ9795@pogo>
In-Reply-To: <20131115134752.GQ9795@pogo>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I do not know which backport include patch for usb interrupt transfer.
If your kernel still use bulk, it may be the cause of this issue.

Am 15.11.2013 14:47, schrieb Luis R. Rodriguez:
> Cc'ing linux-wireless and ath9k_htc_fw list. The firmware is open
> so any issues can now be debugged in collaboration with the community.
> 
> You may try the newer backports:
> 
> http://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.12/backports-3.12-1.tar.bz2
> 
> And as for the firmware it seems to be the latest but I'll let
> others who are maintaining that now chime in.
> 
>   Luis
> 
> On Fri, Nov 15, 2013 at 02:17:43AM -0800, Proffit, Jerome wrote:
>> Hello,
>>
>> Could anybody help with the question below?
>>
>> Thanks,
>>
>> -Jerome
>>
>> -------------------------------------------
>>
>> We are trying to bring up the VIA TECH WLAN USB dongle (AR9271 based
>> chip) on our platform.  We have downloaded the back port
>> drivers from:
>> https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.10/backports-3.10-1.tar.bz2
>> and cross compiled to our target (Tensilica -233).  The Firmware
>> (htc_9271.fw) is downloaded from:
>> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw and copied
>> the same into /lib/firmware/ on the target.  Loaded all generated
>> modules (.ko) and connect the WiFi over USB dongle into the USB
>> connector. But the device is not getting initialized. Please find the
>> log as below. Please help in this regard.
>>
>>
>> Log:
>> usb 1-1: new high speed USB device using dwc_otg and address 2
>> usb 1-1: configuration #1 chosen from 1 choice
>> usb 1-1: ath9k_htc: Firmware htc_9271.fw requested
>> usb 1-1: firmware: requesting htc_9271.fw
>> usb 1-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51000
>> ath9k_htc 1-1:1.0: ath9k_htc: Target is unresponsive
>> ath9k_htc: Failed to initialize the device
>>
>>
>> Product:VIA USB2.0 WLAN
>> Manufacturer:VIA TECH
>>
>> Vendor id: 0x040d 
>> Product id: 0x3801
>> ----------------------------------------
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Regards,
Oleksij
