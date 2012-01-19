Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47438 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993Ab2ASVTY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 16:19:24 -0500
Received: by obcva7 with SMTP id va7so408227obc.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2012 13:19:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
References: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
Date: Thu, 19 Jan 2012 22:19:23 +0100
Message-ID: <CAC9WiBh5-vS6UmCYCs911WAudmWDtsgDPmHim71LtvaC81HsWQ@mail.gmail.com> (sfid-20120119_221928_208373_43B3E356)
Subject: Re: brcmsmac broken with 3.2
From: Francis Moreau <francis.moro@gmail.com>
To: alwin@broadcom.com, rvossen@broadcom.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm wondering now why the brmsmac driver had been removed from the
staging driver tree if no one cares.

Bye.

On Thu, Jan 12, 2012 at 8:32 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I'm facing a new issue after upgrading from 3.1 to 3.2.
>
> It happens when switching on/off my wireless card (BCM4313 [14e4:4727]).
>
> Here's the oops I'm getting:
>
> [36370.370768] WARNING: at net/mac80211/rx.c:2979
> ieee80211_rx+0x91b/0x9e0 [mac80211]()
> [36370.370775] Hardware name: Vostro 3500
> [36370.370777] Modules linked in: rfcomm bridge stp bnep btusb
> bluetooth overlayfs(O) nfsd nfs lockd fscache auth_rpcgss nfs_acl
> sunrpc fuse af_packet ipv6 snd_hda_codec_hdmi arc4 snd_hda_codec_idt
> brcmsmac mac80211 snd_hda_intel brcmutil snd_hda_codec cfg80211
> snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd
> dell_laptop r8169 rfkill uvcvideo videodev sr_mod sg iTCO_wdt media
> i2c_i801 v4l2_compat_ioctl32 mii dcdbas soundcore mei(C) intel_ips
> snd_page_alloc iTCO_vendor_support crc8 cordic i915 drm_kms_helper drm
> i2c_algo_bit i2c_core coretemp binfmt_misc cpufreq_ondemand
> cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf
> nvram dell_wmi sparse_keymap dm_mod joydev evdev kvm_intel kvm video
> battery wmi ata_piix ahci libahci libata sd_mod scsi_mod crc_t10dif
> ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore
> usb_common
> [36370.370870] Pid: 0, comm: swapper/0 Tainted: G        WC O 3.2.0 #63
> [36370.370874] Call Trace:
> [36370.370876]  <IRQ>  [<ffffffff8106809f>] warn_slowpath_common+0x7f/0xc0
> [36370.370888]  [<ffffffff810680fa>] warn_slowpath_null+0x1a/0x20
> [36370.370904]  [<ffffffffa04fb2bb>] ieee80211_rx+0x91b/0x9e0 [mac80211]
> [36370.370910]  [<ffffffff81062ccd>] ? enqueue_task_rt+0x5d/0x70
> [36370.370915]  [<ffffffff810528aa>] ? enqueue_task+0x6a/0x80
> [36370.370925]  [<ffffffffa04dedd9>]
> ieee80211_tasklet_handler+0xb9/0x160 [mac80211]
> [36370.370931]  [<ffffffff8106f43d>] tasklet_action+0xcd/0x110
> [36370.370935]  [<ffffffff8106efda>] __do_softirq+0xaa/0x1e0
> [36370.370941]  [<ffffffff81467aac>] call_softirq+0x1c/0x30
> [36370.370946]  [<ffffffff81015255>] do_softirq+0x65/0xa0
> [36370.370950]  [<ffffffff8106edde>] irq_exit+0x8e/0xc0
> [36370.370955]  [<ffffffff81468366>] do_IRQ+0x66/0xe0
> [36370.370960]  [<ffffffff8145dbae>] common_interrupt+0x6e/0x6e
> [36370.370963]  <EOI>  [<ffffffff8109be0e>] ?
> tick_nohz_stop_sched_tick+0x28e/0x3d0
> [36370.370974]  [<ffffffff81012fe1>] cpu_idle+0x81/0x120
> [36370.370981]  [<ffffffff81441242>] rest_init+0x72/0x80
> [36370.370988]  [<ffffffff81ac7cd9>] start_kernel+0x3c5/0x3d0
> [36370.370994]  [<ffffffff81ac7346>] x86_64_start_reservations+0x131/0x135
> [36370.370999]  [<ffffffff81ac744d>] x86_64_start_kernel+0x103/0x112
>
> Thanks for any hints/fixes
> --
> Francis



-- 
Francis
