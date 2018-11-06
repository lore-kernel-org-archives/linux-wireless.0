Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B28C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 13:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 396702083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 13:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cQaToIrT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 396702083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbeKFXEE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 18:04:04 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42476 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388212AbeKFXEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 18:04:04 -0500
Received: by mail-qk1-f195.google.com with SMTP id u68so18364083qkg.9
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 05:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Le8SwuAhO5G037e49AiwKzCaSMXV7q+hqtRmWjwV8o=;
        b=cQaToIrTcG7xVSPs8MhHg+V+OXss96dKR4kzUI9HLecZgSsi6/rdbHgosDSGC0gBKk
         75qV3oWazRt8mq9UfRVaChTWz6u0dWgyhl+tVQs6A04VnC06uPjtWUTW4vwCL0lPd4Zh
         DyWzLeQWW4BRxROD89eEzhvMd7ahcN1jCfV9RidoMxKQhT+pOxJwQGLiKjpcAA86ot2K
         twg1zpmwJOYOlk27HgUL6h/k5PJyKu1r6WjavqVHXZJ1+zevqvX2cx19Byw7Wh5p4sFR
         C9EvNq4XyKffeKnNTPfKNbpyVeKiFcgyNwpV+ZEi0cvnnQQrXZ0txBXwQ1zoOHhgq8gv
         RT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Le8SwuAhO5G037e49AiwKzCaSMXV7q+hqtRmWjwV8o=;
        b=TH2LU9rjVBPwf+IfKrw4zlGsuMFnRlpZuyV9dvNp3Dhc8xd7I64GaRAqFpUcLiG9iT
         VPMQh93ELxLRsANcyma/krF1Zyld3qsgxPnja0x/NX2EvOZgNxsMd0V/K61BrctYWCGE
         X2Dc5y9fNw1tKdFhAVd/zDeS7CbwxMFcoEGajVK0T5/Q4pFXaVUCjVeZcg93e+Di51CS
         vtKub30qEBhFpFIgncgPm8BWwPs0h+CA1QnhkEptcn51hDk3caqt42HOrsNy2EWbljXy
         kVjG3dULdhizyphzgLzbnxPZV8jT+qS5wFMrjF0fBGpERyw8xENHn08sYywDjo8JIgS/
         Nv7g==
X-Gm-Message-State: AGRZ1gJ7xtdFmnTm8OGXdIeJ7mYchShcgUkZSpehfdLPnrlQ/AyDtrFr
        Ng8xgISy3rIt3r5cdyViFK/M0+IC0I4Wz2RnJPDnAPqi
X-Google-Smtp-Source: AJdET5d6O1e/tXIQtBqYTCV7rARrkDexT2eKbhgAR74Q81zpQFbjPi2e362dI3LYpS77zG/lGOwAyLuJvkN1/czQwzY=
X-Received: by 2002:a37:4c2:: with SMTP id 185mr24497071qke.95.1541511526594;
 Tue, 06 Nov 2018 05:38:46 -0800 (PST)
MIME-Version: 1.0
References: <CAJVZm6dHuQPMrU+tSyZe_nsFcmmJ75byG+JbOzcHUeey9LpjDA@mail.gmail.com>
 <3cf02129-6be4-5665-e633-ca2c384dcd75@lwfinger.net>
In-Reply-To: <3cf02129-6be4-5665-e633-ca2c384dcd75@lwfinger.net>
From:   Menion <menion@gmail.com>
Date:   Tue, 6 Nov 2018 14:38:35 +0100
Message-ID: <CAJVZm6cz16AnCADMBTNaDBSFaxZHC1Cyb1BcZ=i_h+Dh7hf3=w@mail.gmail.com>
Subject: Re: RTL8188EUS support
To:     Larry.Finger@lwfinger.net
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi
Yes sorry I was referring to rtl8xxxu driver, I don't really know how
it could come up as rtl2xxxx :)
I have compiled it for my Openwrt x86_64 image, that run kernel
4.14.72, I just needed to tweak the Makefile in order to pick the
command line KSRC instead of the platform detected one
Anyhow the compilation command seems ok:

