Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:26580 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752349AbYBRCD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 21:03:56 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Mon, 18 Feb 2008 11:03:47 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
References: <1203088151.8931.197.camel@johannes.berg> <20080216022918.18775.59888.stgit@one> <1203239503.12783.22.camel@johannes.berg>
In-Reply-To: <1203239503.12783.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802181103.47670.bruno@thinktube.com> (sfid-20080218_020400_643389_C50FAF36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 February 2008 18:11:43 Johannes Berg wrote:
> Looks good, thanks for your patience. I have two minor comments still,
> sorry for the lack of focus in earlier review.
>
> > +		} else if (local && local->ops && local->ops->get_tsf)
> > +			/* second best option: get current TSF */
> > +			rx_timestamp = local->ops->get_tsf(local_to_hw(local));
>
> This is assuming that we don't manage to process the frame within 192
> usecs. I guess that will be true since we defer it to a tasklet, but do
> we want to bet on it in the future or should we simply widen the window
> where the merge *won't* happen because the driver doesn't provide enough
> info and also add the 24 bytes offset here?

sorry, i was to fast in agreeing ;)
on a second thought i realized that we don't need to worry about that:

since we get to handle the frame after it was received *completely*, we can be 
sure that the current time returned by get_tsf() is later than the time when 
byte 24 was received. so no need for adding the offset.

i'll rebase the unmodified patch series and resend it.

bruno
