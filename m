Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab3EGNhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 09:37:47 -0400
Message-ID: <1367933862.8328.18.camel@jlt4.sipsolutions.net> (sfid-20130507_153750_649706_11E88207)
Subject: Re: [RFC 01/12] mac80211: track and share mesh BSSes among
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 07 May 2013 15:37:42 +0200
In-Reply-To: <1367548442-8229-2-git-send-email-thomas@cozybit.com> (sfid-20130503_043613_832435_74C8844A)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
	 <1367548442-8229-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130503_043613_832435_74C8844A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok this is big ... Let me tackle it patch by patch I guess :-)

> +struct mesh_local_bss {

> +	bool can_share;

Does that even make sense? I mean, wouldn't you simply not link/create
such an entry if the given vif can't share?

> @@ -818,6 +986,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  	local->fif_other_bss--;
>  	atomic_dec(&local->iff_allmultis);
>  	ieee80211_configure_filter(local);
> +
> +	netif_tx_stop_all_queues(sdata->dev);

how is that related to this patch?

johannes

