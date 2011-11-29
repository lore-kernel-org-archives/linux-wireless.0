Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1K2IYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 03:24:47 -0500
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com> (sfid-20111129_032719_396777_36A0D329)
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111129_032719_396777_36A0D329)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 09:24:44 +0100
Message-ID: <1322555084.4110.2.camel@jlt3.sipsolutions.net> (sfid-20111129_092450_842509_D9C85365)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 21:27 -0500, Nikolay Martynov wrote:
> Currently code allows three (HT_AGG_MAX_RETRIES) unanswered addba
> requests. When this limit is reached aggregation is turned off for
> given TID permanently. This doesn't seem right: three requests is
> not that much, some 'blackout' can happen, but effect of it affects
> whole connection indefinitely.
>   This patch adds a period of time (1 minute) after which counter of
> sent addba requests is reset so addba requests can be sent again.
>   The traffic impact should be negligible, but connection will be more
> stable.

Conceptually, this seems OK to me, although on broken APs it might mean
connection stalls every minute, not sure how desirable that is?

> -	/* we have tried too many times, receiver does not want A-MPDU */
>  	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
> -		ret = -EBUSY;
> -		goto err_unlock_sta;
> +		unsigned int timestamp = jiffies_to_msecs(jiffies);
> +		if (timestamp - sta->ampdu_mlme.last_addba_req_time[tid] >
> +		    HT_AGG_RETRIES_PERIOD) {

this logic is confusing -- why ms? jiffies should be absolutely OK for
minute-long timeouts.

johannes

