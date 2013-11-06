Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3KFKYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:24:24 -0500
Message-ID: <1383733459.14307.22.camel@jlt4.sipsolutions.net> (sfid-20131106_112427_311529_C5CE2025)
Subject: Re: [PATCH 05/19] cfg80211: processing core regulatory hints on its
 own
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:24:19 +0100
In-Reply-To: <1383671897-7746-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181722_813465_91E1B730)
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
	 <1383671897-7746-6-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131105_181722_813465_91E1B730)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 09:18 -0800, Luis R. Rodriguez wrote:

>  	struct wiphy *wiphy = NULL;
> +	enum reg_request_treatment treatment;

This

>  	if (WARN_ON(!reg_request->alpha2))
>  		return;
> @@ -1552,7 +1580,18 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>  		return;
>  	}
>  
> -	switch (__regulatory_hint(wiphy, reg_request)) {
> +	switch (reg_request->initiator) {
> +	case NL80211_REGDOM_SET_BY_CORE:
> +		reg_process_hint_core(reg_request);
> +		return;
> +	case NL80211_REGDOM_SET_BY_USER:
> +	case NL80211_REGDOM_SET_BY_DRIVER:
> +	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
> +		treatment = __regulatory_hint(wiphy, reg_request);
> +		break;
> +	}
> +
> +	switch (treatment) {

is used uninitialized here

johannes

