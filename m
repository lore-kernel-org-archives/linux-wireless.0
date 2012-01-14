Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50836 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2ANVhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jan 2012 16:37:20 -0500
Received: by dady25 with SMTP id y25so923488dad.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jan 2012 13:37:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHBVuDKNjSQz9w3PPBRBDMb5Wvf_O0JW_tYLKo1VYufi6M-fJg@mail.gmail.com>
References: <CAHBVuDKNjSQz9w3PPBRBDMb5Wvf_O0JW_tYLKo1VYufi6M-fJg@mail.gmail.com>
From: =?UTF-8?B?0JTQttC+0L3QsNGC0LDQvSDQktCw0YjQuNC90LPRgtC+0L0=?=
	<dzhonw@mail.ru>
Date: Sat, 14 Jan 2012 16:36:59 -0500
Message-ID: <CAHBVuDKJ7pytj8FT5FYpabUXEc0RfBE4J7WtKsw8cMgnNPTbiw@mail.gmail.com> (sfid-20120114_223725_395995_30147FAC)
Subject: Re: BCM4313 troubles and backtrace
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a quick follow-up with some extra information.

The brcmsmac driver was working fairly well for a while.  I began
transferring a large file over the connection (with rsync), and after
about 9MB, I got the following error:

ieee80211 phy0: brcms_c_prec_enq_head: No where to go, prec == 4
(repeated another 11 times)

at which point it claimed to transfer another ~200KB, but then I got:

ieee80211 phy0: brcms_c_dotxstatus: INTERMEDIATE but not AMPDU
(repeated once more)

And nothing more was transferred and the connection was hung.
However, it maintained association to the AP and everything else about
the connection looked fine.  The network mostly did not respond after
that, though I could occasionally get a ping through to other local
computers.

-- 
Jonathan

On 14 January 2012 14:02, Джонатан Вашингтон <dzhonw@mail.ru> wrote:
> I have a BCM4313 wireless card (14e4:4727) in an Acer Aspire One 722
> (dual core, 64bit).
>
> With my kernel's default brcmsmac driver, the system freezes after
> associating with an AP.  With the wl driver, the card is not detected.
>  With a bleeding edge brcmsmac driver, the system doesn't freeze, but
> connectivity drops out (while staying associated with the AP)
> frequently for long periods of time, allowing only a few KB of traffic
> with the network at a time.
>
> I get a number of warnings in dmesg and an *occasional* kernel
> backtrace.  Below is a backtrace, and attached is a full dmesg, I
> believe from the same boot.  You can see by the dmesg that I've tried
> a number of things; please ignore parts irrelevant to this issue.
>
>
>
> WARNING: at /home/blank/debian/kernel/release/linux-2.6/linux-2.6-3.2~rc7/debian/build/source_amd64_none/net/wireless/mlme.c:366
> cfg80211_send_assoc_timeout+0x103/0x105 [cfg80211]()
> Hardware name: AO722
> Modules linked in: cryptd aes_x86_64 aes_generic bcma(O) powernow_k8
> mperf cpufreq_powersave cpufreq_userspace cpufreq_conservative
> cpufreq_stats parport_pc ppdev lp parport binfmt_misc uinput fuse nfsd
> nfs lockd fscache auth_rpcgss nfs_acl sunrpc xfs ext2 loop joydev
> snd_hda_codec_conexant snd_hda_codec_hdmi uvcvideo videodev media
> v4l2_compat_ioctl32 ums_realtek usb_storage uas arc4 snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device
> radeon ttm sp5100_tco drm_kms_helper brcmsmac i2c_piix4 mac80211 drm
> acer_wmi brcmutil sparse_keymap ohci_hcd cfg80211 snd psmouse crc8
> ehci_hcd usbcore soundcore pcspkr cordic usb_common i2c_algo_bit
> serio_raw i2c_core k10temp evdev ac rfkill snd_page_alloc battery
> power_supply wmi button video processor thermal_sys ext4 mbcache jbd2
> crc16 sd_mod crc_t10dif ahci libahci libata scsi_mod [last unloaded:
> atl1c]
> Pid: 17725, comm: kworker/u:2 Tainted: G        W  O 3.2.0-rc7-amd64 #1
> Call Trace:
>  [<ffffffff810457ed>] ? warn_slowpath_common+0x78/0x8c
>  [<ffffffffa0204882>] ? cfg80211_send_assoc_timeout+0x103/0x105 [cfg80211]
>  [<ffffffff81338d69>] ? __mutex_unlock_slowpath+0x29/0x2f
>  [<ffffffffa0268244>] ? ieee80211_assoc_done+0x47/0x1a4 [mac80211]
>  [<ffffffff8103f908>] ? select_task_rq_fair+0x39f/0x67e
>  [<ffffffff810506e7>] ? usleep_range+0x3e/0x3e
>  [<ffffffff8133984b>] ? _raw_spin_lock_bh+0xe/0x1c
>  [<ffffffff81013509>] ? paravirt_read_tsc+0x5/0x8
>  [<ffffffff81013965>] ? native_sched_clock+0x27/0x2f
>  [<ffffffff81013972>] ? sched_clock+0x5/0x8
>  [<ffffffff81062608>] ? sched_clock_local+0xd/0x6f
>  [<ffffffff81026990>] ? _flat_send_IPI_mask+0x68/0x78
>  [<ffffffff8103e3d3>] ? try_to_wake_up+0x187/0x197
>  [<ffffffffa026a6ad>] ? ieee80211_work_work+0x1006/0x1065 [mac80211]
>  [<ffffffff81036e14>] ? set_next_entity+0x32/0x55
>  [<ffffffff8100d027>] ? load_TLS+0x7/0xa
>  [<ffffffff8100d617>] ? __switch_to+0xc1/0x20e
>  [<ffffffffa02696a7>] ? free_work+0xe/0xe [mac80211]
>  [<ffffffff81059d95>] ? process_one_work+0x163/0x284
>  [<ffffffff8105ad5d>] ? worker_thread+0xc2/0x145
>  [<ffffffff8105ac9b>] ? manage_workers.isra.23+0x15b/0x15b
>  [<ffffffff8105de99>] ? kthread+0x76/0x7e
>  [<ffffffff813407f4>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff8105de23>] ? kthread_worker_fn+0x139/0x139
>  [<ffffffff813407f0>] ? gs_change+0x13/0x13
> ---[ end trace efce98d16f124c84 ]---
>
>
> --
> Jonathan
