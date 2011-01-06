Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab1AFVzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:55:22 -0500
Subject: Re: [RFC PATCH 10/17] zd1211rw: implement beacon fetching and
 handling ieee80211_get_buffered_bc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <201101062246.38932.chunkeey@googlemail.com>
References: <20110104234745.25309.72030.stgit@fate.lan>
	 <20110104234910.25309.19235.stgit@fate.lan>
	 <201101062246.38932.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 22:55:20 +0100
Message-ID: <1294350920.25228.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-06 at 22:46 +0100, Christian Lamparter wrote:

> Ideally, you should assign a proper sequence # to beacon frames too.
> (802.11-2007 7.1.3.4.1)
> 
> But as before, the long time between the upload and the actual beacon
> xmit by the hardware make things really difficult. If you just call
> "create_tx_desc_seq" right now, "theoretically" you have to buffer
> all management and other Non-QoS data frames until the beacon was sent.
> 
> However, no one would do that :D. Either the hardware/firmware
> controls the sequence counter or it's simply not implemented
> (and nobody cares ;) ).

Yeah ... it turns out that nobody cares. It's probably easier/better to
actually send beacons with seqno 0 instead of trying to hack around it.



> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index c47d7c0..f71ed31 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -225,6 +225,7 @@ struct ieee80211_if_ap {
>  	struct sk_buff_head ps_bc_buf;
>  	atomic_t num_sta_ps; /* number of stations in PS mode */
>  	int dtim_count;
> +	bool dtim_bc_mc;
>  };
>  
>  struct ieee80211_if_wds {
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 5950e3a..26b688b 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -2178,6 +2178,8 @@ static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
>  	if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
>  		aid0 = 1;
>  
> +	bss->dtim_bc_mc = aid0 == 1;
> +
>  	if (have_bits) {
>  		/* Find largest even number N1 so that bits numbered 1 through
>  		 * (N1 x 8) - 1 in the bitmap are 0 and number N2 so that bits
> @@ -2540,7 +2542,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
>  	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head)
>  		goto out;
>  
> -	if (bss->dtim_count != 0)
> +	if (bss->dtim_count != 0 || !bss->dtim_bc_mc)
>  		goto out; /* send buffered bc/mc only after DTIM beacon */

Hmm, interesting. That makes some sense I guess. Luckily, I have
hardware offload for this (extra queue) so I don't have to worry about
it :-)

johannes

