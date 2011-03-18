Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37445 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab1CRRgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 13:36:43 -0400
Received: by iwn34 with SMTP id 34so4211926iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 10:36:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik8iUxgniVHB2UBC359GxrmAxUTLGL-_eZ7Gtom@mail.gmail.com>
References: <1300416312-16808-1-git-send-email-lrodriguez@atheros.com> <AANLkTik8iUxgniVHB2UBC359GxrmAxUTLGL-_eZ7Gtom@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 10:36:23 -0700
Message-ID: <AANLkTin0vHKfdfaTf7ZPHUrGCasezPf8yeKUwdRfUNUQ@mail.gmail.com>
Subject: Re: [PATCH] ath6kl: fix device registration ordering
To: gregkh@suse.de
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, vmehta@atheros.com,
	devel@linuxdriverproject.org, naveen.singh@atheros.com,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 10:35 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Mar 17, 2011 at 7:45 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Defer device registration to cfg80211 until it is ready.
>> This fixes a race against udev whereby device events
>> (both udev and RTNL) might be emitted with an unregistered
>> device specification (wlan%d).
>>
>> This fixes a race on ath6kl on systems where the device
>> boots up really quickly to the the point udev and the
>> respective userspace daemon tries to start mucking with
>> the device prior to the device being initialized properly.
>>
>> This fixes this bug:
>>
>> http://code.google.com/p/chromium-os/issues/detail?id=13159
>>
>> Without this loading of ath6kl will fail.
>>
>> Cc: stable@kernel.org
>> Cc: Naveen Singh <naveen.singh@atheros.com>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> Please disregard this for now, I am testing ath6k right now on x86_64
> where it has a failure upon load and it oopses, likely due to this
> patch and what I believe is wiphy_unregister() being called twice.
> I'll fix the oops first and then resubmit a v2. If you do not hit a
> failure upon load though then the patch would help your issues with
> udev, but still we must handle the failure cases better. My failure
> are because I'm using an x86_64 box to test ath6kl and its buggy
> there.

FWIW the oops is:


[    7.100017] ABI Version mismatch: Host(0x1), Target(0x0)
[    7.100057] ar6000_avail: ar6000_init
[    7.100096] BUG: unable to handle kernel NULL pointer dereference at 00000004
[    7.100139] IP: [<c042a9f6>] device_pm_remove+0x26/0x50
[    7.100176] *pdpt = 0000000032244001 *pde = 0000000000000000
[    7.100212] Oops: 0002 [#1] SMP
[    7.100235] last sysfs file: /sys/kernel/uevent_seqnum
[    7.100265] Modules linked in: snd_hda_codec_hdmi
snd_hda_codec_analog radeon snd_hda_intel snd_hda_codec snd_hwdep
ath6kl(C) snd_pcm ttm drm_kms_helper snd_seq_midi drm snd_
rawmidi snd_seq_midi_event cfg80211 snd_seq snd_timer snd_seq_device
psmouse snd asus_atk0110 serio_raw joydev k10temp ati_agp soundcore
snd_page_alloc agpgart i2c_piix4 i2c_alg
o_bit lp parport usbhid hid usb_storage mmc_block pata_marvell
firewire_ohci sdhci_pci ahci sdhci sky2 floppy firewire_core crc_itu_t
libahci pata_atiixp
[    7.100596]
[    7.100607] Pid: 718, comm: AR6K startup Tainted: G         C
2.6.38-rc5+ #8 System manufacturer System Product Name/M3A79-T DELUXE
[    7.100681] EIP: 0060:[<c042a9f6>] EFLAGS: 00010286 CPU: 2
[    7.100712] EIP is at device_pm_remove+0x26/0x50
[    7.100738] EAX: f19856a4 EBX: f1985644 ECX: 00000000 EDX: 00000000
[    7.100772] ESI: f073004c EDI: f0730164 EBP: f06f7eec ESP: f06f7ee8
[    7.100806]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    7.100836] Process AR6K startup (pid: 718, ti=f06f6000
task=f214b280 task.ti=f06f6000)
[    7.100881] Stack:
[    7.100894]  f1985644 f06f7f00 c0421d2f f1985600 f073004c f07300e0
f06f7f0c c05e4589
[    7.100952]  f0730000 f06f7f40 f85073dc f06f7f10 e9bfc120 00000000
f86e1329 f06f7f40
[    7.101009]  c027f962 e9bfc120 00000000 f1984600 f07302c0 ffffffff
f06f7f58 f86a536b
[    7.101067] Call Trace:
[    7.101084]  [<c0421d2f>] device_del+0x2f/0x190
[    7.101111]  [<c05e4589>] rfkill_unregister+0x49/0xa0
[    7.101145]  [<f85073dc>] wiphy_unregister+0x2c/0x170 [cfg80211]
[    7.101181]  [<c027f962>] ? sysfs_hash_and_remove+0x72/0x80
[    7.101217]  [<f86a536b>] ar6k_cfg80211_deinit+0x4b/0x80 [ath6kl]
[    7.101255]  [<f86b382a>] ? ar6000_sysfs_bmi_deinit+0x2a/0x40 [ath6kl]
[    7.101296]  [<f86bb395>] ar6000_avail_ev+0x455/0x830 [ath6kl]
[    7.101330]  [<c014d090>] ? default_wake_function+0x10/0x20
[    7.101366]  [<f86ba830>] ? ar6000_target_failure+0x0/0x80 [ath6kl]
[    7.101406]  [<f86d4100>] ? startup_task+0x0/0x60 [ath6kl]
[    7.101440]  [<f86d4121>] startup_task+0x21/0x60 [ath6kl]
[    7.101475]  [<f86d4100>] ? startup_task+0x0/0x60 [ath6kl]
[    7.101506]  [<c0170874>] kthread+0x74/0x80
[    7.101530]  [<c0170800>] ? kthread+0x0/0x80
[    7.101555]  [<c010ad7e>] kernel_thread_helper+0x6/0x10
[    7.101584] Code: 90 8d 74 26 00 55 89 e5 53 3e 8d 74 26 00 89 c3
83 c0 68 e8 6d 5a d1 ff b8 cc 39 85 c0 e8 03 7d 1d 00 8b 4b 60 8d 43
60 8b 53 64 <89> 51 04 89 0a 89 43 60 89 43 64 b8 cc 39 85 c0 e8 75 7a
1d 00
[    7.101822] EIP: [<c042a9f6>] device_pm_remove+0x26/0x50 SS:ESP 0068:f06f7ee8
[    7.101866] CR2: 0000000000000004
[    7.101886] ---[ end trace 769975b16fdd074b ]---

  Luis
