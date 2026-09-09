Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1BB56853B;
	Wed,  9 Sep 2026 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788967565; cv=none; b=uTx9WCtcMjDCbEEDjCSGndnG8C2Q1eWL3D8SO+P4DL6liJ+Ep2nesRc+kGZwYyvTyY3KPRPK7uJ+qeqFRlYvyfY9qIbHJjIiZQmBiAllelA9FiYO9cyM6BUA4sOE/Vk4CwDhBQWgwla2nW4WHqViaQXjizy9mohPrqsrFpuWFwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788967565; c=relaxed/simple;
	bh=Cf2hreyau1WZx40HIJYSVkVGQzRG0li2rax//M/ZeU4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tBJpHiz1pGYoLv7CgHmR0aAEksWAIrjwwp3BhlunDgSQ3/6WR/xEFK40l34ojyXxILN1yxhzd0gMgo9pFj/F/IXpXFeKfGiGRoIMazgWEBYxd+3o0BgAQJ4Gl2TeMm2SFO/Y6PbDJzV5XIAZwV70eYkYySID0EIKGqR5Ug27BtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFrRqU5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFrRqU5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040F61F00A3A;
	Wed,  9 Sep 2026 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788967563;
	bh=VmQN5R3CMf9j81dcdOm9MAKp3S2PpYHRXM8Hl8m6TOs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MFrRqU5NzXxhXulydHviLVF6dDyfaTnZkx4JVwjYIM0iKTXRE3XWW7D6KjTMYndtJ
	 YTJWgw2vba5sJJY+iHWMQTmo6DykvxjfPZQ75Fq4VoNSoospeE+eJWNTKMP5n+iNXe
	 6jPTbBb45uaRQvfZgV4694yq1JKVkwi1ntvhd0zncE1DdwLbix5x5TNYImmTTSd2Uf
	 60zyY6bvTUW6YLSGCZCQsRtyB1SmcgzM2QL3h1nqgDkFuUMyTGKtJhriVGziKDsN3q
	 jOAe42bQt4u0o6/bS1fXHBgizu0I+2ILe4N/OLLQdc31FlHJB/MsEX+/cE6OcG5qo8
	 nVkdrX5ivac5g==
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
From: netdev-bot+sashiko@kernel.org
To: omermetekaya0@gmail.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
 kvalo@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 horms@kernel.org, syzbot+adeb8550754921fece20@syzkaller.appspotmail.com,
 syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com,
 syzbot+8141dcbd23a8f857798a@syzkaller.appspotmail.com,
 syzbot+b0ae8f1abf7d891e0426@syzkaller.appspotmail.com,
 syzbot+d6bbe0f5705cb8a5aa2b@syzkaller.appspotmail.com, kuba@kernel.org
Date: Wed, 09 Sep 2026 15:26:02 +0000
Message-ID: <178896756249.219967.143377989987631735@kernel.org>
In-Reply-To: <20260906002657.620076-2-omermetekaya0@gmail.com>
References: <20260906002657.620076-2-omermetekaya0@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 2 · Medium: 1 · Low: 0

- [High] The patch only splits the rtnl critical section at wiphy
  granularity: rtnl_lock() is taken once per snapshot entry and held…
- [High] If a new wiphy device is registered between the two RCU read
  sections, the array population loop will break early and silently skip…
- [Medium] reg_check_chans_work() (net/wireless/reg.c:2464) newly depends
  on a kmalloc_array() allocation and silently abandons the entire…

--

wifi: cfg80211: avoid holding rtnl_mutex across all cfg80211_leave() calls

This changes reg_check_chans_work() to snapshot cfg80211_rdev_list under RCU
with a device reference on each entry, then take rtnl_lock() once per device
instead of once for the whole walk.  A wiphy.registered check is added after
each rtnl acquisition to skip devices that went away in the meantime.

Closes: https://syzkaller.appspot.com/bug?extid=adeb8550754921fece20
Closes: https://syzkaller.appspot.com/bug?extid=101224300649c3eb8af4
Closes: https://syzkaller.appspot.com/bug?extid=8141dcbd23a8f857798a
Closes: https://syzkaller.appspot.com/bug?extid=b0ae8f1abf7d891e0426
Closes: https://syzkaller.appspot.com/bug?extid=d6bbe0f5705cb8a5aa2b

> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index a8336baf85dc6..7a3f1e470e143 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2463,15 +2463,49 @@ static void reg_leave_invalid_chans(struct wiphy *wiphy)
>  
>  static void reg_check_chans_work(struct work_struct *work)
>  {
> -	struct cfg80211_registered_device *rdev;
> +	struct cfg80211_registered_device *rdev, **snap;
> +	int i, n = 0;
>  
>  	pr_debug("Verifying active interfaces after reg change\n");
> -	rtnl_lock();
>  
> -	for_each_rdev(rdev)
> -		reg_leave_invalid_chans(&rdev->wiphy);
> +	/*
> +	 * Snapshot rdev pointers under RCU with a device reference so they
> +	 * cannot be freed between per-device rtnl acquisitions. Using a
> +	 * per-device rtnl_lock() instead of holding it across all devices
> +	 * avoids starving other rtnl waiters when cfg80211_leave() is slow.
> +	 */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list)
> +		n++;
> +	rcu_read_unlock();
>  
> -	rtnl_unlock();
> +	if (!n)
> +		return;
> +
> +	snap = kmalloc_array(n, sizeof(*snap), GFP_KERNEL);
> +	if (!snap)
> +		return;

