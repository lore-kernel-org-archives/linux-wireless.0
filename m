Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F63C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 14:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CA5B206B6
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 14:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=eblau.com header.i=@eblau.com header.b="U9JPVIhx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfADOnY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 09:43:24 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44696 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfADOnY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 09:43:24 -0500
Received: by mail-ed1-f68.google.com with SMTP id y56so31923357edd.11
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2019 06:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eblau.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D8G8PdhTbqZuhVxj4+TsKuwwBK/ffKSCS0VFkO+XT6w=;
        b=U9JPVIhxSe1HwGiKOhVGKqnmM81cUdI90F8uMi4aOOCjgdHWOr7uqv/3JgHTIAj8fX
         YSMmh10IsqIA566rj7S2qzpiHYTZGYfu5w7zjMI8G9cBnacGkH0TpHxESu/VL7UA+9ka
         ltHSQCg5+lnwnpkx864WawyB2wX035FPOx7mU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D8G8PdhTbqZuhVxj4+TsKuwwBK/ffKSCS0VFkO+XT6w=;
        b=fudRpUMivgA7Sz+cMGL7jsB2c4DXgXhptVkLD10aLkbGdJntgRccos+VFjyDzpQ//M
         Grk6dQVKUs6MqH6GZzdWC0aBFMJaWk/JKkOerz25LBDwtsBo9NJADGvM5rwgG3uehT0X
         AdUxgp2DZSOzlSRKihH977UhPtPSS7pvw/LHHf7E49BYEe+EW9UdzV8IWwxgKnv16sXx
         XWqC+MI+H7qFMwKLCXtzTmdItF7LmcIWmwhyHSc1/HIcod/kWepyawNvIPfAwEWX/aJ5
         LW0ZIdY5WCMksmHk+zcfvq4vIGZZmthtftZz1MAIDG/AhkHLEkf4tkezha/P1/bgKvsE
         lcMw==
X-Gm-Message-State: AA+aEWZ4DlqT2U8wqcyN32tREsMfxjx0ZcIYFgR3De8ujkgBiIvmE6JZ
        1WJ6wASjSQk+qV+0yVOUIHl/8WiLs7ciZnzJQo7rDYk0
X-Google-Smtp-Source: AFSGD/VzVUjC8MNUC4UqOLYjaQ/tSXXkPE2vox2bAEsv8oiJD9LC36KuKPEXWILsKgIuuJWWXqTuXxJ8dtLChKuezQg=
X-Received: by 2002:a17:906:30d5:: with SMTP id b21-v6mr39948855ejb.42.1546613000582;
 Fri, 04 Jan 2019 06:43:20 -0800 (PST)
MIME-Version: 1.0
References: <CADU241NrgYUq+eEyaNXteTA+KkPgcLXRHraR9y1OZm2bYY7U3g@mail.gmail.com>
 <d3a083b8-f78d-fcf2-d27a-879eeb77b625@broadcom.com> <85706b88-85be-c27a-a1c9-57aa57f65fa9@broadcom.com>
In-Reply-To: <85706b88-85be-c27a-a1c9-57aa57f65fa9@broadcom.com>
From:   Eric Blau <eblau@eblau.com>
Date:   Fri, 4 Jan 2019 09:43:09 -0500
Message-ID: <CADU241PrOidaDR1hZOU8Fg-woocc_gNUie9Vz6pb0aRkENHphA@mail.gmail.com>
Subject: Re: nl80211 related warning w/ 4-way handshake offload and failure to associate
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 4, 2019 at 8:30 AM Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 1/4/2019 2:23 PM, Arend Van Spriel wrote:
> > On 1/3/2019 5:29 PM, Eric Blau wrote:
> >> There is an Arch Linux bug open on this with a bunch of details here:
> >>
> >> https://bugs.archlinux.org/task/61119
> >
> > The ArchLinux issue seems to be using broadcom-wl driver, while you have
> > issue with brcmfmac. Just to clarify I can only support the brcmfmac
> > driver.
>
> Looking at the original log in the ArchLinux issue, it is completely
> something else so I ignore that for now and focus on your issue.
>
> Regards,
> Arend

Thanks, Arend. I applied the patch that you sent and the resulting
warning shows "use_fwsup=0". Does this mean I should follow up with
wpa_supplicant?

I noticed that with WPA2, I can associate fine and everything works as
expected, but it fails with this warning with WPA2-Enterprise w/ PEAP
&amp; MSCHAPv2.

