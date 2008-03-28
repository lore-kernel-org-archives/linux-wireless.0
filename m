Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:38980 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYC1QOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 12:14:10 -0400
Received: by nf-out-0910.google.com with SMTP id g13so172865nfb.21
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 09:14:07 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: fixup some non-functional merge errors
Date: Fri, 28 Mar 2008 17:13:07 +0100
Cc: linux-wireless@vger.kernel.org
References: <1206662053-6237-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1206662053-6237-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803281713.07431.IvDoorn@gmail.com> (sfid-20080328_161414_285512_B509A3D3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 March 2008, John W. Linville wrote:
> These small changes restore the rt2x00 sources to the way Ivo intended.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks!

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ----
>  2 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 333484d..30f9f3a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -674,7 +674,7 @@ struct rt2x00_dev {
>  	 * This will only be compiled in when required.
>  	 */
>  #ifdef CONFIG_RT2X00_LIB_RFKILL
> -unsigned long rfkill_state;
> +	unsigned long rfkill_state;
>  #define RFKILL_STATE_ALLOCATED		1
>  #define RFKILL_STATE_REGISTERED		2
>  	struct rfkill *rfkill;
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index f52e925..d2c0967 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1194,10 +1194,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	rt2x00debug_deregister(rt2x00dev);
>  	rt2x00rfkill_free(rt2x00dev);
> -
> -	/*
> -	 * Free LED.
> -	 */
>  	rt2x00leds_unregister(rt2x00dev);
>  
>  	/*


