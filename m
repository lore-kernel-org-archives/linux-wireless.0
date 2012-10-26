Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965612Ab2JZVYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 17:24:11 -0400
Message-ID: <1351286683.10813.26.camel@jlt4.sipsolutions.net> (sfid-20121026_232414_537599_24C4E89F)
Subject: Re: [PATCH] wireless: Allow registering more than one beacon
 listener.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Oct 2012 23:24:43 +0200
In-Reply-To: <1351286218-24838-1-git-send-email-greearb@candelatech.com> (sfid-20121026_231718_180820_DA67353D)
References: <1351286218-24838-1-git-send-email-greearb@candelatech.com>
	 (sfid-20121026_231718_180820_DA67353D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Ben,

A few small comments:

> +	nreg = kzalloc(sizeof(*nreg), GFP_KERNEL);

> +	memset(nreg, 0, sizeof(*nreg));

that memset isn't needed after kzalloc :)

> +	spin_lock_bh(&rdev->beacon_registrations_lock);
> +	list_for_each_entry(reg, &rdev->beacon_registrations, list) {
> +		msg = nlmsg_new(len + 100, gfp);

since you're in the locked section, you can't use "gfp" any more and
have to use GFP_ATOMIC, so we could even consider removing the gfp
argument to the function.


> +		hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FRAME);
> +		if (!hdr) {
> +			spin_unlock_bh(&rdev->beacon_registrations_lock);
> +			nlmsg_free(msg);
> +			return;

it seems this should be some goto since nla_put_failure is also a label?


> +		spin_lock_bh(&rdev->beacon_registrations_lock);
> +		list_for_each_entry_safe(reg, tmp, &rdev->beacon_registrations,
> +					 list) {
> +			if (reg->nlportid == notify->portid) {
> +				list_del(&reg->list);
> +				kfree(reg);

You could break here, but it doesn't matter much.

johannes


