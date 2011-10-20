Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1JTLNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 07:13:36 -0400
Subject: Re: [PATCH 2/3] mac80211: find correct IE offset in mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1319070203-22097-2-git-send-email-thomas@cozybit.com> (sfid-20111020_022408_281423_10D03F24)
References: <1319070203-22097-1-git-send-email-thomas@cozybit.com>
	 <1319070203-22097-2-git-send-email-thomas@cozybit.com>
	 (sfid-20111020_022408_281423_10D03F24)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 13:13:30 +0200
Message-ID: <1319109210.3959.6.camel@jlt3.sipsolutions.net> (sfid-20111020_131340_596897_C7479537)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
> +	switch (stype) {
> +	case IEEE80211_STYPE_PROBE_RESP:
> +		ies = (u8 *) mgmt->u.probe_resp.variable;
> +		break;
> +	case IEEE80211_STYPE_BEACON:
> +		ies = (u8 *) mgmt->u.beacon.variable;
> +		break;
> +	default:
> +		return;
> +	}
> +

Does that really make sense? the offset is the same anyway and we don't
get here with other frames.

johannes

