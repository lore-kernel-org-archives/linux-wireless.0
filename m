Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:54000 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022Ab0GKRxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 13:53:47 -0400
Received: from Philip-Prindevilles-MacBook-Pro.local ([192.168.1.114])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.4/8.14.4) with ESMTP id o6BHrlfN021977
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 11:53:47 -0600
Message-ID: <4C3A052B.4040602@redfish-solutions.com>
Date: Sun, 11 Jul 2010 11:53:47 -0600
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Ath5k breaking in ath5k_pci_suspend_compat going on 2 weeks
References: <4C3926F7.5070606@redfish-solutions.com> <4C395F03.40200@redfish-solutions.com>
In-Reply-To: <4C395F03.40200@redfish-solutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest revision that I could build was 2010-06-02, and that panics 
the box:

ompat-wireless backport release: compat-wireles-20100526-1-g9a89e44
Backport based on linux-next.git next-20100526
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
ath5k 0000:00:11.0: registered as 'phy0'
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<00000000>]
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: ath5k(+) mac80211 ath cfg80211 rfkill_backport compat dahdi s
ha512_generic sha256_generic deflate zlib_deflate arc4 ecb sha1_generic blowfish
  des_generic cbc cryptosoft cryptodev(P) ocf(P) geodewdt geode_rng geode_aes cry
pto_blkcipher via_rhine rtc cs5535_gpio

Pid: 1438, comm: modprobe Tainted: P          (2.6.27.48-astlinux #1)
EIP: 0060:[<00000000>] EFLAGS: 00010286 CPU: 0
EIP is at 0x0
EAX: cea68000 EBX: cf9b3490 ECX: 00000000 EDX: 00000000
ESI: cea68154 EDI: cea83be0 EBP: cea68000 ESP: cea87cec
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process modprobe (pid: 1438, ti=cea86000 task=cf994460 task.ti=cea86000)
Stack: c0259ceb cf9b3400 cea87cf4 cea87cf4 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 000005dc cea68000 cea83be0 ffffffff 00000010
        c025a0e2 00000000 00000000 ffffffff 00000000 c034e8cc ffffffff 00000000
Call Trace:
  [<c0259ceb>] rtnl_fill_ifinfo+0x2a8/0x45e
  [<c025a0e2>] rtmsg_ifinfo+0x40/0xa7
  [<c025a17e>] rtnetlink_event+0x35/0x38
  [<c02aa0ab>] notifier_call_chain+0x2a/0x47
  [<c012716e>] raw_notifier_call_chain+0x9/0xc
  [<c0252ee8>] register_netdevice+0x228/0x25d
  [<d09449d3>] ieee80211_if_add+0x60e/0x704 [mac80211]
  [<c015fff4>] alloc_inode+0xda/0x150
  [<c01b8bd8>] debugfs_mknod+0x10d/0x119
  [<c0115cfb>] printk+0x14/0x18
  [<d09453eb>] ieee80211_init_rate_ctrl_alg+0x18b/0x1b4 [mac80211]
  [<d093992a>] ieee80211_register_hw+0x28c/0x320 [mac80211]
  [<d08c6742>] ath5k_pci_probe+0xb03/0xde2 [ath5k]
  [<c01da23c>] pci_device_probe+0x36/0x55
  [<c01f7f8b>] driver_probe_device+0x9c/0x112
  [<c01f8038>] __driver_attach+0x37/0x55
  [<c01f7911>] bus_for_each_dev+0x31/0x52
  [<c01f7e3f>] driver_attach+0x11/0x13
  [<c01f8001>] __driver_attach+0x0/0x55
  [<c01f7c5d>] bus_add_driver+0x91/0x194
  [<d086e000>] init_ath5k_pci+0x0/0x2f [ath5k]
  [<c01f8239>] driver_register+0x6d/0xc2
  [<d086e000>] init_ath5k_pci+0x0/0x2f [ath5k]
  [<c01da2fe>] __pci_register_driver+0x35/0x60
  [<d086e01a>] init_ath5k_pci+0x1a/0x2f [ath5k]
  [<c0101037>] _stext+0x37/0xfb
  [<c013068d>] sys_init_module+0x87/0x176
  [<c01037e6>] syscall_call+0x7/0xb
  =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:cea87cec
---[ end trace d08207f47ddcaa64 ]---
/etc/runlevels/default/S02wifi: line 11:  1438 Segmentation fault      modprobe
$i
Configuring WiFi cards...





On 7/11/10 12:04 AM, Philip Prindeville wrote:
> I take it back... it seems to go back at least to 2010-06-12.
>
>
> On 7/10/10 8:05 PM, Philip Prindeville wrote:
>> This still seems to be broken, a couple of weeks later:
>>
>>   CC [M]  
>> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/attach.o 
>>
>>   CC [M]  
>> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.o 
>>
>> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.c:243: 
>> error: 'ath5k_pci_suspend_compat' undeclared here (not in a function)
>> /home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.c:244: 
>> error: 'ath5k_pci_resume_compat' undeclared here (not in a function)
>> make[6]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k/base.o] 
>> Error 1
>> make[5]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath/ath5k] 
>> Error 2
>> make[4]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless/ath] 
>> Error 2
>> make[3]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-06-26/drivers/net/wireless] 
>> Error 2
>>
>>
>> and from today's tarball:
>>
>>
>>   CC [M]  
>> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.o 
>>
>> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.c:243: 
>> error: 'ath5k_pci_suspend_compat' undeclared here (not in a function)
>> /home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.c:244: 
>> error: 'ath5k_pci_resume_compat' undeclared here (not in a function)
>> make[6]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k/base.o] 
>> Error 1
>> make[5]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath/ath5k] 
>> Error 2
>> make[4]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless/ath] 
>> Error 2
>> make[3]: *** 
>> [/home/philipp/kernel/build_i586/compat-wireless-2010-07-10/drivers/net/wireless] 
>> Error 2
>>
>>
>> Can someone please have a look and fix their regression?
>>
>> Thanks,
>>
>> -Philip
>

