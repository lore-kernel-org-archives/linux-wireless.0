Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:41519 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbeH1KVk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 06:21:40 -0400
Received: by mail-oi0-f66.google.com with SMTP id k12-v6so866776oiw.8
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2018 23:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <CABCw=ciXSrxNumPtk_W+aso9eDbhjennsKT6VFq2va=hej7jKA@mail.gmail.com>
 <d2aafbe259d10d849aa0710530b328f9eae4ecf2.camel@coelho.fi>
In-Reply-To: <d2aafbe259d10d849aa0710530b328f9eae4ecf2.camel@coelho.fi>
From: =?UTF-8?Q?R=2E_Alejandro_Oquendo_Mu=C3=B1oz?= <rd.qnd.m@gmail.com>
Date: Mon, 27 Aug 2018 22:31:24 -0400
Message-ID: <CABCw=cgX4Q4RzQJ_F_=KNFEt5xqWPiBGkG1XBv_9mfYvVVWz3Q@mail.gmail.com> (sfid-20180828_083135_855475_EBAD868F)
Subject: Re: Support for Killer/Wireless-AC 9260 wireless cards
To: luca@coelho.fi
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2018 at 2:29 AM Luca Coelho <luca@coelho.fi> wrote:
>
> Hi,
>
> On Sun, 2018-07-29 at 22:59 -0400, R. Alejandro Oquendo Mu=C3=B1oz wrote:
> > Hi,
> > Are there any plans to officially support "Killer/Wireless-AC 9260
> > wireless cards" in Linux 4.19?
> > For now this card works using this patch [1] in Manjaro, and also
> > works for Archlinux distro [2].
> >
> > Thanks,
> > Alejandro
> >
> > [1] "Subject: [PATCH] iwlwifi: add killer cards for 9000 series"
> >
> https://gitlab.manjaro.org/packages/core/linux418/blob/master/0001-iwlwif=
i-killer-ac-1550.patch
> > [2] https://bugs.archlinux.org/task/59202
>
> The PCI IDs for the Killer cards were sent upstream and are part of
> 4.18 already, as well as some stable versions.  The commit is this:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D0a5257bc6d89c2ae69b9bf955679cb4f89261874
>
> Please let us know if you still have issues with it.

Hi Luca,
The card generally works fine with 4.18, but sometimes fails and show
an error when resuming from suspend. Removing and adding iwlwifi
solves the problem for now.
Please let me know if you need more information.
Alejandro

$ uname -a
Linux r4 4.18.5-arch1-1-ARCH #1 SMP PREEMPT Fri Aug 24 12:48:58 UTC
2018 x86_64 GNU/Linux

