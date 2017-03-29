Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42744 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751990AbdC2ImG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:42:06 -0400
Message-ID: <1490776922.7948.9.camel@sipsolutions.net> (sfid-20170329_104237_571645_9DC44AF1)
Subject: Re: [PATCH v3 1/4] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 10:42:02 +0200
In-Reply-To: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	if (data->center_freq2)
> +		if (nla_put_u32(skb, HWSIM_ATTR_CENTER_FREQ2, data-
> >center_freq2))
> +			goto nla_put_failure;
> 

That could be simplified (but isn't really interesting)

> + * @HWSIM_ATTR_CENTER_FREQ2: Configured center-freq-2.  Not reported
> if value is zero.

The value 0 really just means "unused" - so this should say "if used"
or so.

> + * @HWSIM_ATTR_CH_WIDTH: Configured channel width.

That should point to &enum nl80211_chan_width I guess.

Anyway, all of that is minor. The biggest problem I have with this
patch upon close review is that it only handles one case, and actually
ties that case to the nl80211 API.

hwsim also can deal with channel contexts already, is there much point
in making the userspace API ignorant of that?

johannes
