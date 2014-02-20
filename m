Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaBTPP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 10:15:29 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1WGVLU-0003uj-7W
	for linux-wireless@vger.kernel.org; Thu, 20 Feb 2014 16:15:28 +0100
Message-ID: <1392909326.5073.32.camel@jlt4.sipsolutions.net> (sfid-20140220_161531_695500_C57F7F16)
Subject: Re: [PATCH 2/2] mac80211: allow driver to return error from
 sched_scan_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 Feb 2014 16:15:26 +0100
In-Reply-To: <1392909251-5557-2-git-send-email-johannes@sipsolutions.net> (sfid-20140220_161423_693380_5ACB4780)
References: <1392909251-5557-1-git-send-email-johannes@sipsolutions.net>
	 <1392909251-5557-2-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140220_161423_693380_5ACB4780)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:14 +0100, Johannes Berg wrote:

> +++ b/include/net/mac80211.h
> @@ -2460,6 +2460,7 @@ enum ieee80211_roc_type {
>   *	This process will continue until sched_scan_stop is called.
>   *
>   * @sched_scan_stop: Tell the hardware to stop an ongoing scheduled scan.
> + *	In this case, ieee80211_sched_scan_stopped() must not be called.

The TI driver doesn't do this right, obviously, but I'm hoping somebody
can fix it. In the meantime, it'll just continue to be as racy as it
always used to be :)

johannes