menion@Menionubuntu:/media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu$
KSRC=/media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/linux-4.14.72/
CROSS_COMPILE=/media/storage/das1/temp/openwrt_x86/staging_dir/toolchain-x86_64_gcc-7.3.0_musl/bin/x86_64-openwrt-linux-
make
make ARCH=x86_64
CROSS_COMPILE=/media/storage/das1/temp/openwrt_x86/staging_dir/toolchain-x86_64_gcc-7.3.0_musl/bin/x86_64-openwrt-linux-
-C /media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/linux-4.14.72/
M=/media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu
 modules
make[1]: Entering directory
'/media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/linux-4.14.72'
  CC [M]  /media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu/core/rtw_cmd.o

the compilation goes fine but in the end it complains, with warning
for missing symbols, but I think it is normal:

WARNING: "cfg80211_remain_on_channel_expired"
[/media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu/8188eu.ko]
undefined!
WARNING: "cfg80211_scan_done"
[/media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu/8188eu.ko]
undefined!
WARNING: "cfg80211_inform_bss_frame_data"
[/media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu/8188eu.ko]
undefined!
  CC      /media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu/8188eu.mod.o
  LD [M]  /media/storage/das1/temp/openwrt_x86/build_dir/target-x86_64_musl/linux-x86_64/rtl8188eu/8188eu.ko

I load it on my openwrt (running in virtualbox) but when I attach the
dongle I get an error (if I understand correctly the issue is with
FALSE return from : rtw_regsty_chk_target_tx_power_valid)
What can be the problem?
Thanks by

--dmesg--

[   87.596336] RTW: rtl8188eu v5.2.2.4_25483.20171222
[   87.597085] RTW: build time: Nov  6 2018 12:13:11
[   87.659036] RTW: hal_com_config_channel_plan chplan:0x20
[   87.659860] RTW: rtw_regsty_chk_target_tx_power_valid return _FALSE
for band:0, path:0, rs:0, t:-1
[   87.660956] ------------[ cut here ]------------
[   87.661544] WARNING: CPU: 0 PID: 1923 at wiphy_register+0x25e/0x850
[cfg80211]
[   87.662601] Modules linked in: 8188eu(+) ath9k_htc ath9k_common
rtl8821ae rtl8192se rtl8192de rtl8192cu rtl8192ce rtl8192c_common
rtl_usb rtl_pci rt2800usb rt2800pci rt2800mmio rt2800lib rt2500usb
rt2500pci rt2400pci pppoe ppp_async btcoexist ath9k_hw ath rtlwifi
rtl8xxxu rtl818x_pci rtl8187 rt2x00usb rt2x00pci rt2x00mmio rt2x00lib
rndis_host pppox ppp_generic nf_conntrack_ipv6 mac80211 iptable_nat
ipt_REJECT ipt_MASQUERADE cfg80211 cdc_ether xt_time xt_tcpudp
xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_conntrack
xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_FLOWOFFLOAD usbnet slhc
r8712u r8169 nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4
nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_flow_table_hw
nf_flow_table nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack
[   87.669478]  lib80211_crypt_wep lib80211_crypt_tkip
lib80211_crypt_ccmp lib80211 iptable_mangle iptable_filter ip_tables
e1000e crc_itu_t crc_ccitt compat i2c_dev ip6t_REJECT nf_reject_ipv6
nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables
x_tables igb i2c_algo_bit e1000 tun vfat fat ntfs nls_utf8
nls_iso8859_1 nls_cp437 eeprom_93cx6 xhci_plat_hcd ehci_platform xfs
libcrc32c button_hotplug ptp pps_core mii [last unloaded: 8188eu]
[   87.672991] CPU: 0 PID: 1923 Comm: modprobe Tainted: G        W
  4.14.72 #0
