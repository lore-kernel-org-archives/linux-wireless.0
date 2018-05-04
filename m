Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:41099 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbeEDTzv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 15:55:51 -0400
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
From: Wirz <spam@lukas-wirz.de>
Subject: b43 crashes on rmmod (bcm4331)
Message-ID: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de> (sfid-20180504_215555_784636_188849C5)
Date: Fri, 4 May 2018 22:55:26 +0300
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="AU6OvInpaAhvXXomYgxRnb4FmxC3oVpmV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AU6OvInpaAhvXXomYgxRnb4FmxC3oVpmV
Content-Type: multipart/mixed; boundary="b6rHxDGWppxSvktXK7roY6N22VtTbvNWQ";
 protected-headers="v1"
From: Wirz <spam@lukas-wirz.de>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Message-ID: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
Subject: b43 crashes on rmmod (bcm4331)

--b6rHxDGWppxSvktXK7roY6N22VtTbvNWQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi,

I'm using b43 to operate a BCM4331 (on a MacBookPro 9,2).  At the moment
I'm using the kernels that are shipped with debian testing.

On all three versions of 4.15 (what debian called 4.15.4, 4.15.11, and
4.15.17) that were available as well as the current 4.16.5 I can load
b43 and successfully use it, but the kernel crashes when unloading the
driver, see the trace below.
I had no such problems under 4.14.17.

Is that a known problem?  Can I provide any more information to trace
this down?

cheers, lukas



[27541.758851] wlan0: deauthenticating from f4:6b:ef:5f:1b:e5 by local
choice (Reason: 3=3DDEAUTH_LEAVING)
[27542.009123] general protection fault: 0000 [#1] SMP PTI
[27542.009129] Modules linked in: ctr ccm cpufreq_conservative bnep
cpufreq_userspace cpufreq_powersave binfmt_misc dm_crypt algif_skcipher
af_alg btusb btrtl btbcm btintel hid_appleir hid_apple bluetooth
jitterentropy_rng drbg ansi_cprng ecdh_generic hid_generic usbhid
bcm5974 hid arc4 b43(-) joydev uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 mac80211 videobuf2_common videodev media
cfg80211 intel_rapl x86_pkg_temp_thermal intel_powerclamp efi_pstore ssb
rfkill pcmcia pcmcia_core coretemp rng_core nls_ascii kvm_intel kvm
irqbypass nls_cp437 iTCO_wdt iTCO_vendor_support vfat fat
crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi evdev
snd_hda_codec_cirrus dm_mod snd_hda_codec_generic applesmc input_polldev
ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf pcspkr
efivars snd_hda_intel
[27542.009199]  snd_hda_codec snd_hda_core snd_hwdep bcma snd_pcm_oss
i915 snd_mixer_oss snd_pcm drm_kms_helper snd_timer mei_me snd drm sg
soundcore mei i2c_algo_bit shpchp lpc_ich sbs apple_gmux sbshc acpi_als
kfifo_buf industrialio video apple_bl ac button loop firewire_sbp2
parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4 ext4
crc16 mbcache jbd2 fscrypto ecb btrfs zstd_decompress zstd_compress
xxhash raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath
linear md_mod sr_mod cdrom sd_mod crc32c_intel ahci libahci sdhci_pci
cqhci sdhci firewire_ohci libata tg3 aesni_intel libphy xhci_pci
aes_x86_64 ehci_pci firewire_core crypto_simd crc_itu_t xhci_hcd
ehci_hcd cryptd glue_helper mmc_core i2c_i801 scsi_mod
[27542.009284]  usbcore usb_common thunderbolt
[27542.009293] CPU: 1 PID: 30802 Comm: rmmod Not tainted 4.16.0-1-amd64
#1 Debian 4.16.5-1
[27542.009295] Hardware name: Apple Inc.
MacBookPro9,2/Mac-6F01561E16C75D06, BIOS MBP91.88Z.00D3.B0C.1509111653
09/11/2015
[27542.009304] RIP: 0010:kfree+0x4f/0x180
[27542.009307] RSP: 0018:ffffa8638448fe50 EFLAGS: 00010207
[27542.009311] RAX: ffff96325b9a4a01 RBX: b842b70420b5828a RCX:
00000001820001cc
[27542.009314] RDX: 00000001820001cd RSI: ffffe590d16e6900 RDI:
000069d180000000
[27542.009316] RBP: ffff96325cadd0a0 R08: ffff96325b9a4bf8 R09:
00000001820001cc
[27542.009320] R10: 02e0f2141882d600 R11: ffff9631d987d100 R12:
ffffffffc080a122
[27542.009323] R13: ffffffffc10850f8 R14: ffff96325cadd100 R15:
0000000000000000
[27542.009327] FS:  00007f82c0a95b80(0000) GS:ffff96326f280000(0000)
knlGS:0000000000000000
[27542.009330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[27542.009333] CR2: 0000559625d724a8 CR3: 00000003d9990001 CR4:
00000000001606e0
[27542.009336] Call Trace:
[27542.009349]  bcma_device_remove+0x22/0x30 [bcma]
[27542.009357]  device_release_driver_internal+0x15a/0x220
[27542.009364]  driver_detach+0x39/0x70
[27542.009369]  bus_remove_driver+0x51/0xd0
[27542.009385]  b43_exit+0x18/0xcaf [b43]
[27542.009392]  SyS_delete_module+0x18f/0x290
[27542.009398]  ? task_work_run+0x38/0xb0
[27542.009404]  do_syscall_64+0x6c/0x130
[27542.009411]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[27542.009415] RIP: 0033:0x7f82c03bb5e7
[27542.009418] RSP: 002b:00007ffc133187c8 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[27542.009422] RAX: ffffffffffffffda RBX: 00007ffc13318828 RCX:
00007f82c03bb5e7
[27542.009426] RDX: 000000000000000a RSI: 0000000000000800 RDI:
000056430c000808
[27542.009428] RBP: 000056430c0007a0 R08: 00007ffc13317741 R09:
0000000000000000
[27542.009431] R10: 00007f82c042b960 R11: 0000000000000206 R12:
00007ffc133189f0
[27542.009434] R13: 00007ffc13318edd R14: 000056430c000260 R15:
000056430c0007a0
[27542.009437] Code: 00 80 49 01 da 0f 82 39 01 00 00 48 c7 c7 00 00 00
80 48 2b 3d 7b 5c e2 00 49 01 fa 49 c1 ea 0c 49 c1 e2 06 4c 03 15 59 5c
e2 00 <49> 8b 42 20 48 8d 50 ff a8 01 4c 0f 45 d2 49 8b 52 20 48 8d 42
[27542.009505] RIP: kfree+0x4f/0x180 RSP: ffffa8638448fe50
[27542.009508] ---[ end trace 564977d3706dc719 ]---




--b6rHxDGWppxSvktXK7roY6N22VtTbvNWQ--

--AU6OvInpaAhvXXomYgxRnb4FmxC3oVpmV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWuy6swAKCRDWbaSYbwIj
LfiOAJ4sevwwgGEbeuOWb9F82ZJODH72vQCeI9xOJ9AcowCpHRGGmfFK+13kyVs=
=0Y3i
-----END PGP SIGNATURE-----

--AU6OvInpaAhvXXomYgxRnb4FmxC3oVpmV--