[ 9168.857768] ACPI: button: The lid device is not compliant to SW_LID.
[ 9169.054391] ------------[ cut here ]------------
[ 9169.054392] Timeout waiting for hardware access (CSR_GP_CNTRL 0x0c040008=
)
[ 9169.054409] WARNING: CPU: 8 PID: 4223 at
drivers/net/wireless/intel/iwlwifi/pcie/trans.c:2008
iwl_trans_pcie_grab_nic_access+0x1e1/0x220 [iwlwifi]
[ 9169.054409] Modules linked in: rfcomm fuse nvidia_modeset(PO)
nvidia(PO) ipmi_devintf ipmi_msghandler 8021q mrp ccm joydev mousedev
bnep arc4 snd_hda_codec_hdmi iwlmvm mac80211 intel_rapl
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
snd_hda_codec_realtek snd_hda_codec_generic kvm snd_hda_intel
i2c_algo_bit iwlwifi irqbypass crct10dif_pclmul drm_kms_helper
snd_hda_codec crc32_pclmul dell_wmi iTCO_wdt ghash_clmulni_intel
dell_smbios drm iTCO_vendor_support pcbc btusb snd_hda_core dcdbas
uvcvideo cfg80211 btrtl btbcm alienware_wmi btintel snd_hwdep
videobuf2_vmalloc dell_wmi_descriptor wmi_bmof intel_wmi_thunderbolt
snd_pcm mxm_wmi videobuf2_memops videobuf2_v4l2 bluetooth intel_gtt
videobuf2_common agpgart aesni_intel idma64 aes_x86_64 videodev
crypto_simd cryptd glue_helper intel_lpss_pci
[ 9169.054431]  syscopyarea snd_timer mei_me input_leds sysfillrect
intel_cstate sysimgblt snd ucsi_acpi intel_uncore typec_ucsi alx
ecdh_generic processor_thermal_device media psmouse mei
intel_rapl_perf rfkill mdio fb_sys_fops i2c_i801 led_class soundcore
pcspkr intel_lpss intel_pch_thermal intel_soc_dts_iosf typec rtc_cmos
int3403_thermal battery int340x_thermal_zone ac wmi int3400_thermal
evdev intel_hid pcc_cpufreq acpi_thermal_rel mac_hid sparse_keymap
crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2
fscrypto hid_generic usbhid hid sd_mod ahci xhci_pci libahci xhci_hcd
serio_raw atkbd libata libps2 usbcore crc32c_intel scsi_mod usb_common
i8042 serio
[ 9169.054455] CPU: 8 PID: 4223 Comm: kworker/u24:29 Tainted: P
W  O      4.18.5-arch1-1-ARCH #1
[ 9169.054455] Hardware name: Alienware Alienware 15 R4/Alienware 15
R4, BIOS 1.2.1 05/29/2018
[ 9169.054458] Workqueue: events_unbound async_run_entry_fn
[ 9169.054462] RIP: 0010:iwl_trans_pcie_grab_nic_access+0x1e1/0x220 [iwlwif=
i]
[ 9169.054463] Code: 8b f6 49 8d 55 08 bf 40 01 00 00 e8 b9 c1 81 f5
e9 31 ff ff ff 89 c6 48 c7 c7 28 d6 89 c0 c6 05 52 1a 03 00 01 e8 d9
17 80 f5 <0f> 0b e9 ec fe ff ff 48 8b 7b 30 48 c7 c1 90 d6 89 c0 31 d2
31 f6
[ 9169.054478] RSP: 0000:ffff93ec8260bc08 EFLAGS: 00010086
[ 9169.054479] RAX: 0000000000000000 RBX: ffff8c0b463f0018 RCX: 00000000000=
00002
[ 9169.054480] RDX: 0000000080000002 RSI: ffffffffb6e811ce RDI: 00000000fff=
fffff
[ 9169.054480] RBP: ffff8c0b463f8f10 R08: 00000000bc39adb0 R09: 00000000000=
0003d
[ 9169.054481] R10: 00000000000004c6 R11: 0000000000006afc R12: ffff93ec826=
0bc70
[ 9169.054481] R13: 000000000c040008 R14: ffff93ec85d49000 R15: ffff8c0b403=
ba7f0
[ 9169.054482] FS:  0000000000000000(0000) GS:ffff8c0b4d400000(0000)
knlGS:0000000000000000
[ 9169.054483] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9169.054483] CR2: 0000000000000000 CR3: 000000038920a001 CR4: 00000000003=
606e0
[ 9169.054484] Call Trace:
[ 9169.054490]  iwl_fw_error_dump+0xb38/0x1070 [iwlwifi]
[ 9169.054495]  __iwl_mvm_mac_start+0x2ac/0x2f0 [iwlmvm]
[ 9169.054497]  ? preempt_count_add+0x68/0xa0
[ 9169.054501]  iwl_mvm_mac_start+0x53/0x120 [iwlmvm]
[ 9169.054502]  ? __cancel_work_timer+0x105/0x190
[ 9169.054512]  drv_start+0x3e/0x130 [mac80211]
[ 9169.054522]  ieee80211_reconfig+0x84/0x1470 [mac80211]
[ 9169.054523]  ? preempt_count_add+0x68/0xa0
[ 9169.054533]  wiphy_resume+0x5f/0x130 [cfg80211]
[ 9169.054539]  ? wiphy_namespace+0x10/0x10 [cfg80211]
[ 9169.054541]  dpm_run_callback+0x59/0x180
[ 9169.054542]  device_resume+0xac/0x1f0
[ 9169.054543]  async_resume+0x19/0x30
[ 9169.054545]  async_run_entry_fn+0x37/0x140
[ 9169.054546]  process_one_work+0x1eb/0x3c0
[ 9169.054547]  worker_thread+0x2d/0x3d0
[ 9169.054548]  ? process_one_work+0x3c0/0x3c0
[ 9169.054550]  kthread+0x112/0x130
[ 9169.054552]  ? kthread_flush_work_fn+0x10/0x10
[ 9169.054554]  ret_from_fork+0x35/0x40
[ 9169.054555] ---[ end trace b117d1f26462321e ]---
[ 9169.054557] iwlwifi 0000:45:00.0: iwlwifi transaction failed,
dumping registers
[ 9169.054558] iwlwifi 0000:45:00.0: iwlwifi device config registers:
[ 9169.055444] iwlwifi 0000:45:00.0: 00000000: 25268086 00100406
02800029 00000010 9db00004 00000000 00000000 00000000
[ 9169.055446] iwlwifi 0000:45:00.0: 00000020: 00000000 00000000
00000000 15501a56 00000000 000000c8 00000000 0000010b
[ 9169.055446] iwlwifi 0000:45:00.0: iwlwifi device memory mapped registers=
:
[ 9169.055603] iwlwifi 0000:45:00.0: 00000000: 00880000 00000000
00000000 00000000 00000000 00000000 00027e1f 00000000
[ 9169.055604] iwlwifi 0000:45:00.0: 00000020: 00000011 0c040008
00000321 d55555d5 d55555d5 d55555d5 80008040 001f0042
[ 9169.055655] iwlwifi 0000:45:00.0: iwlwifi device AER capability structur=
e:
[ 9169.055728] iwlwifi 0000:45:00.0: 00000000: 14c10001 00000000
00000000 00462031 00000000 00002000 00000000 00000000
[ 9169.055728] iwlwifi 0000:45:00.0: 00000020: 00000000 00000000 00000000
[ 9169.055729] iwlwifi 0000:45:00.0: iwlwifi parent port
(0000:00:1d.7) config registers:
[ 9169.055765] iwlwifi 0000:00:1d.7: 00000000: a3378086 00100407
060400f0 00810010 00000000 00000000 00454500 000000f0
[ 9169.055766] iwlwifi 0000:00:1d.7: 00000020: 9db09db0 0001fff1
00000000 00000000 00000000 00000040 00000000 0010040b
[ 9169.055769] iwlwifi 0000:45:00.0: iwlwifi root port (0000:00:1d.7)
AER cap structure:
[ 9169.055779] iwlwifi 0000:00:1d.7: 00000000: 14010001 00000000
00010000 00060011 00000000 00002000 00000000 00000000
[ 9169.055780] iwlwifi 0000:00:1d.7: 00000020: 00000000 00000000
00000000 00000000 00000000 00000000
[ 9169.153147] usb 1-14: reset full-speed USB device number 4 using xhci_hc=
d
[ 9169.416520] usb 1-7: reset high-speed USB device number 3 using xhci_hcd
[ 9170.457761] WARNING: CPU: 1 PID: 4223 at
drivers/net/wireless/intel/iwlwifi/mvm/sta.c:96
iwl_mvm_find_free_sta_id+0x45/0x50 [iwlmvm]
[ 9170.457765] Modules linked in: rfcomm fuse nvidia_modeset(PO)
nvidia(PO) ipmi_devintf ipmi_msghandler 8021q mrp ccm joydev mousedev
bnep arc4 snd_hda_codec_hdmi iwlmvm mac80211 intel_rapl
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
snd_hda_codec_realtek snd_hda_codec_generic kvm snd_hda_intel
i2c_algo_bit iwlwifi irqbypass crct10dif_pclmul drm_kms_helper
snd_hda_codec crc32_pclmul dell_wmi iTCO_wdt ghash_clmulni_intel
dell_smbios drm iTCO_vendor_support pcbc btusb snd_hda_core dcdbas
uvcvideo cfg80211 btrtl btbcm alienware_wmi btintel snd_hwdep
videobuf2_vmalloc dell_wmi_descriptor wmi_bmof intel_wmi_thunderbolt
snd_pcm mxm_wmi videobuf2_memops videobuf2_v4l2 bluetooth intel_gtt
videobuf2_common agpgart aesni_intel idma64 aes_x86_64 videodev
crypto_simd cryptd glue_helper intel_lpss_pci
[ 9170.457858]  syscopyarea snd_timer mei_me input_leds sysfillrect
intel_cstate sysimgblt snd ucsi_acpi intel_uncore typec_ucsi alx
ecdh_generic processor_thermal_device media psmouse mei
intel_rapl_perf rfkill mdio fb_sys_fops i2c_i801 led_class soundcore
pcspkr intel_lpss intel_pch_thermal intel_soc_dts_iosf typec rtc_cmos
int3403_thermal battery int340x_thermal_zone ac wmi int3400_thermal
evdev intel_hid pcc_cpufreq acpi_thermal_rel mac_hid sparse_keymap
crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2
fscrypto hid_generic usbhid hid sd_mod ahci xhci_pci libahci xhci_hcd
serio_raw atkbd libata libps2 usbcore crc32c_intel scsi_mod usb_common
i8042 serio
[ 9170.457954] CPU: 1 PID: 4223 Comm: kworker/u24:29 Tainted: P
W  O      4.18.5-arch1-1-ARCH #1
[ 9170.457957] Hardware name: Alienware Alienware 15 R4/Alienware 15
R4, BIOS 1.2.1 05/29/2018
[ 9170.457968] Workqueue: events_unbound async_run_entry_fn
[ 9170.457991] RIP: 0010:iwl_mvm_find_free_sta_id+0x45/0x50 [iwlmvm]
[ 9170.457993] Code: b6 f6 48 89 f2 89 c8 48 d3 ea 48 85 d2 75 0b 48
83 bc cf 70 18 00 00 00 74 0f 48 83 c1 01 48 83 f9 10 75 de b8 ff 00
00 00 c3 <0f> 0b eb c7 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 41 89 c8
31 ed
[ 9170.458074] RSP: 0000:ffff93ec8260bbe8 EFLAGS: 00010202
[ 9170.458078] RAX: 0000000000000110 RBX: ffff8c0b403baee4 RCX: 00000000000=
00000
[ 9170.458081] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8c0b403=
b9528
[ 9170.458083] RBP: ffff8c0b403b9528 R08: 0000000000000004 R09: 00000000000=
00000
[ 9170.458086] R10: 0000000000000000 R11: ffff8c0b4d260a68 R12: 00000000000=
00004
[ 9170.458088] R13: 0000000000000002 R14: ffff8c0b403ba7f0 R15: ffffffffb6e=
dc00f
[ 9170.458092] FS:  0000000000000000(0000) GS:ffff8c0b4d240000(0000)
knlGS:0000000000000000
[ 9170.458095] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9170.458098] CR2: 0000000000000000 CR3: 000000038920a001 CR4: 00000000003=
606e0
[ 9170.458100] Call Trace:
[ 9170.458126]  iwl_mvm_allocate_int_sta+0x56/0x70 [iwlmvm]
[ 9170.458148]  iwl_mvm_add_aux_sta+0x34/0xe0 [iwlmvm]
[ 9170.458164]  iwl_mvm_up+0x330/0x9b0 [iwlmvm]
[ 9170.458216]  ? __iterate_interfaces+0x72/0x110 [mac80211]
[ 9170.458226]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[ 9170.458270]  ? ieee80211_wake_queues_by_reason+0x83/0xa0 [mac80211]
[ 9170.458288]  __iwl_mvm_mac_start+0x259/0x2f0 [iwlmvm]
[ 9170.458295]  ? preempt_count_add+0x68/0xa0
[ 9170.458311]  iwl_mvm_mac_start+0x53/0x120 [iwlmvm]
[ 9170.458318]  ? __cancel_work_timer+0x105/0x190
[ 9170.458350]  drv_start+0x3e/0x130 [mac80211]
[ 9170.458395]  ieee80211_reconfig+0x84/0x1470 [mac80211]
[ 9170.458402]  ? preempt_count_add+0x68/0xa0
[ 9170.458440]  wiphy_resume+0x5f/0x130 [cfg80211]
[ 9170.458468]  ? wiphy_namespace+0x10/0x10 [cfg80211]
[ 9170.458475]  dpm_run_callback+0x59/0x180
[ 9170.458482]  device_resume+0xac/0x1f0
[ 9170.458488]  async_resume+0x19/0x30
[ 9170.458495]  async_run_entry_fn+0x37/0x140
[ 9170.458501]  process_one_work+0x1eb/0x3c0
[ 9170.458507]  worker_thread+0x2d/0x3d0
[ 9170.458513]  ? process_one_work+0x3c0/0x3c0
[ 9170.458519]  kthread+0x112/0x130
[ 9170.458525]  ? kthread_flush_work_fn+0x10/0x10
[ 9170.458533]  ret_from_fork+0x35/0x40
[ 9170.458540] ---[ end trace b117d1f26462321f ]---


>
> --
> Cheers,
> Luca.
>


--=20
             _
 _ __ __|  |       ___
|  '__/  _` |      /  _  \
|  |  |  (_|  |     |  (_)  |
|_|   \__,_|___ \___/
            |_____|
l.u. #425157
