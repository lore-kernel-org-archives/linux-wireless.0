Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53239 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbZKHNyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:54:15 -0500
Received: by ewy3 with SMTP id 3so2378050ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:54:20 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 7/9] rt2800usb: fix RX descriptor naming
Date: Sun, 8 Nov 2009 14:54:18 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133940.23584.22577.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133940.23584.22577.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081454.18649.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: fix RX descriptor naming
> 
> Rename RXD_W0_* defines to RXINFO_W0_* ones to match naming
> used for TX descriptor and by the vendor driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   10 ++++----
>  drivers/net/wireless/rt2x00/rt2800usb.h |   40 ++++++++++++++++----------------
>  2 files changed, 25 insertions(+), 25 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -594,16 +594,16 @@ static void rt2800usb_fill_rxdone(struct
>  	rt2x00_desc_read(rxwi, 2, &rxwi2);
>  	rt2x00_desc_read(rxwi, 3, &rxwi3);
>  
> -	if (rt2x00_get_field32(rxd0, RXD_W0_CRC_ERROR))
> +	if (rt2x00_get_field32(rxd0, RXINFO_W0_CRC_ERROR))
>  		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
>  
>  	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
>  		rxdesc->cipher = rt2x00_get_field32(rxwi0, RXWI_W0_UDF);
>  		rxdesc->cipher_status =
> -		    rt2x00_get_field32(rxd0, RXD_W0_CIPHER_ERROR);
> +		    rt2x00_get_field32(rxd0, RXINFO_W0_CIPHER_ERROR);
>  	}
>  
> -	if (rt2x00_get_field32(rxd0, RXD_W0_DECRYPTED)) {
> +	if (rt2x00_get_field32(rxd0, RXINFO_W0_DECRYPTED)) {
>  		/*
>  		 * Hardware has stripped IV/EIV data from 802.11 frame during
>  		 * decryption. Unfortunately the descriptor doesn't contain
> @@ -618,10 +618,10 @@ static void rt2800usb_fill_rxdone(struct
>  			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
>  	}
>  
> -	if (rt2x00_get_field32(rxd0, RXD_W0_MY_BSS))
> +	if (rt2x00_get_field32(rxd0, RXINFO_W0_MY_BSS))
>  		rxdesc->dev_flags |= RXDONE_MY_BSS;
>  
> -	if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD)) {
> +	if (rt2x00_get_field32(rxd0, RXINFO_W0_L2PAD)) {
>  		rxdesc->dev_flags |= RXDONE_L2PAD;
>  		skbdesc->flags |= SKBDESC_L2_PADDED;
>  	}
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.h
> @@ -111,25 +111,25 @@
>   * AMSDU: rx with 802.3 header, not 802.11 header.
>   */
>  
> -#define RXD_W0_BA			FIELD32(0x00000001)
> -#define RXD_W0_DATA			FIELD32(0x00000002)
> -#define RXD_W0_NULLDATA			FIELD32(0x00000004)
> -#define RXD_W0_FRAG			FIELD32(0x00000008)
> -#define RXD_W0_UNICAST_TO_ME		FIELD32(0x00000010)
> -#define RXD_W0_MULTICAST		FIELD32(0x00000020)
> -#define RXD_W0_BROADCAST		FIELD32(0x00000040)
> -#define RXD_W0_MY_BSS			FIELD32(0x00000080)
> -#define RXD_W0_CRC_ERROR		FIELD32(0x00000100)
> -#define RXD_W0_CIPHER_ERROR		FIELD32(0x00000600)
> -#define RXD_W0_AMSDU			FIELD32(0x00000800)
> -#define RXD_W0_HTC			FIELD32(0x00001000)
> -#define RXD_W0_RSSI			FIELD32(0x00002000)
> -#define RXD_W0_L2PAD			FIELD32(0x00004000)
> -#define RXD_W0_AMPDU			FIELD32(0x00008000)
> -#define RXD_W0_DECRYPTED		FIELD32(0x00010000)
> -#define RXD_W0_PLCP_RSSI		FIELD32(0x00020000)
> -#define RXD_W0_CIPHER_ALG		FIELD32(0x00040000)
> -#define RXD_W0_LAST_AMSDU		FIELD32(0x00080000)
> -#define RXD_W0_PLCP_SIGNAL		FIELD32(0xfff00000)
> +#define RXINFO_W0_BA			FIELD32(0x00000001)
> +#define RXINFO_W0_DATA			FIELD32(0x00000002)
> +#define RXINFO_W0_NULLDATA		FIELD32(0x00000004)
> +#define RXINFO_W0_FRAG			FIELD32(0x00000008)
> +#define RXINFO_W0_UNICAST_TO_ME		FIELD32(0x00000010)
> +#define RXINFO_W0_MULTICAST		FIELD32(0x00000020)
> +#define RXINFO_W0_BROADCAST		FIELD32(0x00000040)
> +#define RXINFO_W0_MY_BSS		FIELD32(0x00000080)
> +#define RXINFO_W0_CRC_ERROR		FIELD32(0x00000100)
> +#define RXINFO_W0_CIPHER_ERROR		FIELD32(0x00000600)
> +#define RXINFO_W0_AMSDU			FIELD32(0x00000800)
> +#define RXINFO_W0_HTC			FIELD32(0x00001000)
> +#define RXINFO_W0_RSSI			FIELD32(0x00002000)
> +#define RXINFO_W0_L2PAD			FIELD32(0x00004000)
> +#define RXINFO_W0_AMPDU			FIELD32(0x00008000)
> +#define RXINFO_W0_DECRYPTED		FIELD32(0x00010000)
> +#define RXINFO_W0_PLCP_RSSI		FIELD32(0x00020000)
> +#define RXINFO_W0_CIPHER_ALG		FIELD32(0x00040000)
> +#define RXINFO_W0_LAST_AMSDU		FIELD32(0x00080000)
> +#define RXINFO_W0_PLCP_SIGNAL		FIELD32(0xfff00000)
>  
>  #endif /* RT2800USB_H */
> 


