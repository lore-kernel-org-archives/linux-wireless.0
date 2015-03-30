Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:54025 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752720AbbC3PDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 11:03:43 -0400
Message-ID: <1427727818.14276.7.camel@perches.com> (sfid-20150330_170346_635401_65B14245)
Subject: Re: [PATCH 1/2] mac80211: add TX fastpath
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Mon, 30 Mar 2015 08:03:38 -0700
In-Reply-To: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net>
References: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 16:36 +0200, Johannes Berg wrote:
> In order to speed up mac80211's TX path, add the "fast-xmit" cache
> that will cache the data frame 802.11 header and other data to be
> able to build the frame more quickly. This cache is rebuilt when
> external triggers imply changes, but a lot of the checks done per
> packet today are simplified away to the check for the cache.

Possible optimization:

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
[]
> +void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
> +{
> +	struct ieee80211_fast_tx build = {}, *fast_tx, *old;

This "{}" memset should probably be moved farther down
because there are many return paths that are possible
before the memset is necessary.

> +	struct ieee80211_local *local = sta->local;
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	struct ieee80211_hdr *hdr = (void *)build.hdr;
> +	struct ieee80211_chanctx_conf *chanctx_conf;
> +	__le16 fc;
> +
> +	if (!(local->hw.flags & IEEE80211_HW_SUPPORT_FAST_XMIT))
> +		return;
> +
> +	ieee80211_clear_fast_xmit(sta);
> +
> +	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS &&
> +	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) &&
> +	    sdata->vif.type == NL80211_IFTYPE_STATION)
> +		return;
> +
> +	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
> +		return;
> +
> +	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
> +	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
> +	    test_sta_flag(sta, WLAN_STA_PS_DELIVER))
> +		return;
> +
> +	/* fast-xmit doesn't handle fragmentation at all */
> +	if (local->hw.wiphy->frag_threshold != (u32)-1)
> +		return;

To here...

> +	rcu_read_lock();
> +	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> +	if (!chanctx_conf) {
> +		rcu_read_unlock();
> +		return;
> +	}

or here.

> +	build.band = chanctx_conf->def.chan->band;
> +	rcu_read_unlock();



