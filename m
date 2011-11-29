Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1K2Q5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 11:57:41 -0500
Subject: Re: Followup with dmesg WARNING (was Bug report: can't maintain
 WiFi connectivity        in recent kernels.)
From: wwguy <wey-yi.w.guy@intel.com>
To: Ken D'Ambrosio <ken@jots.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <a562bb7bd5c895756114c38e0de891de@www.jots.org>
References: <a562bb7bd5c895756114c38e0de891de@www.jots.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 08:51:10 -0800
Message-ID: <1322585470.21947.7.camel@wwguy-ubuntu> (sfid-20111129_175745_225634_AA08CC10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

no sure, there are some mac80211 race condition problem found and being
address now. maybe you can try the patch from Nikolay and see if help.

Wey

On Tue, 2011-11-29 at 06:18 -0800, Ken D'Ambrosio wrote:
> I hadn't sent this, because I'd thought I was only getting WARNINGs on my
> Virtualbox-tainted kernel, but this happened untainted, so here you go.  Hope
> it helps!
> 
> -Ken
> 
> 
> [  198.113130] wlan0: deauthenticating from 00:27:0d:98:d1:f1 by local choice
> (reason=3)
> [  198.113277] ------------[ cut here ]------------
> [  198.113313] WARNING: at net/wireless/mlme.c:309
> __cfg80211_auth_remove+0x56/0xa0 [cfg80211]()
> [  198.113317] Hardware name: EC14 Series
> [  198.113320] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat binfmt_misc
> ppdev snd_hda_codec_hdmi snd_hda_codec_realtek joydev snd_hda_intel
> snd_hda_codec arc4 snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm usb_storage
> snd_seq_dummy uvcvideo videodev snd_seq_oss fbcon tileblit snd_seq_midi i915
> snd_rawmidi iwlwifi font bitblit snd_seq_midi_event softcursor snd_seq psmouse
> snd_timer snd_seq_device serio_raw mac80211 drm_kms_helper acer_wmi drm
> sparse_keymap atl1c i2c_algo_bit cfg80211 intel_agp snd intel_gtt agpgart
> soundcore video snd_page_alloc lp parport
> [  198.113397] Pid: 44, comm: kworker/u:3 Not tainted 3.1.0+ #1
> [  198.113401] Call Trace:
> [  198.113412]  [<c068e057>] ? printk+0x1d/0x1f
> [  198.113423]  [<c01562b2>] warn_slowpath_common+0x72/0xa0
> [  198.113439]  [<f8cbc1e6>] ? __cfg80211_auth_remove+0x56/0xa0 [cfg80211]
> [  198.113454]  [<f8cbc1e6>] ? __cfg80211_auth_remove+0x56/0xa0 [cfg80211]
> [  198.113461]  [<c0156302>] warn_slowpath_null+0x22/0x30
> [  198.113480]  [<f8cbc1e6>] __cfg80211_auth_remove+0x56/0xa0 [cfg80211]
> [  198.113496]  [<f8cbc2ae>] cfg80211_send_auth_timeout+0x5e/0xc0 [cfg80211]
> [  198.113518]  [<f868f796>] ieee80211_probe_auth_done+0xe6/0xf0 [mac80211]
> [  198.113525]  [<c014f614>] ? wake_up_process+0x14/0x20
> [  198.113532]  [<c06976ec>] ? __mutex_unlock_slowpath+0x3c/0x50
> [  198.113552]  [<f86929bb>] ieee80211_work_work+0x47b/0x12d0 [mac80211]
> [  198.113559]  [<c0134c58>] ? default_spin_lock_flags+0x8/0x10
> [  198.113566]  [<c0698701>] ? _raw_spin_trylock_bh+0x1/0x30
> [  198.113575]  [<c017043e>] process_one_work+0xfe/0x3a0
> [  198.113580]  [<c014f614>] ? wake_up_process+0x14/0x20
> [  198.113586]  [<c016dfe5>] ? start_worker+0x25/0x30
> [  198.113605]  [<f8692540>] ? free_work+0x20/0x20 [mac80211]
> [  198.113612]  [<c0170f74>] worker_thread+0x124/0x2d0
> [  198.113618]  [<c0170e50>] ? manage_workers.isra.28+0x1e0/0x1e0
> [  198.113624]  [<c0174ced>] kthread+0x6d/0x80
> [  198.113630]  [<c0174c80>] ? flush_kthread_worker+0x80/0x80
> [  198.113637]  [<c069fb06>] kernel_thread_helper+0x6/0x10
> [  198.113642] ---[ end trace 04bdbdc199f6d75f ]---
> 
> 
> 
> Hi.  For reasons pertaining to btrfs, I'm running 3.1+  kernels, and the wifi
> on my system now flakes out sporadically, but reliably.  It can sometimes run
> for a couple days, but other days (like, say, yesterday) it'll fail upwards of
> 30 times. Simply attempting to re-acquire a connection via Network Manager
> fails 100%.  I need to rmmod and modprobe the iwlwifi module, and then am able
> to immediately connect, 100% of the time -- albeit, briefly.  Rebooting under
> these circumstances seems to have as much affect as reloading the module.  (I
> wonder if there's something that changes on the WAP side that triggers this? 
> That would explain the occasional doses of extended uptime, followed by days of
> misery, regardless of reboots and module playing.)
> 
> While the behavior, sadly, *is* sporadic, when
> 
> - it's not a problem on older (distribution-supplied) kernels, and
> - reloading -- and only reloading -- the module fixes it, however briefly,
> 
> it seems to me it's probably a problem with the module.
> 
> 
> Here's some additional information:
> 
> * Happens on multiple WAPs (home, hotel, work, etc.)
> 
> * 02:00.0 Network controller: Intel Corporation WiFi Link 1000 Series
> 
> * The system *thinks* everything is fine -- NetworkManager happily shows all
> the WAPs, etc. -- but I'm unable to re-acquire them until I reload the module.
> 
> * kernel 3.1.0+, untainted  (Chris Mason's btrfs git pull from three weeks ago;
> also experienced with slightly older, post 3.x kernels)
> 
> * Seems to fail most quickly under load (e.g., streaming); can push an hour if
> doing relatively little
> 
> * I'm unsure which kernel rev. was the tipping point, but Ubuntu 10.04
> generally "just worked," and is what I'm booted to now off of USB -- 2.6.32.
> 
> I'd give you dmesg messages, but I'm -- catch-22 -- Ubuntu 10.04 won't mount my
> btrfs partition, but runs WiFi flawlessly.  If you need those messages, just
> let me know, and I'll pull them off.
> 
> If there's anything else I can help out with, please don't hesitate to let me
> know.
> 
> Thanks!
> 
> -Ken
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


