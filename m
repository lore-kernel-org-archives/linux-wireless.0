Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5F5C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA5D2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZI4TsgKZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfCTPsd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:48:33 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34025 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfCTPsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 11:48:33 -0400
Received: by mail-oi1-f193.google.com with SMTP id u12so2194543oiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2019 08:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9FTErJck/gCH+bBmdV/1jVkf4IjJLOKmUO7WX0keulo=;
        b=ZI4TsgKZ5WCbyT3nRxIC96p/UNMT4kn2WkJdFhqYdSInqFWVAMo2x5lpRbrJjs/OWZ
         XnDWOSVGnUyKT3Uwlanq3/Vr68gOpuwreo9isCo+yxzoCpDYpCe8d5rNMrNuqQl8pebk
         lJxvi5gi53u+mKUgDlbqOILWScINDOHTtfBZIN/oCmlckQ9ePBeGpd6ci571usun1c5G
         Dtlb0CWAv/4DQ3VgcwTOCCGo2AAIHPA8QnvMkgQjScEPQUpsCDrAquq4oXx1aB9Bxw7L
         toFGnypAHqhxkjwcr1tqg1N2ZodOcoKLktNJ5A9LFRQg9RTL5MyZ27XzuVegnvDwGSA6
         z3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9FTErJck/gCH+bBmdV/1jVkf4IjJLOKmUO7WX0keulo=;
        b=Vo4uss3Aq4iQ0jKhQZ3cA7HnAubIA+NLvqH9G1pzF3LO78+0pbxBGy92/MzdpdI1+J
         ECCado8PejO4Oyejs4O0WejavGdbMcjI1X4oU+byrzz5X1ze1O9ql6DuzbRj8Mtkt2Qs
         tEGVXqgu85Mk4flyKsvG/VVEmljtv1rXUs34af3K3lcCoW/ZjNx8F2+pClf933IYZF4i
         I/b0XOUf375vXvX9uSNSsFWH7y44P6Xh9hg2pGl0Q0JRXDBsHfc/5JgML7Yft1lAJkF3
         03vKmFaJ2nPGPzLUd4mb24QFiwe1hy7wz0HHB4DBT4gahXFvU77KR71tSTmJ+MLclQ5g
         EEPA==
X-Gm-Message-State: APjAAAVgeTsQ3IS42bSisNg1C8/Hx4UYyNs00NlEp15CDyOKR30LehJU
        XMLCwTrYUb1pLRPISqyV7OHZ6PrTox+CL6CU7K44Newv
X-Google-Smtp-Source: APXvYqw4WhsWRv9PNws3ulONrAquYJBQznafZNpEFYFs/P/3aQpxaM/s5t0u1QVEQdH8cXAVStdBzlzbL+qRElwBXOk=
X-Received: by 2002:aca:5757:: with SMTP id l84mr5872815oib.155.1553096910978;
 Wed, 20 Mar 2019 08:48:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Wed, 20 Mar 2019 08:48:30
 -0700 (PDT)
In-Reply-To: <2715bcef-5b03-fc19-e665-3c6f90a7d123@candelatech.com>
References: <1553025580-6118-1-git-send-email-pozega.tomislav@gmail.com> <2715bcef-5b03-fc19-e665-3c6f90a7d123@candelatech.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 20 Mar 2019 16:48:30 +0100
Message-ID: <CAKR_QVKfb5vkT1xmmEyvJzeb+VnPx8T3ZpkdLPTMx+agtSBYMg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Fix ASPM L1 state on QCA988X
To:     Ben Greear <greearb@candelatech.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 20/03/2019, Ben Greear <greearb@candelatech.com> wrote:
> On 3/19/19 12:59 PM, Tomislav Po=C5=BEega wrote:
>> On some systems there are heavy crashes if the kernel config
>> option CONFIG_PCIEASPM_PERFORMANCE is not set. Patch provided by
>> Sujith for ath9k fixes this issue and the card operates without
>> crashes with kernel default CONFIG_PCIEASPM_DEFAULT option that uses
>> BIOS provided ASPM settings. Tested with QCA9862 mPCIe card.
>
> Hello,
>
> Were these firmware crashes or system crashes or both?  Can you
> describe that a bit more so we can better understand what bugs this
> is fixing?
>
>
> Thanks,
> Ben
>

