Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:35575 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbeESUnt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 May 2018 16:43:49 -0400
Received: by mail-vk0-f68.google.com with SMTP id g72-v6so6808300vke.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 May 2018 13:43:49 -0700 (PDT)
MIME-Version: 1.0
From: Mattias Jernberg <nostrad@gmail.com>
Date: Sat, 19 May 2018 22:43:47 +0200
Message-ID: <CAMZeTPn=oTcbDsYFLg+F4CxopmL1SP0xryC9mAzZPe+cqV5cCA@mail.gmail.com> (sfid-20180519_224354_195174_53578CBA)
Subject: rtl8723be signal strength loss, and possibly a OOPS/BUG
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

With kernel 4.16 I experience a loss in signal strength on rtl8723be,
it is very similar to having the ant_sel parameter wrong (or missing),
iw scan shows only my own access point next to me and with a signal
strength of under -60 rather than above -30.

I bisected this down to 874e837d67d0db179c9771f38fd21df07c703e93 being
the offending commit.

I have also seen three BUGs that might be related. They appear when
setting ant_sel=1

* The first one occurred (both on Debians 4.16.5 kernel and on
mainline 4.17-rc5) when I did modprobe rtl8723be ant_sel=1, after a
modprobe -r rtl8723be.
* The second one when booting with ant_sel=1 in /etc/modprobe.d.
* The third one is when booting
874e837d67d0db179c9771f38fd21df07c703e93 and having ant_sel=1.

Correct (at least on 4.15.0) for this laptop is ant_sel=2.

Thankful for any help
Mattias Jernberg

