Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab2FUN02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:26:28 -0400
Message-ID: <1340285187.4489.25.camel@jlt3.sipsolutions.net> (sfid-20120621_152631_031995_20D946A4)
Subject: Re: [RFC v2 7/7] mac80211: reuse channels for channel context
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 15:26:27 +0200
In-Reply-To: <1340280216-18807-8-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
	 <1340280216-18807-8-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 14:03 +0200, Michal Kazior wrote:

> +		if (!ieee80211_channel_types_are_compatible(ctx->conf.channel_type,
> +							    channel_type,
> +							    &compat_type))
> +			continue;
> +		if (ctx->conf.channel_type != compat_type) {
> +			ctx->conf.channel_type = compat_type;
> +			drv_change_chantype(local, ctx);
> +		}

Maybe somehow there's a need to also keep track of the desired channel
type per vif so it can be recalculated when a vif is removed, not just
when one is added?

johannes

