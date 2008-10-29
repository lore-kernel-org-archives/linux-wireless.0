Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:16419 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJ2Uxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 16:53:30 -0400
Received: by ey-out-2122.google.com with SMTP id 6so94647eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 13:53:28 -0700 (PDT)
Message-ID: <4908CD44.8070503@gmail.com> (sfid-20081029_215335_503343_485EFA95)
Date: Wed, 29 Oct 2008 20:53:24 +0000
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Dave <kilroyd@googlemail.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net,
	linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [Orinoco-devel] 2.6.28-rc2: new PCMCIA device instance after
 resume - orinoco can't download firmware
References: <200810282219.51492.arvidjaar@mail.ru> <200810291819.20848.arvidjaar@mail.ru> <4908B03C.400@gmail.com> <200810292143.06027.rjw@sisk.pl>
In-Reply-To: <200810292143.06027.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
> On Wednesday, 29 of October 2008, Dave wrote:
>> Andrey Borzenkov wrote:
>>> On Wednesday 29 October 2008, Rafael J. Wysocki wrote:
>>>>> Do you have any idea what could it be? Original message is here:
>>>>> http://marc.info/?l=linux-wireless&m=122522165719760&w=2
>>>> This probably is a result of the fact that we don't include firmware blobs
>>>> into modular drivers any more.  Please try to compile your driver directly
>>>> into the kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
>>>>
>>>> If this helps, we'll know what the problem is.
>>>>
>>> Ehh ... you miss the point. The problem is NOT missing firmware (I have
>>> already been running with external firmware just fine in 2.6.27). The
>>> problem is that during resume instead of simply resume *existing*
>>> device/driver instance PCMCIA suddenly decides to re-discover the *same*
>>> device yet another again.
>>>
>>> bisecting will
>>> take ages here. I need some advice which options to turn on.
>> I attempted to bisect, but ran into problems. As an alternative, I added
>> a WARN_ON(err) immediately after the request_firmware call to get a
>> stack dump:
>>
>> orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
>> ------------[ cut here ]------------
>> WARNING: at
>> /usr/src/linux-current/wireless-testing/drivers/net/wireless/orinoco.c:495
>> orinoco_dl_firmware+0xbb/0x1ce [orinoco]()
>> Modules linked in: orinoco_cs orinoco hermes_dld hermes michael_mic
>> aty128fb snd_maestro3 [last unloaded: hermes]
>> Pid: 22157, comm: bash Not tainted 2.6.28-rc2-wl #41
>> Call Trace:
>>  [<c0117a8c>] warn_on_slowpath+0x3e/0x57
>>  [<c019578a>] release_sysfs_dirent+0x50/0x60
>>  [<c0195b3d>] sysfs_addrm_finish+0x73/0x78
>>  [<c0195d03>] remove_dir+0x21/0x27
>>  [<c02a8901>] fw_dev_release+0x15/0x1d
>>  [<c022cfbe>] kobject_release+0x0/0x5
>>  [<c022d68b>] kref_put+0x3f/0x4c
>>  [<c02a8c7d>] _request_firmware+0x176/0x1bd
>>  [<d1083381>] orinoco_dl_firmware+0xbb/0x1ce [orinoco]
>>  [<d10836d0>] orinoco_download+0x1f/0x30 [orinoco]
>>  [<d1086b39>] orinoco_init+0x63/0x4aa [orinoco]
>>  [<c0362ee8>] __dev_get_by_name+0x18/0x72
>>  [<c03632ed>] __dev_alloc_name+0x110/0x128
>>  [<c03660e5>] netdev_init_queue_locks+0x29/0x41
>>  [<c03661e6>] register_netdevice+0x60/0x1d7
>>  [<c036638c>] register_netdev+0x2f/0x3b
>>  [<d10912a0>] orinoco_cs_config+0xe1/0x174 [orinoco_cs]
>>  [<c02ecdda>] pcmcia_device_probe+0xfa/0x144
>>  [<c0196200>] sysfs_do_create_link+0x3c/0x10f
>>  [<c02a559e>] __device_attach+0x0/0x5
>>  [<c02a54d9>] really_probe+0x70/0xea
>>  [<c02a5596>] driver_probe_device+0x34/0x3c
>>  [<c02a4a53>] bus_for_each_drv+0x38/0x59
>>  [<c02a55ee>] device_attach+0x4b/0x5e
>>  [<c02a559e>] __device_attach+0x0/0x5
>>  [<c02a4c00>] bus_attach_device+0x21/0x4f
>>  [<c02a3955>] device_add+0x147/0x272
>>  [<c02ed29b>] pcmcia_device_add+0x1ca/0x253
>>  [<c02ed3a1>] pcmcia_card_add+0x7d/0x8a       <----- ??
>>  [<c0112185>] dequeue_task_fair+0xf/0x10
>>  [<c0101c8d>] __switch_to+0x1d/0x139
>>  [<c011407b>] finish_task_switch+0x22/0x66
>>  [<c03e18fb>] __sched_text_start+0x2d3/0x2ec
>>  [<c022cf6d>] kobject_get+0xf/0x13
>>  [<c02a3a9e>] get_device+0xe/0x14
>>  [<c02e928a>] pcmcia_get_socket+0xe/0x7e
>>  [<c02edf0e>] ds_event+0x77/0x94
>>  [<c02e96b1>] send_event+0x84/0x9d
>>  [<c02e9bee>] socket_resume+0xa1/0xb5
>>  [<c02e9255>] pcmcia_socket_dev_resume+0x49/0x70
>>  [<c0238d42>] pci_legacy_resume+0x13/0x1a
>>  [<c0238e81>] pci_pm_resume+0x42/0x46
>>  [<c02a7887>] pm_op+0x2b/0x48
>>  [<c02a7a42>] resume_device+0x2e/0xa8
>>  [<c02a7b21>] dpm_resume+0x65/0xfc
>>  [<c02a7cf1>] device_resume+0x8/0x10
>>  [<c0135173>] suspend_devices_and_enter+0x72/0xa1
>>  [<c013521d>] enter_state+0x62/0x7a
>>  [<c013533f>] state_store+0x9f/0xb4
>>  [<c01352a0>] state_store+0x0/0xb4
>>  [<c022d0b8>] kobj_attr_store+0x18/0x1c
>>  [<c0194cf1>] flush_write_buffer+0x38/0x4c
>>  [<c0194d37>] sysfs_write_file+0x32/0x51
>>  [<c015eb9b>] vfs_write+0x81/0xf3
>>  [<c015ecab>] sys_write+0x3c/0x62
>>  [<c0102ced>] sysenter_do_call+0x12/0x21
>> ---[ end trace 596cca76ed6aae6a ]---
>> eth1: Cannot find firmware agere_sta_fw.bin
>>
>> ?? Is that supposed to happen on resume?
> 
> Hm, what exactly do you mean?

I mean that from pcmcia_socket_dev_resume (shortly after resuming from
STR) we somehow get to pcmcia_card_add which results in a call to
orinoco_cs_config and orinoco_init.

Basically we have a completely new device. orinoco_init calls
request_firmware which fails under resume (because it tries to get
firmware from userspace), but is OK on normal startup. Andreys code to
load firmware after resume will only work when we call orinoco_cs_resume
for the device that got suspended, not if we see a new device.

Looking at the pcmcia code it looks like ds_event is getting a
CS_EVENT_CARD_INSERTION event. Should we be processing that event ?

Has suspend/resume of pcmcia devices changed so that they are detached
on suspend and enumerated on resume?


Regards,

Dave.

PS. compiling the firmware blob into the kernel does allow the device to
correctly restart. However it does so via orinoco_init, not
orinoco_cs_resume.
