Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36242 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYHLAzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 20:55:52 -0400
Subject: Re: [PATCH 1/1] iwlwifi: fix printk newlines
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
References: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 02:55:55 +0200
Message-Id: <1218502555.25524.22.camel@californication> (sfid-20080812_025557_691349_3AC3B58E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jiri,

> Add newlines at printk outputs to not break dmesg.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    6 +++---
>  drivers/net/wireless/iwlwifi/iwl-sta.c      |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 22bb269..4a0cc78 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -967,7 +967,7 @@ static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
>  
>  	s = iwl4965_get_sub_band(priv, channel);
>  	if (s >= EEPROM_TX_POWER_BANDS) {
> -		IWL_ERROR("Tx Power can not find channel %d ", channel);
> +		IWL_ERROR("Tx Power can not find channel %d\n", channel);
>  		return -1;
>  	}

can we not just fix IWL_ERROR to always append the newline?

Regards

Marcel


