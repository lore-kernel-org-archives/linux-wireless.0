Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3A9C6786F
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 20:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F06E20833
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 20:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxtAV/Yx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F06E20833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbeKDFOM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 4 Nov 2018 01:14:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35255 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbeKDFOL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Nov 2018 01:14:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id x85-v6so4631040ljb.2;
        Sat, 03 Nov 2018 13:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qMtzQelHeSR0zk6eFdWjCKRcHxIfSIulTyvDDS6UOuQ=;
        b=nxtAV/YxQ2+3rM8FBYqReZ5iLVoZGuoRV280/c4FqmZLdKYl/WwWFODucy3Hns5x4V
         Nrur4C6tdbnO7g/5+cEDyCNGBllD4bfEz9/ErfRiNQ7ZKUzuOz+lnTSuxnrAvmUWvIGS
         8RU4U0X0CnI/W/ZesJDKIWTjw927X83aPUsBU7zlcc8O9kJb3dOT3Q9noIS9+aIi0rmP
         axlO4raoyuj99qqpTJIQbNf4FjLIh9M79UmBPjBCls3qPB4A+8KyvdmkwOCSDYdhX4oH
         xyHnig0hzzwUiFPhXIiirTmtDbfu8mIygA0dYhvWhQuDz11zQ5VybV/XDPKXpdg6U7cN
         ec6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qMtzQelHeSR0zk6eFdWjCKRcHxIfSIulTyvDDS6UOuQ=;
        b=j35u/IMJS4DPDVIhaiLkC9TpD9K5IK+Ic8VFdAO69SAC4pddNjqq9UuzYTyo/N/JJ1
         EwFcxcv0Eiwng5u31WGJcFY3/+1DTKzT5dpl7OVwYsn0GitIvQB90zcU5TsnpfGRf7En
         hpyTXogKTcdMVIMIgkDl4E4hG6w4lhKLfgtJiOaWhCt95svZ1od9dT2x7RzzXtPtqwPR
         RaF0PnA3q2P9uSm2FX7RFibERaLscLHIZhkPbheGToIS/GeaL0q+5NOslosFrqcaQRjQ
         knQPLfPmqO6SOIt+Lpy3u2Bto9Fe6Q+zmpCaHNVXBJn1JPlTqE8BIHz9USk/E17HsYhi
         egJw==
X-Gm-Message-State: AGRZ1gKdpUe3jYRy/sodM23Wy6g1T8ePemxV0reWlkkKsHGlJCa42w0Q
        CggiTO4xGDbmVylu8DHyVJ07cqTMlT4AWt/n8g==
X-Google-Smtp-Source: AJdET5eyPU2RTFchyzs9KM6WYJy2D8KhcUDe4Zb2mE3ImjW0JvzK/D7TcSCR7BJ6WKlvhBIBCFNAGslMRYXxbZXYr18=
X-Received: by 2002:a2e:8546:: with SMTP id u6-v6mr6459133ljj.95.1541275312161;
 Sat, 03 Nov 2018 13:01:52 -0700 (PDT)
MIME-Version: 1.0
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Sat, 3 Nov 2018 21:01:26 +0100
Message-ID: <CAEJqkgiKzYTZQTGWNAPTeOPFWz658FWqDsAhyoxVDP1VKWSukg@mail.gmail.com>
Subject: atk10k Unknown eventid and WARN() on resume with kernel 4.19
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, dex77@frugalware.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

starting with kernel 4.19 we noticed  'Unknown eventid: xxxx' warnings
on our Laptops.

...

crazy@devnull:~$ dmesg | grep Unknow
[    7.144998] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
[    7.147758] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
[    9.441654] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
[    9.444446] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
[   11.770997] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
[   11.773787] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
[320339.374108] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
[320339.377020] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
[320342.128664] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
[320342.131447] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
[320344.452864] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
[320344.455696] ath10k_pci 0000:03:00.0: Unknown eventid: 90118

....

Both boxes also hits the following WARN*() on resume from S3:

