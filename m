Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3LCOS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 09:18:27 -0500
Message-ID: <1386080300.4393.25.camel@jlt4.sipsolutions.net> (sfid-20131203_151830_593393_F4A16A98)
Subject: Re: [PATCH v3] cfg80211: fix dfs channel state after stopping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 03 Dec 2013 15:18:20 +0100
In-Reply-To: <1386073466-2641-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131203_132446_051868_EEB2B776)
References: <1386073466-2641-1-git-send-email-marek.puzyniak@tieto.com>
	 (sfid-20131203_132446_051868_EEB2B776)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 13:24 +0100, Marek Puzyniak wrote:

> +		if (cfg80211_chandef_dfs_required(wdev->wiphy, &wdev->preset_chandef))
> +			cfg80211_leave_dfs_chandef(wdev->wiphy, &wdev->preset_chandef);

*far* too long lines. Read CodingStyle documentation please.

Also, any reason to not always call cfg80211_leave_dfs_chandef()?

> +static void cfg80211_leave_dfs_chans(struct wiphy *wiphy,
> +				     u32 center_freq,
> +				     u32 bandwidth)
> +{
> +	struct ieee80211_channel *c;
> +	u32 freq, start_freq, end_freq;
> +
> +	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
> +	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
> +
> +	for (freq = start_freq; freq <= end_freq; freq += 20) {
> +		c = ieee80211_get_channel(wiphy, freq);
> +		if (!c)
> +			continue;
> +		if (!(c->flags & IEEE80211_CHAN_RADAR))
> +			continue;
> +		if (c->dfs_state != NL80211_DFS_AVAILABLE)
> +			continue;
> +
> +		cfg80211_set_chans_dfs_state(wiphy, freq, 20, NL80211_DFS_USABLE);

This seems to catch it anyway.

This also seems a bit wrong, if regulatory happens to change and say the
RADAR flag goes away, then this won't set it to USABLE, and then if the
RADAR flag later re-appears? I guess Luis should handle that in reg.c
though or so?

johannes

