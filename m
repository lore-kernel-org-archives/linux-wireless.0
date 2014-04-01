Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37185 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaDAFcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 01:32:47 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so4416067wib.10
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 22:32:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53399E42.2090504@candelatech.com>
References: <53399E42.2090504@candelatech.com>
Date: Tue, 1 Apr 2014 07:32:46 +0200
Message-ID: <CA+BoTQmfBGJxwFnpq+7dE7MgL_db5gkCvRVfhk9YFAAPLZQwHQ@mail.gmail.com> (sfid-20140401_073251_448808_1D703722)
Subject: Re: ath10k: ieee80211_restart_work called with hardware scan in progress
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2014 18:56, Ben Greear <greearb@candelatech.com> wrote:
> This came from a customer (demo) system.  Firmware is 10.1.389 based, modified
> by us.  It has lots of known issues, but I haven't seen the warning
> below before, and not sure it is specifically a bug with ath10k or not.

Hmm..


> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)
> Mar 31 13:49:54 ct521-5332 kernel: ath10k: could not start hw scan (-108)

-108 = ESHUTDOWN. This can be a result of calling ath10k_halt() IOW
driver is stopping by mac80211 request or ath10k_core_restart() was
called. I suppose the latter is the case here.

ath10k_halt() calls ieee80211_scan_completed(hw, true) if necessary.
But since it only sets 1 or 2 bits in local->scanning in mac80211 and
schedules local->scan_work I suspect you can end up having
local->restart_work scheduled sooner in some cases (both use different
workqueues: scan_work uses per-hw queue, restart_work uses global
system queue) and see the following:

> Mar 31 13:49:54 ct521-5332 kernel: ieee80211_restart_work called with hardware scan in progress
> Mar 31 13:49:54 ct521-5332 kernel: Modules linked in: nf_nat_ipv4 nf_nat fuse 8021q mrp garp stp llc macvlan pktgen coretemp hwmon sunrpc ipv6 uinput
> snd_hda_codec_realtek snd_hda_codec_generic ath10k_pci ath10k_core snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_seq snd_seq_device iTCO_wdt e1000e
> microcode ath gpio_ich snd_pcm iTCO_vendor_support ppdev ptp snd_timer parport_pc snd cfg80211 parport serio_raw pps_core soundcore pcspkr i2c_i801 lpc_ich i915
> drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iptable_nat]
> Mar 31 13:49:54 ct521-5332 kernel: CPU: 0 PID: 11818 Comm: kworker/0:0 Tainted: G        WC   3.14.0-rc7-wl-ath+ #4
> Mar 31 13:49:54 ct521-5332 kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 09/05/2011
> Mar 31 13:49:54 ct521-5332 kernel: Workqueue: events ieee80211_restart_work [mac80211]
> Mar 31 13:49:54 ct521-5332 kernel: 0000000000000009 ffff8800bd865d68 ffffffff815ab0a5 ffff88022bc0ec38
> Mar 31 13:49:54 ct521-5332 kernel: ffff8800bd865db8 ffff8800bd865da8 ffffffff810c1aa8 ffff8800bd865d88
> Mar 31 13:49:54 ct521-5332 kernel: ffffffffa03858ce ffff8802214d5650 ffff8802214d45e0 ffff8802214d5650
> Mar 31 13:49:54 ct521-5332 kernel: Call Trace:
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff815ab0a5>] dump_stack+0x4e/0x71
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810c1aa8>] warn_slowpath_common+0x77/0x91
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffffa03858ce>] ? ieee80211_restart_work+0x49/0x68 [mac80211]
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810c1b56>] warn_slowpath_fmt+0x41/0x43
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffffa03858ce>] ieee80211_restart_work+0x49/0x68 [mac80211]
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d52af>] process_one_work+0x162/0x216
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d5724>] worker_thread+0x12f/0x1fd
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810d55f5>] ? rescuer_thread+0x268/0x268
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da37f>] kthread+0xa0/0xa8
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff815b5b4c>] ret_from_fork+0x7c/0xb0
> Mar 31 13:49:54 ct521-5332 kernel: [<ffffffff810da2df>] ? __kthread_parkme+0x5c/0x5c
> Mar 31 13:49:54 ct521-5332 kernel: ---[ end trace fd8ccdaa79168e68 ]---

It seems to me that any mac80211-driver can hit this as long as it
requests a restart during a scan while something queued via
ieee80211_queue_work() blocks (that something could be driver worker)
long enough.


Michał
