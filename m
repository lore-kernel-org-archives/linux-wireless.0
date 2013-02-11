Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:56636 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938Ab3BKVht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:37:49 -0500
Received: by mail-ob0-f180.google.com with SMTP id ef5so6636116obb.11
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 13:37:49 -0800 (PST)
Message-ID: <511964AB.6080701@lwfinger.net> (sfid-20130211_223753_754924_7AF585FE)
Date: Mon, 11 Feb 2013 15:37:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Catalin Iacob <iacobcatalin@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rtlwifi: Initialize rate_init member of struct rate_control_ops
References: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com>
In-Reply-To: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 03:18 PM, Catalin Iacob wrote:
> This partially reverts commit 44ba973699b831414c3f8eef68ee5a7fe1208a05.
>
> rate_control_rate_init assumes the rate_init member of
> struct rate_control_ops is not NULL therefore not initializing it leads to
> an oops as soon the driver succesfully associates to an AP.
>
> The removal of rate_update from 44ba973699b831414c3f8eef68ee5a7fe1208a05
> is ok because rate_update is checked for NULL before being
> called.
>
> Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rc.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
> index 204f46c..6ad8bb7 100644
> --- a/drivers/net/wireless/rtlwifi/rc.c
> +++ b/drivers/net/wireless/rtlwifi/rc.c
> @@ -217,6 +217,12 @@ static void rtl_tx_status(void *ppriv,
>   	}
>   }
>
> +static void rtl_rate_init(void *ppriv,
> +			  struct ieee80211_supported_band *sband,
> +			  struct ieee80211_sta *sta, void *priv_sta)
> +{
> +}
> +
>   static void *rtl_rate_alloc(struct ieee80211_hw *hw,
>   		struct dentry *debugfsdir)
>   {
> @@ -261,6 +267,7 @@ static struct rate_control_ops rtl_rate_ops = {
>   	.free = rtl_rate_free,
>   	.alloc_sta = rtl_rate_alloc_sta,
>   	.free_sta = rtl_rate_free_sta,
> +	.rate_init = rtl_rate_init,
>   	.tx_status = rtl_tx_status,
>   	.get_rate = rtl_get_rate,
>   };

Shouldn't rate_control_rate_init() in net/mac80211/rate.h be changed to protect 
against the oops? I don't see any value in the client driver having to provide a 
dummy routine. The rtlwifi family of drivers use their own rate-control 
mechanism, and get no rate-control info from mac80211.

Larry


