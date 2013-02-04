Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3BDRiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:38:18 -0500
Message-ID: <1359999522.17993.20.camel@jlt4.sipsolutions.net> (sfid-20130204_183821_034633_4F43D1B1)
Subject: Re: [PATCH 2/3] mac80211: generate mesh probe requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 04 Feb 2013 18:38:42 +0100
In-Reply-To: <1359853341-29237-3-git-send-email-thomas@cozybit.com> (sfid-20130203_020332_915907_BE35B422)
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
	 <1359853341-29237-3-git-send-email-thomas@cozybit.com>
	 (sfid-20130203_020332_915907_BE35B422)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-02 at 17:02 -0800, Thomas Pedersen wrote:

> -	pos = skb_put(skb, ie_ssid_len);
> -	*pos++ = WLAN_EID_SSID;
> +	if (ieee80211_vif_is_mesh(vif)) {
> +		pos = skb_put(skb, 2 + 2 + ssid_len);
> +		*pos++ = WLAN_EID_SSID;
> +		*pos++ = 0;
> +		/* NOTE: mesh ID will be out of order */

Why put it out of order?

Also I'm not convinced that it's a good idea to translate "SSID" from
the userspace API to "mesh ID" silently? Might make more sense to have
those separately maybe? I mean, it seems reasonable to even think you
might scan for a mesh network when you're not a mesh interface, for
example?

johannes

