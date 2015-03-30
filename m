Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45733 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbbC3JLT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 05:11:19 -0400
Message-ID: <1427706675.26117.24.camel@sipsolutions.net> (sfid-20150330_111122_604655_12248D56)
Subject: Re: [PATCH] cfg80211: Stop calling crda if it is not responsive
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@suse.com
Date: Mon, 30 Mar 2015 11:11:15 +0200
In-Reply-To: <1427609931-6113-1-git-send-email-ilan.peer@intel.com> (sfid-20150329_081902_084943_B4703242)
References: <1427609931-6113-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150329_081902_084943_B4703242)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-29 at 09:18 +0300, Ilan Peer wrote:
> Patch eeca9fce1d71a4955855ceb0c3b13c1eb9db27c1 (cfg80211: Schedule
> timeout for all CRDA call) introduced a regression, where in case
> that crda is not installed (or not configured properly etc.), the
> regulatory core will needlessly continue to call it.

And print a message, which was the complaint :)

> @@ -544,6 +549,11 @@ static int call_crda(const char *alpha2)
>  	/* query internal regulatory database (if it exists) */
>  	reg_regdb_query(alpha2);
>  
> +	if (reg_crda_timeouts > REG_MAX_CRDA_TIMEOUTS) {
> +		pr_info("Exceeded CRDA call max attempts. Not calling CRDA\n");
> +		return -EINVAL;
> +	}

and won't this just trade one message for another??

Or in fact, duplicate messages - 'calling crda' followed by 'exceeded'?

johannes

