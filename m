Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:57825 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3A0V1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 16:27:15 -0500
Received: by mail-qa0-f42.google.com with SMTP id cr7so196027qab.8
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2013 13:27:14 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWfjE4CWU9k9DRyQhDxB1MbgaL5WfR_B=viTLKWN5YCxg@mail.gmail.com>
References: <2709103.3nEV2q8lKr@zarzych>
	<97097679.G4cU4YgE3z@zarzych>
	<CA+icZUWfjE4CWU9k9DRyQhDxB1MbgaL5WfR_B=viTLKWN5YCxg@mail.gmail.com>
Date: Sun, 27 Jan 2013 22:27:14 +0100
Message-ID: <CA+icZUUM6FFaJNVc9HB27uqb3W4ELf1NgX6mcx23ZjsXcLdxtQ@mail.gmail.com> (sfid-20130127_222718_420248_DEF8C2A7)
Subject: Re: Possible bug in iwlwifi
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Maciek Zarzycki <zarzych@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 27, 2013 at 10:25 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sun, Jan 27, 2013 at 9:59 PM, Maciek Zarzycki <zarzych@gmail.com> wrote:
>> Hi,
>> Please tell me if you need any more info to take a look at this problem. I'm willing to invest time in assisting you in fixing this problem.
>>
>
> Hi,
>
> I can't say much to the call-traces, but in general you should add
> your kernel-config and dmesg at least.
> An 'lspci -nnvv' (or lsusb) wouldn't hurt, too.
>
> Check <wireless.kernel.org> on how to debug iwlwifi driver
> (documentation websites).
>
> If you are fit in kernel-building you can try the pending patches in
> Greg's linux-stable GIT [2].

[ Damn top-posting ]

That's correct GitWeb-URL for [2]:

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=tree;f=review-3.7

- Sedat -

