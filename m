Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45383 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab3FDLcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:32:45 -0400
Message-ID: <51ADD058.5000003@openwrt.org> (sfid-20130604_133248_763952_2E72852D)
Date: Tue, 04 Jun 2013 13:32:40 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/6] ath9k: Fix ANI monitoring
References: <1370340695-29003-1-git-send-email-sujith@msujith.org> <1370340695-29003-2-git-send-email-sujith@msujith.org>
In-Reply-To: <1370340695-29003-2-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-04 12:11 PM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The commit "ath9k_hw: improve ANI processing and rx desensitizing parameters"
> changed various ANI operational parameters to address a specific
> card/environment. This is not really applicable for other cards
> in general usage.
> 
> As per internal documentation, lowering the immunity level can be
> done only after 5 periods have passed and the CCK/OFDM errors are
> below the low watermak threshold - which have been fixed at 300 and
> 400 respectively by the sytems team.
> 
> Raising the immunity level can be done when CCK/OFDM errors exceed
> 600 and 1000 (per second).
> 
> Set these values once during attach.
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
> index 78b9fa9..1088472 100644
> --- a/drivers/net/wireless/ath/ath9k/ani.h
> +++ b/drivers/net/wireless/ath/ath9k/ani.h
> @@ -21,11 +21,9 @@
>  
>  /* units are errors per second */
>  #define ATH9K_ANI_OFDM_TRIG_HIGH          3500
> -#define ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI 1000
>  
>  /* units are errors per second */
>  #define ATH9K_ANI_OFDM_TRIG_LOW           400
> -#define ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI 900
>  
>  /* units are errors per second */
>  #define ATH9K_ANI_CCK_TRIG_HIGH           600
> 
With this patch, the raise-limit is always 3500, you should change it to
1000 when removing the above-/below-INI distinction.

- Felix
