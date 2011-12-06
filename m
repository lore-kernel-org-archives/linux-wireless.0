Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1LFJJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 04:09:40 -0500
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1323140612-3050-1-git-send-email-mar.kolya@gmail.com> (sfid-20111206_040350_541483_DE1175A9)
References: <1322641938.3982.0.camel@jlt3.sipsolutions.net>
	 <1323140612-3050-1-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111206_040350_541483_DE1175A9)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 10:09:36 +0100
Message-ID: <1323162576.4696.4.camel@jlt3.sipsolutions.net> (sfid-20111206_100944_995368_FF0F5E8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-05 at 22:03 -0500, Nikolay Martynov wrote:
> Currently code allows three (HT_AGG_MAX_RETRIES) unanswered addba
> requests. When this limit is reached aggregation is turned off for
> given TID permanently. This doesn't seem right: three requests is
> not that much, some 'blackout' can happen, but effect of it affects
> whole connection indefinitely.
>   This patch increases number of retries to 15. Also, when there have
> been 3 or more retries it splits further retries apart by 15 seconds
> instead of sending them in very short period of time.
> 
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>

> +	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_BURST_RETRIES &&
> +	   jiffies - sta->ampdu_mlme.last_addba_req_time[tid] <
> +	   HT_AGG_RETRIES_PERIOD) {

You should use the time_after or time_before macros to avoid issues with
jiffies wrapping. Other than that looks good to me.

johannes

