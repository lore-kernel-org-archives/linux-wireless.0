Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38613 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab3FPSHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jun 2013 14:07:24 -0400
Message-ID: <51BDFED6.1060509@openwrt.org> (sfid-20130616_200729_198033_7F40A3F5)
Date: Sun, 16 Jun 2013 20:07:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, jkp@iki.fi, gfmichaud@gmail.com
Subject: Re: [PATCH v2] ath9k: Add custom parameters for CUS198
References: <1371144086-10150-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1371144086-10150-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-13 7:21 PM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> CUS198 is a card based on AR9485. There are differences
> between the base reference design HB125 and CUS198.
> Identify such cards based on the PCI subsystem IDs and
> set HW parameters appropriately.
> 
> Addresses this bug - https://bugzilla.kernel.org/show_bug.cgi?id=49201
> 
> Cc: jkp@iki.fi
> Cc: gfmichaud@gmail.com
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 18 +++++++++++++---
>  drivers/net/wireless/ath/ath9k/ath9k.h         |  3 +++
>  drivers/net/wireless/ath/ath9k/hw.h            |  4 ++++
>  drivers/net/wireless/ath/ath9k/init.c          | 21 +++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/pci.c           | 29 ++++++++++++++++++++++++++
>  5 files changed, 72 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index 25b8bbb..9a00bc0 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -3563,16 +3563,22 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
>  {
>  	struct ath9k_hw_capabilities *pCap = &ah->caps;
>  	int chain;
> -	u32 regval, value;
> +	u32 regval, value, gpio;
>  	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
>  			AR_PHY_SWITCH_CHAIN_0,
>  			AR_PHY_SWITCH_CHAIN_1,
>  			AR_PHY_SWITCH_CHAIN_2,
>  	};
>  
> -	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
> +	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0)) {
> +		if (ah->config.xlna_gpio)
> +			gpio = ah->config.xlna_gpio;
> +		else
> +			gpio = AR9300_EXT_LNA_CTL_GPIO_AR9485;
> +
>  		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
>  				    AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED);
Shouldn't the ath9k_hw_cfg_output line change as well, otherwise you
simply add an unused-but-set variable here.

- Felix
