Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2E3Urc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 16:47:32 -0400
Date: Wed, 30 May 2012 15:47:29 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
Subject: Re: brcmsmac problems in wireless-testing
Message-ID: <20120530204729.GF30697@thinkpad-t410> (sfid-20120530_224809_315523_D91BC2BF)
References: <20120530202547.GE30697@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120530202547.GE30697@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bah, I managed to screw up the format of the headers somehow. Fixed the
subject.

On Wed, May 30, 2012 at 03:25:47PM -0500, Seth Forshee wrote:
> Hi Arend,
> 
> I'm seeing some problems with BCM43224 in a Macbook Air 4,1 in
> wireless-testing. The symptom is that transferring data on the
> connection isn't working, even though it appears to still be associated.
> Eventually network manager realizes the connection is dead and gets
> stuck in an endless loop of trying to reassociate until I take down the
> connection and bring it back up. I find the following in dmesg.
> 
> [  583.943618] WARNING: at /home/sforshee/wireless-testing/wireless-testing/drivers/net/wireless/brcm80211/brcmsmac/main.c:7968 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
> [  583.943626] Hardware name: MacBookAir4,1
> [  583.943629] Modules linked in: hidp dm_crypt snd_hda_codec_hdmi snd_hda_codec_cirrus arc4 brcmsmac mac80211 brcmutil cfg80211 cordic joydev snd_hda_intel snd_hda_codec snd_hwdep snd_pcm applesmc input_polldev coretemp snd_seq_midi microcode snd_rawmidi rfcomm uvcvideo bnep snd_seq_midi_event parport_pc videobuf2_core videodev snd_seq ppdev btusb videobuf2_vmalloc snd_timer bluetooth videobuf2_memops bcm5974 snd_seq_device snd soundcore bcma snd_page_alloc apple_bl mei(C) mac_hid lp parport hid_apple usbhid hid ghash_clmulni_intel aesni_intel cryptd aes_x86_64 i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: ipmi_msghandler]
> [  583.943733] Pid: 63, comm: kworker/u:6 Tainted: G         C   3.4.0-030400+brcmreg201205292159-generic #030400+brcmreg201205292159
> [  583.943740] Call Trace:
> [  583.943756]  [<ffffffff8105022f>] warn_slowpath_common+0x7f/0xc0
> [  583.943765]  [<ffffffff8105028a>] warn_slowpath_null+0x1a/0x20
> [  583.943785]  [<ffffffffa03c2bd9>] brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]
> [  583.943798]  [<ffffffffa03b35fb>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
> [  583.943840]  [<ffffffffa03483ed>] ieee80211_mgd_probe_ap_send+0x12d/0x1f0 [mac80211]
> [  583.943852]  [<ffffffff8101258b>] ? __switch_to+0x12b/0x420
> [  583.943864]  [<ffffffff8167707e>] ? _raw_spin_lock+0xe/0x20
> [  583.943892]  [<ffffffffa0348aaf>] ieee80211_mgd_probe_ap.part.22+0x10f/0x130 [mac80211]
> [  583.943917]  [<ffffffffa0348c4e>] ieee80211_sta_monitor_work+0x2e/0x30 [mac80211]
> [  583.943928]  [<ffffffff8106d52a>] process_one_work+0x12a/0x420
> [  583.943952]  [<ffffffffa0348c20>] ? ieee80211_beacon_connection_loss_work+0x150/0x150 [mac80211]
> [  583.943962]  [<ffffffff8106e0ce>] worker_thread+0x12e/0x2f0
> [  583.943972]  [<ffffffff8106dfa0>] ? manage_workers.isra.25+0x200/0x200
> [  583.943980]  [<ffffffff81072d63>] kthread+0x93/0xa0
> [  583.943989]  [<ffffffff816805a4>] kernel_thread_helper+0x4/0x10
> [  583.943997]  [<ffffffff81072cd0>] ? flush_kthread_worker+0x80/0x80
> [  583.944004]  [<ffffffff816805a0>] ? gs_change+0x13/0x13
> [  583.944009] ---[ end trace 32b6c1209a07d73c ]---
> [ 1018.400892] ieee80211 phy0: brcms_c_prec_enq_head: No where to go, prec == 4
> 
> This last message repeats indefinitely until disassociating with the AP.
> I also found an instance of this in my logs where I start getting the
> messages from brcms_c_prec_enq_head without the warning.
> 
> I'm not doing anything specific to trigger the issue. I've found it in
> this state a couple times after the machine has been left sitting idle
> for a while. I'm currently trying to reproduce it again so I can poke at
> it some more.
> 
> Let me know if you have any ideas. Bisecting will be problematic due to
> the variability in reproducing, but I don't think I've ever seen this in
> 3.4.
> 
> Thanks,
> Seth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
