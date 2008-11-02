Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60705 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbYKBXQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 18:16:40 -0500
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <35B834EA-39BA-4A3E-B636-DC371469BD6B@holtmann.org> (sfid-20081103_001650_287135_3792CBF1)
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1ba2fa240811011314i182695e6wc577a2559fab64b6@mail.gmail.com>
Content-Type: multipart/mixed; boundary=Apple-Mail-2-399972278
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: Still 4965 issues with wireless-testing
Date: Mon, 3 Nov 2008 00:16:31 +0100
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com> <DAD31980-B029-46D4-A687-9B0426899853@holtmann.org> <1ba2fa240810310652t351b0b77k819a7e03659503eb@mail.gmail.com> <BF4BAA7D-FEBC-40F7-AE07-D6BBD31A2A0B@holtmann.org> <1ba2fa240810311409i5203bcccu2b944dcc505deb30@mail.gmail.com> <C202FD8E-EB1E-417D-8086-7ADFBC72A1D3@holtmann.org> <1ba2fa240810311635t69165473hef0ef64bf4426d3a@mail.gmail.com> <FB3E29C0-9493-4A1C-B725-734C100ADF3D@holtmann.org> <1ba2fa240811011314i182695e6wc577a2559fab64b6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Apple-Mail-2-399972278
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hi Tomas,

>>>>>>>>> so besides the point that the Ubuntu 8.10 kernel has a  
>>>>>>>>> broken driver
>>>>>>>>> for
>>>>>>>>> the Intel 4965 cards which will crash my X61 after less than  
>>>>>>>>> one
>>>>>>>>> minute
>>>>>>>>> uptime when it connects to my access point, I have my dmesg  
>>>>>>>>> full
>>>>>>>>> with
>>>>>>>>> warnings from the latest wireless-testing kernel.
>>>>>>>>>
>>>>>>>>> I know that we have discussed this before and Johannes'  
>>>>>>>>> patch at
>>>>>>>>> least
>>>>>>>>> turns it into warnings instead of killing my system  
>>>>>>>>> completely, but
>>>>>>>>> I
>>>>>>>>> am
>>>>>>>>> still surprised why this hasn't been fixed.
>>>>>>>>
>>>>>>>> so this becomes more and more annoying. I get this WARN_ON now
>>>>>>>> multiple
>>>>>>>> times pre minute. Only the first few minutes after loading the
>>>>>>>> firmware
>>>>>>>> everything is okay and then it keeps filling my dmesg. And on  
>>>>>>>> top of
>>>>>>>> that, I
>>>>>>>> now see these:
>>>>>>>>
>>>>>>>> __ratelimit: 1189 callbacks suppressed
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> __ratelimit: 57695 callbacks suppressed
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> __ratelimit: 3345 callbacks suppressed
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>>>
>>>>>>>> What is going on here? This is a normal setup and nothing  
>>>>>>>> fancy.
>>>>>>>> Access
>>>>>>>> point is N-Capable from D-Link btw.
>>>>>>>
>>>>>>>
>>>>>>> I have D-Link too I don't see this. What kernel version is  
>>>>>>> this? Is
>>>>>>> this your ubuntu version or wireless-testing?
>>>>>>> Any more data you can provide (.config. slabinfo)
>>>>>>
>>>>>> this is from wireless-testing. The Ubuntu 2.6.27 kernel is  
>>>>>> totally
>>>>>> broken.
>>>>>> It will crash the kernel since we are missing the patch to turn  
>>>>>> this
>>>>>> into
>>>>>> a
>>>>>> warning :)
>>>>>>
>>>>>> Attached is my config. The slabinfo will follow once the SKB  
>>>>>> errors
>>>>>> come
>>>>>> up
>>>>>> again. It normally takes a few hours before they show. Just  
>>>>>> resumed
>>>>>> that
>>>>>> machine.
>>>>>
>>>>> I've downloaded whole moblin last night over 2.6.27.4, it's a  
>>>>> bit slow
>>>>> because the missing calibrations but it didn't crashed.
>>>>>
>>>>> I will test your config, your machine is T61  am I right?
>>>>
>>>> I have a X61 and running the 64-bit version of kernel and  
>>>> userspace.
>>>
>>> I found in sky2 driver comment
>>>
>>> * The buffer returned from netdev_alloc_skb is
>>> * aligned except if slab debugging is enabled
>>>
>>> Since you have slub debug enabled, can you run this debug patch on
>>> your system (might be withe space broken, I've  just pasted in)
>>
>> I applied your patch and ran the latest wireless-testing for over  
>> 24 hours
>> now. The iwl_tx_cmd_complete issues shows up on a regular basis and  
>> the
>> allocate SKB buffers, too. However it didn't trigger the extra  
>> WARN_ON you
>> added.
>
> Thanks for the report, will try different directions.

I did suspended this system after two days and resummed it today and  
it gets worse and worse. This really needs fixing:

iwlagn: Can not allocate SKB buffers
__ratelimit: 1 callbacks suppressed
__ratelimit: 5965 callbacks suppressed
__ratelimit: 1993 callbacks suppressed
__ratelimit: 2405 callbacks suppressed
__ratelimit: 839 callbacks suppressed
__ratelimit: 2406 callbacks suppressed
__ratelimit: 566 callbacks suppressed

I am attaching the full dmesg out and you can look through it by  
yourself, but whatever happens here is just plain wrong.

Regards

Marcel

--Apple-Mail-2-399972278
Content-Disposition: attachment;
	filename=dmesg.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="dmesg.txt"
Content-Transfer-Encoding: 7bit

] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c00>] ? trace_hardirqs_off_caller+0x8/0x9f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff8047a486>] ? _spin_unlock+0x26/0x2a
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff8047a486>] ? _spin_unlock+0x26/0x2a
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a709>] ? _spin_lock_irqsave+0x19/0x70
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80254200>] ? trace_hardirqs_on_caller+0x4d/0x12d
 [<ffffffff80239132>] ? local_bh_enable+0xc9/0xcf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
