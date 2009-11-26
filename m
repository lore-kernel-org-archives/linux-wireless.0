Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58480 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZKZPNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:13:18 -0500
Received: by bwz27 with SMTP id 27so607437bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 07:13:24 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: Re: [PATCH 06/12] wl1251: fix payload alignment
References: <20091126150141.917.35278.stgit@tikku>
	<20091126150904.917.8182.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 26 Nov 2009 17:13:21 +0200
In-Reply-To: <20091126150904.917.8182.stgit@tikku> (Kalle Valo's message of "Thu\, 26 Nov 2009 17\:09\:04 +0200")
Message-ID: <877htd9v5a.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> mac80211 complained that in some cases IP payload was not aligned, this
> happens if the 802.11 header is not aligned with four. In that case we have
> to move entire packet to make the payload properly aligned.

[...]

> +	if (ieee80211_hdrlen(*fc) & 0x3) {
> +		from = skb->data;
> +		to = skb_push(skb, 2);
> +		memmove(to, from, skb->len);
> +		fc = (u16 *) skb->data;
> +	}

I would like to get comments about this. Is memmove() the right way to
do this?

-- 
Kalle Valo
