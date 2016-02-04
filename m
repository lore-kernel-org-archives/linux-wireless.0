Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:38709 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755866AbcBDRiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 12:38:21 -0500
Message-ID: <1454607491.14997.13.camel@perches.com> (sfid-20160204_183832_671689_922AE4DF)
Subject: Re: [PATCH RESEND 70/70] staging: wilc1000: remove warnings line
 over 80 characters
From: Joe Perches <joe@perches.com>
To: Glen Lee <glen.lee@atmel.com>, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	Chris.Park@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Date: Thu, 04 Feb 2016 09:38:11 -0800
In-Reply-To: <1454577871-667-31-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
	 <1454577871-667-31-git-send-email-glen.lee@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-04 at 18:24 +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes the warnings reported by checkpatch.pl
> for line over 80 characters.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
[]
> @@ -4,7 +4,7 @@
>  #include 
>  #include 
>  #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
> -							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
> +				 BEACON_INTERVAL_LEN + CAP_INFO_LEN)

Another style is to use the continuation on the first line

#define TAG_PARAM_OFFSET	\
	(MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN)

>  
>  enum basic_frame_type {
>  	FRAME_TYPE_CONTROL     = 0x04,
> @@ -337,8 +337,10 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
>  		tim_elm = get_tim_elm(msa, rx_len + FCS_LEN, index);
>  		if (tim_elm)
>  			network_info->dtim_period = tim_elm[3];
> -		ies = &msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
> -		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
> +		ies = &msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN +
> +			   CAP_INFO_LEN];
> +		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN +
> +				    BEACON_INTERVAL_LEN + CAP_INFO_LEN);

Pretty funny that a TAG_PARAM_OFFSET change is in the same patch

It'd be simpler to use that define here.

		ies = &msa[TAG_PARAM_OFFSET];
		ies_len = rx_len - TAG_PARAM_OFFSET;

>  		if (!connect_resp_info->ies)

