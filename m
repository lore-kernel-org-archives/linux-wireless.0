Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:60959 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbZDOOMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 10:12:18 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1224791muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 07:12:16 -0700 (PDT)
Message-ID: <49E5EC66.80408@tuffmail.co.uk> (sfid-20090415_161237_595263_5485D440)
Date: Wed, 15 Apr 2009 15:17:10 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
Subject: BUG in freq_reg_info_regd
References: <9b2b86520904150345r31851012jb6a231e02583038a@mail.gmail.com> <9b2b86520904150358u81dd977g3378ef81d7748355@mail.gmail.com> <20090415130232.GA21411@tuxdriver.com>
In-Reply-To: <20090415130232.GA21411@tuxdriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Apr 15, 2009 at 11:58:39AM +0100, Alan Jenkins wrote:
>   
>> [Corrected Luis address]
>>
>> On 4/15/09, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
>>     
>>> Looking at the code, I think it does need fixing.  There's even a
>>> comment which says "this finds them (or not)" - and if they're not
>>> found, channel_before / channel_after will be unset.
>>>       
>
> I reverted the (HT40-related) patch series that last touched that line.
> Hopefully that resolves that warning.
>
>   
>> Um, also the new "ath" module taints the kernel
>>
>> ath: module 'unspecified' taints kernel.
>>
>> and I get a new BUG in freq_reg_info_regd.  I'll send the full trace
>> as soon as someone reassures it is welcome and wireless-testing is
>> really intended for testing at the current time :-).
>>     
>
> Someone probably wants to see it. :-)
>
> John
>   

Great.  Here it is.  Note "Tainted: P" is probably due to a missing 
MODULE_LICENSE in ath.c; my kernel doesn't rely on any binary blobs.

[    4.108459] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> 
IRQ 18
[    4.108591] ath5k 0000:01:00.0: setting latency timer to 64
[    4.108802] ath5k 0000:01:00.0: registered as 'phy0'
[    4.176459] ath: Country alpha2 being used: 00
[    4.176556] ath: Regpair detected: 0x60
[    4.176679] BUG: unable to handle kernel NULL pointer dereference at 
00000004
[    4.176874] IP: [<dffede2e>] freq_reg_info_regd+0x2a/0xf2 [cfg80211]
[    4.177053] *pdpt = 0000000017451001 *pde = 0000000000000000
[    4.177245] Oops: 0000 [#2]
[    4.177376] last sysfs file: /sys/class/input/input5/modalias
[    4.177477] Modules linked in: ath5k(+) snd_hwdep snd_pcm_oss 
snd_mixer_oss uhci_hcd ehci_hcd mac80211 i2c_i801 led_class ath(P) 
psmouse serio_raw snd_pcm i2c_core pcspkr cfg80211 atl2 intel_agp 
snd_timer snd_page_alloc usbcore agpgart eeepc_laptop video backlight 
output battery rfkill ac processor button evdev thermal fan ata_generic
[    4.179388]
[    4.179475] Pid: 1641, comm: modprobe Tainted: P      D    
(2.6.30-rc1-wleeepc #11) 701
[    4.179615] EIP: 0060:[<dffede2e>] EFLAGS: 00010286 CPU: 0
[    4.179732] EIP is at freq_reg_info_regd+0x2a/0xf2 [cfg80211]
[    4.179834] EAX: 00000000 EBX: df200060 ECX: 00004e20 EDX: e0099524
[    4.179938] ESI: 00000060 EDI: 0024cde0 EBP: de551d70 ESP: de551d50
[    4.180003]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[    4.180003] Process modprobe (pid: 1641, ti=de550000 task=de833000 
task.ti=de550000)
[    4.180003] Stack:
[    4.180003]  00000020 c04079c0 00028020 0000010d c04079bc 00000000 
00000060 df200a20
[    4.180003]  de551dac dffee02a de551d9c e0099524 de8480e4 e0099524 
df200060 df2009c8
[    4.180003]  00000000 00000000 00000000 00000000 00000000 00000060 
de8480e4 de551dc8
[    4.180003] Call Trace:
[    4.180003]  [<dffee02a>] ? wiphy_apply_custom_regulatory+0x7f/0xf4 
[cfg80211]
[    4.180003]  [<e00994b3>] ? ath_regd_init+0x206/0x227 [ath]
[    4.180003]  [<e022eb6a>] ? ath5k_reg_notifier+0x0/0x2a [ath5k]
[    4.180003]  [<e0230cde>] ? ath5k_pci_probe+0xa7c/0xd96 [ath5k]
[    4.180003]  [<c01a5fdb>] ? sysfs_find_dirent+0x16/0x27
[    4.180003]  [<c01feca1>] ? local_pci_probe+0xe/0x10
[    4.180003]  [<c01ff532>] ? pci_device_probe+0x48/0x66
[    4.180003]  [<c02470a9>] ? driver_probe_device+0x7f/0xf2
[    4.180003]  [<c024715f>] ? __driver_attach+0x43/0x5f
[    4.180003]  [<c024675b>] ? bus_for_each_dev+0x39/0x5a
[    4.180003]  [<c0246f7c>] ? driver_attach+0x14/0x16
[    4.180003]  [<c024711c>] ? __driver_attach+0x0/0x5f
[    4.180003]  [<c0246c5f>] ? bus_add_driver+0xd7/0x1e7
[    4.180003]  [<c0247365>] ? driver_register+0x7b/0xd7
[    4.180003]  [<c01185cc>] ? enqueue_entity+0x232/0x23a
[    4.180003]  [<c01ff833>] ? __pci_register_driver+0x32/0x85
[    4.180003]  [<e00c8018>] ? init_ath5k_pci+0x18/0x30 [ath5k]
[    4.180003]  [<c0101131>] ? _stext+0x49/0x10b
[    4.180003]  [<e00c8000>] ? init_ath5k_pci+0x0/0x30 [ath5k]
[    4.180003]  [<c012f3c2>] ? __blocking_notifier_call_chain+0x40/0x4c
[    4.180003]  [<c013a680>] ? sys_init_module+0x87/0x18b
[    4.180003]  [<c0102804>] ? sysenter_do_call+0x12/0x22
[    4.180003] Code: c3 55 89 e5 57 89 d7 56 ba 20 4e 00 00 53 89 c3 83 
ec 14 85 c9 8b 45 0c 0f 44 ca 8b 15 d8 b5 ff df 85 c0 0f 45 d0 a1 dc b5 
ff df <8b> 40 04 83 f8 03 74 26 48 74 23 8b 73 30 85 f6 74 1c 8b 06 d1
[    4.180003] EIP: [<dffede2e>] freq_reg_info_regd+0x2a/0xf2 [cfg80211] 
SS:ESP 0068:de551d50
[    4.180003] CR2: 0000000000000004
[    4.188765] ---[ end trace 4a0acaa650e724da ]---

