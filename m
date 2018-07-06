Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36002 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932569AbeGFM3a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 08:29:30 -0400
Message-ID: <1530880164.3197.38.camel@sipsolutions.net> (sfid-20180706_142946_286288_E47ED632)
Subject: Re: [PATCH] wireless: mark expected switch fall-throughs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2018 14:29:24 +0200
In-Reply-To: <20180704210553.GA7869@embeddedor.com>
References: <20180704210553.GA7869@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gustavo,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

You dropped the remark saying you didn't review them, but did you?

>  	case NL80211_CHAN_WIDTH_20:
>  		if (!ht_cap->ht_supported)
>  			return false;
> +		/* else: fall through */

What's the point in else:?

We also don't necessarily write

if (!...)
  return false;
else
  do_something();

but rather

if (!...)
  return false;
do_something().

I think I'd prefer without the "else:"

johannes
