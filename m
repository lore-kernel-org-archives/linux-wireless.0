Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPOTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:19:41 -0500
Message-ID: <1387203571.2057.11.camel@jlt4.sipsolutions.net> (sfid-20131216_151952_109090_31D1485C)
Subject: Re: [PATCH 1/2 V3] nl80211/cfg80211: Add support for drivers with
 AP SME that require PMF SA Query assistance
From: Johannes Berg <johannes@sipsolutions.net>
To: Chet Lanctot <clanctot@codeaurora.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 15:19:31 +0100
In-Reply-To: <1386713477-30040-2-git-send-email-clanctot@codeaurora.org> (sfid-20131210_231131_934459_38971108)
References: <1386713477-30040-1-git-send-email-clanctot@codeaurora.org>
	 <1386713477-30040-2-git-send-email-clanctot@codeaurora.org>
	 (sfid-20131210_231131_934459_38971108)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-10 at 14:11 -0800, Chet Lanctot wrote:
> This adds support for drivers that have AP SME integrated but do
> not implement the SA Query procedure that is part of Protected
> Management Frames (PMF, 802.11w).
> 
> Instead, hostapd can be used to assist drivers that lack SA Query
> Procedure handling on their own by allowing them to specify this as
> a device capability flag.
> 
> Also, a station flag is added to let hostapd indicate to the driver
> that the SA Query procedure is complete and the driver can process
> association requests from the station normally.

How will this work? If the device is processing the auth/assoc request
frames, then how can hostapd know this? Is the device expected to then
pass up the frame?

Also, which (upstream) driver is going to use this?

> + * @NL80211_ATTR_AP_SME_NO_SA_QUERY: The driver for this device
> + *	implments the AP SME but lacks support for doing the MFP SA

typo: implements

> + *	Query procedure.  This flag is used to express the need for
> + *	a userspace helper (hostapd) to do this procedure and notifiy

typo: notify

> + *	the driver through cfg80211 when it is complete.

Should probably say how the driver is notified (via the station flag)?

> @@ -3689,7 +3689,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
>  		return -EINVAL;
>  
>  	/* When you run into this, adjust the code below for the new flag */
> -	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
> +	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
>  
>  	switch (statype) {
>  	case CFG80211_STA_MESH_PEER_KERNEL:
> @@ -3766,7 +3766,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
>  				  BIT(NL80211_STA_FLAG_ASSOCIATED) |
>  				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
>  				  BIT(NL80211_STA_FLAG_WME) |
> -				  BIT(NL80211_STA_FLAG_MFP)))
> +				  BIT(NL80211_STA_FLAG_MFP) |
> +				  BIT(NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED)))
>  			return -EINVAL;
>  
>  		/* but authenticated/associated only if driver handles it */

Maybe we should also check if the driver supports the flag?

> @@ -4090,7 +4091,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
>  		return -EINVAL;
>  
>  	/* When you run into this, adjust the code below for the new flag */
> -	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
> +	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
>  
>  	switch (dev->ieee80211_ptr->iftype) {
>  	case NL80211_IFTYPE_AP:

Can this really be right? Is it simply invalid on a new station? Why
does this even make sense - this is done for AP SME where this is never
invoked?

Anyway you need to reject adding TDLS peers with this flag, for example,
afaict.

johannes