These were system crashes that rendered firmware restart feature useless.

With default kernel config pinging router took ~0.70ms and sometimes
it was possible to load some smaller web pages. Any larger page load
caused immediate crash.

Enabling kernel option CONFIG_PCIEASPM_PERFORMANCE and rebuilding
reduced ping time to the router to ~0.55ms and connection was stable.

This patch provides fix to the ASPM so that the card works fine
without forcing ASPM performance configuration. Ping to the router was
the same, about 0.55ms.

So, as Sujith already explained in his original patchwork this really
fixes L1 latency issue that impacts card communication with the host.
Here is my log from yesterday while testing, what happens without this
patch, or without CONFIG_PCIEASPM_PERFORMANCE enabled: (failed to
flush transmit queue was first message on every occasion this
happened)

Mar 19 17:09:02 ubuntu kernel: [  258.528040] ath10k_pci 0000:03:00.0:
failed to flush transmit queue (skip 0 ar-state 1): 0
Mar 19 17:09:05 ubuntu kernel: [  261.536042] ath10k_pci 0000:03:00.0:
failed to install key for vdev 0 peer 10:fe:ed:e5:73:42: -110
Mar 19 17:09:08 ubuntu kernel: [  264.544053] ath10k_pci 0000:03:00.0:
wmi command 36893 timeout, restarting hardware
Mar 19 17:09:08 ubuntu kernel: [  264.544067] ath10k_pci 0000:03:00.0:
failed to delete peer 10:fe:ed:e5:73:42 for vdev 0: -11
Mar 19 17:09:08 ubuntu kernel: [  264.544071] ath10k_pci 0000:03:00.0:
found sta peer 10:fe:ed:e5:73:42 (ptr ffff88013a466e00 id 63) entry on
vdev 0 after it was supposedly removed
Mar 19 17:09:08 ubuntu kernel: [  264.544085] ------------[ cut here
]------------
Mar 19 17:09:08 ubuntu kernel: [  264.544142] WARNING: CPU: 1 PID: 744
at net/mac80211/sta_info.c:970 __sta_info_destroy_part2+0x18b/0x190
[mac80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544151] Modules linked in:
xt_limit xt_tcpudp xt_DSCP ipt_REJECT nf_reject_ipv4 nf_conntrack_irc
nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ctr binfmt_misc vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) deflate camellia_generic cast5_generic cast_common cmac
rmd160 ccm serpent_generic blowfish_generic blowfish_x86_64
blowfish_common twofish_generic twofish_x86_64_3way xts twofish_x86_64
twofish_common xcbc sha512_generic des_generic ablk_helper cryptd lrw
gf128mul glue_helper aes_x86_64 xfrm_user ah4 esp4 xfrm4_mode_beet
xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport ipcomp
xfrm_ipcomp af_key xfrm_algo arc4 rfcomm bridge stp llc bnep
tpm_infineon snd_hda_codec_analog snd_hda_codec_generic ath3k btusb
btintel bluetooth snd_hda_intel snd_hda_codec snd_hda_core
Mar 19 17:09:08 ubuntu kernel: [  264.544207]  iptable_mangle
snd_hwdep iptable_filter snd_pcm ip_tables x_tables radeon
snd_seq_midi snd_rawmidi ttm ath10k_pci ath10k_core mac80211
drm_kms_helper snd_seq_midi_event ath psmouse snd_seq video serio_raw
drm fb_sys_fops tg3 cfg80211 snd_seq_device sysimgblt snd_timer
sysfillrect syscopyarea i2c_algo_bit ptp snd wmi rfkill pps_core
k10temp hp_accel sp5100_tco lis3lv02d soundcore i2c_piix4
input_polldev tpm_tis tpm_tis_core
Mar 19 17:09:08 ubuntu kernel: [  264.544237] CPU: 1 PID: 744 Comm:
wpa_supplicant Tainted: G           O    4.9.135 #49
Mar 19 17:09:08 ubuntu kernel: [  264.544238] Hardware name:
Hewlett-Packard HP Compaq 6735b (NA961ET#ABD)/30E3, BIOS 68GTT Ver.
F.15 10/25/2010
Mar 19 17:09:08 ubuntu kernel: [  264.544240]  ffffc900006a3a50
ffffffff81353fc6 0000000000000000 0000000000000000
Mar 19 17:09:08 ubuntu kernel: [  264.544243]  ffffc900006a3a90
ffffffff81146689 00000009a0270b13 ffff880133a9f000
Mar 19 17:09:08 ubuntu kernel: [  264.544246]  ffff880137bc0700
ffff880137c908c0 ffff880137bc0c58 ffff880137bc0c58
Mar 19 17:09:08 ubuntu kernel: [  264.544249] Call Trace:
Mar 19 17:09:08 ubuntu kernel: [  264.544258]  [<ffffffff81353fc6>]
dump_stack+0x4d/0x67
Mar 19 17:09:08 ubuntu kernel: [  264.544265]  [<ffffffff81146689>]
__warn.cold.10+0x91/0xb6
Mar 19 17:09:08 ubuntu kernel: [  264.544270]  [<ffffffff8105117d>]
warn_slowpath_null+0x1d/0x20
Mar 19 17:09:08 ubuntu kernel: [  264.544305]  [<ffffffffa0275c0b>]
__sta_info_destroy_part2+0x18b/0x190 [mac80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544341]  [<ffffffffa0275f0d>]
__sta_info_flush+0x12d/0x190 [mac80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544378]  [<ffffffffa02bc0cc>]
ieee80211_set_disassoc+0xbc/0x410 [mac80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544411]  [<ffffffffa02cf23e>]
ieee80211_mgd_deauth.cold.48+0x15e/0x1ae [mac80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544444]  [<ffffffffa0289ea8>]
ieee80211_deauth+0x18/0x20 [mac80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544494]  [<ffffffffa00d5637>]
cfg80211_mlme_deauth+0x97/0x150 [cfg80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544529]  [<ffffffffa00d99da>]
cfg80211_disconnect+0x9a/0x1f0 [cfg80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544562]  [<ffffffffa00f54f3>]
cfg80211_wext_siwmlme+0x83/0x9a [cfg80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544595]  [<ffffffffa00f5470>] ?
cfg80211_wext_siwgenie+0x120/0x120 [cfg80211]
Mar 19 17:09:08 ubuntu kernel: [  264.544600]  [<ffffffff81670991>]
ioctl_standard_iw_point+0x241/0x300
Mar 19 17:09:08 ubuntu kernel: [  264.544602]  [<ffffffff81670af7>]
ioctl_standard_call+0xa7/0xb0
Mar 19 17:09:08 ubuntu kernel: [  264.544606]  [<ffffffff812cec1e>] ?
security_capable+0x4e/0x70
Mar 19 17:09:08 ubuntu kernel: [  264.544613]  [<ffffffff81670a50>] ?
ioctl_standard_iw_point+0x300/0x300
Mar 19 17:09:08 ubuntu kernel: [  264.544618]  [<ffffffff81670739>]
wireless_process_ioctl.constprop.12+0xd9/0xf0
Mar 19 17:09:08 ubuntu kernel: [  264.544623]  [<ffffffff81670c32>]
wext_handle_ioctl+0x62/0xa0
Mar 19 17:09:08 ubuntu kernel: [  264.544625]  [<ffffffff815db7aa>]
dev_ioctl+0x2aa/0x5d0
Mar 19 17:09:08 ubuntu kernel: [  264.544629]  [<ffffffff811b88d6>] ?
do_readv_writev+0x196/0x260
Mar 19 17:09:08 ubuntu kernel: [  264.544632]  [<ffffffff815a1908>]
sock_ioctl+0x98/0x280
Mar 19 17:09:08 ubuntu kernel: [  264.544635]  [<ffffffff811cc8f9>]
do_vfs_ioctl+0x99/0x5d0
Mar 19 17:09:08 ubuntu kernel: [  264.544637]  [<ffffffff811cceaa>]
SyS_ioctl+0x7a/0x90
Mar 19 17:09:08 ubuntu kernel: [  264.544640]  [<ffffffff81002a61>]
do_syscall_64+0x61/0xc0
Mar 19 17:09:08 ubuntu kernel: [  264.544643]  [<ffffffff8168977e>]
entry_SYSCALL_64_after_swapgs+0x58/0xc6
Mar 19 17:09:08 ubuntu kernel: [  264.544646] ---[ end trace
9403fa149caf04b7 ]---
Mar 19 17:09:08 ubuntu kernel: [  264.556724] ath10k_pci 0000:03:00.0:
failed to read hi_board_data address: -16
Mar 19 17:09:14 ubuntu kernel: [  270.595420] ath10k_pci 0000:03:00.0:
failed to wait for target init: -110
Mar 19 17:09:14 ubuntu kernel: [  270.600649] ieee80211 phy0: Hardware
restart was requested
Mar 19 17:09:14 ubuntu kernel: [  270.600691] ath10k_pci 0000:03:00.0:
failed to recalculate rts/cts prot for vdev 0: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600695] ath10k_pci 0000:03:00.0:
failed to set cts protection for vdev 0: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600698] ath10k_pci 0000:03:00.0:
failed to set erp slot for vdev 0: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600701] ath10k_pci 0000:03:00.0:
failed to set preamble for vdev 0: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600704] ath10k_pci 0000:03:00.0:
failed to down vdev 0: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600710] ath10k_pci 0000:03:00.0:
failed to set wmm params: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600712] ath10k_pci 0000:03:00.0:
failed to set wmm params: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600714] ath10k_pci 0000:03:00.0:
failed to set wmm params: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600717] ath10k_pci 0000:03:00.0:
failed to set wmm params: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600722] ath10k_pci 0000:03:00.0:
failed to stop WMI vdev 0: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600724] ath10k_pci 0000:03:00.0:
failed to stop vdev 0: -108
Mar 19 17:09:14 ubuntu kernel: [  270.600734] ath10k_pci 0000:03:00.0:
failed to flush transmit queue (skip 1 ar-state 2): 5000
Mar 19 17:09:20 ubuntu kernel: [  276.645402] ath10k_pci 0000:03:00.0:
failed to wait for target init: -110
Mar 19 17:09:20 ubuntu kernel: [  276.645405] ath10k_pci 0000:03:00.0:
failed to warm reset attempt 1 of 3: -110
Mar 19 17:09:27 ubuntu kernel: [  282.780276] ath10k_pci 0000:03:00.0:
failed to wait for target init: -110
Mar 19 17:09:27 ubuntu kernel: [  282.780278] ath10k_pci 0000:03:00.0:
failed to warm reset attempt 2 of 3: -110
Mar 19 17:09:33 ubuntu kernel: [  288.818402] ath10k_pci 0000:03:00.0:
failed to wait for target init: -110
Mar 19 17:09:33 ubuntu kernel: [  288.818404] ath10k_pci 0000:03:00.0:
failed to warm reset attempt 3 of 3: -110
Mar 19 17:09:36 ubuntu kernel: [  291.863324] ath10k_pci 0000:03:00.0:
failed to wait for target after cold reset: -110
Mar 19 17:09:36 ubuntu kernel: [  291.863339] ------------[ cut here
]------------
Mar 19 17:09:36 ubuntu kernel: [  291.863393] WARNING: CPU: 1 PID: 38
at net/mac80211/util.c:1863 ieee80211_reconfig+0x7a/0x1340 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.863394] Hardware became
unavailable during restart.
Mar 19 17:09:36 ubuntu kernel: [  291.863395] Modules linked in:
xt_limit xt_tcpudp xt_DSCP ipt_REJECT nf_reject_ipv4 nf_conntrack_irc
nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ctr binfmt_misc vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) deflate camellia_generic cast5_generic cast_common cmac
rmd160 ccm serpent_generic blowfish_generic blowfish_x86_64
blowfish_common twofish_generic twofish_x86_64_3way xts twofish_x86_64
twofish_common xcbc sha512_generic des_generic ablk_helper cryptd lrw
gf128mul glue_helper aes_x86_64 xfrm_user ah4 esp4 xfrm4_mode_beet
xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport ipcomp
xfrm_ipcomp af_key xfrm_algo arc4 rfcomm bridge stp llc bnep
tpm_infineon snd_hda_codec_analog snd_hda_codec_generic ath3k btusb
btintel bluetooth snd_hda_intel snd_hda_codec snd_hda_core
Mar 19 17:09:36 ubuntu kernel: [  291.863439]  iptable_mangle
snd_hwdep iptable_filter snd_pcm ip_tables x_tables radeon
snd_seq_midi snd_rawmidi ttm ath10k_pci ath10k_core mac80211
drm_kms_helper snd_seq_midi_event ath psmouse snd_seq video serio_raw
drm fb_sys_fops tg3 cfg80211 snd_seq_device sysimgblt snd_timer
sysfillrect syscopyarea i2c_algo_bit ptp snd wmi rfkill pps_core
k10temp hp_accel sp5100_tco lis3lv02d soundcore i2c_piix4
input_polldev tpm_tis tpm_tis_core
Mar 19 17:09:36 ubuntu kernel: [  291.863468] CPU: 1 PID: 38 Comm:
kworker/1:1 Tainted: G        W  O    4.9.135 #49
Mar 19 17:09:36 ubuntu kernel: [  291.863470] Hardware name:
Hewlett-Packard HP Compaq 6735b (NA961ET#ABD)/30E3, BIOS 68GTT Ver.
F.15 10/25/2010
Mar 19 17:09:36 ubuntu kernel: [  291.863502] Workqueue:
events_freezable ieee80211_restart_work [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.863504]  ffffc90000167cf0
ffffffff81353fc6 ffffc90000167d40 0000000000000000
Mar 19 17:09:36 ubuntu kernel: [  291.863507]  ffffc90000167d30
ffffffff81146689 00000009816862dc ffff880137bc0f88
Mar 19 17:09:36 ubuntu kernel: [  291.863510]  ffff880137bc0f88
ffff880137bc0700 ffff880137bc0700 00000000ffffff92
Mar 19 17:09:36 ubuntu kernel: [  291.863513] Call Trace:
Mar 19 17:09:36 ubuntu kernel: [  291.863519]  [<ffffffff81353fc6>]
dump_stack+0x4d/0x67
Mar 19 17:09:36 ubuntu kernel: [  291.863523]  [<ffffffff81146689>]
__warn.cold.10+0x91/0xb6
Mar 19 17:09:36 ubuntu kernel: [  291.863526]  [<ffffffff810510ff>]
warn_slowpath_fmt+0x4f/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.863558]  [<ffffffffa0270515>] ?
drv_start+0x45/0x110 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.863591]  [<ffffffffa02a249a>]
ieee80211_reconfig+0x7a/0x1340 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.863596]  [<ffffffff810b51cb>] ?
try_to_del_timer_sync+0x4b/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.863627]  [<ffffffffa026d847>]
ieee80211_restart_work+0xa7/0xe0 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.863631]  [<ffffffff8106a5fa>]
process_one_work+0x1fa/0x460
Mar 19 17:09:36 ubuntu kernel: [  291.863633]  [<ffffffff8106ac62>]
worker_thread+0x32/0x4e0
Mar 19 17:09:36 ubuntu kernel: [  291.863635]  [<ffffffff8106ac30>] ?
rescuer_thread+0x3d0/0x3d0
Mar 19 17:09:36 ubuntu kernel: [  291.863638]  [<ffffffff8106f9b9>]
kthread+0xd9/0xf0
Mar 19 17:09:36 ubuntu kernel: [  291.863641]  [<ffffffff81689884>] ?
__switch_to_asm+0x24/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.863644]  [<ffffffff8106f8e0>] ?
kthread_park+0x60/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.863646]  [<ffffffff81689914>]
ret_from_fork+0x54/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.863648] ---[ end trace
9403fa149caf04b8 ]---
Mar 19 17:09:36 ubuntu kernel: [  291.864616] ------------[ cut here
]------------
Mar 19 17:09:36 ubuntu kernel: [  291.864663] WARNING: CPU: 1 PID: 38
at net/mac80211/driver-ops.h:17 drv_remove_interface+0x10c/0x120
[mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.864680] wlan6:  Failed
check-sdata-in-driver check, flags: 0x4
Mar 19 17:09:36 ubuntu kernel: [  291.864680] Modules linked in:
xt_limit xt_tcpudp xt_DSCP ipt_REJECT nf_reject_ipv4 nf_conntrack_irc
nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ctr binfmt_misc vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) deflate camellia_generic cast5_generic cast_common cmac
rmd160 ccm serpent_generic blowfish_generic blowfish_x86_64
blowfish_common twofish_generic twofish_x86_64_3way xts twofish_x86_64
twofish_common xcbc sha512_generic des_generic ablk_helper cryptd lrw
gf128mul glue_helper aes_x86_64 xfrm_user ah4 esp4 xfrm4_mode_beet
xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport ipcomp
xfrm_ipcomp af_key xfrm_algo arc4 rfcomm bridge stp llc bnep
tpm_infineon snd_hda_codec_analog snd_hda_codec_generic ath3k btusb
btintel bluetooth snd_hda_intel snd_hda_codec snd_hda_core
Mar 19 17:09:36 ubuntu kernel: [  291.864742]  iptable_mangle
snd_hwdep iptable_filter snd_pcm ip_tables x_tables radeon
snd_seq_midi snd_rawmidi ttm ath10k_pci ath10k_core mac80211
drm_kms_helper snd_seq_midi_event ath psmouse snd_seq video serio_raw
drm fb_sys_fops tg3 cfg80211 snd_seq_device sysimgblt snd_timer
sysfillrect syscopyarea i2c_algo_bit ptp snd wmi rfkill pps_core
k10temp hp_accel sp5100_tco lis3lv02d soundcore i2c_piix4
input_polldev tpm_tis tpm_tis_core
Mar 19 17:09:36 ubuntu kernel: [  291.864778] CPU: 1 PID: 38 Comm:
kworker/1:1 Tainted: G        W  O    4.9.135 #49
Mar 19 17:09:36 ubuntu kernel: [  291.864779] Hardware name:
Hewlett-Packard HP Compaq 6735b (NA961ET#ABD)/30E3, BIOS 68GTT Ver.
F.15 10/25/2010
Mar 19 17:09:36 ubuntu kernel: [  291.864810] Workqueue:
events_freezable ieee80211_restart_work [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.864812]  ffffc90000167b58
ffffffff81353fc6 ffffc90000167ba8 0000000000000000
Mar 19 17:09:36 ubuntu kernel: [  291.864815]  ffffc90000167b98
ffffffff81146689 0000000900167b68 ffff880137c90c88
Mar 19 17:09:36 ubuntu kernel: [  291.864818]  ffff880137bc0fe8
ffff880137bc0700 ffff880137c91410 ffff880137bc0700
Mar 19 17:09:36 ubuntu kernel: [  291.864820] Call Trace:
Mar 19 17:09:36 ubuntu kernel: [  291.864824]  [<ffffffff81353fc6>]
dump_stack+0x4d/0x67
Mar 19 17:09:36 ubuntu kernel: [  291.864827]  [<ffffffff81146689>]
__warn.cold.10+0x91/0xb6
Mar 19 17:09:36 ubuntu kernel: [  291.864830]  [<ffffffff810510ff>]
warn_slowpath_fmt+0x4f/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.864833]  [<ffffffff815aa229>] ?
skb_dequeue+0x59/0x70
Mar 19 17:09:36 ubuntu kernel: [  291.864864]  [<ffffffffa0270a6c>]
drv_remove_interface+0x10c/0x120 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.864897]  [<ffffffffa0284d92>]
ieee80211_do_stop+0x552/0x860 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.864900]  [<ffffffff8168943a>] ?
_raw_spin_unlock_bh+0x1a/0x20
Mar 19 17:09:36 ubuntu kernel: [  291.864933]  [<ffffffffa02850ba>]
ieee80211_stop+0x1a/0x20 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.864935]  [<ffffffff815ba7fd>]
__dev_close_many+0x8d/0xc0
Mar 19 17:09:36 ubuntu kernel: [  291.864937]  [<ffffffff815ba8ad>]
dev_close_many+0x7d/0x110
Mar 19 17:09:36 ubuntu kernel: [  291.864940]  [<ffffffff815bc7eb>]
dev_close.part.96+0x3b/0x50
Mar 19 17:09:36 ubuntu kernel: [  291.864942]  [<ffffffff815bc81a>]
dev_close+0x1a/0x20
Mar 19 17:09:36 ubuntu kernel: [  291.864995]  [<ffffffffa00abdcb>]
cfg80211_shutdown_all_interfaces+0x7b/0xa0 [cfg80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865028]  [<ffffffffa029ff22>]
ieee80211_handle_reconfig_failure+0x92/0xa0 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865062]  [<ffffffffa02a24a2>]
ieee80211_reconfig+0x82/0x1340 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865066]  [<ffffffff810b51cb>] ?
try_to_del_timer_sync+0x4b/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865097]  [<ffffffffa026d847>]
ieee80211_restart_work+0xa7/0xe0 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865100]  [<ffffffff8106a5fa>]
process_one_work+0x1fa/0x460
Mar 19 17:09:36 ubuntu kernel: [  291.865103]  [<ffffffff8106ac62>]
worker_thread+0x32/0x4e0
Mar 19 17:09:36 ubuntu kernel: [  291.865105]  [<ffffffff8106ac30>] ?
rescuer_thread+0x3d0/0x3d0
Mar 19 17:09:36 ubuntu kernel: [  291.865108]  [<ffffffff8106f9b9>]
kthread+0xd9/0xf0
Mar 19 17:09:36 ubuntu kernel: [  291.865110]  [<ffffffff81689884>] ?
__switch_to_asm+0x24/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865112]  [<ffffffff8106f8e0>] ?
kthread_park+0x60/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865114]  [<ffffffff81689914>]
ret_from_fork+0x54/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865171] ---[ end trace
9403fa149caf04b9 ]---
Mar 19 17:09:36 ubuntu kernel: [  291.865178] ------------[ cut here
]------------
Mar 19 17:09:36 ubuntu kernel: [  291.865210] WARNING: CPU: 1 PID: 38
at net/mac80211/driver-ops.c:39 drv_stop+0xf8/0x100 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865211] Modules linked in:
xt_limit xt_tcpudp xt_DSCP ipt_REJECT nf_reject_ipv4 nf_conntrack_irc
nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ctr binfmt_misc vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) deflate camellia_generic cast5_generic cast_common cmac
rmd160 ccm serpent_generic blowfish_generic blowfish_x86_64
blowfish_common twofish_generic twofish_x86_64_3way xts twofish_x86_64
twofish_common xcbc sha512_generic des_generic ablk_helper cryptd lrw
gf128mul glue_helper aes_x86_64 xfrm_user ah4 esp4 xfrm4_mode_beet
xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport ipcomp
xfrm_ipcomp af_key xfrm_algo arc4 rfcomm bridge stp llc bnep
tpm_infineon snd_hda_codec_analog snd_hda_codec_generic ath3k btusb
btintel bluetooth snd_hda_intel snd_hda_codec snd_hda_core
Mar 19 17:09:36 ubuntu kernel: [  291.865243]  iptable_mangle
snd_hwdep iptable_filter snd_pcm ip_tables x_tables radeon
snd_seq_midi snd_rawmidi ttm ath10k_pci ath10k_core mac80211
drm_kms_helper snd_seq_midi_event ath psmouse snd_seq video serio_raw
drm fb_sys_fops tg3 cfg80211 snd_seq_device sysimgblt snd_timer
sysfillrect syscopyarea i2c_algo_bit ptp snd wmi rfkill pps_core
k10temp hp_accel sp5100_tco lis3lv02d soundcore i2c_piix4
input_polldev tpm_tis tpm_tis_core
Mar 19 17:09:36 ubuntu kernel: [  291.865265] CPU: 1 PID: 38 Comm:
kworker/1:1 Tainted: G        W  O    4.9.135 #49
Mar 19 17:09:36 ubuntu kernel: [  291.865266] Hardware name:
Hewlett-Packard HP Compaq 6735b (NA961ET#ABD)/30E3, BIOS 68GTT Ver.
F.15 10/25/2010
Mar 19 17:09:36 ubuntu kernel: [  291.865296] Workqueue:
events_freezable ieee80211_restart_work [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865298]  ffffc90000167b98
ffffffff81353fc6 0000000000000000 0000000000000000
Mar 19 17:09:36 ubuntu kernel: [  291.865300]  ffffc90000167bd8
ffffffff81146689 0000000900167ba0 ffff880137bc0700
Mar 19 17:09:36 ubuntu kernel: [  291.865303]  ffff880137bc0fe8
0000000000000000 ffff880137c91410 ffff880137bc0700
Mar 19 17:09:36 ubuntu kernel: [  291.865305] Call Trace:
Mar 19 17:09:36 ubuntu kernel: [  291.865308]  [<ffffffff81353fc6>]
dump_stack+0x4d/0x67
Mar 19 17:09:36 ubuntu kernel: [  291.865310]  [<ffffffff81146689>]
__warn.cold.10+0x91/0xb6
Mar 19 17:09:36 ubuntu kernel: [  291.865312]  [<ffffffff8105117d>]
warn_slowpath_null+0x1d/0x20
Mar 19 17:09:36 ubuntu kernel: [  291.865343]  [<ffffffffa02706d8>]
drv_stop+0xf8/0x100 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865377]  [<ffffffffa02a2413>]
ieee80211_stop_device+0x43/0x50 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865410]  [<ffffffffa0284dbf>]
ieee80211_do_stop+0x57f/0x860 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865412]  [<ffffffff8168943a>] ?
_raw_spin_unlock_bh+0x1a/0x20
Mar 19 17:09:36 ubuntu kernel: [  291.865450]  [<ffffffffa02850ba>]
ieee80211_stop+0x1a/0x20 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865455]  [<ffffffff815ba7fd>]
__dev_close_many+0x8d/0xc0
Mar 19 17:09:36 ubuntu kernel: [  291.865460]  [<ffffffff815ba8ad>]
dev_close_many+0x7d/0x110
Mar 19 17:09:36 ubuntu kernel: [  291.865465]  [<ffffffff815bc7eb>]
dev_close.part.96+0x3b/0x50
Mar 19 17:09:36 ubuntu kernel: [  291.865469]  [<ffffffff815bc81a>]
dev_close+0x1a/0x20
Mar 19 17:09:36 ubuntu kernel: [  291.865501]  [<ffffffffa00abdcb>]
cfg80211_shutdown_all_interfaces+0x7b/0xa0 [cfg80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865537]  [<ffffffffa029ff22>]
ieee80211_handle_reconfig_failure+0x92/0xa0 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865573]  [<ffffffffa02a24a2>]
ieee80211_reconfig+0x82/0x1340 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865579]  [<ffffffff810b51cb>] ?
try_to_del_timer_sync+0x4b/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865612]  [<ffffffffa026d847>]
ieee80211_restart_work+0xa7/0xe0 [mac80211]
Mar 19 17:09:36 ubuntu kernel: [  291.865617]  [<ffffffff8106a5fa>]
process_one_work+0x1fa/0x460
Mar 19 17:09:36 ubuntu kernel: [  291.865622]  [<ffffffff8106ac62>]
worker_thread+0x32/0x4e0
Mar 19 17:09:36 ubuntu kernel: [  291.865627]  [<ffffffff8106ac30>] ?
rescuer_thread+0x3d0/0x3d0
Mar 19 17:09:36 ubuntu kernel: [  291.865632]  [<ffffffff8106f9b9>]
kthread+0xd9/0xf0
Mar 19 17:09:36 ubuntu kernel: [  291.865638]  [<ffffffff81689884>] ?
__switch_to_asm+0x24/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865643]  [<ffffffff8106f8e0>] ?
kthread_park+0x60/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865645]  [<ffffffff81689914>]
ret_from_fork+0x54/0x60
Mar 19 17:09:36 ubuntu kernel: [  291.865647] ---[ end trace
9403fa149caf04ba ]---
