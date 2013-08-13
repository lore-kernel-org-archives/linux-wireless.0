Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33280 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3HMMxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 08:53:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21002.11091.326462.787869@gargle.gargle.HOWL> (sfid-20130813_145307_946286_E61DB2F3)
Date: Tue, 13 Aug 2013 18:19:23 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 3/5] ath9k: avoid accessing MRC registers on single-chain devices
In-Reply-To: <1376390010-81819-3-git-send-email-nbd@openwrt.org>
References: <1376390010-81819-1-git-send-email-nbd@openwrt.org>
	<1376390010-81819-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> They are not implemented, and accessing them might trigger errors
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index 39c3730..18a5aa4 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -1172,6 +1172,10 @@ skip_ws_det:
>  		 * is_on == 0 means MRC CCK is OFF (more noise imm)
>  		 */
>  		bool is_on = param ? 1 : 0;
> +
> +		if (ah->caps.rx_chainmask == 1)
> +			break;
> +

This is done in ath9k_hw_set_cck_nil(). All the 1-chain devices are handled
except AR9330. Maybe the chainmask check can be moved there ?

Sujith
