Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab3LEObZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 09:31:25 -0500
Message-ID: <1386253879.4182.4.camel@jlt4.sipsolutions.net> (sfid-20131205_153128_857356_93C22EAB)
Subject: Re: [PATCH 4/4] cfg80211: prevent race condition on scan request
 cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Dec 2013 15:31:19 +0100
In-Reply-To: <1386235289-27278-4-git-send-email-eliad@wizery.com> (sfid-20131205_102143_377274_769D4BD3)
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
	 <1386235289-27278-4-git-send-email-eliad@wizery.com>
	 (sfid-20131205_102143_377274_769D4BD3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 11:21 +0200, Eliad Peller wrote:

> @@ -219,8 +221,13 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
>  	 * the scan request or not ... if it accesses the dev
>  	 * in there (it shouldn't anyway) then it may crash.
>  	 */
> -	if (!leak)
> -		kfree(request);
> +	if (leak) {
> +		request->pending_cleanup = true;
> +		return;

This seems insufficient, if the driver never indicates completion, we'd
never clear rdev->scan_req?

johannes

