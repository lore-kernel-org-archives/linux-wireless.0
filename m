Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:39284 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbYEJPqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 11:46:45 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K0N00DUUT5V9TS0@mta4.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sat, 10 May 2008 11:46:44 -0400 (EDT)
Date: Sat, 10 May 2008 11:46:42 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies	-	2.6.26-rc1
 kernel
In-reply-to: <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <1210434402.3787.7.camel@X61.NetworkingUnlimited.com> (sfid-20080510_174709_321299_19CBE909)
MIME-version: 1.0
Content-type: text/plain
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2008-05-10 at 10:39 -0400, Vincent C Jones wrote:
> On Sat, 2008-05-10 at 03:12 +0300, Tomas Winkler wrote:
> > On Sat, May 10, 2008 at 2:41 AM, Vincent C Jones
> > <v.jones@networkingunlimited.com> wrote:
> > >
> > > On Sat, 2008-05-10 at 00:23 +0300, Tomas Winkler wrote:
> > >> On Fri, May 9, 2008 at 7:57 PM, Vincent C Jones
> > >> <v.jones@networkingunlimited.com> wrote:
> > >> > The channel/frequency reporting by iwlwifi is incompatible with
> > >> >  wpa_supplicant for 5GHz (802.11A) channels. Version numbers and iwlist
> > >> >  versus wpa_supplicant scan results are below. Association still works if
> > >> >  the correct channel is specified using iwconfig, but that is
> > >> >  incompatible with roaming.
> > >>
> > >> Fixed by the patch ' iwlwifi: Fix frequency in rx_status fill'
> > >>
> > >> Thanks
> > >> Tomas
> > >
> > > This patch did not apply cleanly to plain 2.6.26-rc1: off by -4 lines in
> > > iwl-3945.c and by 1078 lines in iwl-4965.c. More important, it did not
> > > fix the problem of wpa_supplicant thinking the 802.11A access points are
> > > on channel 0. Same results with 2.6.26-rc1-git7, with & without patch.
> > > Any idea when this patch (and the patches it appears to depend on) will
> > > make it into the 2.6.26 release?
> > >
> > 
> > This patch is against wireless-testing.git, it's just too lines and
> > doesn't really have logical dependencies on other patches so I didn't
> > create a separate patch for 2.6.26...It looks maybe I should.
> > Can you  try to eproduce your problem on wireless-testing kernel with
> > this patch?
> > Also some logs will be useful
> > 
> > Thanks
> > Tomas
> 
> Tomas,
> 
> No joy. Did I git the wrong tree?
> 
> (git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git)
> 
> Still had to apply your patch (offset 223 lines this time). Also applied
> the media/built-in.o patch so my config would compile. Wpa_supplicant
> (v0.6.3) still reports 0 for the channel of 11A stations:

May be more to this than just missing 802.11a channel reporting...
walked to within range of a NetGear dual-band 802.11N 5GHz/11G 2.4GHz AP
and could not even see the 802.11A side of the AP, (while another
machine was associated with it, so both halves of the AP were up).
I associated on the G channel, then tried to force an association on the
A channel by setting the frequency with iwconfig. At some point, I got
the following (note that I could still associate with the G channel when
done):

