Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab1J1KJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 06:09:53 -0400
Subject: Re: [PATCH] orinoco: release BSS structures returned by
 cfg80211_inform_bss()
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1319796003-404-1-git-send-email-kilroyd@googlemail.com> (sfid-20111028_120854_823825_84190D26)
References: <1319719502.3944.5.camel@jlt3.sipsolutions.net>
	 <1319796003-404-1-git-send-email-kilroyd@googlemail.com>
	 (sfid-20111028_120854_823825_84190D26)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 12:09:48 +0200
Message-ID: <1319796588.8931.9.camel@jlt3.sipsolutions.net> (sfid-20111028_120956_586939_C9CF2C35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 11:00 +0100, David Kilroy wrote:
> The pointer returned by cfg80211_inform_bss is a referenced
> struct. The orinoco driver does not need to keep the struct, so
> we just release it.

Thanks!


> +	cbss = cfg80211_inform_bss(wiphy, channel, bss->a.bssid, timestamp,
> +				   capability, beacon_interval, ie_buf, ie_len,
> +				   signal, GFP_KERNEL);
> +	if (cbss)
> +		cfg80211_put_bss(cbss);

Obviously doesn't hurt, but cfg80211_put_bss(NULL) is acceptable, if
you'd prefer the code that way.

johannes

