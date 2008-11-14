Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:46064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbYKNKHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 05:07:48 -0500
Message-ID: <491D4DE5.7000202@suse.de> (sfid-20081114_110753_964712_560CE0BC)
Date: Fri, 14 Nov 2008 11:07:33 +0100
From: Frank Seidel <fseidel@suse.de>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
Subject: Re: Problem with Kernel Oops in ipw2200
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>	 <20081112213350.GJ2411@tuxdriver.com>  <491BF062.4050705@suse.de> <1226631539.2604.411.camel@debian.sh.intel.com>
In-Reply-To: <1226631539.2604.411.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> May I have your oops log?

Yes, sure, see below

> Please try if attached patch fix the problem.

IPW_DEBUG is undeclared, but besides that i'm currently trying
your patch, thanks a lot!

Kernel Ooops message:
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<f92f35df>] :ipw2200:ipw_tx_skb+0x1b8/0x5df
*pde = 00000000
Oops: 0002 [#1] SMP
last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BATA/energy_full
Modules linked in: michael_mic arc4 ecb ieee80211_crypt_tkip aes_i586
crypto_blkcipher aes_generic ieee80211_crypt_ccmp af_packet binfmt_misc
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device i915 drm ipv6
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
speedstep_lib fuse loop dm_mod pcmcia snd_intel8x0 ipw2200(N)
snd_ac97_codec yenta_socket ac97_bus ieee80211 iTCO_wdt rsrc_nonstatic
ohci1394 snd_pcm snd_timer ieee80211_crypt iTCO_vendor_support
pcmcia_core r8169 ieee1394 snd ide_cd_mod i2c_i801 intel_agp video
container soundcore rtc_cmos output rtc_core i2c_core button battery ac
snd_page_alloc rtc_lib agpgart pcspkr cdrom shpchp serio_raw joydev
pci_hotplug ide_disk uhci_hcd ehci_hcd usbcore edd ext3 mbcache jbd fan
ide_pci_generic ata_generic ata_piix pata_acpi libata scsi_mod dock piix
ide_core thermal processor thermal_sys hwmon
Supported: No

Pid: 3405, comm: ping Tainted: G          (2.6.27.4-2-default #1)
EIP: 0060:[<f92f35df>] EFLAGS: 00010046 CPU: 0
EIP is at ipw_tx_skb+0x1b8/0x5df [ipw2200]
EAX: 00000000 EBX: 00000000 ECX: f781a400 EDX: 00000000
ESI: f781a400 EDI: 00000000 EBP: 00000000 ESP: ecbadaec
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process ping (pid: 3405, ti=ecbac000 task=ecab5180 task.ti=ecbac000)
Stack: 00000000 00000000 41081600 c2860b00 9f24d2e7 52d2bbd9 f01bc1c0
0000000c
       f037d400 f781a400 f78b8c5c 00000000 f7795010 f01bc1f4 01f3b860
0000005c
       0000c1f4 00000001 00000018 00000000 0000000c f78b8c5c f781a400
00000000
Call Trace:
 [<f92f441d>] ipw_net_hard_start_xmit+0x47/0x66 [ipw2200]
 [<f92b5d69>] ieee80211_xmit+0x939/0x99c [ieee80211]
 [<c02dd75d>] dev_hard_start_xmit+0xf0/0x156
 [<c02ebf42>] __qdisc_run+0xa6/0x1ad
 [<c02ddab8>] dev_queue_xmit+0x20b/0x343
 [<c02fd90b>] ip_finish_output+0x1d6/0x20f
 [<c02fcc75>] ip_local_out+0x15/0x17
 [<c02fceca>] ip_push_pending_frames+0x253/0x2ae
 [<c0313ba7>] raw_sendmsg+0x37f/0x3f3
 [<c031ad82>] inet_sendmsg+0x3b/0x45
 [<c02d2482>] sock_sendmsg+0xc9/0xe4
 [<c02d2627>] sys_sendmsg+0x18a/0x1eb
 [<c02d392b>] sys_socketcall+0x241/0x290
 [<c0103cbb>] sysenter_do_call+0x12/0x2f
 [<ffffe430>] 0xffffe430
 =======================
Code: 24 44 8b 4c 24 24 48 89 44 24 2c 6b c0 28 03 44 24 28 8b 90 ac 04
00 00 89 d5 c1 e5 07 03 a8 c8 04 00 00 8b 80 cc 04 00 00 89 ef <89> 0c
90 b9 20 00 00 00 31 c0 f3 ab 88 5d 08 c6 45 00 00 c6 45
EIP: [<f92f35df>] ipw_tx_skb+0x1b8/0x5df [ipw2200] SS:ESP 0068:ecbadaec
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------
