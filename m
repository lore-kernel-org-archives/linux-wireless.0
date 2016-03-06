Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:34823 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbcCFP6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 10:58:14 -0500
Date: Sun, 6 Mar 2016 17:58:09 +0200
From: Jouni Malinen <j@w1.fi>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Subject: Re: [PATCH 1/3] mac80211: TDLS: always downgrade invalid chandefs
Message-ID: <20160306155809.GA15589@w1.fi> (sfid-20160306_165817_673541_0EB99B78)
References: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 02, 2016 at 11:28:31PM +0200, Emmanuel Grumbach wrote:
> Even if the current chandef width is equal to the station's max-BW, it
> doesn't mean it's a valid width for TDLS. Make sure to always check
> regulatory constraints in these cases.

I'm not sure this change is the trigger for this issue, but since I
noticed this for the first time today and this commit went just in into
wireless-testing.git, it sounds quite likely that this was indeed behind
the busy loop I saw here:

> diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
> @@ -332,7 +332,7 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
>  	/* proceed to downgrade the chandef until usable or the same */
> -	while (uc.width > max_width &&
> +	while (uc.width > max_width ||
>  	       !cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &uc,
>  					      sdata->wdev.iftype))
>  		ieee80211_chandef_downgrade(&uc);

I'm not sure what caused the chandef in uc (sta->tdls_chandef) to be
invalid (actually, I do know now; see below), but when running the
ap_open_tdls_vht80plus80 test case, the VM got stuck in a busy loop
printing warnings about that chandef being invalid and with this while
loop being here, that never stopped.. Well, until couple of hours later
when I noticed this and stopped in manually.  That left 1.6 GB of kernel
log entries (and that would have been way more had printk not refused to
print so much, but even the "589 printk messages dropped" prints were
enough to make this huge)..

So if uc is invalid here, it looks like this loop can get into a state
where it never terminates. The iteration hits these warnings:

WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:336 cfg80211_chandef_dfs_required+0xf6/0x100()
WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:608 cfg80211_chandef_usable+0x188/0x190()
WARNING: CPU: 2 PID: 623 at net/mac80211/util.c:2860 ieee80211_chandef_downgrade+0x138/0x170()

The last entry here seems to imply that c->width downgrade happened once
successfully since no other WARN_ON_ONCE() were printed within
ieee80211_chandef_downgrade().

This is followed by:

WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:336 cfg80211_chandef_dfs_required+0xf6/0x100()
WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:608 cfg80211_chandef_usable+0x188/0x190()
WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:336 cfg80211_chandef_dfs_required+0xf6/0x100()
WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:608 cfg80211_chandef_usable+0x188/0x190()
WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:336 cfg80211_chandef_dfs_required+0xf6/0x100()
WARNING: CPU: 2 PID: 623 at net/wireless/chan.c:608 cfg80211_chandef_usable+0x188/0x190()
WARNING: CPU: 2 PID: 623 at net/mac80211/util.c:2848 ieee80211_chandef_downgrade+0x39/0x170()

The last one here is hitting the WARN_ON_ONCE(1) in the default case, so
it looks like there were two more successful downgrades (total three
starting from 80+80) and then we are in a busy loop with every new
iteration hitting that default case warning at util.c:2848. This
continues indefinitely.

Regardless of what caused the chandef to be invalid, this while loop
would benefit of some added robustness to avoid the possibility of an
infinite loop where the channel width cannot be downgraded anymore.

The console log from that run is available here:
http://w1.fi/a/tdls-downgrade-warning-loop.txt


It looks like I can now reproduce this easily with
./vm-run.sh ap_open_tdls_vht80plus80

Reverting this one-liner patch removes that loop and all of the chandef
invalid warnings.

With this patch applied, ieee80211_tdls_chandef_vht_upgrade() shows
uc.width == 4, max_width == 4, and chandef valid at the beginning of the
function. Just before the while loop, uc.width == 3, max_width == 3,
chandef is now invalid. On loop iterations, uc.width is dropped to 2, 1,
and finally 0 where it remains while the loop continues running.

The chandef becomes invalid when going through the centers_80mhz loop
and setting uc.center_freq1 = 5210, uc.width = NL80211_CHAN_WIDTH_80.
The AP was configured with seg0_idx 42 + seg1_idx 155.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
