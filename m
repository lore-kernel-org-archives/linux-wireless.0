Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60563 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbZAEVK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 16:10:57 -0500
Message-ID: <4962775B.2040205@lwfinger.net> (sfid-20090105_221102_419399_1BC1D088)
Date: Mon, 05 Jan 2009 15:10:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with rtl8187
References: <496273D4.6020600@lwfinger.net> <1231189302.3697.25.camel@johannes>
In-Reply-To: <1231189302.3697.25.camel@johannes>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Does the backtrace continue beyond what you pasted?

Yes, here is the whole thing.

------------[ cut here ]------------
WARNING: at net/mac80211/tx.c:1184 ieee80211_master_start_xmit+0x41c/0x50d
[mac80211]()
Modules linked in: rtl8187 eeprom_93cx6 af_packet snd_pcm_oss snd_mixer_oss
snd_seq snd_seq_device nfs lockd nfs_acl sunrpc
 vboxnetflt vboxdrv cpufreq_conservative cpufreq_userspace cpufreq_powersave
powernow_k8 fuse loop dm_mod arc4 ecb b43 rfki
ll snd_hda_intel mac80211 led_class snd_pcm input_polldev snd_timer snd
ide_cd_mod k8temp soundcore cfg80211 serio_raw forc
edeth button battery hwmon ac snd_page_alloc ssb cdrom sg joydev sd_mod ohci_hcd
uhci_hcd ehci_hcd usbcore edd ext3 mbcache
 jbd fan amd74xx ide_core ahci libata scsi_mod thermal processor [last unloaded:
eeprom_93cx6]
Pid: 17149, comm: phy6 Tainted: G        W  2.6.28-rc9-wl #58
Call Trace:
 [<ffffffff8023afce>] warn_on_slowpath+0x58/0x7d
 [<ffffffff803c8c3c>] ? pskb_expand_head+0xe6/0x156
 [<ffffffffa029dbff>] ? __ieee80211_tx+0x40/0x12a [mac80211]
 [<ffffffffa029e98b>] ieee80211_master_start_xmit+0x41c/0x50d [mac80211]
 [<ffffffffa029e8c5>] ? ieee80211_master_start_xmit+0x356/0x50d [mac80211]
 [<ffffffff803cf0a4>] dev_hard_start_xmit+0x214/0x28f
 [<ffffffff803dfb9b>] __qdisc_run+0xf3/0x1fe
 [<ffffffff803cf584>] dev_queue_xmit+0x357/0x48f
 [<ffffffff803cf375>] ? dev_queue_xmit+0x148/0x48f
 [<ffffffffa029fa0e>] ieee80211_tx_skb+0x60/0x62 [mac80211]
 [<ffffffffa0293c61>] ieee80211_send_probe_req+0x1d2/0x1e1 [mac80211]
 [<ffffffff80236c1f>] ? finish_task_switch+0x5f/0xb9
 [<ffffffff80236bc0>] ? finish_task_switch+0x0/0xb9
 [<ffffffffa0290c1b>] ieee80211_scan_work+0x155/0x17a [mac80211]
 [<ffffffff8024ac68>] run_workqueue+0x103/0x20a
 [<ffffffff8024ac16>] ? run_workqueue+0xb1/0x20a
 [<ffffffffa0290ac6>] ? ieee80211_scan_work+0x0/0x17a [mac80211]
 [<ffffffff8024ae4f>] worker_thread+0xe0/0xf1
 [<ffffffff8024e998>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8024ad6f>] ? worker_thread+0x0/0xf1
 [<ffffffff8024e664>] kthread+0x49/0x76
 [<ffffffff8020d0c9>] child_rip+0xa/0x11
 [<ffffffff80236bc0>] ? finish_task_switch+0x0/0xb9
 [<ffffffff8020c5e4>] ? restore_args+0x0/0x30
 [<ffffffff8024e61b>] ? kthread+0x0/0x76
 [<ffffffff8020d0bf>] ? child_rip+0x0/0x11
---[ end trace 19e8b89a6586bb14 ]---

Larry
