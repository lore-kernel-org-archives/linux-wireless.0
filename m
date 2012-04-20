Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2DTM0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 08:26:23 -0400
Message-ID: <1334924774.3446.0.camel@jlt3.sipsolutions.net> (sfid-20120420_142627_036812_C8F23282)
Subject: Re: [PATCH v2] cfg80211: Validate legacy rateset.
From: Johannes Berg <johannes@sipsolutions.net>
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 20 Apr 2012 14:26:14 +0200
In-Reply-To: <1334924001-8584-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120420_141349_224433_434B8225)
References: <1334924001-8584-1-git-send-email-bkamatch@qca.qualcomm.com>
	 (sfid-20120420_141349_224433_434B8225)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-20 at 17:43 +0530, Bala Shanmugam wrote:
> Legacy rates are not validated while configuring
> tx rateset using iw. So below cmd is accepted by nl80211.
> sudo iw wlan2 set bitrates legacy-2.4 1 2 3
> 
> Validate legacy rates and return
> error if any rate in the rateset is not valid.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> ---
>  net/wireless/nl80211.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index bcf6f70..f822e7c 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -5577,6 +5577,9 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>  				sband,
>  				nla_data(tb[NL80211_TXRATE_LEGACY]),
>  				nla_len(tb[NL80211_TXRATE_LEGACY]));
> +			if (mask.control[band].legacy == 0 &&
> +				nla_len(tb[NL80211_TXRATE_LEGACY]))
> +				return -EINVAL;

Please use proper indentation.

johannes

