Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:52043 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752696Ab2FWICR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 04:02:17 -0400
Message-ID: <1340438536.2274.9.camel@joe2Laptop> (sfid-20120623_100226_733307_ED2AAD2D)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Sat, 23 Jun 2012 01:02:16 -0700
In-Reply-To: <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
	 <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 19:18 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are a few things that make the logging and
> debugging in mac80211 less useful than it should
> be right now:
>  * a lot of messages should be pr_info, not pr_debug
>  * wholesale use of pr_debug makes it require *both*
>    Kconfig and dynamic configuration
>  * there are still a lot of ifdefs
>  * the style is very inconsistent, sometimes the
>    sdata->name is printed in front

> Clean up everything, introducing new macros and
> separating out the station MLME debugging into
> a new Kconfig symbol.

I think all the Kconfig debugging options aren't
particularly useful.

I think you should use a level/mask module debug
variable to enable these instead of appearing to try
to minimize the size of the objects via individual
Kconfig options.

I think it'd be better to enable them all the time
(or not at all when !DEBUG) and select them for output
via the debug level.



