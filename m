Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:37950 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0G2Fmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 01:42:50 -0400
Subject: Re: [PATCH] wl1271: update hw/fw version info in wiphy struct
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <1280351443-28535-1-git-send-email-linville@tuxdriver.com>
References: <1280351443-28535-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 08:01:52 +0300
Message-ID: <1280379712.6475.79.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 23:10 +0200, ext John W. Linville wrote:
> This makes the information available through ethtool...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_main.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index 374abf0..9d68f00 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -839,6 +839,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
>  				   struct ieee80211_vif *vif)
>  {
>  	struct wl1271 *wl = hw->priv;
> +	struct wiphy *wiphy = hw->wiphy;
>  	int retries = WL1271_BOOT_RETRIES;
>  	int ret = 0;
>  
> @@ -892,6 +893,12 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
>  
>  		wl->state = WL1271_STATE_ON;
>  		wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
> +
> +		/* update hw/fw version info in wiphy struct */
> +		wiphy->hw_version = wl->chip.id;
> +		strncpy(wiphy->fw_version, wl->chip.fw_ver,
> +			sizeof(wiphy->fw_version));
> +
>  		goto out;
>  
>  irq_disable:

Acked-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>


-Juuso



