Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55382 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaE3HJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 03:09:37 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so1478826wgg.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 00:09:35 -0700 (PDT)
Message-ID: <53882EAD.4010609@gmail.com> (sfid-20140530_090945_093414_3FDCD4CF)
Date: Fri, 30 May 2014 10:09:33 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: piotr <pitkotko@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
References: <536F6620.9030001@gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com> <loom.20140530T020912-598@post.gmane.org>
In-Reply-To: <loom.20140530T020912-598@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>
>>> My wireless card was working fine for some time, but after reinstallation of
>>> computer with Ubuntu, it stopped working and i keep getting this in my
>>> dmesg:
>>
>> Can you please share with us the kernel versions you had used until now,
> and your current version?
>>
> 
> Hi,
> 
> I have similar problem. My system is Ubuntu 14.04 with kernel 3.13.0-24
> installed on a new Toshiba laptop with N2230 wifi card. 
> dmesg:
> [  614.007461] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
> [  614.007748] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
> [  614.007790] iwlwifi 0000:01:00.0: Unable to initialize device.
> [  614.008318] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
> [  614.015390] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
> [  614.059495] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD failed:
> FW Error
> 
> Is the card broken?
> 
> Best,
> Piotr
> 
> 
>>>
>>> lspci:
>>> 0a:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev
>>> c4)
>>>          Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN
>>>
>>>
>>> dmesg:
>>> [ 1465.050832] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
>>> [ 1465.058299] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
>>> [ 1465.104509] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
>>> failed: FW Error
>>> [ 1465.104522] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
>>> [ 1465.104527] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
>>> [ 1465.104818] iwlwifi 0000:0a:00.0: Unable to initialize device.
>>> [ 1465.105296] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
>>> [ 1465.112770] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
>>> [ 1465.156493] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
>>> failed: FW Error
>>> [ 1465.156500] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
>>> [ 1465.156504] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
>>> [ 1465.156784] iwlwifi 0000:0a:00.0: Unable to initialize device.
>>> [ 1465.158031] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
>>> [ 1465.165471] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
>>> [ 1465.212534] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
>>> failed: FW Error
>>> [ 1465.212542] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
>>> [ 1465.212546] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
>>> [ 1465.212825] iwlwifi 0000:0a:00.0: Unable to initialize device.
>>> [ 1465.213119] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
>>> [ 1465.220559] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
>>>
>>> Does this mean i have issue with driver/kernel or my wifi card is
>>> broken? I tried copying latest uucode for 2230 wireless card
>>> (http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=
>>> get&target=iwlwifi-2030-ucode-18.168.6.1.tgz)
>>> into /lib/firmware and reloading kernel module, no success. Still the
>>> same issue.
>>>

Can you try to add bt_coex_active=0 as debug parameter?

Thanks
