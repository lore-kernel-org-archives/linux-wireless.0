Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab2GXOec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 10:34:32 -0400
Message-ID: <1343140469.4415.36.camel@jlt3.sipsolutions.net> (sfid-20120724_163434_934756_497F099A)
Subject: Re: [RFC] mac80211: add PS flag to bss_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Jul 2012 16:34:29 +0200
In-Reply-To: <1342703465-26703-1-git-send-email-eliad@wizery.com> (sfid-20120719_151108_940433_38B3767C)
References: <1342703465-26703-1-git-send-email-eliad@wizery.com>
	 (sfid-20120719_151108_940433_38B3767C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-19 at 16:11 +0300, Eliad Peller wrote:
> Currently, ps mode is indicated per device (rather than
> per interface), which doesn't make a lot of sense.
> 
> Moreover, there are subtle bugs caused by the inability
> to indicate ps change along with other changes
> (e.g. when the AP deauth us, we'd like to indicate
> CHANGED_PS | CHANGED_ASSOC, as changing PS before
> notifying about disassociation will result in null-packets
> being sent (if IEEE80211_HW_SUPPORTS_DYNAMIC_PS) while
> the sta is already disconnected.)
> 
> Keep the current per-device notifications, and add
> additional per-vif notifications. In order to keep it
> simple, these notifications are NOT called due to
> (temporary) dynamic_ps/offchannel operations.

So I think if we do this, it would make sense to not do it in recalc_ps,
but like you did in disassoc:

> @@ -1368,6 +1388,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>  	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
>  		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>  		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +		sdata->vif.bss_conf.ps = false;
> +		changed |= BSS_CHANGED_PS;
>  	}
>  	local->ps_sdata = NULL;

set it directly in the relevant code.


However, I'm not sure that we really should toggle it with association?
For the original CONF_PS semantics where mac80211 actually woke up for
dynamic PS etc. this made sense, but for smarter devices I think the PS
flag could be solely mirroring the combination of
 a) broken AP => no PS
 b) user enable/disable

even when not associated?

johannes