[   87.673852] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[   87.674777] task: ffff880006427300 task.stack: ffffc900004f8000
[   87.675462] RIP: 0010:wiphy_register+0x25e/0x850 [cfg80211]
[   87.676097] RSP: 0018:ffffc900004fb9a0 EFLAGS: 00010246
[   87.676751] RAX: 0000000000000000 RBX: ffff880006bc8300 RCX: ffffffffa084ae80
[   87.677616] RDX: 0000000000000000 RSI: ffffffff81c7aee0 RDI: ffff880006bc8300
[   87.678599] RBP: ffffc900004fba10 R08: 0000000000000000 R09: ffffc90000081869
[   87.679407] R10: ffffc900004fba28 R11: 0000000000000001 R12: ffffc90000080698
[   87.680137] R13: ffff880006bcc000 R14: 0000000000000000 R15: ffffffffa082a355
[   87.681248] FS:  00007ff17b05bb88(0000) GS:ffff880007c00000(0000)
knlGS:0000000000000000
[   87.682163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.682915] CR2: 00007fe4162ceb40 CR3: 00000000067e2001 CR4: 00000000000606f0
[   87.683778] Call Trace:
[   87.684333]  ? complete_all+0x3d/0x50
[   87.684830]  ? __kmalloc+0x3d/0xf0
[   87.685383]  rtw_wiphy_register+0x47/0x4a [8188eu]
[   87.685970]  ? rtw_wiphy_register+0x47/0x4a [8188eu]
[   87.686603]  rtw_cfg80211_ndev_res_register+0x14/0x54 [8188eu]
[   87.687299]  rtw_init_netdev_name+0x18d/0x1bd [8188eu]
[   87.687907]  rtw_os_ndevs_init+0x140/0x1c6 [8188eu]
[   87.688917]  rtw_set_hal_ops+0x74d/0x840 [8188eu]
[   87.690530]  usb_probe_interface+0x188/0x220
[   87.691299]  driver_probe_device+0x133/0x2c0
[   87.692219]  __driver_attach+0x6f/0xa0
[   87.692774]  ? driver_probe_device+0x2c0/0x2c0
[   87.693537]  bus_for_each_dev+0x52/0x90
[   87.694160]  driver_attach+0x19/0x20
[   87.694672]  bus_add_driver+0xf0/0x1f0
[   87.695215]  driver_register+0x83/0xc0
[   87.695729]  usb_register_driver+0x7a/0x130
[   87.696296]  ? 0xffffffffa0889000
[   87.696799]  init_module+0x57/0x1000 [8188eu]
[   87.697473]  do_one_initcall+0x9a/0x170
[   87.698026]  ? __vunmap+0x88/0xb0
[   87.698497]  ? vfree+0x60/0x70
[   87.698950]  do_init_module+0x55/0x1d4
[   87.699499]  load_module+0x1b8d/0x2250
[   87.700075]  SyS_init_module+0x107/0x120
[   87.700689]  ? SyS_init_module+0x107/0x120
[   87.701406]  do_syscall_64+0x115/0x1b0
[   87.701908]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   87.702536] RIP: 0033:0x7ff17ae21fd8
[   87.703062] RSP: 002b:00007ffc50736b90 EFLAGS: 00000212 ORIG_RAX:
00000000000000af
[   87.703928] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff17ae21fd8
[   87.704676] RDX: 0000000000402b2f RSI: 0000000000274190 RDI: 00007ff17a75c020
[   87.705442] RBP: 00000000006040a0 R08: 0000000000000000 R09: 0000000000000802
[   87.706173] R10: 0000000000000000 R11: 0000000000000212 R12: 00007ff17a75c020
[   87.706982] R13: 0000000000000003 R14: 0000000000402b2f R15: 0000000000274190
[   87.707759] Code: 00 0f 84 2d 05 00 00 0f 0b bb ea ff ff ff e9 ee
05 00 00 8b 0a 89 8f 00 08 00 00 0f b7 52 04 66 89 97 04 08 00 00 66
85 c0 75 04 <0f> 0b eb 15 89 c2 66 81 e2 fe 1f 66 39 d0 74 09 0f 0b 66
89 97
[   87.710174] ---[ end trace 312f56694fd4fe2f ]---
[   87.710850] ------------[ cut here ]------------
[   87.711469] WARNING: CPU: 0 PID: 1923 at wiphy_register+0x4fe/0x850
[cfg80211]
[   87.712363] Modules linked in: 8188eu(+) ath9k_htc ath9k_common
rtl8821ae rtl8192se rtl8192de rtl8192cu rtl8192ce rtl8192c_common
rtl_usb rtl_pci rt2800usb rt2800pci rt2800mmio rt2800lib rt2500usb
rt2500pci rt2400pci pppoe ppp_async btcoexist ath9k_hw ath rtlwifi
rtl8xxxu rtl818x_pci rtl8187 rt2x00usb rt2x00pci rt2x00mmio rt2x00lib
rndis_host pppox ppp_generic nf_conntrack_ipv6 mac80211 iptable_nat
ipt_REJECT ipt_MASQUERADE cfg80211 cdc_ether xt_time xt_tcpudp
xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_conntrack
xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_FLOWOFFLOAD usbnet slhc
r8712u r8169 nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4
nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_flow_table_hw
nf_flow_table nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack
[   87.718993]  lib80211_crypt_wep lib80211_crypt_tkip
lib80211_crypt_ccmp lib80211 iptable_mangle iptable_filter ip_tables
e1000e crc_itu_t crc_ccitt compat i2c_dev ip6t_REJECT nf_reject_ipv6
nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables
x_tables igb i2c_algo_bit e1000 tun vfat fat ntfs nls_utf8
nls_iso8859_1 nls_cp437 eeprom_93cx6 xhci_plat_hcd ehci_platform xfs
libcrc32c button_hotplug ptp pps_core mii [last unloaded: 8188eu]
[   87.722683] CPU: 0 PID: 1923 Comm: modprobe Tainted: G        W
  4.14.72 #0