ay 10 11:20:04 X61 kernel: ------------[ cut here ]------------
May 10 11:20:04 X61 kernel: WARNING: at
include/../net/mac80211/rate.h:153 rs_get_rate+0x159/0x194 [iwl4965]()
May 10 11:20:04 X61 kernel: Modules linked in: iwl4965 iwlcore rfkill
mac80211 cfg80211 aes_x86_64 aes_generic rfcomm iptable_filter ip_tables
ip6_tables x_tables i915 drm af_packet cpufreq_conservative
cpufreq_userspace l2cap cpufreq_powersave acpi_cpufreq snd_pcm_oss
snd_mixer_oss snd_seq snd_seq_device microcode ext3 jbd mbcache fuse
nls_iso8859_1 nls_cp437 vfat fat loop dm_mod tp_smapi thinkpad_ec
input_polldev pata_acpi ata_generic ata_piix arc4 ecb crypto_blkcipher
ide_pci_generic thinkpad_acpi mmc_block piix bay pcmcia firmware_class
hci_usb output battery intel_agp ac e1000e ide_core snd_hda_intel
snd_pcm snd_timer snd_page_alloc rtc_cmos snd_hwdep rtc_core rtc_lib snd
led_class sdhci mmc_core button bluetooth yenta_socket ohci1394
rsrc_nonstatic i2c_i801 i2c_core soundcore ieee1394 pcmcia_core sg
uinput sd_mod ehci_hcd uhci_hcd usbcore edd reiserfs fan ahci libata
scsi_mod dock thermal processor thermal_sys hwmon [last unloaded:
cfg80211]
May 10 11:20:04 X61 kernel: Pid: 4947, comm: iwl4965 Not tainted
2.6.26-rc1-wl-test #2
May 10 11:20:04 X61 kernel:
May 10 11:20:04 X61 kernel: Call Trace:
May 10 11:20:04 X61 kernel:  [<ffffffff8022dbb5>] warn_on_slowpath
+0x51/0x79
May 10 11:20:04 X61 kernel:
[<ffffffffa029b5fc>] :mac80211:ieee80211_rx_bss_info+0x829/0x83b
May 10 11:20:04 X61 kernel:
[<ffffffffa029b783>] :mac80211:ieee80211_rx_mgmt_beacon+0x175/0x185
May 10 11:20:04 X61 kernel:  [<ffffffffa02d4bc1>] :iwl4965:rs_get_rate
+0x159/0x194
May 10 11:20:04 X61 kernel:  [<ffffffff802837a9>] cache_alloc_refill
+0x89/0x481
May 10 11:20:04 X61 kernel:
[<ffffffffa029feaf>] :mac80211:rate_control_get_rate+0x79/0xdd
May 10 11:20:04 X61 kernel:
[<ffffffffa02a46d9>] :mac80211:ieee80211_tx_h_rate_ctrl+0x31/0xfa
May 10 11:20:04 X61 kernel:
[<ffffffffa02a546c>] :mac80211:ieee80211_master_start_xmit+0x1ea/0x370
May 10 11:20:04 X61 kernel:  [<ffffffff803a7f43>] __qdisc_run+0xbc/0x1af
May 10 11:20:04 X61 kernel:  [<ffffffff8039ab63>] dev_queue_xmit
+0x153/0x264
May 10 11:20:04 X61 kernel:
[<ffffffffa029ccf8>] :mac80211:ieee80211_associated+0xe7/0x189
May 10 11:20:04 X61 kernel:
[<ffffffffa029ef61>] :mac80211:ieee80211_sta_work+0x0/0x733
May 10 11:20:04 X61 kernel:
[<ffffffffa029f468>] :mac80211:ieee80211_sta_work+0x507/0x733
May 10 11:20:04 X61 kernel:  [<ffffffff80228abb>] hrtick_set+0x88/0xf6
May 10 11:20:04 X61 kernel:  [<ffffffff80401ddc>] thread_return
+0x68/0xac
May 10 11:20:04 X61 kernel:
[<ffffffffa029ef61>] :mac80211:ieee80211_sta_work+0x0/0x733
May 10 11:20:04 X61 kernel:  [<ffffffff8023c09c>] run_workqueue
+0x79/0x104
May 10 11:20:04 X61 kernel:  [<ffffffff8023c975>] worker_thread
+0xd9/0xe8
May 10 11:20:04 X61 kernel:  [<ffffffff8023f19c>]
autoremove_wake_function+0x0/0x2e
May 10 11:20:04 X61 kernel:  [<ffffffff8023c89c>] worker_thread+0x0/0xe8
May 10 11:20:04 X61 kernel:  [<ffffffff8023f080>] kthread+0x47/0x73
May 10 11:20:04 X61 kernel:  [<ffffffff80228cd2>] schedule_tail
+0x28/0x5d
May 10 11:20:04 X61 kernel:  [<ffffffff8020cbd8>] child_rip+0xa/0x12
May 10 11:20:04 X61 kernel:  [<ffffffff8023f039>] kthread+0x0/0x73
May 10 11:20:04 X61 kernel:  [<ffffffff8020cbce>] child_rip+0x0/0x12
May 10 11:20:04 X61 kernel:
May 10 11:20:04 X61 kernel: ---[ end trace b453f118a4b6c339 ]---
May 10 11:20:06 X61 kernel: wlan0: No ProbeResp from current AP
00:1e:2a:6c:93:d9 - assume out of range
May 10 11:20:06 X61 kernel: wlan0: Initial auth_alg=0
May 10 11:20:06 X61 kernel: wlan0: authenticate with AP
00:1e:2a:6c:93:d9
May 10 11:20:06 X61 kernel: wlan0: Initial auth_alg=0
May 10 11:20:06 X61 kernel: wlan0: authenticate with AP
00:1e:2a:6c:93:d9
May 10 11:20:06 X61 kernel: wlan0: RX authentication from
00:1e:2a:6c:93:d9 (alg=0 transaction=2 status=0)
May 10 11:20:06 X61 kernel: wlan0: authenticated
May 10 11:20:06 X61 kernel: wlan0: associate with AP 00:1e:2a:6c:93:d9
May 10 11:20:06 X61 kernel: wlan0: authentication frame received from
00:1e:2a:6c:93:d9, but not in authenticate state - ignored
May 10 11:20:06 X61 kernel: wlan0: RX ReassocResp from 00:1e:2a:6c:93:d9
(capab=0x411 status=0 aid=1)
May 10 11:20:06 X61 kernel: wlan0: associated
May 10 11:20:06 X61 kernel: wlan0: switched to short barker preamble
(BSSID=00:1e:2a:6c:93:d9)

               ###
Vince
