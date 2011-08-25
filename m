Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1HYFGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 01:06:08 -0400
Subject: Re: [PATCH] mac80211: fix suspend/resume races with unregister hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
In-Reply-To: <1313150459-13234-1-git-send-email-sgruszka@redhat.com>
References: <1313150459-13234-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 22:06:24 -0700
Message-ID: <1314248784.5054.44.camel@jlt3.sipsolutions.net> (sfid-20110825_070612_654641_2C08A56E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-12 at 14:00 +0200, Stanislaw Gruszka wrote:

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ab12440..97db267 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1875,6 +1875,9 @@ struct wiphy {
>  	 * you need use set_wiphy_dev() (see below) */
>  	struct device dev;
>  
> +	/* protects ->resume, ->suspend sysfs callbacks against unregister hw */
> +	bool registered;

Warning(/home/wireless/wireless-testing//include/net/cfg80211.h:1927):
No description found for parameter 'registered'

please fix.

johannes

