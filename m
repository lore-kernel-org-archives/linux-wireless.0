Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48389 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2AKTcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 14:32:46 -0500
Received: by eaal12 with SMTP id l12so355290eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 11:32:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: Re: [PATCH] carl9170: claim to support IBSS RSN.
Date: Wed, 11 Jan 2012 17:13:36 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Nicolas Cavallari <cavallar@lri.fr>
References: <1326296690-2644-1-git-send-email-cavallar@lri.fr>
In-Reply-To: <1326296690-2644-1-git-send-email-cavallar@lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201201111713.36373.chunkeey@googlemail.com> (sfid-20120111_203250_432825_C3F58C4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, January 11, 2012 04:44:50 PM Nicolas Cavallari wrote:
> On carl9170, HW encryption is disabled on IBSS; the mac80211
> software-based encryption is used instead. As mac80211 supports IBSS
> RSN (per-STA GTK), claim its support in the carl9170 PHY.

Uh, was IBSS RSN fixed? Sure, if it works, why not. 

Acked-by: Christian Lamparter <chunkeey@googlemail.com>
 
> Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
> ---
>  drivers/net/wireless/ath/carl9170/main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index f06e069..24c7f85 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -1796,6 +1796,9 @@ void *carl9170_alloc(size_t priv_size)
>  		ar->noise[i] = -95; /* ATH_DEFAULT_NOISE_FLOOR */
>  
>  	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +
> +	/* As IBSS Encryption is software-based, IBSS RSN is supported. */
> +	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
>  	return ar;
>  
>  err_nomem:
> 