mapiprofile[17091]: segfault at 0 ip 00007f247c4df6b0 sp 00007fff86202d38 error 4 in libc-2.8.90.so[7f247c45d000+169000]
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c00>] ? trace_hardirqs_off_caller+0x8/0x9f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff8047a709>] ? _spin_lock_irqsave+0x19/0x70
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff8047a486>] ? _spin_unlock+0x26/0x2a
 [<ffffffff80250046>] ? tick_dev_program_event+0x37/0xa5
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff8047a486>] ? _spin_unlock+0x26/0x2a
 [<ffffffff8044370a>] ? tcp_v4_rcv+0x469/0x6c5
 [<ffffffff80429d8d>] ? ip_local_deliver_finish+0x183/0x1be
 [<ffffffff80429c43>] ? ip_local_deliver_finish+0x39/0x1be
 [<ffffffff804098d7>] ? __kfree_skb+0x7c/0x80
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff8042995a>] ? ip_rcv_finish+0x2f2/0x30e
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80474105>] ? start_secondary+0x181/0x185
---[ end trace e89aea7dee6be77c ]---
iwlagn: Can not allocate SKB buffers
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level CPU
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level CPU
   groups: 0-1
PM: Syncing filesystems ... done.
Freezing user space processes ... <6>usb 2-1: USB disconnect, address 2
(elapsed 0.04 seconds) done.
Freezing remaining freezable tasks ... <3>btusb_intr_complete: hci0 urb ffff880078419948 failed to resubmit (19)
btusb_send_frame: hci0 urb ffff880030d40d68 submission failed
(elapsed 0.13 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
pci 0000:00:02.0: power state changed by ACPI to D3
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
sdhci-pci 0000:05:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
iwlagn 0000:03:00.0: PCI INT A disabled
ahci 0000:00:1f.2: PCI INT B disabled
ata5: port disabled. ignoring.
ata_piix 0000:00:1f.1: PCI INT C disabled
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
ehci_hcd 0000:00:1a.7: PCI INT C disabled
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
kvm: disabling virtualization on CPU1
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4389.25 BogoMIPS (lpj=8778504)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
kvm: enabling virtualization on CPU1
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level CPU
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level CPU
   groups: 0-1
CPU1 is up
ACPI: Waking up from system sleep state S3
ACPI: EC: non-query interrupt received, switching to interrupt mode
pci 0000:00:02.0: power state changed by ACPI to D0
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1a.7: setting latency timer to 64
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20002020, writing 0x2020)
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.1: setting latency timer to 64
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb6: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
ata5: port disabled. ignoring.
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: setting latency timer to 64
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
firewire_ohci 0000:05:00.1: restoring config space at offset 0x4 (was 0x0, writing 0xd7efe800)
firewire_ohci 0000:05:00.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
firewire_ohci 0000:05:00.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
sdhci-pci 0000:05:00.2: restoring config space at offset 0x4 (was 0x0, writing 0xd7efe400)
sdhci-pci 0000:05:00.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
sdhci-pci 0000:05:00.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
sdhci-pci 0000:05:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
pci 0000:00:02.0: power state changed by ACPI to D0
pci 0000:00:02.0: setting latency timer to 64
Restarting tasks ... done.
wlan0: deauthenticated (Reason: 6)
wlan0: direct probe to AP 00:1c:f0:62:88:5b try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticated
wlan0: associate with AP 00:1c:f0:62:88:5b
wlan0: RX ReassocResp from 00:1c:f0:62:88:5b (capab=0x431 status=0 aid=4)
wlan0: associated
------------[ cut here ]------------
WARNING: at net/mac80211/main.c:227 ieee80211_hw_config+0x9c/0xa8 [mac80211]()
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 3853, comm: NetworkManager Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 [<ffffffff80233feb>] warn_on_slowpath+0x58/0x7d
 [<ffffffff80478d00>] ? mutex_lock_killable_nested+0x2ce/0x307
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff802541d2>] ? trace_hardirqs_on_caller+0x1f/0x12d
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80478e52>] ? mutex_unlock+0x9/0xb
 [<ffffffffa0159132>] ? iwl_mac_config+0x221/0x241 [iwlagn]
 [<ffffffffa00ee22c>] ieee80211_hw_config+0x9c/0xa8 [mac80211]
 [<ffffffffa00f5382>] ieee80211_set_disassoc+0x195/0x1af [mac80211]
 [<ffffffffa00f51ed>] ? ieee80211_set_disassoc+0x0/0x1af [mac80211]
 [<ffffffffa00f549c>] ieee80211_sta_req_auth+0x49/0x6b [mac80211]
 [<ffffffffa00ef154>] ieee80211_ioctl_siwessid+0xcd/0xd9 [mac80211]
 [<ffffffff80463040>] ioctl_standard_iw_point+0x16d/0x1fc
 [<ffffffffa00ef087>] ? ieee80211_ioctl_siwessid+0x0/0xd9 [mac80211]
 [<ffffffff80419191>] ? rtnl_lock+0x12/0x14
 [<ffffffff80419191>] ? rtnl_lock+0x12/0x14
 [<ffffffff80463164>] ioctl_standard_call+0x95/0xb4
 [<ffffffff804632ae>] wext_ioctl_dispatch+0x9a/0x16e
 [<ffffffff80462e5a>] ? ioctl_private_call+0x0/0x79
 [<ffffffff804630cf>] ? ioctl_standard_call+0x0/0xb4
 [<ffffffff8046346d>] wext_handle_ioctl+0x39/0x6f
 [<ffffffff80411e6e>] dev_ioctl+0x610/0x639
 [<ffffffff803115ad>] ? avc_has_perm+0x4e/0x60
 [<ffffffff80313016>] ? inode_has_perm+0x5b/0x61
 [<ffffffff80402bb7>] sock_ioctl+0x203/0x212
 [<ffffffff802ad77c>] vfs_ioctl+0x2a/0x78
 [<ffffffff802adb73>] do_vfs_ioctl+0x3a9/0x3db
 [<ffffffff802adbfa>] sys_ioctl+0x55/0x77
 [<ffffffff8020b3bb>] system_call_fastpath+0x16/0x1b
