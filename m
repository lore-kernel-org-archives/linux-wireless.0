Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42484 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2DPQCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 12:02:25 -0400
Message-ID: <4F8C427C.3020505@candelatech.com> (sfid-20120416_180232_965120_F0CC1854)
Date: Mon, 16 Apr 2012 09:02:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: add possible wiphy interface combinations
References: <1334590102-83386-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1334590102-83386-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 08:28 AM, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> ---
>   drivers/net/wireless/ath/ath5k/base.c |   16 ++++++++++++++++
>   1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 3007bba..2e385f5 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2415,6 +2415,19 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
>   * Initialization routines *
>   \*************************/
>
> +static const struct ieee80211_iface_limit if_limits[] = {
> +	{ .max = 256,	.types = BIT(NL80211_IFTYPE_STATION) },
> +	{ .max = 4,	.types = BIT(NL80211_IFTYPE_AP) |
> +				 BIT(NL80211_IFTYPE_MESH_POINT) },
> +};

The station max is just an arbitrary number or is 256 really
the max it can handle?  At least on ath9k, more are supported,
but I haven't tested ath5k lately....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

