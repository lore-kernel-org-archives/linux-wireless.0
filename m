Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39293 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYKJTbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 14:31:08 -0500
Date: Mon, 10 Nov 2008 14:19:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] cfg80211/mac80211: Add 802.11d support
Message-ID: <20081110191925.GK3546@tuxdriver.com> (sfid-20081110_203114_628754_2C5B83FA)
References: <1226097635-9555-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226097635-9555-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 07, 2008 at 02:40:35PM -0800, Luis R. Rodriguez wrote:
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
> 
> This addresses Johannes' latest feedback. It replaces 3/3
> of my last series.

I'm sorry, but I see four different series w/ similar titles but
with at least some difference in patches between them.  Could you
just repost a singled unified patch series for 802.11d?

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
