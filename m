Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43386 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZAIIOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 03:14:00 -0500
Received: by bwz14 with SMTP id 14so28552451bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 00:13:58 -0800 (PST)
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Subject: Re: drivers returning wrong results from their _tx op
References: <1231193264.3697.41.camel@johannes>
	<b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com>
	<1231246859.3503.0.camel@johannes>
	<20090109022347.GA5077@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 10:13:56 +0200
In-Reply-To: <20090109022347.GA5077@hash.localnet> (Bob Copeland's message of "Thu\, 8 Jan 2009 21\:23\:47 -0500")
Message-ID: <87hc4828xn.fsf@litku.valot.fi> (sfid-20090109_091406_850141_8E237274)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Tue, Jan 06, 2009 at 02:00:59PM +0100, Johannes Berg wrote:
>> I guess it should, want to send a patch?
>
> Some of the return values were already documented in the ops comment, 
> and others like set_key() elsewhere.  Here are more, though I guessed 
> on a couple of them...
>
> From: Bob Copeland <me@bobcopeland.com>
> Date: Thu, 8 Jan 2009 21:00:34 -0500
> Subject: [PATCH] mac80211: document return codes from ops callbacks
>
> For any callbacks in ieee80211_ops, specify what values the return
> codes represent.  While at it, fix a couple of capitalization and
> punctuation differences.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  include/net/mac80211.h |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index b7b9014..903dade 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1170,6 +1170,7 @@ enum ieee80211_ampdu_mlme_action {
>   *	configuration in the TX control data. This handler should,
>   *	preferably, never fail and stop queues appropriately, more
>   *	importantly, however, it must never fail for A-MPDU-queues.
> + *	Returns NETDEV_TX_OK, or NETDEV_TX_BUSY if it fails.
>   *	Must be implemented and atomic.

Based on discussion from netdev I have understood that NETDEV_TX_BUSY
is not recommended, it's better to stop the queue already earlier,
drop the frame or store the skb somewhere else temporarily. Johannes,
have I understood this correctly?

It would be nice to have this documented here.

-- 
Kalle Valo
