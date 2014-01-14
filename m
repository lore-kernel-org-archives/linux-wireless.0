Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaANQKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:10:41 -0500
Message-ID: <1389715838.32635.6.camel@jlt4.sipsolutions.net> (sfid-20140114_171044_901542_E9871C69)
Subject: Re: [RFC 3/4] cfg80211: implement multi-vif interface combination
 validation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 17:10:38 +0100
In-Reply-To: <1389194818-7864-4-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163117_199824_9DE4796D)
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	 <1389194818-7864-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140108_163117_199824_9DE4796D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-08 at 16:26 +0100, Michal Kazior wrote:
> This refactors cfg80211_can_use_iftype_chan() so
> that it can process multi-interface combination
> changes.
> 
> With this it will be possible to handle, e.g.
> multi-BSS channel switching.

This seems reasonable, though I'd say that this code:

> +	for (i = 0; i < num_params; i++) {
> +		if (WARN_ON(hweight32(params[i].radar_detect_width) > 1))
> +			return -EINVAL;
> +
> +		/* sanity check - make sure all wdevs in params[] are unique */
> +		for (j = 0; j < num_params; j++)
> +			if (WARN_ON(i != j && params[i].wdev == params[j].wdev))
> +				return -EINVAL;

could then use some refactoring, e.g. by moving the inside of the loop
to another helper function.

johannes

