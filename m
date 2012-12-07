Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7865 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101Ab2LGK1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:27:16 -0500
Date: Fri, 7 Dec 2012 15:57:14 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 7/8] ath9k_hw: Calculate the correct training power for
 PAPRD
Message-ID: <20121207102712.GA3145@hemis.qca.qualcomm.com> (sfid-20121207_112723_400752_91AFBF2C)
References: <1354874521-4138-1-git-send-email-sujith@msujith.org>
 <1354874521-4138-8-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1354874521-4138-8-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 07, 2012 at 03:32:00PM +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Assign the training power for PAPRD based on the chip.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 41 ++++++++++++++++++--------
>  drivers/net/wireless/ath/ath9k/ar9003_paprd.c  | 22 +++++++++-----
>  2 files changed, 43 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index c86cb640..0f38895 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -5076,6 +5076,33 @@ static inline u8 mcsidx_to_tgtpwridx(unsigned int mcs_idx, u8 base_pwridx)
>  		return base_pwridx + 4 * (mcs_idx / 8) + mod_idx - 2;
>  }
>  
> +static void ar9003_paprd_set_txpower(struct ath_hw *ah,
> +				     struct ath9k_channel *chan,
> +				     u8 *targetPowerValT2)
> +{
> +	int i;
> +
> +	if (!ar9003_is_paprd_enabled(ah))
> +		return;
> +
Can you reorder the patch series as ar9003_is_paprd_enabled is not defined in
previous patches?

-Rajkumar
