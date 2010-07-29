Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab0G2Ujk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 16:39:40 -0400
Subject: Re: [PATCH 1/2] mac80211: support use of NAPI for bottom-half
 processing
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280434454-3597-1-git-send-email-linville@tuxdriver.com>
References: <1280434454-3597-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 22:39:38 +0200
Message-ID: <1280435978.3823.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-29 at 16:14 -0400, John W. Linville wrote:

> +	struct napi_struct napi;
> +	int napi_weight;

Why is the napi struct visible to drivers? Ok .. I see later.

> @@ -1679,6 +1684,8 @@ enum ieee80211_ampdu_mlme_action {
>   *	switch operation for CSAs received from the AP may implement this
>   *	callback. They must then call ieee80211_chswitch_done() to indicate
>   *	completion of the channel switch.
> + *
> + * @napi_poll: Poll Rx queue for incoming data frames.

should this document that napi_weight must be set?

> +	int (*napi_poll)(struct napi_struct *napi, int budget);

I'd prefer passing the hw here and having mac80211 wrap it in a simple
function that does the container_of magic? Anything preventing that?
Then the napi struct can be hidden from drivers.

johannes

