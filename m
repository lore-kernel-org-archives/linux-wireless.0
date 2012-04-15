Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39568 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab2DOB7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 21:59:53 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20362.11117.884392.679390@gargle.gargle.HOWL> (sfid-20120415_040104_086756_82666667)
Date: Sun, 15 Apr 2012 07:29:09 +0530
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: [RFC 2/2] ath9k: fix tx power settings for AR9287
In-Reply-To: <1334417539-6498-2-git-send-email-juhosg@openwrt.org>
References: <1334417539-6498-1-git-send-email-juhosg@openwrt.org>
	<1334417539-6498-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> The 'ath9k_hw_update_regulatory_maxpower'
> helper function has been introduced by
> commit a55f858852e4345d0a31af593c46738ca8614bff
> (ath9k_hw: Cleanup TX power calculation for AR9287).
> 
> Updating of the max_power_level value has been moved
> into the helper function in that change, however the
> removed code from 'ath9k_hw_ar9287_set_txpower' has
> not been replaced with a call of the new helper
> function.
> 
> Due to that missing call, retrieving tx power for 2x2
> and 3x3 chainmask is not handled properly. During the
> calculation of the tx power for 2x2 and 3x3 chainmasks
> the values are reduced. Those reductions must be
> compensated during retrieving.
> 
> Fix this by adding the missing call of the helper
> function.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/eeprom_9287.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
> index f272236..b34e8b2 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
> @@ -824,6 +824,8 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
>  			regulatory->max_power_level = ratesArray[i];
>  	}
>  
> +	ath9k_hw_update_regulatory_maxpower(ah);
> +

Looks like I got confused between 4K-based cards and AR9287.
Thanks for catching this.

Acked-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Sujith
