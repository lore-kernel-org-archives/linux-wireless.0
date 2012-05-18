Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52472 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965749Ab2ERR1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 13:27:35 -0400
Message-ID: <1337362052.4802.12.camel@jlt3.sipsolutions.net> (sfid-20120518_192751_098834_6D8E2DBD)
Subject: Re: [RFC 1/6] mac80211: introduce channel contexts skeleton code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 May 2012 19:27:32 +0200
In-Reply-To: <1337342589-10617-2-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
	 <1337342589-10617-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 14:03 +0200, Michal Kazior wrote:

>  /**
> + * struct ieee80211_channel_context - channel context that vifs may be tuned to
> + *
> + * @channel: the channel to tune to
> + * @channel_type: the channel (HT) type
> + * @vif_list: vifs bound to channel context
> + */
> +struct ieee80211_channel_context {
> +	struct ieee80211_channel *channel;
> +	enum nl80211_channel_type channel_type;
> +
> +	struct list_head vif_list;
> +};

A few trivial comments on this particular struct: I think we should have
an internal and an external struct, so that the list for example isn't
accessible by drivers. OTOH, maybe it should be accessible?

The other request I have would be for private space in here for the
driver, like inside vif or hw structs.

Anyway, I'll look over this in more detail, but might not get to it
before the week after next.

johannes

