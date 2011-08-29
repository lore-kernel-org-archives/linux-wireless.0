Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1H2NwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 09:52:19 -0400
Subject: Re: [RFC 1/3] mac80211: comment allocation of mesh frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1314212539-23669-2-git-send-email-thomas@cozybit.com> (sfid-20110824_210307_317279_1FED7400)
References: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
	 <1314212539-23669-2-git-send-email-thomas@cozybit.com>
	 (sfid-20110824_210307_317279_1FED7400)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:52:19 +0200
Message-ID: <1314625939.8959.13.camel@jlt3.sipsolutions.net> (sfid-20110829_155223_569951_A6313A46)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 12:02 -0700, Thomas Pedersen wrote:

> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index f09e5e8..d5f4a41 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -129,11 +129,14 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
>  		struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_local *local = sdata->local;
> -	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
> +	struct sk_buff *skb = NULL;

No need for = NULL.


> +	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
> +			    25 + sizeof(mgmt->u.action.u.mesh_action) +
> +			    2 + 37); /* HWMP IEs */

IEs? Should that be singular, or is the 2 wrong? Is there a struct that
you can take sizeof() for 37? Maybe not yet?

johannes