[320339.396961] WARNING: CPU: 3 PID: 9002 at
drivers/net/wireless/ath/ath10k/mac.c:5625
ath10k_bss_info_changed+0xb33/0xd90 [ath10k_core]
[320339.396962] Modules linked in: uas usb_storage rndis_host
cdc_ether usbnet mii btrfs xor raid6_pq ufs qnx4 hfsplus hfs minix
ntfs msdos jfs xfs libcrc32c ext2 ctr ccm cmac af_packet amdgpu arc4
chash gpu_sched bnep snd_hda_codec_hdmi
snd_hda_codec_conexant snd_hda_codec_generic joydev uvcvideo radeon
btusb videobuf2_vmalloc videobuf2_memops btrtl videobuf2_v4l2
ath10k_pci btbcm btintel videobuf2_common ath10k_core bluetooth ath
videodev mac80211 ecdh_generic iTCO_wd
t i915 iTCO_vendor_support snd_soc_skl rtsx_usb_ms memstick
snd_soc_skl_ipc intel_wmi_thunderbolt snd_soc_sst_ipc media
snd_soc_sst_dsp snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi
ttm kvmgt vfio_mdev mdev vfio_iommu_type1 snd_
soc_core coretemp vfio cfg80211 cec intel_rapl rc_core drm_kms_helper
x86_pkg_temp_thermal intel_powerclamp
[320339.397005]  nls_utf8 snd_compress snd_pcm_dmaengine nls_cp437
kvm_intel vfat drm fat snd_hda_intel kvm snd_hda_codec intel_gtt
agpgart efi_pstore snd_hda_core r8169 irqbypass psmouse i2c_algo_bit
fb_sys_fops evdev syscopyarea hwmon
sysfillrect mac_hid snd_hwdep libphy sysimgblt i2c_i801 efivars pcspkr
ideapad_laptop intel_pch_thermal i2c_core sparse_keymap rfkill thermal
wmi ac battery video pcc_cpufreq button acpi_pad ppdev sch_fq_codel
fuse snd_pcm_oss snd_mixer_
oss snd_seq_dummy snd_pcm snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_timer snd soundcore lp parport_pc parport
binfmt_misc sg ext4 rtsx_usb_sdmmc crc32c_generic crc16 mmc_core
mbcache jbd2 rtsx_usb fscrypto sr_mod sd_mod c
drom crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
pcbc ahci libahci xhci_pci libata
[320339.397039]  xhci_hcd aesni_intel usbcore aes_x86_64 scsi_mod
crypto_simd cryptd glue_helper serio_raw dm_mirror dm_region_hash
dm_log dm_mod efivarfs unix sha256_mb sha256_ssse3 sha256_generic
sha1_mb mcryptd sha1_ssse3 sha1_generic
hmac ipv6 autofs4
[320339.397051] CPU: 3 PID: 9002 Comm: kworker/u8:1 Not tainted 4.19-fw1 #1
[320339.397052] Hardware name: LENOVO 80UD/LNVNB161216, BIOS
1TCN26WW(V2.07) 03/29/2018
[320339.397067] Workqueue: events_unbound async_run_entry_fn
[320339.397071] RIP: 0010:ath10k_bss_info_changed+0xb33/0xd90 [ath10k_core]
[320339.397072] Code: ff ff b8 a1 ff ff ff e9 e9 f7 ff ff b8 a1 ff ff
ff e9 a5 f6 ff ff b8 a1 ff ff ff e9 ef f5 ff ff b8 a1 ff ff ff e9 4f
f7 ff ff <0f> 0b e9 37 f8 ff ff b8 a1 ff ff ff e9 f6 fa ff ff b8 a1 ff
ff ff
[320339.397073] RSP: 0000:ffffac0704057cd8 EFLAGS: 00010282
[320339.397074] RAX: 00000000fffffffe RBX: ffff9f96ee4f1540 RCX:
0000000000000000
[320339.397092] RDX: ffff9f96ee4f18b8 RSI: ffffac0704057cf8 RDI:
ffff9f96f3b2d380
[320339.397093] RBP: ffff9f96f3b2d380 R08: 0000000000200000 R09:
0000000000000000
[320339.397093] R10: 000000000000001f R11: ffff9f96f3b91a00 R12:
0000000002000000
[320339.397094] R13: ffff9f96f3b2d388 R14: ffff9f96ee4f24d0 R15:
ffff9f96ee4f1540
[320339.397095] FS:  0000000000000000(0000) GS:ffff9f96f7380000(0000)
knlGS:0000000000000000
[320339.397096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[320339.397097] CR2: 0000000000000000 CR3: 000000017200a001 CR4:
00000000003606e0
[320339.397097] Call Trace:
[320339.397102]  ? ath10k_conf_tx+0x12d/0x4c0 [ath10k_core]
[320339.397125]  ieee80211_bss_info_change_notify+0xa9/0x1c0 [mac80211]
[320339.397135]  ieee80211_reconfig+0x9d7/0x14f0 [mac80211]
[320339.397146]  wiphy_resume+0x7e/0x150 [cfg80211]
[320339.397152]  ? wiphy_namespace+0x10/0x10 [cfg80211]
[320339.397155]  dpm_run_callback+0x2e/0x130
[320339.397156]  device_resume+0x97/0x190
[320339.397158]  async_resume+0x19/0x40
[320339.397159]  async_run_entry_fn+0x37/0xe0
[320339.397161]  process_one_work+0x1e9/0x410
[320339.397162]  worker_thread+0x2d/0x3d0
[320339.397164]  ? process_one_work+0x410/0x410
[320339.397165]  kthread+0x113/0x130
[320339.397167]  ? kthread_park+0x90/0x90
[320339.397169]  ret_from_fork+0x35/0x40
[320339.397170] ---[ end trace 99aad6e5b911fa07 ]---

....

Please let me know if you need an dmesg or any other informations.

BR ,

Gabriel C.
