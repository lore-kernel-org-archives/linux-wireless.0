Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:41366 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbeC2G7E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 02:59:04 -0400
Subject: Re: [PATCH] wcn36xx: Disable 5GHz for wcn3610
To: Ramon Fried <rfried@codeaurora.org>, kvalo@codeaurora.org,
        loic.poulain@linaro.org
References: <20180329062058.31340-1-rfried@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <93c900b5-4ddd-bbad-ebe2-4b9549ad8f1c@gmail.com> (sfid-20180329_085921_987264_D720B791)
Date: Thu, 29 Mar 2018 08:58:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180329062058.31340-1-rfried@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2018 08:20 AM, Ramon Fried wrote:
> wcn3610 can only operate on 2.4GHz band due to RF limitation.
> If wcn36xx digital block is associated with an external IRIS
> RF module, retrieve the id and disable 5GHz band in case of
> wcn3610 id.
>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c    | 4 +++-
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index ab5be6d2c691..833531a68c95 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1146,7 +1146,7 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
>  		BIT(NL80211_IFTYPE_MESH_POINT);
>
>  	wcn->hw->wiphy->bands[NL80211_BAND_2GHZ] = &wcn_band_2ghz;
> -	if (wcn->rf_id != RF_IRIS_WCN3620)
> +	if (wcn->rf_id != RF_IRIS_WCN3610 && wcn->rf_id != RF_IRIS_WCN3620)
>  		wcn->hw->wiphy->bands[NL80211_BAND_5GHZ] = &wcn_band_5ghz;
>
>  	wcn->hw->wiphy->max_scan_ssids = WCN36XX_MAX_SCAN_SSIDS;
> @@ -1248,6 +1248,8 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
>  	if (iris_node) {
>  		if (of_device_is_compatible(iris_node, "qcom,wcn3620"))
>  			wcn->rf_id = RF_IRIS_WCN3620;
> +		else if (of_device_is_compatible(iris_node, "qcom,wcn3610"))
> +			wcn->rf_id = RF_IRIS_WCN3620;

RF_IRIS_WCN3610 ?