[   87.723629] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[   87.724508] task: ffff880006427300 task.stack: ffffc900004f8000
[   87.725158] RIP: 0010:wiphy_register+0x4fe/0x850 [cfg80211]
[   87.725846] RSP: 0018:ffffc900004fb9a0 EFLAGS: 00010246
[   87.726547] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa084ae80
[   87.727284] RDX: 0000000000000000 RSI: ffffffff81c7aee0 RDI: ffff880006bc8300
[   87.728063] RBP: ffffc900004fba10 R08: 0000000000000000 R09: 0000000000000003
[   87.728804] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
[   87.729569] R13: ffff880006bcc000 R14: 0000000000000000 R15: ffffffffa082a355
[   87.730296] FS:  00007ff17b05bb88(0000) GS:ffff880007c00000(0000)
knlGS:0000000000000000
[   87.731288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.732311] CR2: 00007fe4162ceb40 CR3: 00000000067e2001 CR4: 00000000000606f0
[   87.733126] Call Trace:
[   87.733655]  ? complete_all+0x3d/0x50
[   87.734490]  ? __kmalloc+0x3d/0xf0
[   87.735026]  rtw_wiphy_register+0x47/0x4a [8188eu]
[   87.735667]  ? rtw_wiphy_register+0x47/0x4a [8188eu]
[   87.736303]  rtw_cfg80211_ndev_res_register+0x14/0x54 [8188eu]
[   87.736994]  rtw_init_netdev_name+0x18d/0x1bd [8188eu]
[   87.737651]  rtw_os_ndevs_init+0x140/0x1c6 [8188eu]
[   87.738247]  rtw_set_hal_ops+0x74d/0x840 [8188eu]
[   87.739003]  usb_probe_interface+0x188/0x220
[   87.739567]  driver_probe_device+0x133/0x2c0
[   87.740103]  __driver_attach+0x6f/0xa0
[   87.740652]  ? driver_probe_device+0x2c0/0x2c0
[   87.741242]  bus_for_each_dev+0x52/0x90
[   87.741768]  driver_attach+0x19/0x20
[   87.742301]  bus_add_driver+0xf0/0x1f0
[   87.742869]  driver_register+0x83/0xc0
[   87.743424]  usb_register_driver+0x7a/0x130
[   87.743951]  ? 0xffffffffa0889000
[   87.744490]  init_module+0x57/0x1000 [8188eu]
[   87.745033]  do_one_initcall+0x9a/0x170
[   87.745555]  ? __vunmap+0x88/0xb0
[   87.746025]  ? vfree+0x60/0x70
[   87.746531]  do_init_module+0x55/0x1d4
[   87.747030]  load_module+0x1b8d/0x2250
[   87.748582]  SyS_init_module+0x107/0x120
[   87.749105]  ? SyS_init_module+0x107/0x120
[   87.749630]  do_syscall_64+0x115/0x1b0
[   87.750201]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   87.750960] RIP: 0033:0x7ff17ae21fd8
[   87.751479] RSP: 002b:00007ffc50736b90 EFLAGS: 00000212 ORIG_RAX:
00000000000000af
[   87.752378] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff17ae21fd8
[   87.753486] RDX: 0000000000402b2f RSI: 0000000000274190 RDI: 00007ff17a75c020
[   87.754277] RBP: 00000000006040a0 R08: 0000000000000000 R09: 0000000000000802
[   87.755055] R10: 0000000000000000 R11: 0000000000000212 R12: 00007ff17a75c020
[   87.755783] R13: 0000000000000003 R14: 0000000000402b2f R15: 0000000000274190
[   87.756745] Code: 0f 0b bb ea ff ff ff e9 55 03 00 00 41 09 c8 4c
39 d2 75 b5 ba 01 00 00 00 49 83 c1 01 49 83 f9 03 0f 85 e5 fe ff ff
84 d2 75 0c <0f> 0b bb ea ff ff ff e9 2a 03 00 00 48 8b 87 a8 08 00 00
48 85
[   87.758561] ---[ end trace 312f56694fd4fe30 ]---
[   87.759195] ------------[ cut here ]------------
[   87.759868] WARNING: CPU: 0 PID: 1923 at
rtw_init_netdev_name+0x9d/0x1bd [8188eu]
[   87.760777] Modules linked in: 8188eu(+) ath9k_htc ath9k_common
rtl8821ae rtl8192se rtl8192de rtl8192cu rtl8192ce rtl8192c_common
rtl_usb rtl_pci rt2800usb rt2800pci rt2800mmio rt2800lib rt2500usb
rt2500pci rt2400pci pppoe ppp_async btcoexist ath9k_hw ath rtlwifi
rtl8xxxu rtl818x_pci rtl8187 rt2x00usb rt2x00pci rt2x00mmio rt2x00lib
rndis_host pppox ppp_generic nf_conntrack_ipv6 mac80211 iptable_nat
ipt_REJECT ipt_MASQUERADE cfg80211 cdc_ether xt_time xt_tcpudp
xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_conntrack
xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_FLOWOFFLOAD usbnet slhc
r8712u r8169 nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4
nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_flow_table_hw
nf_flow_table nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack
[   87.767060]  lib80211_crypt_wep lib80211_crypt_tkip
lib80211_crypt_ccmp lib80211 iptable_mangle iptable_filter ip_tables
e1000e crc_itu_t crc_ccitt compat i2c_dev ip6t_REJECT nf_reject_ipv6
nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables
x_tables igb i2c_algo_bit e1000 tun vfat fat ntfs nls_utf8
nls_iso8859_1 nls_cp437 eeprom_93cx6 xhci_plat_hcd ehci_platform xfs
libcrc32c button_hotplug ptp pps_core mii [last unloaded: 8188eu]
[   87.770726] CPU: 0 PID: 1923 Comm: modprobe Tainted: G        W
  4.14.72 #0
