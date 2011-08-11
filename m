Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1HKM6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 08:58:44 -0400
Subject: Re: [PATCH] mac80211: Tear down BA session on BAR tx failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110811_110858_764910_1F18A73A)
References: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20110811_110858_764910_1F18A73A)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 14:58:39 +0200
Message-ID: <1313067519.3992.4.camel@jlt3.sipsolutions.net> (sfid-20110811_145847_911636_EBFAA1C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-11 at 11:08 +0200, Helmut Schaa wrote:
> As described at [1] some STAs (i.e. Intel 5100 on Windows) can end up
> correctly BlockAcking incoming frames without delivering them to user
> space if a AMPDU subframe got lost and its reorder buffer isn't flushed
> by a BlockAckReq. This in turn results in up to 64 frames being stuck
> in the reorder buffer.
> 
> Accroding

typo

>  to 802.11n-2009 it is not necessary to send a BAR to flush
> the receipients RX reorder buffer but we still do that to be polite.

typo


> IMHO the Windows driver is just buggy and should be fixed to use a
> reasonable timeout for flushing its reorder buffer but the described
> behavior doesn't appear with the Ralink Legacy drivers for example since
> they trigger a tear down of the BA session in several other situations
> as well (a single failed AMPDU :) for example) and thus don't end up in
> this situation.
> 
> Johannes, feel free to NACK this patch as it really is just a
> workaround for buggy clients but I'd say it still makes sense to fall
> back to non-aggregated frames in such a situation. Furthermore, this
> situation is unlikely to happen very often but as written before I was
> able to reproduce it a couple of times.

Seems ok to me, hopefully won't happen often :)

> +		if (!acked && ieee80211_is_back_req(fc)) {
> +			/*
> +			 * BAR failed, let's tear down the BA session as a
> +			 * last resort as some STAs (Intel 5100 on Windows)
> +			 * can get stuck when the BA window isn't flushed
> +			 * correctly.
> +			 */
> +			bar = (struct ieee80211_bar *) skb->data;
> +			ieee80211_stop_tx_ba_session(&sta->sta,
> +						     bar->control >> 12 & 0xf);
> +		}

Hmm, that shift & mask makes me think twice, are there constants, and
maybe there should be some parentheses?

johannes

