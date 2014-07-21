Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45238 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbaGUKNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:13:42 -0400
Message-ID: <1405937608.32255.15.camel@jlt4.sipsolutions.net> (sfid-20140721_121350_935151_389810BF)
Subject: Re: [PATCH 1/2] cfg80211: add enable_dynack API
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Date: Mon, 21 Jul 2014 12:13:28 +0200
In-Reply-To: <1405859555-31806-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143239_045150_A0045046)
References: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1405859555-31806-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140720_143239_045150_A0045046)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-07-20 at 14:32 +0200, Lorenzo Bianconi wrote:

> @@ -2192,6 +2193,12 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>  			return result;
>  	}
>  
> +	if (info->attrs[NL80211_ATTR_WIPHY_DYNACK]) {
> +		result = rdev_enable_dynack(rdev);
> +		if (result)
> +			return result;
> +	}

I think it may be better to handle this in the call that's normally used
(coverage class setting), but allow the other attribute to make a sort
of "dynamic coverage class". And internally, calling drivers, it seems
fine to pass -1 or so since you can extend the datatype there, instead
of introducing a new internal callback. External/internal doesn't always
have to match perfectly.

Additionally, you'll need some capability flag I think.

johannes

