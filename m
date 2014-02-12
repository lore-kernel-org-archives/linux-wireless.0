Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaBLKm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 05:42:57 -0500
Message-ID: <1392201773.4146.10.camel@jlt4.sipsolutions.net> (sfid-20140212_114301_577583_13D4A4B7)
Subject: Re: [PATCH] cfg80211: bugfix in regulatory user hint process
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org,
	Inbal Hacohen <Inbal.Hacohen@intel.com>
Date: Wed, 12 Feb 2014 11:42:53 +0100
In-Reply-To: <1392190347-5570-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392190347-5570-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> After processing hint_user, we would want to schedule the
> timeout work only if we are actually waiting to CRDA. This happens
> when the status is not "IGNORE" nor "ALREADY_SET".

Luis, does this seem right to you? I looked at it but wasn't _entirely_
sure.

johannes

> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1700,7 +1700,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>  		return;
>  	case NL80211_REGDOM_SET_BY_USER:
>  		treatment = reg_process_hint_user(reg_request);
> -		if (treatment == REG_REQ_OK ||
> +		if (treatment == REG_REQ_IGNORE ||
>  		    treatment == REG_REQ_ALREADY_SET)
>  			return;
>  		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));