[   87.771595] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[   87.772892] task: ffff880006427300 task.stack: ffffc900004f8000
[   87.773635] RIP: 0010:rtw_init_netdev_name+0x9d/0x1bd [8188eu]
[   87.774276] RSP: 0018:ffffc900004fba58 EFLAGS: 00010297
[   87.775233] RAX: 0000000000000000 RBX: ffffc9000007d000 RCX: ffffffffa084ae80
[   87.776021] RDX: 0000000000000000 RSI: ffffffff81c7aee0 RDI: ffff880006bc8300
[   87.776780] RBP: ffffc900004fba88 R08: 0000000000000000 R09: 0000000000000003
[   87.777512] R10: ffffc900004fba28 R11: 0000000000000000 R12: ffffc90000080698
[   87.778236] R13: ffff880006bcc000 R14: 0000000000000000 R15: ffffffffa082a355
[   87.779013] FS:  00007ff17b05bb88(0000) GS:ffff880007c00000(0000)
knlGS:0000000000000000
[   87.779926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.780667] CR2: 00007fe4162ceb40 CR3: 00000000067e2001 CR4: 00000000000606f0
[   87.781721] Call Trace:
[   87.782163]  rtw_os_ndevs_init+0x140/0x1c6 [8188eu]
[   87.782806]  rtw_set_hal_ops+0x74d/0x840 [8188eu]
[   87.783560]  usb_probe_interface+0x188/0x220
[   87.784599]  driver_probe_device+0x133/0x2c0
[   87.785347]  __driver_attach+0x6f/0xa0
[   87.785894]  ? driver_probe_device+0x2c0/0x2c0
[   87.786485]  bus_for_each_dev+0x52/0x90
[   87.786986]  driver_attach+0x19/0x20
[   87.787644]  bus_add_driver+0xf0/0x1f0
[   87.788243]  driver_register+0x83/0xc0
[   87.788772]  usb_register_driver+0x7a/0x130
[   87.789331]  ? 0xffffffffa0889000
[   87.789827]  init_module+0x57/0x1000 [8188eu]
[   87.790411]  do_one_initcall+0x9a/0x170
[   87.790913]  ? __vunmap+0x88/0xb0
[   87.791432]  ? vfree+0x60/0x70
[   87.791881]  do_init_module+0x55/0x1d4
[   87.792424]  load_module+0x1b8d/0x2250
[   87.792965]  SyS_init_module+0x107/0x120
[   87.793532]  ? SyS_init_module+0x107/0x120
[   87.794052]  do_syscall_64+0x115/0x1b0
[   87.794595]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   87.795223] RIP: 0033:0x7ff17ae21fd8
[   87.795752] RSP: 002b:00007ffc50736b90 EFLAGS: 00000212 ORIG_RAX:
00000000000000af
[   87.796971] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff17ae21fd8
[   87.797959] RDX: 0000000000402b2f RSI: 0000000000274190 RDI: 00007ff17a75c020
[   87.798834] RBP: 00000000006040a0 R08: 0000000000000000 R09: 0000000000000802
[   87.799642] R10: 0000000000000000 R11: 0000000000000212 R12: 00007ff17a75c020
[   87.800622] R13: 0000000000000003 R14: 0000000000402b2f R15: 0000000000274190
[   87.801794] Code: 4c 8d a7 98 36 00 00 b9 20 00 00 00 48 c7 c2 53
3d 7a a0 4c 89 e6 4c 89 ef e8 c7 de d0 e0 48 89 df e8 ce cc 01 00 83
f8 01 74 07 <0f> 0b e9 8b 00 00 00 48 8b 75 d0 4c 89 ef e8 50 ff ff ff
48 8d
[   87.804052] ---[ end trace 312f56694fd4fe31 ]---
[   87.804653] ------------[ cut here ]------------
[   87.805450] WARNING: CPU: 0 PID: 1923 at
rtw_os_ndevs_init+0x145/0x1c6 [8188eu]
[   87.806309] Modules linked in: 8188eu(+) ath9k_htc ath9k_common
rtl8821ae rtl8192se rtl8192de rtl8192cu rtl8192ce rtl8192c_common
rtl_usb rtl_pci rt2800usb rt2800pci rt2800mmio rt2800lib rt2500usb
rt2500pci rt2400pci pppoe ppp_async btcoexist ath9k_hw ath rtlwifi
rtl8xxxu rtl818x_pci rtl8187 rt2x00usb rt2x00pci rt2x00mmio rt2x00lib
rndis_host pppox ppp_generic nf_conntrack_ipv6 mac80211 iptable_nat
ipt_REJECT ipt_MASQUERADE cfg80211 cdc_ether xt_time xt_tcpudp
xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_conntrack
xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_FLOWOFFLOAD usbnet slhc
r8712u r8169 nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4
nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_flow_table_hw
nf_flow_table nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack
[   87.812829]  lib80211_crypt_wep lib80211_crypt_tkip
lib80211_crypt_ccmp lib80211 iptable_mangle iptable_filter ip_tables
e1000e crc_itu_t crc_ccitt compat i2c_dev ip6t_REJECT nf_reject_ipv6
nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables
x_tables igb i2c_algo_bit e1000 tun vfat fat ntfs nls_utf8
nls_iso8859_1 nls_cp437 eeprom_93cx6 xhci_plat_hcd ehci_platform xfs
libcrc32c button_hotplug ptp pps_core mii [last unloaded: 8188eu]
[   87.816473] CPU: 0 PID: 1923 Comm: modprobe Tainted: G        W
  4.14.72 #0
