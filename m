Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2ABKxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 05:53:04 -0500
Subject: Re: [PATCH v2 3/3] mac80211: add sta_state callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1325162501-7996-4-git-send-email-eliad@wizery.com> (sfid-20111229_134046_803491_0489828C)
References: <1325162501-7996-1-git-send-email-eliad@wizery.com>
	 <1325162501-7996-4-git-send-email-eliad@wizery.com>
	 (sfid-20111229_134046_803491_0489828C)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 11:53:01 +0100
Message-ID: <1325501581.3643.8.camel@jlt3.sipsolutions.net> (sfid-20120102_115308_679621_E661C738)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-29 at 14:41 +0200, Eliad Peller wrote:

[...]

> +static inline void drv_sta_state(struct ieee80211_local *local,
> +				 struct ieee80211_sub_if_data *sdata,
> +				 struct ieee80211_sta *sta,
> +				 enum ieee80211_sta_state state)
> +{
> +	might_sleep();
> +
> +	sdata = get_bss_sdata(sdata);
> +	check_sdata_in_driver(sdata);
> +
> +	trace_drv_sta_state(local, sdata, sta, state);
> +	if (local->ops->sta_state)
> +		local->ops->sta_state(&local->hw, &sdata->vif, sta,
> +				      state);
> +	trace_drv_return_void(local);
> +}

Might be worthwhile to pass "sta_info *sta" and add
WARN_ON(!sta->uploaded)?


I have a more fundamental issue/thought though, but it's hard to put
into words... let me start from what I thought we might want.

I think with the auth/assoc rework I'm planning, we will want to add the
station to the driver before auth, in NONE state. To implement that with
the current state, that means changing all drivers that want the station
in assoc state only.

So to solve this more cleanly, I thought we could hijack the station
state callback (this patchset) and call sta_state even when the station
isn't uploaded yet.

Basically my idea was that new drivers that use the station state
callback can add/remove stations based on the state callback.

The mac80211 backward compatibility implementation would take the state
call and call sta_add() if the station goes into ASSOC state (this
actually depends on the interface type, but that's easy to do.)

This means we need better error handling for state transitions in a lot
of cases, but I think that's doable.


What do you think?

johannes

