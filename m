Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1K0JiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 04:38:09 -0500
Subject: Re: [PATCH] mac80211: fix race condition caused by late addBA resp
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1322378621-14647-2-git-send-email-mar.kolya@gmail.com> (sfid-20111127_082402_823149_B8E64ABA)
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	 <1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111127_082402_823149_B8E64ABA)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Nov 2011 10:38:05 +0100
Message-ID: <1322386685.4044.8.camel@jlt3.sipsolutions.net> (sfid-20111127_103814_275863_26FE29A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-11-27 at 02:23 -0500, Nikolay Martynov wrote:
> Currently if addBA respones comes in just after addba_resp_timer has
> expired we still accept addBA response and (try to) open agg
> session. This patch fixes this race condition and makes sure that if
> addba_resp_timer has expired addBA response is not longer accepted and
> we do not try to open half-closed session.

I wonder what happened that we hit all these races now ... kinda
strange.


> +	del_timer_sync(&tid_tx->addba_resp_timer);
> +
> +	/*
> +	 * Test that we are not stopping agg session now.
> +	 * Since addba_resp_timer may have just finished we need to
> +	 * check HT_AGG_STATE_STOPPING too.
> +	 */
> +	if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state)
> +	    || test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		printk(KERN_DEBUG "got addBA resp for tid %d but we are not "
> +				"(or no longer) expecting expecting it\n",
> +			tid);
> +#endif
> +		goto out;
> +	}
> +
>  	if (mgmt->u.action.u.addba_resp.dialog_token != tid_tx->dialog_token) {
>  #ifdef CONFIG_MAC80211_HT_DEBUG
>  		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);

You can't do this -- if this happens and the dialog token is bad the
session will linger forever since the timer is now dead.

Also please move the bool operators to the end of the line rather than
the start:
	if (test_bit(...) ||
	    test_bit(...)) {

Other than that the patch looks fine.

johannes

