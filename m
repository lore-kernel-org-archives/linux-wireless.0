Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2KLKzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 05:55:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TXrfb-0006Ue-C0
	for linux-wireless@vger.kernel.org; Mon, 12 Nov 2012 11:55:11 +0100
Message-ID: <1352717747.9525.18.camel@jlt4.sipsolutions.net> (sfid-20121112_115518_442574_79F4D1A2)
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 12 Nov 2012 11:55:47 +0100
In-Reply-To: <1352492254-29399-5-git-send-email-johannes@sipsolutions.net> (sfid-20121109_211712_618062_B5E490F2)
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121109_211712_618062_B5E490F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-09 at 21:17 +0100, Johannes Berg wrote:

> +	case NL80211_CHAN_WIDTH_80P80:
> +		width = 80;
> +		if (!vht_cap->vht_supported)
>  			return -EINVAL;
> +		break;
> +	case NL80211_CHAN_WIDTH_80:
> +		width = 80;
> +		if (!vht_cap->vht_supported)
> +			return -EINVAL;
> +		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
> +			return -EINVAL;

Just noticed & fixed the capability check bug here :)

johannes

