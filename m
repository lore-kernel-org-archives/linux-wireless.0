Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2JAOQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 10:16:48 -0400
Message-ID: <1349101039.10330.41.camel@jlt4.sipsolutions.net> (sfid-20121001_161652_009790_333DA8CE)
Subject: Re: [RFC] mac80211: connect with HT20 if HT40 is not permitted
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Paul Stewart <pstew@chromium.org>
Date: Mon, 01 Oct 2012 16:17:19 +0200
In-Reply-To: <1349100121.10330.36.camel@jlt4.sipsolutions.net> (sfid-20121001_160132_854322_0F7EDEE5)
References: <1349100121.10330.36.camel@jlt4.sipsolutions.net>
	 (sfid-20121001_160132_854322_0F7EDEE5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-01 at 16:02 +0200, Johannes Berg wrote:

> Fix this, while avoiding the "Korean AP" issue by
> disabling HT40 and advertising HT20 to the AP
> when connecting.

> +		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
> +			if (cbss->channel->flags & IEEE80211_CHAN_NO_HT40PLUS)

What we *could* do instead is use "channel->orig_flags" here instead to
fix the iwlwifi issue, and allow HT40 RX for when the driver/device has
no limitations (and the HT40 restriction would be regulatory only), but
I'm not sure I see much value in that? That might enable HT40 RX (not
TX) for some devices on those Korean HT40 APs though, but it'd also be
somewhat tricky in the code and more or less relying on cfg80211
internals ... I'd prefer not to introduce these kinds of subtle
differences between devices but if somebody has strong objections to the
patch as is I'd be willing to change it.

johannes

