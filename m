Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2I0JPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 05:15:23 -0400
Message-ID: <1348737359.10353.8.camel@jlt4.sipsolutions.net> (sfid-20120927_111526_802295_C19C5226)
Subject: Re: [PATCH 3/3] cfg80211: add support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@chromium.org>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 27 Sep 2012 11:15:59 +0200
In-Reply-To: <20120926165952.BC0E71E051D@sleffler.sfo.corp.google.com> (sfid-20120926_185956_248675_62A4C8CC)
References: <20120926165952.BC0E71E051D@sleffler.sfo.corp.google.com>
	 (sfid-20120926_185956_248675_62A4C8CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-21 at 11:08 -0700, Sam Leffler wrote:

>  void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
>  {
>  	struct cfg80211_scan_request *request;
> @@ -47,8 +50,16 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
>  
>  	if (request->aborted)
>  		nl80211_send_scan_aborted(rdev, wdev);
> -	else
> +	else {
> +		if (request->flags & CFG80211_SCAN_FLAG_FLUSH) {
> +			/* flush entries from previous scans */
> +			spin_lock_bh(&rdev->bss_lock);
> +			__cfg80211_bss_expire(rdev,
> +				jiffies - request->scan_start);

I wonder if we should pass an absolute time instead? jiffies will
continue to advance while we iterate the list etc., if we pass the
absolute time in both cases we can avoid this small race condition.

The race really isn't important, but it still seems a bit cleaner to me
overall.

johannes

