Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:54465 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756169Ab2DLKTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 06:19:49 -0400
Received: by lahl5 with SMTP id l5so2980923lah.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 03:19:46 -0700 (PDT)
Message-ID: <1334225984.10398.36.camel@cumari> (sfid-20120412_121954_838519_FCFC688D)
Subject: Re: [PATCH v3 2/2] mac80211: add improved HW queue control
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 12 Apr 2012 13:19:44 +0300
In-Reply-To: <1333463330.3574.22.camel@jlt3.sipsolutions.net>
References: <20120403082416.559209159@sipsolutions.net>
	 (sfid-20120403_102724_757636_B390B8A7) <1333441784.3574.4.camel@jlt3.sipsolutions.net>
	 (sfid-20120403_102952_948276_9E4FF728) <1333463330.3574.22.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, 2012-04-03 at 16:28 +0200, Johannes Berg wrote: 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> mac80211 currently only supports one hardware queue
> per AC. This is already problematic for off-channel
> uses since if we go off channel while the BE queue
> is full and then try to send an off-channel frame
> the frame will never go out. This will become worse
> when we support multi-channel since then a queue on
> one channel might be full, but we have to stop the
> software queue for all channels. That is obviously
> not desirable.
> 
> To address this problem allow drivers to register
> more hardware queues, and allow them to map them to
> virtual interfaces. When they stop a hardware queue
> the corresponding AC software queues on the correct
> interfaces will be stopped as well. Additionally,
> there's an off-channel queue to solve that problem
> and a per-interface after-DTIM beacon queue. This
> allows drivers to manage software queues closer to
> how the hardware works.
> 
> Currently, there's a limit of 16 hardware queues.
> This may or may not be sufficient, we can adjust it
> as needed.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: fix aggregation TX queue number
> v3: fix error goto in ieee80211_do_open (thanks Eliad)

John has applied this patch yesterday and now I'm getting a WARNING with
wl12xx, when I try to start AP-mode:

[  162.963806] wl12xx: loaded
[  166.137451] wl12xx: firmware booted (Rev 7.3.5.0.98)
[  166.165344] ------------[ cut here ]------------
[  166.170593] WARNING: at net/mac80211/iface.c:171 ieee80211_check_queues+0x164/0x174 [mac80211]()
[  166.180023] Modules linked in: wl12xx mac80211 cfg80211 rfkill wl12xx_sdio [last unloaded: rfkill]
[  166.189666] [<c001deb0>] (unwind_backtrace+0x0/0x148) from [<c04fe264>] (dump_stack+0x20/0x24)
[  166.198852] [<c04fe264>] (dump_stack+0x20/0x24) from [<c0040320>] (warn_slowpath_common+0x64/0x74)
[  166.208374] [<c0040320>] (warn_slowpath_common+0x64/0x74) from [<c004035c>] (warn_slowpath_null+0x2c/0x34)
[  166.218780] [<c004035c>] (warn_slowpath_null+0x2c/0x34) from [<bf1961fc>] (ieee80211_check_queues+0x164/0x174 [mac80211])
[  166.230712] [<bf1961fc>] (ieee80211_check_queues+0x164/0x174 [mac80211]) from [<bf19855c>] (ieee80211_do_open+0x590/0xc74 [mac80211])
[  166.243713] [<bf19855c>] (ieee80211_do_open+0x590/0xc74 [mac80211]) from [<bf198cb4>] (ieee80211_open+0x74/0x80 [mac80211])
[  166.255737] [<bf198cb4>] (ieee80211_open+0x74/0x80 [mac80211]) from [<c0433228>] (__dev_open+0xac/0xf8)
[  166.265716] [<c0433228>] (__dev_open+0xac/0xf8) from [<c042f0fc>] (__dev_change_flags+0x8c/0x138)
[  166.275177] [<c042f0fc>] (__dev_change_flags+0x8c/0x138) from [<c0433144>] (dev_change_flags+0x20/0x58)
[  166.285217] [<c0433144>] (dev_change_flags+0x20/0x58) from [<c048e660>] (devinet_ioctl+0x6d4/0x7a4)
[  166.294860] [<c048e660>] (devinet_ioctl+0x6d4/0x7a4) from [<c048ff84>] (inet_ioctl+0x1d0/0x1d4)
[  166.304107] [<c048ff84>] (inet_ioctl+0x1d0/0x1d4) from [<c041a558>] (sock_ioctl+0x7c/0x284)
[  166.313018] [<c041a558>] (sock_ioctl+0x7c/0x284) from [<c013ab0c>] (do_vfs_ioctl+0x90/0x598)
[  166.321990] [<c013ab0c>] (do_vfs_ioctl+0x90/0x598) from [<c013b098>] (sys_ioctl+0x84/0x8c)
[  166.330810] [<c013b098>] (sys_ioctl+0x84/0x8c) from [<c00151e0>] (ret_fast_syscall+0x0/0x3c)
[  166.339782] ---[ end trace bb957f3ebaf8b8ed ]---
[  166.344757] wl12xx: down


> +static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
> +{
> +	int n_queues = sdata->local->hw.queues;
> +	int i;
> +
> +	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
> +		if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
> +				 IEEE80211_INVAL_HW_QUEUE))
> +			return -EINVAL;
> +		if (WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
> +				 n_queues))
> +			return -EINVAL;
> +	}
> +
> +	if (sdata->vif.type != NL80211_IFTYPE_AP) {
> +		sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
> +		return 0;
> +	}
> +
> +	if (WARN_ON_ONCE(sdata->vif.cab_queue == IEEE80211_INVAL_HW_QUEUE))
> +		return -EINVAL;
> +
> +	if (WARN_ON_ONCE(sdata->vif.cab_queue >= n_queues))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +

I'm hitting the "sdata->vif.cab_queue == IEEE80211_INVAL_HW_QUEUE".

I think the problem is that we should check whether the
IEEE80211_HW_QUEUE_CONTROL flag is set and skip the cab_queue checks,
like we do if it's not NL80211_IFTYPE_AP.

It seems that this fixes the problem:

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6e85fae..23d1da3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -163,7 +163,8 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
                        return -EINVAL;
        }
 
-       if (sdata->vif.type != NL80211_IFTYPE_AP) {
+       if ((sdata->vif.type != NL80211_IFTYPE_AP) ||
+           !(sdata->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)) {
                sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
                return 0;
        }

What do you think?


-- 
Cheers,
Luca.