---[ end trace e89aea7dee6be77c ]---
usb 2-1: new full speed USB device using uhci_hcd and address 3
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: BCM2045B
usb 2-1: Manufacturer: Broadcom Corp
iwlagn 0000:03:00.0: PCI INT A disabled
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
wlan0: direct probe to AP 00:11:95:2c:3b:9c try 1
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:11:95:2c:3b:9c try 1
wlan0: direct probe to AP 00:11:95:2c:3b:9c try 2
wlan0: direct probe to AP 00:11:95:2c:3b:9c try 3
wlan0: direct probe to AP 00:11:95:2c:3b:9c timed out
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticated
wlan0: associate with AP 00:1c:f0:62:88:5b
wlan0: RX AssocResp from 00:1c:f0:62:88:5b (capab=0x431 status=0 aid=4)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8024c19a>] ? cpu_clock+0x2d/0x3f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
wlan0 direct probe responded
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticated
wlan0: associate with AP 00:1c:f0:62:88:5b
wlan0: RX ReassocResp from 00:1c:f0:62:88:5b (capab=0x431 status=0 aid=4)
wlan0: associated
wlan0: deauthenticated (Reason: 0)
wlan0: direct probe to AP 00:1c:f0:62:88:5b try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticated
wlan0: associate with AP 00:1c:f0:62:88:5b
wlan0: RX ReassocResp from 00:1c:f0:62:88:5b (capab=0x431 status=0 aid=4)
wlan0: associated
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticated
wlan0: associate with AP 00:1c:f0:62:88:5b
wlan0: RX ReassocResp from 00:1c:f0:62:88:5b (capab=0x431 status=0 aid=4)
wlan0: associated
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff8029c937>] ? check_object+0x159/0x208
 [<ffffffff8047a709>] ? _spin_lock_irqsave+0x19/0x70
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff802541d2>] ? trace_hardirqs_on_caller+0x1f/0x12d
 [<ffffffff8024c6c0>] ? getnstimeofday+0x3a/0x96
 [<ffffffff8021a0c3>] ? lapic_next_event+0x15/0x19
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
__ratelimit: 1 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c00>] ? trace_hardirqs_off_caller+0x8/0x9f
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024a8e7>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8024c6c0>] ? getnstimeofday+0x3a/0x96
 [<ffffffff8047a486>] ? _spin_unlock+0x26/0x2a
 [<ffffffff8026cb32>] ? handle_IRQ_event+0x49/0x55
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 22741, comm: rm Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff802207e3>] do_page_fault+0x37f/0x848
 [<ffffffff8028cd65>] ? find_vma+0x58/0x5a
 [<ffffffff8022081d>] do_page_fault+0x3b9/0x848
 [<ffffffff802aa25c>] ? putname+0x30/0x39
 [<ffffffff8029c937>] ? check_object+0x159/0x208
 [<ffffffff802aa25c>] ? putname+0x30/0x39
 [<ffffffff802541d2>] ? trace_hardirqs_on_caller+0x1f/0x12d
 [<ffffffff8047ac5a>] ? error_sti+0x5/0x1d
 [<ffffffff8047a075>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8047a075>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8047ac72>] error_exit+0x0/0xa9