[Severity: Medium]
Does this silently drop the whole regulatory enforcement pass when the
allocation fails?

Before this change reg_check_chans_work() could not fail: it was just
rtnl_lock() + for_each_rdev() + reg_leave_invalid_chans().  Now a transient
kmalloc_array() failure returns without touching any wiphy, so
reg_leave_invalid_chans() never runs for any device in this round.

The only place that queues the work is reg_check_channels():

net/wireless/reg.c:reg_check_channels() {
	mod_delayed_work(system_power_efficient_wq,
			 &reg_check_chans,
			 msecs_to_jiffies(REG_ENFORCE_GRACE_MS));
}

and its callers are all regulatory-change events (set_reg request, country
IE, driver hint, indoor flag).  Nothing re-arms the work on this failure
path, so interfaces that the newly applied regdomain forbids (AP beaconing,
associated STA, joined mesh) would keep running until some unrelated later
regdomain change happens to queue the work again.

Would rescheduling the work on allocation failure, or avoiding the
snapshot array entirely (for example restarting from the list head using
the rdev list generation counter), be preferable here?

> +
> +	i = 0;
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
> +		if (i >= n)
> +			break;
> +		get_device(&rdev->wiphy.dev);
> +		snap[i++] = rdev;
> +	}
> +	rcu_read_unlock();
> +	n = i;
> +
> +	for (i = 0; i < n; i++) {
> +		rtnl_lock();
> +		if (snap[i]->wiphy.registered)
> +			reg_leave_invalid_chans(&snap[i]->wiphy);
> +		rtnl_unlock();
> +		put_device(&snap[i]->wiphy.dev);
> +	}

[Severity: High]
The count pass and the fill pass are two separate RCU read
sections with nothing held in between, so n can be stale by the
time snap[] is populated - and the truncation is silent.

wiphy_register() publishes a new radio with
list_add_rcu(&rdev->list, &cfg80211_rdev_list), i.e. at the head
of the list.  If a device is registered (USB adapter plugged in, a
new radio created) between the two rcu_read_lock() sections, the
second list_for_each_entry_rcu() starts at that brand new rdev,
fills snap[] with the first n entries and then hits the i >= n
break.  The entries that fall off are the ones at the *tail*, i.e.
the oldest radios - exactly the ones most likely to have
associated STAs, beaconing APs or joined meshes that the new
regdomain forbids.  reg_leave_invalid_chans() is never called for
them in this round, and since reg_check_channels() is only armed
from regulatory-change events, nothing retries; those interfaces
keep operating on channels the new regdomain disallows.

Note this is a functional regression against the previous
for_each_rdev() walk under rtnl, which by construction saw a
consistent list.

cfg80211_rdev_list is written under rtnl, so would it be simpler
to build the snapshot in a single pass under rtnl_lock() (counting
and get_device() together, or via cfg80211_rdev_list_generation),
then drop rtnl and re-acquire it per device for the
reg_leave_invalid_chans() calls?  If you want to keep the RCU
two-pass form, what is the plan for the list growing between the
passes - re-count and retry, or over-allocate and re-check?

[Severity: High]
Does this actually bound the rtnl hold time?  The split here is at wiphy
granularity only: rtnl is taken once and held across the complete
reg_leave_invalid_chans() pass for that wiphy.

net/wireless/reg.c:reg_leave_invalid_chans() {
	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
		bool valid;

		scoped_guard(wiphy, wiphy)
			valid = reg_wdev_chan_valid(wiphy, wdev);
		if (!valid)
			cfg80211_leave(rdev, wdev, -1);
	}
}

That inner loop is unchanged and can call cfg80211_leave() an unbounded
number of times, and each call goes into driver ops:

reg_leave_invalid_chans() -> cfg80211_leave() -> cfg80211_leave_locked() ->
cfg80211_disconnect() / cfg80211_stop_ap() / cfg80211_leave_mesh() /
cfg80211_stop_nan()

with cfg80211_leave() itself requiring rtnl:

net/wireless/core.c:cfg80211_leave() {
	ASSERT_RTNL();
	...
	guard(wiphy)(&rdev->wiphy);

	cfg80211_leave_locked(rdev, wdev, link_id);
}

So when the interfaces are concentrated on one wiphy (many wdevs on a single
radio, or one slow leave op), the longest contiguous rtnl section is the same
as before, and rtnl waiters such as inet_rtm_newaddr, tun_chr_close and
nsim_destroy can still exceed hung_task_timeout_secs.  Is that consistent
with the commit message claim that the reported hangs are closed?

Wouldn't a fix need to drop and re-acquire rtnl between wdevs, with
per-wdev re-validation after re-acquiring (re-lookup by wiphy_idx plus a
wdev registered re-check), rather than only between devices?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906002657.620076-2-omermetekaya0%40gmail.com
