Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3DLBBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 21:01:51 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so1137343pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 18:01:51 -0700 (PDT)
Message-ID: <51675CFD.8030603@boundarydevices.com> (sfid-20130412_030237_804062_3249E796)
Date: Thu, 11 Apr 2013 18:01:49 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Doug Anderson <dianders@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: remove redundant initialization for bss_descriptor
References: <1365727993-20941-1-git-send-email-bzhao@marvell.com> <1365727993-20941-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1365727993-20941-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/11/2013 5:53 PM, Bing Zhao wrote:
> Initialization of bss_descriptor is unnecessary as the entire
> structure will be overwritten by a memcpy.
>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Paul Stewart <pstew@chromium.org>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> ---
>   drivers/net/wireless/mwifiex/scan.c |   29 -----------------------------
>   1 files changed, 0 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
> index 37b24e8..9cf5d8f 100644
> --- a/drivers/net/wireless/mwifiex/scan.c
> +++ b/drivers/net/wireless/mwifiex/scan.c
> @@ -1500,36 +1500,7 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
>   	if (ret)
>   		goto done;
>   
> -	/* Update current bss descriptor parameters */
>   	spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
> -	priv->curr_bss_params.bss_descriptor.bcn_wpa_ie = NULL;
> -	priv->curr_bss_params.bss_descriptor.wpa_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_rsn_ie = NULL;
> -	priv->curr_bss_params.bss_descriptor.rsn_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
> -	priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
> -	priv->curr_bss_params.bss_descriptor.ht_cap_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_ht_oper = NULL;
> -	priv->curr_bss_params.bss_descriptor.ht_info_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 = NULL;
> -	priv->curr_bss_params.bss_descriptor.bss_co_2040_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_ext_cap = NULL;
> -	priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
> -	priv->curr_bss_params.bss_descriptor.beacon_buf_size = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_vht_cap = NULL;
> -	priv->curr_bss_params.bss_descriptor.vht_cap_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.bcn_vht_oper = NULL;
> -	priv->curr_bss_params.bss_descriptor.vht_info_offset = 0;
> -	priv->curr_bss_params.bss_descriptor.oper_mode = NULL;
> -	priv->curr_bss_params.bss_descriptor.oper_mode_offset = 0;
> -
> -	/* Disable 11ac by default. Enable it only where there
> -	 * exist VHT_CAP IE in AP beacon
> -	 */
> -	priv->curr_bss_params.bss_descriptor.disable_11ac = true;
> -

Should the = true line be moved below the memcpy?  Your way produces
the same behavior, but was it buggy before?
>   	/* Make a copy of current BSSID descriptor */
>   	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
>   	       sizeof(priv->curr_bss_params.bss_descriptor));

