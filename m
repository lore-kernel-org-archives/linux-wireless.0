Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0I0Ivm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:51:42 -0400
Subject: Re: [PATCH 17/25] wl1271: Fix tid-configuration of TX frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1285576669-8070-18-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-18-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 10:51:40 +0200
Message-ID: <1285577500.4043.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:37 +0300, Luciano Coelho wrote:

> -	/* queue */
> +	/* queue (we use same identifiers for tid's and ac's */
>  	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
> -	desc->tid = wl1271_tx_ac_to_tid(ac);
> +	desc->tid = ac;

That cannot be right unless the "tid" field in "desc" should really be
named "ac", since there are twice as many TIDs as ACs. Nor can
"ac_to_tid" ever be a valid function, for the same reason, it can't be a
surjective function.

If you need the TID (with some fallback for non-QoS frames) you should
probably add that to the tx info somehow.

johannes

