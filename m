Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37488 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbeBQLXe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 06:23:34 -0500
Received: by mail-wm0-f65.google.com with SMTP id v71so7298479wmv.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Feb 2018 03:23:33 -0800 (PST)
From: cantabile <cantabile.desu@gmail.com>
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
To: Jakub Kicinski <kubakici@wp.pl>, mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org
References: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com>
 <20180214164549.72ee26c3@cakuba.netronome.com>
 <f542e9c6-5106-c79c-6e38-7a2f50e6be2d@gmail.com>
 <20180215134738.722654a9@cakuba.netronome.com>
Message-ID: <7cebda93-4b7a-e8b3-271f-0144c5e94248@gmail.com> (sfid-20180217_122338_630662_722654F0)
Date: Sat, 17 Feb 2018 13:23:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180215134738.722654a9@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/02/18 23:47, Jakub Kicinski wrote:
> On Thu, 15 Feb 2018 13:38:00 +0200, cantabile wrote:
>> On 15/02/18 02:45, Jakub Kicinski wrote:
>>> On Wed, 14 Feb 2018 13:34:38 +0200, cantabile wrote:
>>>> The firmware running on the device sometimes survives a reboot
>>>> (firmware_running returns 1). When this happens the driver never calls
>>>> request_firmware, which means the kernel's firmware handling code
>>>> doesn't know this firmware should be cached before hibernating. Upon
>>>> resuming from several hours of hibernation, the firmware is no longer
>>>> running on the device, so the driver calls request_firmware. Since the
>>>> firmware was never cached, it needs to be loaded from disk, and this is
>>>> when the system freezes, somewhere in the xfs driver. Fix this by always
>>>> requesting the firmware, whether it's already running on the device or not.
>>>>
>>>> Signed-off-by: John Smith <cantabile.desu@gmail.com>
>>>
>>> Thanks for tracking this down, but this seems like the wrong
>>> direction.
>>>
>>> What's your hard drive?  Is it some complex configuration which
>>> prevents the block device from coming online after resume?
>>>
>>> If it's really because of some peculiarities of XFS the fix should
>>> go there, no driver will be able to load FW on resume...
>>>    
>>
>> My hard drive is a SATA SSD, with a regular MS-DOS partition table, with
>> three primary partitions: one ext4 mounted at /boot, one xfs mounted at
>> /, one xfs mounted at /home. No encryption, no software RAID, no logical
>> volumes, etc.
>>
>> The kernel has a firmware caching mechanism to make sure that no driver
>> needs to load firmware from disk during the resume process. Because
>> that's unreliable. See this bit of the documentation: [1]
>>
>> This is how it works: when the driver's probe callback calls
>> request_firmware, that function adds the firmware file's name in a
>> devres in your 'struct device'. When you suspend the system, the kernel
>> calls fw_pm_notify [2], which goes through all the 'struct device's and
>> looks for firmware file names previously added by request_firmware, and
>> loads into memory all the firmware files it finds. When you resume the
>> system, all calls to request_firmware ought to find the firmware files
>> already loaded in memory. After resuming, the kernel calls fw_pm_notify
>> again to release the cached firmware files (with some delay).
>>
>> This caching mechanism currently doesn't always work for your driver
>> because your driver doesn't always call request_firmware from the probe
>> callback. Because the firmware running on the device sometimes survives
>> a reboot.
> 
> Thanks for the info.  Would it be cleaner to EXPORT fw_add_devm_name()
> and just call that in case driver sees FW is already loaded?  That
> should inform the fw subsystem that we want the image around in case of
> hibernation, but there is no need to load it immediately?
> 

No, I don't believe it's cleaner to expose a private function that you 
don't even really need. Remember that calling request_firmware every 
time your driver's probe and resume functions are called is normal. It's 
the expected behaviour.
