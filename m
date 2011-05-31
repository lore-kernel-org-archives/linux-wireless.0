Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50259 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886Ab1EaXDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 19:03:20 -0400
Message-ID: <4DE573AF.8060405@openwrt.org> (sfid-20110601_010328_604609_D16E17DA)
Date: Wed, 01 Jun 2011 01:03:11 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [RFC 20/32] ath9k: set NF limits for AR9330
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org> <1306870643-7935-21-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1306870643-7935-21-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-31 9:37 PM, Gabor Juhos wrote:
> Signed-off-by: Gabor Juhos<juhosg@openwrt.org>
> ---
>   drivers/net/wireless/ath/ath9k/ar9003_phy.c |    5 ++++-
>   drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 ++
>   2 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index a0ca1eb..eb18b63 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -1089,7 +1089,10 @@ static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
>   {
>   	ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ;
>   	ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ;
> -	ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9300_2GHZ;
> +	if (AR_SREV_9300(ah))
> +		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9330_2GHZ;
Typo in the SREV check?

- Felix
