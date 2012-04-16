Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2DPRbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 13:31:47 -0400
Message-ID: <4F8C5776.6060209@sipsolutions.net> (sfid-20120416_193151_097042_9B868938)
Date: Mon, 16 Apr 2012 10:31:34 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Validate legacy rateset.
References: <1334298173-4132-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120413_082304_815922_B50E6F19)
In-Reply-To: <1334298173-4132-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120413_082304_815922_B50E6F19)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/12/2012 11:22 PM, Bala Shanmugam wrote:
> Legacy rates are not validated while configuring
> tx rateset using iw. So below cmd is accepted by nl80211.
> sudo iw wlan2 set bitrates legacy-2.4 3
>
> Validate legacy rates and return
> error while configuring improper rates.
>
> Signed-off-by: Bala Shanmugam<bkamatch@qca.qualcomm.com>
> ---
>   net/wireless/nl80211.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index e49da27..cc7bef7 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -5540,6 +5540,8 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>   				sband,
>   				nla_data(tb[NL80211_TXRATE_LEGACY]),
>   				nla_len(tb[NL80211_TXRATE_LEGACY]));
> +			if (mask.control[band].legacy == 0)
> +				return -EINVAL;

I don't think this is right since it would also reject an intentionally 
empty set.

johannes
