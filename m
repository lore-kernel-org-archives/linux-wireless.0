Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab0ITKXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 06:23:53 -0400
Subject: Re: [RFC] mac80211: clear txflags for filtered/retried frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201009182133.50104.chunkeey@googlemail.com>
References: <201009182133.50104.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 12:23:50 +0200
Message-ID: <1284978231.3688.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-09-18 at 21:33 +0200, Christian Lamparter wrote:

>  	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING |
>  		       IEEE80211_TX_INTFL_RETRANSMISSION;
> +	info->flags &= ~(IEEE80211_TX_CTL_RATE_CTRL_PROBE |
> +			 IEEE80211_TX_CTL_PSPOLL_RESPONSE |
> +			 IEEE80211_TX_CTL_FIRST_FRAGMENT |
> +			 IEEE80211_TX_CTL_CLEAR_PS_FILT |
> +			 IEEE80211_TX_CTL_MORE_FRAMES |
> +			 IEEE80211_TX_CTL_AMPDU |
> +			 IEEE80211_TX_STAT_AMPDU_NO_BACK |
> +			 IEEE80211_TX_STAT_TX_FILTERED |
> +			 IEEE80211_TX_STAT_AMPDU);

Theo nly thing I wonder is if we should introduce some #define for the
temporary flags here and put it into mac80211.h so we'll be less likely
to forget updating it when adding new flags?

johannes

