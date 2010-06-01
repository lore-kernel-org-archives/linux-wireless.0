Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0FAT7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 15:59:38 -0400
Received: by fxm8 with SMTP id 8so1320442fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 12:59:37 -0700 (PDT)
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1275419000.5225.0.camel@abhi-desktop>
References: <1275395142.14385.6.camel@maxim-laptop>
	 <1275404221.2839.2.camel@maxim-laptop>
	 <AANLkTinmjlukRABwWWVuO6VRHrULcqB7Zk_HQZSDicKr@mail.gmail.com>
	 <1275419000.5225.0.camel@abhi-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:59:28 +0300
Message-ID: <1275422368.2574.14.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 12:03 -0700, Abhijeet Kolekar wrote: 
> Hello,
>    Please check the following version of the patch.
> 
> Abhijeet
> On Tue, 2010-06-01 at 08:21 -0700, Sedat Dilek wrote:
> > Hi Maxim,
> > 
> > that's a known issue... and there were several mails to LKML and here
> > on the ML (as I see you are very active on both lists :-)).
> > Unfortunately, the patch in [1] didnt go into any (GIT) reposoitory. I know.
> > 
> > I am attaching the original patch and give it a meaningfull name, so
> > people see it on patchwork.kernel.org (linux-wireless).
> > 
> > Kind Regards,
> > - Sedat -
> > 
> > [1] http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208
> > 
> > On Tue, Jun 1, 2010 at 4:57 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > On Tue, 2010-06-01 at 15:25 +0300, Maxim Levitsky wrote:
> > >> Hi,
> > >>
> > >> in 2.6.35-rc1 the wireless became just unusable.
> > >>
> > >> These are problems that I have:
> > >>
> > >> 1. very frequent oopses.This appears to be mention on the list already,
> > >> but patches I tried don't help.
> > >>
> > >> I currently use this bandaid patch, and I still get some crashes:
> > >
> > >
> > > The crash happens here:
> > >
> > > 0xec3d is in iwl3945_request_scan (/home/maxim/software/kernel/linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c:1878).
> > > 1873                    if (chan->band != band)
> > > 1874                            continue;
> > > 1875
> > > 1876                    scan_ch->channel = chan->hw_value;
> > > 1877
> > > 1878                    ch_info = iwl_get_channel_info(priv, band, scan_ch->channel);
> > > 1879                    if (!is_channel_valid(ch_info)) {
> > > 1880                            IWL_DEBUG_SCAN(priv, "Channel %d is INVALID for this band.\n",
> > > 1881                                           scan_ch->channel);
> > > 1882                            continue;
> > >
> > >
> > > The backtrace:
> > >
> > > <1>[14212.708840] BUG: unable to handle kernel paging request at 00000002ffffffb1
> > > <1>[14212.709870] IP: [<ffffffffa0305c0d>] iwl3945_request_scan+0x61d/0xf90 [iwl3945]
> > > <4>[14212.710763] PGD 0
> > > <0>[14212.711636] Oops: 0000 [#1] PREEMPT SMP
> > > <0>[14212.712519] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/hwmon/hwmon1/temp1_input
> > > <4>[14212.713416] CPU 0
> > > <4>[14212.713432] Modules linked in: tg3 libphy iwl3945 iwlcore mac80211 cfg80211 ntfs vfat msdos fat lirc_ene0100 lirc_dev af_packet nfsd exportfs nfs lockd nfs_acl auth_rpcgss usb_storage usb_libusual cpufreq_powersave cpufreq_conservative r852 snd_hda_codec_realtek uvcvideo sm_common cpufreq_userspace acpi_cpufreq snd_hda_intel videodev mperf nand snd_hda_codec nand_ids sdhci_pci iTCO_wdt v4l2_compat_ioctl32 joydev snd_hwdep nand_ecc uhci_hcd sunrpc iTCO_vendor_support sdhci ehci_hcd psmouse snd_pcm mmc_core mtd usbcore coretemp ac sg battery evdev serio_raw snd_page_alloc video nouveau ttm drm_kms_helper drm i2c_algo_bit [last unloaded: cfg80211]
> > > <4>[14212.718797]
> > > <4>[14212.718797] Pid: 4263, comm: iwl3945 Not tainted 2.6.35-rc1 #30 Nettiling/Aspire 5720
> > > <4>[14212.718797] RIP: 0010:[<ffffffffa0305c0d>]  [<ffffffffa0305c0d>] iwl3945_request_scan+0x61d/0xf90 [iwl3945]
> > > <4>[14212.718797] RSP: 0018:ffff88006ce91c80  EFLAGS: 00010297
> > > <4>[14212.718797] RAX: ffff880066e74100 RBX: ffff88001b2c1dc0 RCX: 00000002ffffffb1
> > > <4>[14212.718797] RDX: 0000000000000000 RSI: 00000000ffff8800 RDI: ffff88001b2c1dc0
> > > <4>[14212.718797] RBP: ffff88006ce91d70 R08: 000000000000030e R09: 00000000ffffffff
> > > <4>[14212.718797] R10: 0000000000000058 R11: 0000000000000001 R12: 0000000000000000
> > > <4>[14212.718797] R13: ffff88001b295800 R14: 0000000000000000 R15: ffff88001b2958f2
> > > <4>[14212.718797] FS:  0000000000000000(0000) GS:ffff880002400000(0000) knlGS:0000000000000000
> > > <4>[14212.718797] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > <4>[14212.718797] CR2: 00000002ffffffb1 CR3: 000000000155b000 CR4: 00000000000006f0
> > > <4>[14212.718797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > <4>[14212.718797] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > <4>[14212.718797] Process iwl3945 (pid: 4263, threadinfo ffff88006ce90000, task ffff88006d04a280)
> > > <0>[14212.718797] Stack:
> > > <4>[14212.718797]  ffffffffa02c3810 ffff88006d04a2f0 ffff88006ce91cb0 ffffffff81036911
> > > <4>[14212.718797] <0> 0000000000000000 0000000000000001 ffff88006ce91cd0 ffffffff00000000
> > > <4>[14212.718797] <0> 0057000000000246 0000005800000021 ffff88006ce91fd8 0058ffff813a07bf
> > > <0>[14212.718797] Call Trace:
> > > <4>[14212.718797]  [<ffffffffa02c3810>] ? iwl_bg_start_internal_scan+0x0/0x3d0 [iwlcore]
> > > <4>[14212.718797]  [<ffffffff81036911>] ? get_parent_ip+0x11/0x50
> > > <4>[14212.718797]  [<ffffffffa02c3810>] ? iwl_bg_start_internal_scan+0x0/0x3d0 [iwlcore]
> > > <4>[14212.718797]  [<ffffffffa02c3b2a>] iwl_bg_start_internal_scan+0x31a/0x3d0 [iwlcore]
> > > <4>[14212.718797]  [<ffffffff81056dfe>] ? worker_thread+0x1ce/0x390
> > > <4>[14212.718797]  [<ffffffff81056e50>] worker_thread+0x220/0x390
> > > <4>[14212.718797]  [<ffffffff81056dfe>] ? worker_thread+0x1ce/0x390
> > > <4>[14212.718797]  [<ffffffff8105bc80>] ? autoremove_wake_function+0x0/0x40
> > > <4>[14212.718797]  [<ffffffff81056c30>] ? worker_thread+0x0/0x390
> > > <4>[14212.718797]  [<ffffffff8105b7fe>] kthread+0xae/0xc0
> > > <4>[14212.718797]  [<ffffffff81003b94>] kernel_thread_helper+0x4/0x10
> > > <4>[14212.718797]  [<ffffffff8105b750>] ? kthread+0x0/0xc0
> > > <4>[14212.718797]  [<ffffffff81003b90>] ? kernel_thread_helper+0x0/0x10
> > > <0>[14212.718797] Code: ff ff 41 8d 52 ff 66 89 95 56 ff ff ff eb 14 0f 1f 80 00 00 00 00 41 ff c4 44 3b 60 0c 0f 83 eb 00 00 00 49 63 d4 48 8b 4c d0 38 <44> 3b 31 75 e6 0f b7 41 06 44 89 f6 41 88 47 01 0f b6 d0 48 89
> > > <1>[14212.718797] RIP  [<ffffffffa0305c0d>] iwl3945_request_scan+0x61d/0xf90 [iwl3945]
> > > <4>[14212.718797]  RSP <ffff88006ce91c80>
> > > <0>[14212.718797] CR2: 00000002ffffffb1
> > > <4>[14212.760163] ---[ end trace 7075fd19298c88a3 ]---
> > > <0>[14212.761267] Kernel panic - not syncing: Fatal exception
> > > <4>[14212.762226] Pid: 4263, comm: iwl3945 Tainted: G      D     2.6.35-rc1 #30
> > > <4>[14212.763193] Call Trace:
> > > <4>[14212.764143]  [<ffffffff8139e487>] panic+0x90/0x10a
> > > <4>[14212.765084]  [<ffffffff8100737c>] oops_end+0xcc/0xe0
> > > <4>[14212.765095]  [<ffffffff81027c13>] no_context+0xf3/0x260
> > > <4>[14212.765106]  [<ffffffff810622e5>] ? sched_clock_local+0x25/0x90
> > > <4>[14212.765116]  [<ffffffff81027e95>] __bad_area_nosemaphore+0x115/0x1d0
> > > <4>[14212.765128]  [<ffffffff81027f5e>] bad_area_nosemaphore+0xe/0x10
> > > <4>[14212.765138]  [<ffffffff810283c6>] do_page_fault+0x2e6/0x390
> > > <4>[14212.765148]  [<ffffffff810622e5>] ? sched_clock_local+0x25/0x90
> > > <4>[14212.765158]  [<ffffffff81062410>] ? sched_clock_cpu+0xc0/0x110
> > > <4>[14212.765169]  [<ffffffff8100add7>] ? native_sched_clock+0x27/0x80
> > > <4>[14212.765179]  [<ffffffff810622e5>] ? sched_clock_local+0x25/0x90
> > > <4>[14212.765191]  [<ffffffff813a309f>] page_fault+0x1f/0x30
> > > <4>[14212.765207]  [<ffffffffa0305c0d>] ? iwl3945_request_scan+0x61d/0xf90 [iwl3945]
> > > <4>[14212.765232]  [<ffffffffa02c3810>] ? iwl_bg_start_internal_scan+0x0/0x3d0 [iwlcore]
> > > <4>[14212.765246]  [<ffffffff81036911>] ? get_parent_ip+0x11/0x50
> > > <4>[14212.765266]  [<ffffffffa02c3810>] ? iwl_bg_start_internal_scan+0x0/0x3d0 [iwlcore]
> > > <4>[14212.765286]  [<ffffffffa02c3b2a>] iwl_bg_start_internal_scan+0x31a/0x3d0 [iwlcore]
> > > <4>[14212.765299]  [<ffffffff81056dfe>] ? worker_thread+0x1ce/0x390
> > > <4>[14212.765310]  [<ffffffff81056e50>] worker_thread+0x220/0x390
> > > <4>[14212.765320]  [<ffffffff81056dfe>] ? worker_thread+0x1ce/0x390
> > > <4>[14212.765333]  [<ffffffff8105bc80>] ? autoremove_wake_function+0x0/0x40
> > > <4>[14212.765344]  [<ffffffff81056c30>] ? worker_thread+0x0/0x390
> > > <4>[14212.765353]  [<ffffffff8105b7fe>] kthread+0xae/0xc0
> > > <4>[14212.765365]  [<ffffffff81003b94>] kernel_thread_helper+0x4/0x10
> > > <4>[14212.765376]  [<ffffffff8105b750>] ? kthread+0x0/0xc0
> > > <4>[14212.765386]  [<ffffffff81003b90>] ? kernel_thread_helper+0x0/0x10
> > > <3>[14212.765402] [drm:drm_fb_helper_panic] *ERROR* panic occurred, switching back to text console
> > >>
> > >> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > >> index 3e5bffb..1aef988 100644
> > >> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > >> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > >> @@ -1861,6 +1861,11 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
> > >>         if (!sband)
> > >>                 return 0;
> > >>
> > >> +       if(!priv->scan_request) {
> > >> +               WARN_ON(1);
> > >> +               return 0;
> > >> +       }
> > >> +
> > >>         active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
> > >>         passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);
> > >>
> > >>
> > >> 2. mulicast/broadcast is broken.
> > >> this results in DHCP non working on open access point.
> > >> It seems that DHCP does work on my home wireless, but avahi-autoipd doesn't see any neighbours, and this is annoying.
> > >> It can be worked around by doing (sudo ifconfig wlan0 promisc)
> > >>
> > >>
> > > Best regards,
> > >        Maxim Levitsky
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> 

Doesn't apply.




maxim@maxim-laptop:~/software/kernel/linux-2.6$ patch -p1 --dry-run < ../0001-iwl3945-fix-internal-scan.patch 
patching file drivers/net/wireless/iwlwifi/iwl-agn-lib.c
Hunk #1 succeeded at 1119 (offset 127 lines).
Hunk #2 succeeded at 1136 (offset 127 lines).
patching file drivers/net/wireless/iwlwifi/iwl-core.c
Hunk #1 succeeded at 854 (offset -2 lines).
patching file drivers/net/wireless/iwlwifi/iwl-core.h
Hunk #1 FAILED at 347.
1 out of 1 hunk FAILED -- saving rejects to file drivers/net/wireless/iwlwifi/iwl-core.h.rej
patching file drivers/net/wireless/iwlwifi/iwl3945-base.c
Hunk #1 succeeded at 1844 (offset 61 lines).
Hunk #2 succeeded at 3035 (offset 59 lines).

The other patch I received today does work.

Best regards.
	Maxim Levitsky