[  257.359995] list_del corruption. prev->next should be
00000000d2a848bc, but was 00000000d9e846c0
[  257.360020] ------------[ cut here ]------------
[  257.360021] kernel BUG at
/build/linux-hny3SU/linux-4.16.5/lib/list_debug.c:53!
[  257.360026] invalid opcode: 0000 [#1] SMP PTI
[  257.360027] Modules linked in: rtl8723be btcoexist rtl8723_common
rtl_pci rtlwifi mac80211 cfg80211 rfcomm 8021q garp mrp stp llc cmac
snd_hrtimer snd_seq snd_seq_device bnep nls_ascii nls_cp437 vfat fat
snd_soc_skl hp_wmi snd_hda_codec_hdmi intel_rapl wmi_bmof
snd_soc_skl_ipc x86_pkg_temp_thermal intel_powerclamp coretemp
snd_hda_ext_core snd_soc_sst_dsp snd_hda_codec_realtek arc4
snd_soc_sst_ipc kvm_intel snd_hda_codec_generic snd_soc_acpi kvm
snd_soc_core irqbypass snd_compress intel_cstate efi_pstore btusb
snd_hda_intel btrtl btbcm snd_hda_codec btintel snd_hda_core snd_hwdep
intel_uncore snd_pcm intel_rapl_perf bluetooth serio_raw intel_th_gth
snd_timer snd evdev soundcore efivars joydev pcspkr i915 rtsx_pci_ms
iTCO_wdt uvcvideo iTCO_vendor_support memstick intel_th_pci intel_th
videobuf2_vmalloc
[  257.360081]  hid_sensor_accel_3d hid_sensor_rotation
videobuf2_memops drbg hid_sensor_magn_3d hid_sensor_incl_3d
videobuf2_v4l2 hid_sensor_gyro_3d drm_kms_helper hid_sensor_trigger
videobuf2_common ansi_cprng hid_sensor_iio_common
industrialio_triggered_buffer sg kfifo_buf videodev ecdh_generic
mei_me hid_multitouch industrialio drm media rfkill idma64
i2c_algo_bit shpchp mei processor_thermal_device intel_lpss_pci
intel_lpss intel_soc_dts_iosf intel_pch_thermal tpm_crb tpm_tis
intel_vbtn int3403_thermal wmi tpm_tis_core sparse_keymap
soc_button_array battery ac int340x_thermal_zone tpm hp_wireless video
rng_core int3400_thermal acpi_pad acpi_thermal_rel button sunrpc
efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto
ecb algif_skcipher af_alg dm_crypt dm_mod raid10 raid456
async_raid6_recov
[  257.360114]  async_memcpy async_pq async_xor async_tx xor
hid_sensor_custom hid_sensor_hub hid_generic usbhid hid raid6_pq
libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sd_mod
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc
rtsx_pci_sdmmc mmc_core aesni_intel aes_x86_64 crypto_simd glue_helper
cryptd ahci libahci xhci_pci psmouse rtsx_pci xhci_hcd r8169 libata
i2c_i801 mii scsi_mod usbcore usb_common thermal [last unloaded:
cfg80211]
[  257.360139] CPU: 0 PID: 162 Comm: kworker/0:2 Not tainted
4.16.0-1-amd64 #1 Debian 4.16.5-1
[  257.360140] Hardware name: HP HP Pavilion x360 Convertible/80D1,
BIOS F.25 02/26/2018
[  257.360147] Workqueue: rtl8723be_pci rtl_c2hcmd_wq_callback [rtlwifi]
[  257.360151] RIP: 0010:__list_del_entry_valid+0x73/0x90
[  257.360153] RSP: 0018:ffffaa25c10b3d68 EFLAGS: 00010086
[  257.360155] RAX: 0000000000000054 RBX: 0000000000000000 RCX: 0000000000000000
[  257.360156] RDX: 0000000000000000 RSI: ffff9619aec16738 RDI: ffff9619aec16738
[  257.360158] RBP: ffff96199fc2e2e0 R08: 0000000000000398 R09: 0000000000000004
[  257.360159] R10: 0000000000000000 R11: ffffffff979a8dcd R12: ffff96199fc2e2d8
[  257.360161] R13: ffff96199fc2e2e8 R14: ffffaa25c10b3d88 R15: ffff96199fc2e2e8
[  257.360162] FS:  0000000000000000(0000) GS:ffff9619aec00000(0000)
knlGS:0000000000000000
[  257.360164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  257.360165] CR2: 000055c533d45808 CR3: 0000000118e0a006 CR4: 00000000003606f0
[  257.360167] Call Trace:
[  257.360171]  wait_for_completion_timeout+0x155/0x1a0
[  257.360175]  ? wake_up_q+0x70/0x70
[  257.360181]  halbtc_send_bt_mp_operation.constprop.19+0x81/0x90 [btcoexist]
[  257.360185]  halbtc_set_bt_reg+0x4a/0x90 [btcoexist]
[  257.360189]  ex_btc8723b1ant_bt_info_notify+0x2d1/0x6d0 [btcoexist]
[  257.360193]  rtl_c2hcmd_launcher+0xbb/0x120 [rtlwifi]
[  257.360196]  process_one_work+0x17b/0x360
[  257.360200]  worker_thread+0x2e/0x390
[  257.360202]  ? process_one_work+0x360/0x360
[  257.360204]  kthread+0x113/0x130
[  257.360207]  ? kthread_create_worker_on_cpu+0x70/0x70
[  257.360209]  ? kthread_create_worker_on_cpu+0x70/0x70
[  257.360211]  ret_from_fork+0x35/0x40
[  257.360213] Code: 97 e8 9c c9 d3 ff 0f 0b 48 89 fe 48 c7 c7 28 df
25 97 e8 8b c9 d3 ff 0f 0b 48 89 f2 48 89 fe 48 c7 c7 60 df 25 97 e8
77 c9 d3 ff <0f> 0b 48 c7 c7 a0 df 25 97 e8 69 c9 d3 ff 0f 0b 90 90 90
90 90
[  257.360241] RIP: __list_del_entry_valid+0x73/0x90 RSP: ffffaa25c10b3d68
[  257.360243] ---[ end trace 89b4b0ea883f4120 ]---




[   10.828074] BUG: unable to handle kernel paging request at ffffffffad802660
[   10.828104] IP: native_queued_spin_lock_slowpath+0x161/0x190
[   10.828121] PGD 17600e067 P4D 17600e067 PUD 17600f063 PMD 1754000e1
[   10.828141] Oops: 0003 [#1] SMP PTI
[   10.828154] Modules linked in: 8021q garp mrp stp llc cmac
snd_hrtimer snd_seq snd_seq_device bnep nls_ascii nls_cp437 vfat fat
wmi_bmof hp_wmi snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal
intel_powerclamp snd_hda_codec_realtek arc4 coretemp
snd_hda_codec_generic kvm_intel kvm rtl8723be irqbypass btcoexist
snd_soc_skl intel_cstate btusb snd_soc_skl_ipc btrtl rtl8723_common
btbcm snd_hda_ext_core btintel snd_soc_sst_dsp rtl_pci bluetooth
efi_pstore intel_uncore snd_soc_sst_ipc snd_soc_acpi intel_rapl_perf
rtlwifi pcspkr snd_soc_core uvcvideo snd_compress serio_raw
hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_rotation i915
mac80211 hid_sensor_magn_3d hid_sensor_incl_3d evdev videobuf2_vmalloc
joydev hid_sensor_trigger snd_hda_intel videobuf2_memops
hid_sensor_iio_common industrialio_triggered_buffer
[   10.828362]  videobuf2_v4l2 efivars kfifo_buf industrialio
snd_hda_codec drbg videobuf2_common cfg80211 ansi_cprng hid_multitouch
snd_hda_core videodev snd_hwdep media ecdh_generic rtsx_pci_ms
intel_th_gth snd_pcm drm_kms_helper snd_timer snd idma64 rfkill mei_me
memstick intel_th_pci intel_th soundcore iTCO_wdt sg drm
iTCO_vendor_support mei intel_lpss_pci i2c_algo_bit intel_lpss
processor_thermal_device shpchp intel_pch_thermal intel_soc_dts_iosf
wmi int3403_thermal soc_button_array int340x_thermal_zone ac
intel_vbtn battery sparse_keymap video tpm_crb tpm_tis tpm_tis_core
int3400_thermal tpm rng_core acpi_thermal_rel hp_wireless acpi_pad
button sunrpc efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache
jbd2 fscrypto ecb algif_skcipher af_alg hid_sensor_custom
hid_sensor_hub hid_generic usbhid
[   10.828567]  hid dm_crypt dm_mod raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c
crc32c_generic raid1 raid0 multipath linear md_mod sd_mod
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc
rtsx_pci_sdmmc mmc_core aesni_intel aes_x86_64 crypto_simd glue_helper
cryptd ahci libahci xhci_pci rtsx_pci i2c_i801 xhci_hcd psmouse libata
r8169 mii usbcore scsi_mod usb_common thermal
[   10.828684] CPU: 0 PID: 510 Comm: kworker/0:3 Not tainted
4.16.0-1-amd64 #1 Debian 4.16.5-1
[   10.828708] Hardware name: HP HP Pavilion x360 Convertible/80D1,
BIOS F.25 02/26/2018
[   10.828734] Workqueue: rtl8723be_pci rtl_c2hcmd_wq_callback [rtlwifi]
[   10.828755] RIP: 0010:native_queued_spin_lock_slowpath+0x161/0x190
[   10.828773] RSP: 0018:ffffa43641517d60 EFLAGS: 00010086
[   10.828789] RAX: ffffffffad802660 RBX: 0000000000000000 RCX: ffff89bdaec22480
[   10.828810] RDX: 000000000000191c RSI: 000000006474e550 RDI: ffff89bda2fe7ae0
[   10.828830] RBP: ffff89bda2fe7ae0 R08: 0000000000040000 R09: 0000000000000000
[   10.828850] R10: 0000000000000000 R11: 0000000000000ed1 R12: ffff89bda2fe7ad8
[   10.828870] R13: ffff89bda2fe7ae8 R14: ffffa43641517d88 R15: ffff89bda2fe7ae8
[   10.828891] FS:  0000000000000000(0000) GS:ffff89bdaec00000(0000)
knlGS:0000000000000000
[   10.828914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.828942] CR2: ffffffffad802660 CR3: 000000017600a003 CR4: 00000000003606f0
[   10.828974] Call Trace:
[   10.828986]  _raw_spin_lock_irq+0x24/0x27
[   10.829001]  wait_for_completion_timeout+0x143/0x1a0
[   10.829019]  ? wake_up_q+0x70/0x70
[   10.829034]  halbtc_send_bt_mp_operation.constprop.19+0x81/0x90 [btcoexist]
[   10.829056]  halbtc_set_bt_reg+0x4a/0x90 [btcoexist]
[   10.829073]  ex_btc8723b1ant_bt_info_notify+0x2d1/0x6d0 [btcoexist]
[   10.829094]  rtl_c2hcmd_launcher+0xbb/0x120 [rtlwifi]
[   10.829112]  process_one_work+0x17b/0x360
[   10.829126]  worker_thread+0x2e/0x390
[   10.829139]  ? process_one_work+0x360/0x360
[   10.829156]  kthread+0x113/0x130
[   10.829168]  ? kthread_create_worker_on_cpu+0x70/0x70
[   10.829184]  ret_from_fork+0x35/0x40
[   10.829198] Code: c3 f3 90 4c 8b 09 4d 85 c9 74 f6 eb d2 c1 ea 12
83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 80 24 02 00 48 03 04 d5
40 e4 2a ae <48> 89 08 8b 41 08 85 c0 75 09 f3 90 8b 41 08 85 c0 74 f7
4c 8b
[   10.829271] RIP: native_queued_spin_lock_slowpath+0x161/0x190 RSP:
ffffa43641517d60
[   10.830709] CR2: ffffffffad802660
[   10.832164] ---[ end trace 80c173d404c136d4 ]---



[   10.687183] ------------[ cut here ]------------
[   10.687185] rtl8723be: error H2C cmd because of Fw download fail!!!
[   10.687273] WARNING: CPU: 0 PID: 34 at
drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c:227
rtl8723be_fill_h2c_cmd+0x103/0x400 [rtl8723be]
[   10.687275] Modules linked in: 8021q garp mrp stp llc cmac
snd_hrtimer snd_seq snd_seq_device bnep nls_ascii nls_cp437 vfat fat
snd_hda_codec_hdmi intel_rapl arc4 x86_pkg_temp_thermal
intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic wmi_bmof
hp_wmi coretemp snd_soc_skl rtl8723be snd_soc_skl_ipc kvm_intel
btcoexist snd_hda_ext_core rtl8723_common snd_soc_sst_dsp rtl_pci
snd_soc_sst_ipc rtlwifi snd_soc_acpi kvm snd_soc_core irqbypass
snd_compress intel_cstate mac80211 efi_pstore snd_hda_intel
intel_uncore intel_rapl_perf snd_hda_codec joydev intel_th_gth evdev
snd_hda_core btusb btrtl btbcm intel_th_pci iTCO_wdt btintel snd_hwdep
intel_th bluetooth snd_pcm iTCO_vendor_support serio_raw efivars
snd_timer pcspkr rtsx_pci_ms snd cfg80211 soundcore i915 memstick
hid_multitouch drbg hid_sensor_accel_3d
[   10.687370]  uvcvideo ansi_cprng hid_sensor_gyro_3d drm_kms_helper
hid_sensor_rotation hid_sensor_magn_3d videobuf2_vmalloc
hid_sensor_incl_3d sg videobuf2_memops videobuf2_v4l2
hid_sensor_trigger videobuf2_core hid_sensor_iio_common idma64
ecdh_generic drm videodev processor_thermal_device
industrialio_triggered_buffer kfifo_buf mei_me industrialio media
rfkill intel_lpss_pci i2c_algo_bit mei intel_soc_dts_iosf shpchp
intel_lpss intel_pch_thermal wmi int3403_thermal soc_button_array
int340x_thermal_zone ac battery intel_vbtn sparse_keymap tpm_crb
tpm_tis video tpm_tis_core tpm int3400_thermal acpi_thermal_rel
hp_wireless acpi_pad button sunrpc efivarfs ip_tables x_tables autofs4
ext4 crc16 mbcache jbd2 fscrypto algif_skcipher af_alg
hid_sensor_custom hid_sensor_hub usbhid hid dm_crypt dm_mod raid10
[   10.687457]  raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0
multipath linear md_mod sd_mod crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel pcbc rtsx_pci_sdmmc mmc_core
aesni_intel aes_x86_64 crypto_simd glue_helper cryptd psmouse ahci
libahci xhci_pci i2c_i801 rtsx_pci libata r8169 mii xhci_hcd scsi_mod
usbcore thermal
[   10.687514] CPU: 0 PID: 34 Comm: kworker/0:1 Not tainted
4.15.0-874e837d67d0+ #17
[   10.687516] Hardware name: HP HP Pavilion x360 Convertible/80D1,
BIOS F.25 02/26/2018
[   10.687530] Workqueue: rtl8723be_pci rtl_c2hcmd_wq_callback [rtlwifi]
[   10.687541] RIP: 0010:rtl8723be_fill_h2c_cmd+0x103/0x400 [rtl8723be]
[   10.687544] RSP: 0018:ffffaf1100e0bdb0 EFLAGS: 00010286
[   10.687548] RAX: 0000000000000000 RBX: ffffffffc12df9a0 RCX: 0000000000000006
[   10.687551] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff9249aec0ee70
[   10.687553] RBP: 0000000000000000 R08: 0000000000000388 R09: 0000000000000004
[   10.687555] R10: 00000000000001d0 R11: 0000000000000001 R12: ffff92499d301500
[   10.687557] R13: 0000000000000000 R14: dead000000000100 R15: 0000000000000001
[   10.687561] FS:  0000000000000000(0000) GS:ffff9249aec00000(0000)
knlGS:0000000000000000
[   10.687563] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.687566] CR2: 000055b4818242d0 CR3: 0000000214009004 CR4: 00000000003606f0
[   10.687568] Call Trace:
[   10.687585]  ex_btc8723b1ant_bt_info_notify+0x369/0x690 [btcoexist]
[   10.687597]  rtl_c2hcmd_launcher+0xb8/0x120 [rtlwifi]
[   10.687606]  process_one_work+0x188/0x380
[   10.687612]  worker_thread+0x2e/0x390
[   10.687618]  ? process_one_work+0x380/0x380
[   10.687622]  kthread+0x111/0x130
[   10.687626]  ? kthread_create_worker_on_cpu+0x70/0x70
[   10.687632]  ret_from_fork+0x1f/0x30
[   10.687637] Code: 41 80 bc 24 6c 08 00 00 00 75 c9 48 89 c6 48 89
ef e8 72 de fb f1 eb a9 48 c7 c7 90 b7 0f c1 c6 05 52 34 01 00 01 e8
2d 9c 98 f1 <0f> ff e9 3a ff ff ff 48 89 c6 41 c6 84 24 6c 08 00 00 01
48 89
[   10.687719] ---[ end trace 127c675f3a6f944e ]---
