Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2FTMMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:12:25 -0400
Message-ID: <1340194342.4655.59.camel@jlt3.sipsolutions.net> (sfid-20120620_141229_393516_D9BDFF6B)
Subject: Re: [PATCH v3 1/2] nl80211/cfg80211: add scan channel times to scan
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Date: Wed, 20 Jun 2012 14:12:22 +0200
In-Reply-To: <CAK80WHbMVr0GVrKRGL9OD8CUHi8FBVRL0tDGewf9doLm2etb0g@mail.gmail.com>
References: <1340177634-24568-1-git-send-email-victorg@ti.com>
	 <1340178370.4655.22.camel@jlt3.sipsolutions.net>
	 <CAK80WHYU+dOvMQG2aDTP7rO6b=MZXDVcX4a7KGpLizgutVcD8g@mail.gmail.com>
	 <1340180991.4655.30.camel@jlt3.sipsolutions.net>
	 <CAK80WHbMVr0GVrKRGL9OD8CUHi8FBVRL0tDGewf9doLm2etb0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 13:38 +0300, Goldenshtein, Victor wrote:

> Will add this check, so we will read scan attributes only if the
> NL80211_FEATURE_SCAN_TIMES is set by the  driver.

Thx.

> > If I set *ONLY* max_passive_ch_time = 10 via nl80211, what will happen?
> >
> 
> There is no MAX times for the software scan, so the default values
> will be used ,no problem here.

What if it's hardware scan, not software scan?

> The hw_scan has it's own specific default values, and it should
> validate that his default min_passive_channel_time is <=
> max_passive_ch_time from the user request.

I don't think you're understanding it yet ...

Say I have USER_max_passive_time but DEFAULT_min_passive_time -- that
can cause all kinds of weird things to happen, and forcing drivers to
validate it seems rather stupid.

> The other option is to enforce usermode to define always min *and*
> max, something like:
> if ((info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) &&
>     (info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME])) {
>              request->min_ch_time =
> nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]);
>              request->max_ch_time =
> nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]);
>     }
> 
> Although, not sure that enforcing is the correct way ?

It makes a lot more sense than your way which can result in invalid
configurations being passed to the driver ...

johannes

