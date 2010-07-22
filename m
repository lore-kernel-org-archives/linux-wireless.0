Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37045 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0GVGlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 02:41:07 -0400
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 09:34:18 +0300
Message-ID: <1279780458.2322.25.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Great that someone finally made the endianess changes that we never had
the time to do for wl1251. Thanks for that! :)

I took a look at your patch and I have a few minor comments below, but
the best person to comment would certainly be Kalle, not me ;)


On Wed, 2010-07-21 at 18:31 +0200, ext John W. Linville wrote:
> diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
> index 2545123..c688895 100644
> --- a/drivers/net/wireless/wl12xx/wl1251_boot.c
> +++ b/drivers/net/wireless/wl12xx/wl1251_boot.c

[...]

> @@ -467,7 +467,7 @@ static int wl1251_boot_upload_nvs(struct wl1251 *wl)
>  		val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
>  		       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
>  
> -		val = cpu_to_le32(val);
> +		val = (u32 __force) cpu_to_le32(val);

This will work, but such casts always make me a bit suspicious.  I think
this is fine for now, but later I think we should make sure that all the
_write() functions explicitly receive __le32 as val, or receives the
cpu's u32 and converts it before actually writing the value, for clarity
reasons.  Kalle, what do you think?


> diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
> index c822318..a38ec19 100644
> --- a/drivers/net/wireless/wl12xx/wl1251_tx.c
> +++ b/drivers/net/wireless/wl12xx/wl1251_tx.c

[...]

> @@ -191,11 +191,13 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
>  	if (control->control.hw_key &&
>  	    control->control.hw_key->alg == ALG_TKIP) {
>  		int hdrlen;
> -		u16 fc;
> +		__le16 fc;
> +		u16 length;
>  		u8 *pos;
>  
> -		fc = *(u16 *)(skb->data + sizeof(*tx_hdr));
> -		tx_hdr->length += WL1251_TKIP_IV_SPACE;
> +		fc = *(__le16 *)(skb->data + sizeof(*tx_hdr));

Is this going to work? sizeof(*tx_hdr), and the operation, will be in
the cpu's endianess, right? Wouldn't the following be the right thing to
do then?

fc = cpu_to_le16(le16_to_cpu(skb->data) + sizeof(*tx_hdr));

Maybe some casts are needed too, I didn't check that, but regarding the
endianess, I think this is how it should go.  It's the same thing as the
length parameter:

> +		length = le16_to_cpu(tx_hdr->length) + WL1251_TKIP_IV_SPACE;
> +		tx_hdr->length = cpu_to_le16(length);

...which is treated correctly here.



-- 
Cheers,
Luca.

