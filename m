Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab2FUPEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 11:04:07 -0400
Message-ID: <1340291033.4489.37.camel@jlt3.sipsolutions.net> (sfid-20120621_170410_541492_0E30BDE0)
Subject: Re: [RFCv2 12/13] cfg80211: add channel checking for iface
 combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 17:03:53 +0200
In-Reply-To: <1340172859-18146-13-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	 <1340172859-18146-13-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:

> +		case CHAN_MODE_SHARED:
> +			for (i = 0; i < num_max_channels; i++)
> +				if (!used_channels[i] || used_channels[i] == ch)
> +					break;
> +
> +			if (i == num_max_channels) {
> +				kfree(used_channels);
> +				return -ENOMEM;
> +			}

Maybe use -EBUSY? -ENOMEM doesn't seem to make much sense? Or maybe I'm
misunderstanding that? You allocated a pretty large number before (one
for each possible channel) so we can't really run into it anyway I
think?

Or ... maybe we should just do something like

 * force num_different_channels to be less than a constant we define,
   say #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10 by checking in
   wiphy registration -- if somebody needs more .... they can change
   the constant but that seems very unlikely
 * use a channel array with that size on the stack here, then we don't
   even need to alloc memory

johannes

