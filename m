Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18654 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab1H2GTZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 02:19:25 -0400
Date: Mon, 29 Aug 2011 11:49:49 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2 3/4] ath9k: only fill antenna diversity hw ops on
 chips that support it
Message-ID: <20110829061948.GA29433@vmraj-lnx.users.atheros.com> (sfid-20110829_081937_263103_1E5FE68C)
References: <1314597262-49427-1-git-send-email-nbd@openwrt.org>
 <1314597262-49427-2-git-send-email-nbd@openwrt.org>
 <1314597262-49427-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314597262-49427-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 07:54:21AM +0200, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_phy.c |    6 ++++--
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c |    6 ++++--
>  drivers/net/wireless/ath/ath9k/hw-ops.h     |    6 ++++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
> index 3cbbb03..38e91f8 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
> @@ -570,8 +570,10 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
>  	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
>  	priv_ops->do_getnf = ar9002_hw_do_getnf;
>  
> -	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
> -	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
> +	if (AR_SREV_9285(ah)) {
> +		ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
> +		ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
> +	}
>
Better to return from ar900*_hw_antdiv_comb_conf_set/get based on
hw capability (ATH9K_HW_CAP_ANT_DIV_COMB) rathar than adding chip specific
checks. That looks to be more generic.

--
Rajkumar