kernel: ------------[ cut here ]------------
kernel: use_fwsup=0
kernel: WARNING: CPU: 0 PID: 2461 at
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5132
brcmf_cfg80211_set_pmk+0x5e/0x70 [brcmfmac]
kernel: Modules linked in: asix usbnet mii libphy fuse ipt_MASQUERADE
nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat
nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c crc32c_generic
br_netfilter bridge stp llc cmac bnep sg crypto_user
snd_hda_codec_hdmi btusb btrtl btbcm btintel bluetooth ecdh_generic
crc16 input_leds joydev mousedev bcm5974 uas msr ofpart cmdlinepart
intel_spi_platform intel_spi brcmfmac spi_nor nls_iso8859_1 nls_cp437
i915 vfat fat mtd iTCO_wdt iTCO_vendor_support brcmutil intel_rapl
snd_hda_codec_cirrus snd_hda_codec_generic kvmgt vfio_mdev
snd_hda_intel mdev x86_pkg_temp_thermal vfio_iommu_type1
intel_powerclamp coretemp vfio cfg80211 kvm_intel snd_hda_codec
i2c_algo_bit kvm applesmc snd_hda_core input_polldev drm_kms_helper
irqbypass snd_hwdep intel_cstate snd_pcm intel_uncore intel_rapl_perf
mmc_core pcspkr thunderbolt lpc_ich i2c_i801 intel_pch_thermal
snd_timer mei_me snd rfkill
kernel:  spi_pxa2xx_pci mei soundcore drm acpi_als intel_gtt sbs
kfifo_buf agpgart sbshc industrialio syscopyarea sysfillrect sysimgblt
fb_sys_fops evdev apple_bl spi_pxa2xx_platform mac_hid ac pcc_cpufreq
facetimehd(OE) videobuf2_dma_sg videobuf2_memops videobuf2_v4l2
videobuf2_common videodev media ip_tables x_tables zfs(POE)
zunicode(POE) zavl(POE) icp(POE) zcommon(POE) znvpair(POE) spl(OE)
algif_skcipher af_alg hid_apple hid_generic usbhid hid dm_crypt dm_mod
sd_mod usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel ahci libahci xhci_pci aesni_intel libata xhci_hcd
aes_x86_64 crypto_simd scsi_mod cryptd glue_helper
kernel: CPU: 0 PID: 2461 Comm: wpa_supplicant Tainted: P        W  OE
   4.20.0-arch1-1-ARCH #1
kernel: Hardware name: Apple Inc. MacBookPro12,1/Mac-E43C1C25D4880AD6,
BIOS MBP121.88Z.0177.B00.1806051659 06/05/2018
kernel: RIP: 0010:brcmf_cfg80211_set_pmk+0x5e/0x70 [brcmfmac]
kernel: Code: 02 75 1b 0f b6 55 08 80 fa 20 77 28 48 8b 75 10 48 8d bb
c0 08 00 00 5b 5d e9 7e fe ff ff 48 c7 c7 84 2b 00 c1 e8 2c d6 ab c6
&lt;0f&gt; 0b b8 ea ff ff ff 5b 5d c3 b8 de ff ff ff eb f6 90 0f 1f 44
00
kernel: RSP: 0018:ffffa52401347a98 EFLAGS: 00010282
kernel: RAX: 0000000000000000 RBX: ffff968dce003000 RCX: 0000000000000000
kernel: RDX: 0000000000000007 RSI: ffffffff88aa4606 RDI: 00000000ffffffff
kernel: RBP: ffffa52401347ab0 R08: 0000000000000001 R09: 0000000000001d90
kernel: R10: 0000000000000004 R11: 0000000000000000 R12: ffff968dce002050
kernel: R13: ffff968dce003000 R14: ffff968dcf6cc000 R15: ffff968dcf6cc300
kernel: FS:  00007fe0b9da7480(0000) GS:ffff968de6a00000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007f0959aad000 CR3: 000000022dd9c001 CR4: 00000000003606f0
kernel: Call Trace:
kernel:  nl80211_set_pmk+0x178/0x270 [cfg80211]
kernel:  genl_family_rcv_msg+0x1c4/0x3c0
kernel:  ? preempt_schedule_common+0xd/0x80
kernel:  genl_rcv_msg+0x47/0x90
kernel:  ? __kmalloc_node_track_caller+0x1ed/0x290
kernel:  ? genl_family_rcv_msg+0x3c0/0x3c0
kernel:  netlink_rcv_skb+0x4c/0x120
kernel:  genl_rcv+0x24/0x40
kernel:  netlink_unicast+0x196/0x240
kernel:  netlink_sendmsg+0x1fd/0x3c0
kernel:  sock_sendmsg+0x33/0x40
kernel:  ___sys_sendmsg+0x295/0x2f0
kernel:  ? dev_get_by_name_rcu+0x73/0x90
kernel:  ? dev_ioctl+0x171/0x3d0
kernel:  ? __check_object_size+0xa0/0x189
kernel:  ? preempt_count_add+0x79/0xb0
kernel:  ? __inode_wait_for_writeback+0x7f/0xf0
kernel:  ? preempt_count_add+0x79/0xb0
kernel:  ? _raw_spin_lock+0x13/0x30
kernel:  ? _raw_spin_unlock+0x16/0x30
kernel:  ? __dentry_kill+0x116/0x160
kernel:  __sys_sendmsg+0x57/0xa0
kernel:  do_syscall_64+0x5b/0x170
kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
kernel: RIP: 0033:0x7fe0ba2defd8
kernel: Code: 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 f3
0f 1e fa 48 8d 05 65 65 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05
&lt;48&gt; 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 41 89 d4
55
kernel: RSP: 002b:00007fff882d7da8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
kernel: RAX: ffffffffffffffda RBX: 000055ef2411bfe0 RCX: 00007fe0ba2defd8
kernel: RDX: 0000000000000000 RSI: 00007fff882d7de0 RDI: 0000000000000005
kernel: RBP: 000055ef2415ff70 R08: 0000000000000004 R09: 000000000000000d
kernel: R10: 00007fff882d7eb4 R11: 0000000000000246 R12: 000055ef2411bef0
kernel: R13: 00007fff882d7de0 R14: ffffffffffffffff R15: 0000000000000000
kernel: ---[ end trace 77aa8ecbc92afdd3 ]---
