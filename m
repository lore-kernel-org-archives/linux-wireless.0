Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYE3Rwh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 13:52:37 -0400
Subject: Re: [PATCH 1/3] WEXT: Add support for passing PMK and capability
	flags to WEXT
From: Dan Williams <dcbw@redhat.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20080530164258.4744.40F06B3A@sm.sony.co.jp>
References: <20080530163019.4741.40F06B3A@sm.sony.co.jp>
	 <20080530164258.4744.40F06B3A@sm.sony.co.jp>
Content-Type: text/plain
Date: Fri, 30 May 2008 13:52:15 -0400
Message-Id: <1212169935.8178.29.camel@localhost.localdomain> (sfid-20080530_195239_336016_D5B2B245)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-30 at 16:52 +0900, Masakazu Mokuno wrote:
> This defines the flags for setting the PMK to the driver and the
> capability flag for this so that the user space program can figure out
> whether the target driver wants to do 4-way hand shake by itself and
> pass the PMK which is needed before 4-way handshake to the driver.
> 
> Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  include/linux/wireless.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -611,6 +611,7 @@
>  #define IW_ENCODE_ALG_WEP	1
>  #define IW_ENCODE_ALG_TKIP	2
>  #define IW_ENCODE_ALG_CCMP	3
> +#define IW_ENCODE_ALG_PMK	4
>  /* struct iw_encode_ext ->ext_flags */
>  #define IW_ENCODE_EXT_TX_SEQ_VALID	0x00000001
>  #define IW_ENCODE_EXT_RX_SEQ_VALID	0x00000002
> @@ -630,6 +631,7 @@
>  #define IW_ENC_CAPA_WPA2	0x00000002
>  #define IW_ENC_CAPA_CIPHER_TKIP	0x00000004
>  #define IW_ENC_CAPA_CIPHER_CCMP	0x00000008
> +#define IW_ENC_CAPA_4WAY_HANDSHAKE	0x00000010
>  
>  /* Event capability macros - in (struct iw_range *)->event_capa
>   * Because we have more than 32 possible events, we use an array of
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