---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c00>] ? trace_hardirqs_off_caller+0x8/0x9f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8047a709>] ? _spin_lock_irqsave+0x19/0x70
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
__ratelimit: 5965 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
__ratelimit: 1993 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
wlan0: deauthenticated (Reason: 0)
wlan0: direct probe to AP 00:1c:f0:62:88:5b try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticated
wlan0: associate with AP 00:1c:f0:62:88:5b
wlan0: RX ReassocResp from 00:1c:f0:62:88:5b (capab=0x431 status=0 aid=4)
wlan0: associated
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
__ratelimit: 2405 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
__ratelimit: 839 callbacks suppressed
iwlagn: Can not allocate SKB buffers
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 32185, comm: fixdep Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace e89aea7dee6be77c ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8047a451>] ? _spin_unlock_irqrestore+0x38/0x47
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b61d>] ? acpi_idle_enter_bm+0x2ce/0x353
 [<ffffffff8038b613>] ? acpi_idle_enter_bm+0x2c4/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace e89aea7dee6be77c ]---
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi sdhci_pci sdhci iwlagn iwlcore thinkpad_acpi rfkill backlight mmc_core mac80211 led_class nvram firewire_ohci firewire_core sg piix ide_core crc_itu_t cfg80211 yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd evdev ehci_hcd usbcore e1000e unix
Pid: 3013, comm: cc1 Tainted: G        W  2.6.28-rc2-wl #7
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff8022d168>] ? try_to_wake_up+0x260/0x272
 [<ffffffffa0144b14>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa015a201>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa015a512>] iwl_irq_tasklet+0x212/0x2ca [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace e89aea7dee6be77c ]---
__ratelimit: 2406 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
__ratelimit: 566 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers

--Apple-Mail-2-399972278
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-2-399972278--
