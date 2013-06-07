Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42836 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3FGK6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 06:58:48 -0400
Message-ID: <51B1BCE1.6080200@openwrt.org> (sfid-20130607_125851_298965_52737352)
Date: Fri, 07 Jun 2013 12:58:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, mickflemm@gmail.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com,
	adrian@freebsd.org, ath5k-devel@lists.ath5k.org,
	bvahl@net.t-labs.tu-berlin.de
Subject: Re: [PATCH v2] ath5k: make use of the new rate control API
References: <1370593505-4439-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1370593505-4439-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-07 10:25 AM, Thomas Huehn wrote:
> This patch enabels ath5k to use the new rate table to lookup each
> mrr rate and retry information per packet.
> 
> Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  drivers/net/wireless/ath/ath5k/base.c         |   77 ++++++++++++++++++++-----
>  drivers/net/wireless/ath/ath5k/base.h         |   14 +++--
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
>  3 files changed, 72 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 7f702fe..c63759f 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1587,6 +1633,8 @@ ath5k_tx_frame_completed(struct ath5k_hw *ah, struct sk_buff *skb,
>  
>  	ieee80211_tx_info_clear_status(info);
>  
> +	memcpy(info->status.rates, bf->rates, sizeof(info->status.rates));
> +
>  	for (i = 0; i < ts->ts_final_idx; i++) {
>  		struct ieee80211_tx_rate *r =
>  			&info->status.rates[i];
Please make sure that either this code is able to deal with a size
mismatch of info->status.rates vs. bf->rates, or that it at least fails
at compile time if the size of info->status.rate gets changed.

- Felix
