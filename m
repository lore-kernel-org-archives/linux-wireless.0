Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaAGQHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 11:07:51 -0500
Message-ID: <1389110867.4645.32.camel@jlt4.sipsolutions.net> (sfid-20140107_170754_637821_6D9A3F74)
Subject: Re: [PATCH v2] nl80211: add Guard Interval support for
 set_bitrate_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 17:07:47 +0100
In-Reply-To: <1387653268-2685-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131221_201445_717274_612D7DC6)
References: <1387653268-2685-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131221_201445_717274_612D7DC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-12-21 at 20:14 +0100, Janusz Dziedzic wrote:

> @@ -7474,6 +7475,9 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>  					mask.control[band].vht_mcs))
>  				return -EINVAL;
>  		}
> +		if (tb[NL80211_TXRATE_GI])
> +			mask.control[band].gi =
> +				nla_get_u8(tb[NL80211_TXRATE_GI]);

I think you need to sanity check the value, otherwise userspace can set
it to 42 and things would get rather confusing in the kernel.

johannes