> Before that I would try the pending patch from iwlwifi-fixes GIT [1],
> it's for 3.7-stable as well.
>
> Can you try and report?
>
> Regards,
> - Sedat -
>
> P.S.: IIRC iwlwifi folks have an own mailing-list?
>
> [1] http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-fixes.git;a=patch;h=ae023b2795d36f0f077e157428eb7eafa29ee412
> [2] http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-3.7.y
>
>> Thanks,
>> Maciek
>>
>> On Thursday 24 of January 2013 21:51:52 you wrote:
>>> Hi,
>>> I might have stumbled upon a bug in iwlwifi - it doesn't work after resuming from suspend to ram. The curious thing is that this only happens when suspending with AC power connected. Id doesn't happen when suspending on battery only. Below are some system specs and repro steps. Please let me know if you need more information.
>>>
>>> System: Thinkpad t430
>>> Wifi adapter: 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 3e)
>>> Kernel: Linux *** 3.7.4-1-ARCH #1 SMP PREEMPT Mon Jan 21 23:05:29 CET 2013 x86_64 GNU/Linux
>>>
>>>
>>> Steps to reproduce:
>>> 1. Suspend to ram
>>> 2. Wake the system
>>> 3. The following can be seen in dmesg:
>>>
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>>> sty 24 21:07:12 zarzych kernel: ------------[ cut here ]------------
>>> sty 24 21:07:12 zarzych kernel: WARNING: at drivers/net/wireless/iwlwifi/iwl-io.c:150 iwl_grab_nic_access+0x7f/0xf0 [iwlwifi]()
>>> sty 24 21:07:12 zarzych kernel: Hardware name: 2342CTO
>>> sty 24 21:07:12 zarzych kernel: Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
>>> sty 24 21:07:12 zarzych kernel: Modules linked in: msr cpufreq_stats rfcomm bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev med
>>> sty 24 21:07:12 zarzych kernel:  sdhci_pci sdhci mmc_core xhci_hcd libata scsi_mod ehci_hcd usbcore usb_common
>>> sty 24 21:07:12 zarzych kernel: Pid: 5779, comm: systemd-sleep Tainted: G           O 3.7.4-1-ARCH #1
>>> sty 24 21:07:12 zarzych kernel: Call Trace:
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa04e4838>] ? iwl_grab_nic_access_silent+0x188/0x200 [iwlwifi]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa04e492f>] iwl_grab_nic_access+0x7f/0xf0 [iwlwifi]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa04e561b>] iwl_write_prph+0x3b/0x190 [iwlwifi]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa04f0186>] iwl_apm_init+0x136/0x1e0 [iwlwifi]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa04f0ddc>] iwl_trans_pcie_start_fw+0xec/0x15a0 [iwlwifi]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff814ac665>] ? _raw_spin_unlock_bh+0x25/0x30
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa04e7501>] ? iwl_init_notification_wait+0x71/0xb0 [iwlwifi]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa0586be3>] iwl_load_ucode_wait_alive+0x93/0x4b0 [iwldvm]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa058e568>] ? iwl_sta_alloc_lq+0x68/0xb0 [iwldvm]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa05864b0>] ? iwl_alloc_all+0x30/0x30 [iwldvm]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa05859aa>] iwlagn_mac_start+0x13a/0x220 [iwldvm]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa0538b89>] ieee80211_reconfig+0x199/0x1560 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81363601>] ? input_pass_values.part.8+0x61/0x170
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa052a80d>] ieee80211_resume+0x2d/0x70 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa0483111>] wiphy_resume+0xa1/0xb0 [cfg80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa0483070>] ? wiphy_suspend+0x80/0x80 [cfg80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81347de8>] dpm_run_callback+0x58/0x90
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81347ecc>] device_resume+0xac/0x1a0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81349534>] dpm_resume+0x104/0x230
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81349885>] dpm_resume_end+0x15/0x30
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff812c6cc9>] ? acpi_suspend_begin_old+0x2d/0x2d
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8109f6f6>] suspend_devices_and_enter+0xb6/0x340
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8109fb3a>] pm_suspend+0x1ba/0x230
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8109ee05>] state_store+0xa5/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8126764f>] kobj_attr_store+0xf/0x20
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff811f73cd>] sysfs_write_file+0xcd/0x140
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81184438>] vfs_write+0xa8/0x180
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81184782>] sys_write+0x52/0xa0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff814b041e>] ? do_page_fault+0xe/0x10
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff814b435d>] system_call_fastpath+0x1a/0x1f
>>> sty 24 21:07:12 zarzych kernel: ---[ end trace fb919511f3d75480 ]---
>>> sty 24 21:07:12 zarzych kernel: btusb 1-1.4:1.0: no reset_resume for driver btusb?
>>> sty 24 21:07:12 zarzych kernel: btusb 1-1.4:1.1: no reset_resume for driver btusb?
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: Failed to load firmware chunk!
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: Could not load the [0] uCode section
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: Unable to initialize device.
>>> sty 24 21:07:12 zarzych kernel: ------------[ cut here ]------------
>>> sty 24 21:07:12 zarzych kernel: WARNING: at net/mac80211/util.c:1348 ieee80211_reconfig+0x63c/0x1560 [mac80211]()
>>> sty 24 21:07:12 zarzych kernel: Hardware name: 2342CTO
>>> sty 24 21:07:12 zarzych kernel: Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.
>>> sty 24 21:07:12 zarzych kernel: Modules linked in: msr cpufreq_stats rfcomm bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev med
>>> sty 24 21:07:12 zarzych kernel:  sdhci_pci sdhci mmc_core xhci_hcd libata scsi_mod ehci_hcd usbcore usb_common
>>> sty 24 21:07:12 zarzych kernel: Pid: 5779, comm: systemd-sleep Tainted: G        W  O 3.7.4-1-ARCH #1
>>> sty 24 21:07:12 zarzych kernel: Call Trace:
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa053902c>] ieee80211_reconfig+0x63c/0x1560 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81363601>] ? input_pass_values.part.8+0x61/0x170
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa052a80d>] ieee80211_resume+0x2d/0x70 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa0483111>] wiphy_resume+0xa1/0xb0 [cfg80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa0483070>] ? wiphy_suspend+0x80/0x80 [cfg80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81347de8>] dpm_run_callback+0x58/0x90
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81347ecc>] device_resume+0xac/0x1a0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81349534>] dpm_resume+0x104/0x230
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81349885>] dpm_resume_end+0x15/0x30
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff812c6cc9>] ? acpi_suspend_begin_old+0x2d/0x2d
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8109f6f6>] suspend_devices_and_enter+0xb6/0x340
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8109fb3a>] pm_suspend+0x1ba/0x230
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8109ee05>] state_store+0xa5/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8126764f>] kobj_attr_store+0xf/0x20
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff811f73cd>] sysfs_write_file+0xcd/0x140
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81184438>] vfs_write+0xa8/0x180
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81184782>] sys_write+0x52/0xa0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff814b041e>] ? do_page_fault+0xe/0x10
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff814b435d>] system_call_fastpath+0x1a/0x1f
>>> sty 24 21:07:12 zarzych kernel: ---[ end trace fb919511f3d75481 ]---
>>> sty 24 21:07:12 zarzych kernel: dpm_run_callback(): wiphy_resume+0x0/0xb0 [cfg80211] returns -110
>>> sty 24 21:07:12 zarzych kernel: PM: Device phy0 failed to resume: error -110
>>> sty 24 21:07:12 zarzych kernel: PM: resume of devices complete after 6816.029 msecs
>>> sty 24 21:07:12 zarzych kernel: PM: Finishing wakeup.
>>> sty 24 21:07:12 zarzych kernel: Restarting tasks ... done.
>>> sty 24 21:07:12 zarzych kernel: video LNXVIDEO:00: Restoring backlight state
>>> sty 24 21:07:12 zarzych systemd[1]: Started Suspend.
>>> sty 24 21:07:12 zarzych systemd[1]: Service sleep.target is not needed anymore. Stopping.
>>> sty 24 21:07:12 zarzych systemd[1]: Stopping Sleep.
>>> sty 24 21:07:12 zarzych systemd[1]: Stopped target Sleep.
>>> sty 24 21:07:12 zarzych systemd[1]: Stopping Suspend.
>>> sty 24 21:07:12 zarzych systemd[1]: Stopped target Suspend.
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> wake requested (sleeping: yes  enabled: yes)
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> waking up and re-enabling...
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (eth0): now managed
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (eth0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (eth0): bringing up device.
>>> sty 24 21:07:12 zarzych kernel: ------------[ cut here ]------------
>>> sty 24 21:07:12 zarzych kernel: WARNING: at net/mac80211/driver-ops.h:12 ieee80211_do_stop+0x6fb/0x730 [mac80211]()
>>> sty 24 21:07:12 zarzych kernel: Hardware name: 2342CTO
>>> sty 24 21:07:12 zarzych kernel: wlan0:  Failed check-sdata-in-driver check, flags: 0x4
>>> sty 24 21:07:12 zarzych kernel: Modules linked in: msr cpufreq_stats rfcomm bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev med
>>> sty 24 21:07:12 zarzych kernel:  sdhci_pci sdhci mmc_core xhci_hcd libata scsi_mod ehci_hcd usbcore usb_common
>>> sty 24 21:07:12 zarzych kernel: Pid: 953, comm: NetworkManager Tainted: G        W  O 3.7.4-1-ARCH #1
>>> sty 24 21:07:12 zarzych kernel: Call Trace:
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa05368fc>] ? ieee80211_free_keys+0x7c/0x90 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa052342b>] ieee80211_do_stop+0x6fb/0x730 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813cad31>] ? dev_deactivate_many+0x201/0x250
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa052347a>] ieee80211_stop+0x1a/0x20 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813a9ac5>] __dev_close_many+0x75/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813a9b3d>] __dev_close+0x2d/0x40
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813ae721>] __dev_change_flags+0xa1/0x180
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813ae8b8>] dev_change_flags+0x28/0x70
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bb8ba>] do_setlink+0x38a/0xa20
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81283261>] ? nla_parse+0x31/0xe0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81283261>] ? nla_parse+0x31/0xe0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bd02e>] rtnl_newlink+0x36e/0x590
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bc854>] rtnetlink_rcv_msg+0x114/0x300
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bc740>] ? __rtnl_unlock+0x20/0x20
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813d5611>] netlink_rcv_skb+0xb1/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bae55>] rtnetlink_rcv+0x25/0x40
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813d4f51>] netlink_unicast+0x1a1/0x220
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813d53b9>] netlink_sendmsg+0x329/0x3a0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81392f2a>] sock_sendmsg+0xda/0xf0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81393311>] __sys_sendmsg+0x371/0x380
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8119ffc7>] ? fget_light+0x97/0x100
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81396609>] sys_sendmsg+0x49/0x90
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff814b435d>] system_call_fastpath+0x1a/0x1f
>>> sty 24 21:07:12 zarzych kernel: ---[ end trace fb919511f3d75482 ]---
>>> sty 24 21:07:12 zarzych kernel: ------------[ cut here ]------------
>>> sty 24 21:07:12 zarzych kernel: WARNING: at drivers/net/wireless/iwlwifi/dvm/mac80211.c:1424 iwlagn_mac_remove_interface+0x11b/0x1b0 [iwldvm]()
>>> sty 24 21:07:12 zarzych kernel: Hardware name: 2342CTO
>>> sty 24 21:07:12 zarzych kernel: Modules linked in: msr cpufreq_stats rfcomm bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev med
>>> sty 24 21:07:12 zarzych kernel:  sdhci_pci sdhci mmc_core xhci_hcd libata scsi_mod ehci_hcd usbcore usb_common
>>> sty 24 21:07:12 zarzych kernel: Pid: 953, comm: NetworkManager Tainted: G        W  O 3.7.4-1-ARCH #1
>>> sty 24 21:07:12 zarzych kernel: Call Trace:
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa0584efb>] iwlagn_mac_remove_interface+0x11b/0x1b0 [iwldvm]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa052311f>] ieee80211_do_stop+0x3ef/0x730 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813cad31>] ? dev_deactivate_many+0x201/0x250
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffffa052347a>] ieee80211_stop+0x1a/0x20 [mac80211]
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813a9ac5>] __dev_close_many+0x75/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813a9b3d>] __dev_close+0x2d/0x40
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813ae721>] __dev_change_flags+0xa1/0x180
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813ae8b8>] dev_change_flags+0x28/0x70
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bb8ba>] do_setlink+0x38a/0xa20
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81283261>] ? nla_parse+0x31/0xe0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81283261>] ? nla_parse+0x31/0xe0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bd02e>] rtnl_newlink+0x36e/0x590
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bc854>] rtnetlink_rcv_msg+0x114/0x300
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bc740>] ? __rtnl_unlock+0x20/0x20
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813d5611>] netlink_rcv_skb+0xb1/0xc0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813bae55>] rtnetlink_rcv+0x25/0x40
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813d4f51>] netlink_unicast+0x1a1/0x220
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff813d53b9>] netlink_sendmsg+0x329/0x3a0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81392f2a>] sock_sendmsg+0xda/0xf0
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81393311>] __sys_sendmsg+0x371/0x380
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff8119ffc7>] ? fget_light+0x97/0x100
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff81396609>] sys_sendmsg+0x49/0x90
>>> sty 24 21:07:12 zarzych kernel:  [<ffffffff814b435d>] system_call_fastpath+0x1a/0x1f
>>> sty 24 21:07:12 zarzych kernel: ---[ end trace fb919511f3d75483 ]---
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: ctx->vif =           (null), vif = ffff880211504fb8
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0:         ID = 0:        ctx = ffff88020c12ae18        ctx->vif =           (null)
>>> sty 24 21:07:12 zarzych laptop-mode[5904]: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/* is not readable, skipping.
>>> sty 24 21:07:12 zarzych laptop-mode[5903]: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/* is not readable, skipping.
>>> sty 24 21:07:12 zarzych laptop-mode[5900]: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/* is not readable, skipping.
>>> sty 24 21:07:12 zarzych laptop-mode[5918]: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/* is not readable, skipping.
>>> sty 24 21:07:12 zarzych laptop-mode[5919]: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/* is not readable, skipping.
>>> sty 24 21:07:12 zarzych laptop-mode[5911]: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/* is not readable, skipping.
>>> sty 24 21:07:12 zarzych laptop-mode[5920]: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/* is not readable, skipping.
>>> sty 24 21:07:12 zarzych laptop-mode[5998]: Laptop mode
>>> sty 24 21:07:12 zarzych laptop-mode[6003]: enabled, not active [unchanged]
>>> sty 24 21:07:12 zarzych laptop-mode[6048]: Laptop mode
>>> sty 24 21:07:12 zarzych laptop-mode[6049]: enabled, not active [unchanged]
>>> sty 24 21:07:12 zarzych laptop-mode[6054]: Laptop mode
>>> sty 24 21:07:12 zarzych laptop-mode[6055]: enabled, not active [unchanged]
>>> sty 24 21:07:12 zarzych kernel: e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (eth0): preparing device.
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (eth0): deactivating device (reason 'managed') [2]
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (wlan0): now managed
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (wlan0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
>>> sty 24 21:07:12 zarzych NetworkManager[953]: <info> (wlan0): bringing up device.
>>> sty 24 21:07:12 zarzych kernel: e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>> sty 24 21:07:12 zarzych kernel: IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>>> sty 24 21:07:12 zarzych kernel: iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
>>> sty 24 21:07:13 zarzych upowerd[1693]: (upowerd:1693): UPower-Linux-WARNING **: energy_full (93.900000) is greater than energy_full_design (93.240000)
>>> sty 24 21:07:13 zarzych kernel: [drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake to ack request.
>>> sty 24 21:07:18 zarzych kernel: iwlwifi 0000:03:00.0: Failed to load firmware chunk!
>>> sty 24 21:07:18 zarzych kernel: iwlwifi 0000:03:00.0: Could not load the [0] uCode section
>>> sty 24 21:07:18 zarzych kernel: iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
>>> sty 24 21:07:18 zarzych NetworkManager[953]: <info> (wlan0): deactivating device (reason 'managed') [2]
>>> sty 24 21:07:18 zarzych kernel: iwlwifi 0000:03:00.0: Unable to initialize device.
>>> sty 24 21:07:18 zarzych kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>>> sty 24 21:07:18 zarzych kernel: iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
>>> sty 24 21:07:24 zarzych kernel: iwlwifi 0000:03:00.0: Failed to load firmware chunk!
>>> sty 24 21:07:24 zarzych kernel: iwlwifi 0000:03:00.0: Could not load the [0] uCode section
>>> sty 24 21:07:24 zarzych kernel: iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
>>> sty 24 21:07:24 zarzych kernel: iwlwifi 0000:03:00.0: Unable to initialize device.
>>> sty 24 21:07:24 zarzych kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>>> sty 24 21:07:24 zarzych kernel: iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
>>> sty 24 21:07:30 zarzych kernel: iwlwifi 0000:03:00.0: Failed to load firmware chunk!
>>> sty 24 21:07:30 zarzych kernel: iwlwifi 0000:03:00.0: Could not load the [0] uCode section
>>> sty 24 21:07:30 zarzych kernel: iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
>>> sty 24 21:07:30 zarzych NetworkManager[953]: <error> [1359058050.764308] [nm-supplicant-interface.c:898] interface_add_cb(): (wlan0): error adding interface: wpa_supplicant couldn't grab this interface.
>>> sty 24 21:07:30 zarzych NetworkManager[953]: dbus_g_proxy_cancel_call: assertion `pending != NULL' failed
>>> sty 24 21:07:30 zarzych NetworkManager[953]: <info> (wlan0): supplicant interface state: starting -> down
>>> sty 24 21:07:30 zarzych NetworkManager[953]: <warn> Trying to remove a non-existant call id.
>>> sty 24 21:07:30 zarzych kernel: iwlwifi 0000:03:00.0: Unable to initialize device.
>>>
>>> Thanks,
>>> Maciek
>>>
>>>
>> --
>> Maciek Zarzycki
