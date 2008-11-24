Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYKXMpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 07:45:12 -0500
Message-ID: <492AA1BC.3080205@suse.de> (sfid-20081124_134518_766564_124506FE)
Date: Mon, 24 Nov 2008 13:44:44 +0100
From: Frank Seidel <fseidel@suse.de>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
Subject: Re: [PATCH] Re: Problem with Kernel Oops in ipw2200
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>	 <20081112213350.GJ2411@tuxdriver.com>  <491BF062.4050705@suse.de>	 <1226631539.2604.411.camel@debian.sh.intel.com>  <49214BF3.8050306@suse.de> <1227296397.13619.33.camel@rc-desk>
In-Reply-To: <1227296397.13619.33.camel@rc-desk>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

reinette chatre wrote:
> Frank,
> 
> The patch above was not accepted. Would it be possible for you to try
> the patch below instead? Thank you very much.

sadfully this patch doesn't seem to fix this issue like the last one.
When applied i run in the following Oops:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<f92405bf>] :ipw2200:ipw_net_hard_start_xmit+0x428/0x875
*pde = 00000000 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:03.0/rf_kill
Modules linked in: aes_i586(N) crypto_blkcipher(N) aes_generic(N) ieee80211_crypt_ccmp(N) af_packet(N) microcode(N) binfmt_misc(N) cpufreq_conservative(N) cpufreq_userspace(N) cpufreq_powersave(N) acpi_cpufreq(N) speedstep_lib(N) snd_pcm_oss(N) snd_mixer_oss(N) snd_seq(N) snd_seq_device(N) ipv6(N) fuse(N) loop(N) dm_mod(N) snd_intel8x0(N) pcmcia(N) ipw2200(N) snd_ac97_codec(N) ieee80211(N) yenta_socket(N) ohci1394(N) ac97_bus(N) ieee80211_crypt(N) r8169(N) rsrc_nonstatic(N) ieee1394(N) snd_pcm(N) pcmcia_core(N) snd_timer(N) shpchp(N) snd(N) video(N) rtc_cmos(N) pci_hotplug(N) i2c_i801(N) intel_agp(N) container(N) soundcore(N) sr_mod(N) iTCO_wdt(N) rtc_core(N) output(N) battery(N) ac(N) rtc_lib(N) serio_raw(N) joydev(N) pcspkr(N) i2c_core(N) agpgart(N) cdrom(N) button(N) snd_page_alloc(N) iTCO_vendor_support(N) sg(N) sd_mod(N) crc_t10dif(N) ehci_hcd(N) uhci_hcd(N) usbcore(N) edd(N) ext3(N) mbcache(N) jbd(N) fan(N) ide_pci_generic(N) piix(N) ide_core(N) ata_generic(N) ata_piix(
N) libata(N) scsi_mod(N) dock(N) thermal(N) processor(N) thermal_sys(N) hwmon(N)
Supported: No

Pid: 3538, comm: ping Tainted: G          (2.6.27.5-2-default #1)
EIP: 0060:[<f92405bf>] EFLAGS: 00010046 CPU: 0
EIP is at ipw_net_hard_start_xmit+0x428/0x875 [ipw2200]
EAX: 00000000 EBX: 00000000 ECX: f7ac7c60 EDX: 00000000
ESI: f79ba480 EDI: 00000000 EBP: 00000000 ESP: ecef1ab0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process ping (pid: 3538, ti=ecef0000 task=f7507000 task.ti=ecef0000)
Stack: f7534b04 ecd5fc00 f8e986f6 ecd5fc00 f7534b24 f7534af4 f8eb9181 00529280 
       00000000 00000000 f79ba000 f7ac7c60 f79bac60 f79bac5c 00000282 0000000c 
       ecd5fc00 f7abd080 00000018 00000001 00004b14 f7534af4 f8eb9860 0001005c 
Call Trace:
 [<f91e1d59>] ieee80211_xmit+0x9f0/0xa63 [ieee80211]
 [<c02e3474>] dev_hard_start_xmit+0x1e0/0x247
 [<c02f1e91>] __qdisc_run+0xa6/0x1ad
 [<c02e3920>] dev_queue_xmit+0x35b/0x493
 [<c03037b1>] ip_finish_output+0x1d6/0x20f
 [<c0302b1b>] ip_local_out+0x15/0x17
 [<c0302d70>] ip_push_pending_frames+0x253/0x2ae
 [<c03198ad>] raw_sendmsg+0x5ff/0x677
 [<c0320a82>] inet_sendmsg+0x3b/0x45
 [<c02d855a>] sock_sendmsg+0xc9/0xe4
 [<c02d86ff>] sys_sendmsg+0x18a/0x1eb
 [<c02d9a03>] sys_socketcall+0x241/0x290
 [<c0104c8b>] sysenter_do_call+0x12/0x2f
 [<ffffe430>] 0xffffe430
 =======================
Code: 24 4c 8b 4c 24 2c 48 89 44 24 64 6b c0 28 03 44 24 34 8b 90 ac 04 00 00 89 d5 c1 e5 07 03 a8 c8 04 00 00 8b 80 cc 04 00 00 89 ef <89> 0c 90 b9 20 00 00 00 31 c0 f3 ab 88 5d 08 c6 45 00 00 c6 45 
EIP: [<f92405bf>] ipw_net_hard_start_xmit+0x428/0x875 [ipw2200] SS:ESP 0068:ecef1ab0
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------


