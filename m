Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2LTNqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:46:17 -0500
Message-ID: <1356011197.10029.17.camel@jlt4.sipsolutions.net> (sfid-20121220_144620_945940_CAB03041)
Subject: Re: [PATCH 2/2] mac80211: properly stop/wake queues before/after
 off-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Date: Thu, 20 Dec 2012 14:46:37 +0100
In-Reply-To: <1356010879-10054-2-git-send-email-sgruszka@redhat.com> (sfid-20121220_144135_978357_0252CBD0)
References: <1356010879-10054-1-git-send-email-sgruszka@redhat.com>
	 <1356010879-10054-2-git-send-email-sgruszka@redhat.com>
	 (sfid-20121220_144135_978357_0252CBD0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 14:41 +0100, Stanislaw Gruszka wrote:

>  		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
> -			netif_tx_stop_all_queues(sdata->dev);
> +			ieee80211_stop_queues_by_reason(&local->hw,
> +				IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);

That won't work ... if you do this you can't send probe requests or
offchannel frames any more.

What we should be doing is refcount the netif queues as well to avoid
them starting because while offchannel the driver re-enables.

johannes

