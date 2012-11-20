Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2KTLl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:41:57 -0500
Message-ID: <1353411746.9399.14.camel@jlt4.sipsolutions.net> (sfid-20121120_124200_608974_9D2EFB2E)
Subject: Re: [PATCH 08/15] wlcore: add chanctx implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Date: Tue, 20 Nov 2012 12:42:26 +0100
In-Reply-To: <1353343170-26516-9-git-send-email-eliad@wizery.com> (sfid-20121119_173952_507956_82E60242)
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	 <1353343170-26516-9-git-send-email-eliad@wizery.com>
	 (sfid-20121119_173952_507956_82E60242)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:

> +static int wlcore_op_add_chanctx(struct ieee80211_hw *hw,
> +				 struct ieee80211_chanctx_conf *ctx)
> +{
> +	wl1271_debug(DEBUG_MAC80211, "mac80211 add chanctx %d (type %d)",
> +		     ieee80211_frequency_to_channel(ctx->channel->center_freq),
> +		     ctx->channel_type);

Ok so I just realized there's another small issue with this patch/these
patches -- my VHT changes, which I'm planning to merge soon, will change
the chanctx_conf structure contents, which might then be tricky with git
tree handling?

I'm not too worried about that, but might be something to keep in mind.
Right now my changes are easy because they only affect hwsim as the only
driver using channel contexts.

johannes