[   87.817694] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[   87.819501] task: ffff880006427300 task.stack: ffffc900004f8000
[   87.820435] RIP: 0010:rtw_os_ndevs_init+0x145/0x1c6 [8188eu]
[   87.821144] RSP: 0018:ffffc900004fba98 EFLAGS: 00010297
[   87.821776] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880006bcc060
[   87.822521] RDX: ffff880006bcc060 RSI: ffffffff81c7aee0 RDI: 0000000000000000
[   87.823284] RBP: ffffc900004fbac0 R08: 0000000000000000 R09: 0000000000000003
[   87.824042] R10: ffffc900004fba28 R11: 0000000000000000 R12: ffff880006bce000
[   87.824835] R13: 0000000000000001 R14: ffffc9000007d000 R15: ffffffffa082a355
[   87.825595] FS:  00007ff17b05bb88(0000) GS:ffff880007c00000(0000)
knlGS:0000000000000000
[   87.826514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.827212] CR2: 00007fe4162ceb40 CR3: 00000000067e2001 CR4: 00000000000606f0
[   87.827977] Call Trace:
[   87.828429]  rtw_set_hal_ops+0x74d/0x840 [8188eu]
[   87.829031]  usb_probe_interface+0x188/0x220
[   87.829621]  driver_probe_device+0x133/0x2c0
[   87.830152]  __driver_attach+0x6f/0xa0
[   87.830860]  ? driver_probe_device+0x2c0/0x2c0
[   87.831519]  bus_for_each_dev+0x52/0x90
[   87.832066]  driver_attach+0x19/0x20
[   87.832695]  bus_add_driver+0xf0/0x1f0
[   87.833350]  driver_register+0x83/0xc0
[   87.834041]  usb_register_driver+0x7a/0x130
[   87.834711]  ? 0xffffffffa0889000
[   87.835240]  init_module+0x57/0x1000 [8188eu]
[   87.835839]  do_one_initcall+0x9a/0x170
[   87.836437]  ? __vunmap+0x88/0xb0
[   87.836908]  ? vfree+0x60/0x70
[   87.837404]  do_init_module+0x55/0x1d4
[   87.837938]  load_module+0x1b8d/0x2250
[   87.838473]  SyS_init_module+0x107/0x120
[   87.838980]  ? SyS_init_module+0x107/0x120
[   87.839848]  do_syscall_64+0x115/0x1b0
[   87.840396]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   87.841055] RIP: 0033:0x7ff17ae21fd8
[   87.841585] RSP: 002b:00007ffc50736b90 EFLAGS: 00000212 ORIG_RAX:
00000000000000af
[   87.842467] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff17ae21fd8
[   87.843285] RDX: 0000000000402b2f RSI: 0000000000274190 RDI: 00007ff17a75c020
[   87.844011] RBP: 00000000006040a0 R08: 0000000000000000 R09: 0000000000000802
[   87.844801] R10: 0000000000000000 R11: 0000000000000212 R12: 00007ff17a75c020
[   87.845585] R13: 0000000000000003 R14: 0000000000402b2f R15: 0000000000274190
[   87.846358] Code: 74 34 0f b6 87 c0 48 00 00 49 8d b6 93 34 00 00
84 c0 74 0d 49 8d b6 a3 34 00 00 3c 01 49 0f 45 f7 e8 fe f0 ff ff 83
f8 01 74 0b <0f> 0b 48 63 c3 4d 8d 2c c4 eb 3c 83 c3 01 eb 0c bb 00 00
00 00
[   87.848426] ---[ end trace 312f56694fd4fe32 ]---
[   88.110525] usb 1-2: reset high-speed USB device number 3 using xhci_hcd
[   88.404766] usbcore: registered new interface driver rtl8188eu
Il giorno mar 6 nov 2018 alle ore 03:27 Larry Finger
<Larry.Finger@lwfinger.net> ha scritto:
>
> On 11/5/18 5:37 AM, Menion wrote:
> > Hi all
> > I have a question about the support of RTL8188EUS chipset (which I
> > have in a TpLink 0bda:8179 usb dongle)
> > This dongle works with the wext staging driver r8188eu driver. Is it
> > meant to be supported in the rtl2xxx driver?
>
> Assuming that you mean rtl8xxxu, the answer is no. I have no idea what rtl2xxx is.
>
> If you want a cfg80211/nl80211 driver rather than the wext-based one, I am
> currently cleaning up a new driver from Realtek with the possibility of
> replacing the one now in staging with a new version. It can be obtained with the
> following command:
>
> git clone https://github.com/lwfinger/rtl8188eu.git -b v5.2.2.4
>
> This driver will definitely handle your device and has pretty good performance.
> Using a local speedtest.net-type web server, I get up to 50 Mbps down and 45
> Mbps up.
>
> The driver is undergoing fairly rapid change, but mostly to remove lots of dead
> code, thus you will not need to pull that often. It will build on any kernel
> from 4.20 back to at least 2.6.13. I am only testing on 4.20-rc1.
>
> Larry
>
