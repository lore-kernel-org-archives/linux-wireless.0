Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXFy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 01:54:58 -0400
Message-ID: <1335246891.3447.1.camel@jlt3.sipsolutions.net> (sfid-20120424_075501_702462_F9A76D07)
Subject: Re: [RFC] mac80211: use queue helpers to suspend/resume transmission
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 24 Apr 2012 07:54:51 +0200
In-Reply-To: <1335208539-31325-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1335208539-31325-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-24 at 00:45 +0530, Rajkumar Manoharan wrote:

>  		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> -		if (local->queue_stop_reasons[q] ||
> +		if (local->queue_stop_reasons[q]) {
> +			defer_tx = true;
> +			if (test_bit(IEEE80211_QUEUE_STOP_REASON_ALLOW_PROBE,
> +					&local->queue_stop_reasons[q]) &&
> +			    (ieee80211_is_probe_req(hdr->frame_control) ||
> +			     ieee80211_is_nullfunc(hdr->frame_control)))
> +				defer_tx = false;
> +		}
> +		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
> +		if (defer_tx ||

No no no. This is completely wrong. NACK.

johannes

