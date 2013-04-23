Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45726 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3DWA4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 20:56:45 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so27258wgh.12
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 17:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2356110.PbBN8nvqFd@linux-zd5t.site>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net>
	<CAJ-Vmonm78MF=3jO19MESsmfizCTti-CHMaZTn7cNUKDSNH32g@mail.gmail.com>
	<CAJ-VmonDtOW8_W1z04rjR_8ubwQNvVWiDqC-m+gULmwi3HRcEw@mail.gmail.com>
	<2356110.PbBN8nvqFd@linux-zd5t.site>
Date: Mon, 22 Apr 2013 17:56:43 -0700
Message-ID: <CAJ-VmokgmmpmRz-SP1oQHC5-o+sfd8J2a=V2+=Q4p-gkGDAfJg@mail.gmail.com> (sfid-20130423_025651_108348_7145CDFA)
Subject: Re: ath9k problems on openSUSE 12.3
From: Adrian Chadd <adrian@freebsd.org>
To: Gerry Gavigan <gerry@gavigan.f9.co.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some register values can only be written to once. Writing to them
again without a power cycle doesn't change anything. You need a power
cycle.

If any of these registers were adjusted when you were testing
different kernels, you may end up having that old setting affect the
new (or old) kernel.

You'd have to physically power off the laptop between reboots.




Adrian

On 22 April 2013 16:35, Gerry Gavigan <gerry@gavigan.f9.co.uk> wrote:
> Thank you for replying
>
> Unfortunately while I understood every word I don't understand what to do
>
> For example by "once-only" do you mean that once written that's it forever or
> do you mean once during install
>
> For example I'm fairly sure everything was reasonably fine with 3.7.10 but when
> I ugraded to 3.8.7 for better gma500 graphics chip compatibility things went
> wrong for wifi but a revert has achieved nothing
>
> Should I remove the battery from the netbook then do an fresh install of
> openSUSE 12.3 with 3.7.10?
>
> or something else?
>
> Sorry to take up your time
>
> Gerry
>
>
> On Monday 22 Apr 2013 10:31:02 Adrian Chadd wrote:
>> .. and make sure you do a full hardware reset (power off, wait, power
>> on) when you downgrade or upgrade.
>>
>> Some of the register settings may be once-only and require a power
>> cycle to change.
>
>
>>
>>
>>
>> adrian
>>
>> On 22 April 2013 10:30, Adrian Chadd <adrian@freebsd.org> wrote:
>> > Wasn't there a recent change to ath9k which reverted an initval
>> > change? Specifically for the AR9485?
>> >
>> > The problem was an unstable PLL that shows up when you do aggressive
>> > PCIe PHY power save.
>> >
>> > The change was to go back to the previous PCIe initval array.
>> >
>> >
>> >
>> > Adrian
>> >
>> > On 22 April 2013 05:30, Gerry Gavigan <gerry@gavigan.f9.co.uk> wrote:
>> >> After some discussion :
>> >>
>> >> https://forums.opensuse.org/english/get-technical-help-here/wireless/4846
>> >> 86-advanced-atheros-issue-12-3-ath9k-64bit-frequent-random-de-auths-2.htm
>> >> l
>> >>
>> >> I have been advised to seek help here as the phase lock loop is not
>> >> working.
>> >>
>> >> In case it's relevant:
>> >>
>> >> - the wifi was working if possibly slightly unstable until I upgraded to
>> >> 3.8.7
>> >>
>> >>   (to cure suspend and resume on a gma500 in an AAO)
>> >>
>> >> - Downgrading didn't work
>> >>
>> >> lspci -nn returns
>> >>
>> >> 02:00.0 Network controller [0280]: Atheros Communications Inc. AR9485
>> >> Wireless Network Adapter [168c:0032] (rev 01)
>> >>
>> >> dmesg reports
>> >>
>> >> [ 24.800514] ------------[ cut here ]------------
>> >> [ 24.800563] WARNING: at
>> >> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.7.10/linux-3.7/drivers/net/w
>> >> ireless/ath/ath9k/hw.c:794 ar9003_get_pll_sqsum_dvc+0xa8/0xc0
>> >> [ath9k_hw]()
>> >> [ 24.800567] Hardware name: AOD270
>> >> [ 24.800571] Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit
>> >> af_packet bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
>> >> ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle
>> >> nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
>> >> nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
>> >> ip6_tables x_tables cpufreq_conservative cpufreq_userspace
>> >> cpufreq_powersave acpi_cpufreq mperf coretemp iTCO_wdt
>> >> iTCO_vendor_support acer_wmi
>> >> sparse_keymap snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel
>> >> snd_hda_codec snd_hwdep snd_pcm snd_seq microcode serio_raw pcspkr
>> >> i2c_i801
>> >> snd_timer snd_seq_device uvcvideo videobuf2_core sg videodev
>> >> videobuf2_vmalloc videobuf2_memops lpc_ich mfd_core arc4 joydev snd ath9k
>> >> rts_pstor(C) mac80211 ath9k_common ath9k_hw ath cfg80211 rfkill r8169
>> >> soundcore snd_page_alloc wmi ac battery button autofs4 gma500_gfx
>> >> drm_kms_helper drm i2c_algo_bit video thermal processor thermal_sys
>> >> scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_dh_hp_sw scsi_dh
>> >> [ 24.800687] Pid: 64, comm: kworker/u:3 Tainted: G C 3.7.10-1.1-desktop
>> >> #1
>> >> [ 24.800690] Call Trace:
>> >> [ 24.800713] [<c0205779>] try_stack_unwind+0x199/0x1b0
>> >> [ 24.800729] [<c0204487>] dump_trace+0x47/0xf0
>> >> [ 24.800740] [<c02057db>] show_trace_log_lvl+0x4b/0x60
>> >> [ 24.800749] [<c0205808>] show_trace+0x18/0x20
>> >> [ 24.800760] [<c06fbeeb>] dump_stack+0x6d/0x72
>> >> [ 24.800812] [<c0238cb8>] warn_slowpath_common+0x78/0xb0
>> >> [ 24.800855] [<c0238d0b>] warn_slowpath_null+0x1b/0x20
>> >> [ 24.800897] [<f7c84448>] ar9003_get_pll_sqsum_dvc+0xa8/0xc0 [ath9k_hw]
>> >> [ 24.800941] [<f7b2d2b8>] ath_hw_pll_work+0x48/0xc0 [ath9k]
>> >> [ 24.801012] [<c02527dc>] process_one_work+0x10c/0x400
>> >> [ 24.801038] [<c0253e89>] worker_thread+0x119/0x3b0
>> >> [ 24.801055] [<c02584f2>] kthread+0x92/0xa0
>> >> [ 24.801076] [<c070dc67>] ret_from_kernel_thread+0x1b/0x28
>> >> [ 24.801093] [<c0258460>] kthread_create_on_node+0xd0/0xd0
>> >> [ 24.808339] DWARF2 unwinder stuck at kthread+0x0/0xa0
>> >> [ 24.808346]
>> >> [ 24.808350] Leftover inexact backtrace:
>> >> [ 24.808350]
>> >> [ 24.808361] ---[ end trace 33960a031f166c71 ]---
>> >>
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> >> in the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
