Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33028 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaGXLJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 07:09:37 -0400
Message-ID: <1406200166.14675.16.camel@jlt4.sipsolutions.net> (sfid-20140724_130939_712150_F0389F63)
Subject: Re: [PATCHv2 1/2] cfg80211: extend coverage_class datatype
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Date: Thu, 24 Jul 2014 13:09:26 +0200
In-Reply-To: <1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123925_429943_609B768D)
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140724_123925_429943_609B768D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 12:39 +0200, Lorenzo Bianconi wrote:

> @@ -1269,8 +1270,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>  				rdev->wiphy.frag_threshold) ||
>  		    nla_put_u32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
>  				rdev->wiphy.rts_threshold) ||
> -		    nla_put_u8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
> -			       rdev->wiphy.coverage_class) ||
> +		    nla_put_s16(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
> +				rdev->wiphy.coverage_class) ||
>  		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
>  			       rdev->wiphy.max_scan_ssids) ||
>  		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,

This will break existing userspace.

Also please supply a better commit message.

johannes

