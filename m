Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60570 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZAKHJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 02:09:15 -0500
Received: by bwz14 with SMTP id 14so30765737bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 23:09:14 -0800 (PST)
To: johannes@sipsolutions.net
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/2] mac80211: use ps-poll to request frames in power save mode
References: <20090111070148.3849.10799.stgit@tikku>
	<20090111070353.3849.5303.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 11 Jan 2009 09:09:12 +0200
In-Reply-To: <20090111070353.3849.5303.stgit@tikku> (Kalle Valo's message of "Sun\, 11 Jan 2009 09\:03\:54 +0200")
Message-ID: <877i52s4iv.fsf@litku.valot.fi> (sfid-20090111_080919_172376_EFA9ADA5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> +static ieee80211_rx_result debug_noinline
> +ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
> +{

[...]

> +	if (!ieee80211_has_moredata(hdr->frame_control)) {
> +		/* AP has no more frames buffered for us */
> +		printk(KERN_DEBUG "no more data");
> +		local->pspolling = false;
> +		return RX_CONTINUE;
> +	}
> +
> +	/* more data bit is set, let's request a new frame from the AP */
> +	ieee80211_send_pspoll(local, rx->sdata);
> +
> +	return 0;

This should obviously return RX_CONTINUE, I'll fix it in the next
round.

-- 
Kalle Valo
