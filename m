Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53346 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbeDSPHL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 11:07:11 -0400
Message-ID: <1524150429.3024.24.camel@sipsolutions.net> (sfid-20180419_170715_398609_8172992F)
Subject: Re: [PATCH 2/2] cfg80211: Modify wiphy registration semantics for
 self managed hints
From: Johannes Berg <johannes@sipsolutions.net>
To: asinghal@codeaurora.org
Cc: Jouni Malinen <jouni@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Kiran Kumar Lokere <klokere@codeaurora.org>,
        jjohnson@codeaurora.org
Date: Thu, 19 Apr 2018 17:07:09 +0200
In-Reply-To: <5f8caab7e7cfb88072c2e221ea45063e@codeaurora.org>
References: <1520106021-16836-1-git-send-email-jouni@codeaurora.org>
         <1520106021-16836-2-git-send-email-jouni@codeaurora.org>
         <1521627352.2645.27.camel@sipsolutions.net>
         <5f8caab7e7cfb88072c2e221ea45063e@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-04-13 at 13:32 -0700, asinghal@codeaurora.org wrote:
> hi Johannes,
>              please fine some replies inline:
> 
> On 2018-03-21 03:15, Johannes Berg wrote:
> > So I really think this should just be one patch - it's not about
> > "registration semantics" but about which types of requests get passed
> > to reg_notifier(), and if you do it in one place you'd better also do
> > it in the other.
> 
> Sure, I have combined the two patches in one patch now:

So now you should probably resend it properly, with a new subject that
explains it better? Just "modify" doesn't really seem all that
appropriate - what's the modification?

Patchwork also lost half the patch for some reason, probably you
copy/pasted it and lost some whitespace at an empty line.

> Call the regulatory notifier for self managed hints only if
> initiator is NL80211_REGDOM_SET_BY_USER and hint type is
> NL80211_USER_REG_HINT_CELL_BASE. Also call regulatory
> notifier when wiphy is registered under similar conditions.

I guess this should say why.

>   	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
>   		wiphy = &rdev->wiphy;
> -		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
> +		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
>   			self_managed_found = true;
> -		else
> -			return false;
> +			if (request->initiator == NL80211_REGDOM_SET_BY_USER &&
> +			    request->user_reg_hint_type ==
> +			    NL80211_USER_REG_HINT_CELL_BASE)
> +				reg_call_notifier(wiphy, request);
> +		} else {
> +			self_managed_found = false;
> +		}
>   	}

This is awkward now - how about

self_managed_found = regulatory_flags & SELF_MANAGED;
if (self_managed_found &&
    request->initiator == ... &&
    ...)
        reg_call_notifier(...)


> @@ -3700,15 +3705,21 @@ void wiphy_regulatory_register(struct wiphy 
> *wiphy)
>   {
>   	struct regulatory_request *lr;
> 
> -	/* self-managed devices ignore external hints */
> -	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
> +	lr = get_last_request();
> +
> +	/* self-managed devices ignore beacon hints and 11d IE */
> +	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
>   		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
> -					   REGULATORY_COUNTRY_IE_IGNORE;
> +			REGULATORY_COUNTRY_IE_IGNORE;

no need to change the indentation here

johannes
