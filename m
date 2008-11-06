Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30527 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYKFU4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 15:56:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 12:56:45 -0800
Date: Thu, 6 Nov 2008 12:56:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] cfg80211/mac80211: Add 802.11d support
Message-ID: <20081106205643.GI6169@tesla> (sfid-20081106_215649_362666_3E17254E)
References: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com> <1226004327-10290-2-git-send-email-lrodriguez@atheros.com> <1226004327-10290-3-git-send-email-lrodriguez@atheros.com> <1226004327-10290-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1226004327-10290-4-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 06, 2008 at 12:45:27PM -0800, Luis Rodriguez wrote:
> This adds country IE parsing to mac80211 and enables its usage
> within the new regulatory infrastructure in cfg80211. We parse
> the country IEs only on management beacons for the BSSID you are
> associated to and disregard the IEs when the country and environment
> (indoor, outdoor, any) matches the already processed country IE.
> 
> To avoid following misinformed or outdated APs we build and use
> a regulatory domain out of the intersection between what the AP
> provides us on the country IE and what CRDA is aware is allowed
> on the same country.
> 
> A secondary device is allowed to follow only the same country IE
> as it make no sense for two devices on a system to be in two
> different countries.
> 
> In the case the AP is using country IEs for an incorrect country
> the user may help compliance further by setting the regulatory
> domain before or after the IE is parsed and in that case another
> intersection will be performed.
> 
> CONFIG_WIRELESS_OLD_REGULATORY is supported but requires CRDA
> present.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath9k/recv.c |    5 +-

Crap please ignore that hunk.. or I can resend...

  Luis

