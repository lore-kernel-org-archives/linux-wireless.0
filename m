Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33040 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232AbaGXLLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 07:11:00 -0400
Message-ID: <1406200256.14675.17.camel@jlt4.sipsolutions.net> (sfid-20140724_131116_292285_E2415F5F)
Subject: Re: [PATCHv2 1/2] cfg80211: extend coverage_class datatype
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Date: Thu, 24 Jul 2014 13:10:56 +0200
In-Reply-To: <1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123925_429943_609B768D)
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140724_123925_429943_609B768D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 12:39 +0200, Lorenzo Bianconi wrote:

> @@ -2242,10 +2243,15 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>  		changed |= WIPHY_PARAM_COVERAGE_CLASS;
>  	}
>  
> +	if (info->attrs[NL80211_ATTR_WIPHY_DYNACK]) {
> +		coverage_class = -1;
> +		changed |= WIPHY_PARAM_COVERAGE_CLASS;
> +	}

I think you should also reject having both dyn and fixed attributes.

You should also have a feature flag that drivers set that you test here
and refuse dynamic if it's not supported, I guess?

johannes

