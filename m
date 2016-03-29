Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36168 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbcC2Vol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 17:44:41 -0400
Received: by mail-pa0-f45.google.com with SMTP id tt10so23581273pab.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 14:44:40 -0700 (PDT)
Date: Tue, 29 Mar 2016 14:44:37 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jason Mobarak <jam@cozybit.com>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: Re: [RESEND PATCH 15/16] wcn36xx: don't pad beacons for mesh
Message-ID: <20160329214437.GW8929@tuxbot> (sfid-20160329_234503_992361_7C170517)
References: <1459231593-360-16-git-send-email-bjorn.andersson@linaro.org>
 <1459287672-3324-1-git-send-email-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459287672-3324-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 29 Mar 14:41 PDT 2016, Bjorn Andersson wrote:

> From: Jason Mobarak <jam@cozybit.com>
> 
> Patch "wcn36xx: Pad TIM PVM if needed" has caused a regression in mesh
> beaconing.  The field tim_off is always 0 for mesh mode, and thus
> pvm_len (referring to the TIM length field) and pad are both incorrectly
> calculated.  Thus, msg_body.beacon_length is incorrectly calculated for
> mesh mode. Fix this.
> 
> Fixes: 8ad99a4e3ee5 ("wcn36xx: Pad TIM PVM if needed")
> Signed-off-by: Jason Mobarak <jam@cozybit.com>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Resend this single patch with included Fixes tag.
> 

Sorry for the spam, I read the git log incorrectly. The patch referred
to is part of this series, so the sha1 is bogus.

Regards,
Bjorn

>  drivers/net/wireless/ath/wcn36xx/smd.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index a57d158298a1..b1bdc229e560 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -1410,6 +1410,11 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
>  
>  	pvm_len = skb_beacon->data[tim_off + 1] - 3;
>  	pad = TIM_MIN_PVM_SIZE - pvm_len;
> +
> +	/* Padding is irrelevant to mesh mode since tim_off is always 0. */
> +	if (vif->type == NL80211_IFTYPE_MESH_POINT)
> +		pad = 0;
> +
>  	msg_body.beacon_length = skb_beacon->len + pad;
>  	/* TODO need to find out why + 6 is needed */
>  	msg_body.beacon_length6 = msg_body.beacon_length + 6;
> -- 
> 2.5.0
> 
