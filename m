Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2AaFxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:53:18 -0500
Message-ID: <4F27819A.1030200@sipsolutions.net> (sfid-20120131_065320_402119_42D844B7)
Date: Mon, 30 Jan 2012 21:52:26 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: [RFC 7/9] nl80211/cfg80211: add DFS feature flag
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-8-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-8-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
> +static int nl80211_put_feature_flags(struct wiphy *wiphy,
> +				     struct sk_buff *msg)
> +{
> +	if (wiphy->flags&  WIPHY_FLAG_SUPPORTS_DFS)
> +		wiphy->features |= NL80211_FEATURE_DFS;
> +
> +
> +	NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, wiphy->features);
> +
> +	return 0;
> +nla_put_failure:
> +	return -ENOBUFS;
> +}

I think you misunderstood the new feature flags -- they're supposed to 
be set by the driver directly, not indirectly via wiphy->flags.

johannes
