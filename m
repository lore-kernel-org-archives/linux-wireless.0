Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:45337 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZCHORP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 10:17:15 -0400
Received: by ewy25 with SMTP id 25so609974ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 07:17:12 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: Use rt2x00usb_register_multiwrite()
Date: Sun, 8 Mar 2009 15:17:09 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200903042225.28989.IvDoorn@gmail.com>
In-Reply-To: <200903042225.28989.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903081517.10141.IvDoorn@gmail.com> (sfid-20090308_151731_222832_BAA1CFD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please revert below patch (932dec0edbccaf0f4b599df424cad40e04fe8ae1)
it breaks practically everything in rt2500usb and rt73usb (beaconing, HW crypto
and firmware loading)

Thanks,

Ivo

On Wednesday 04 March 2009, Ivo van Doorn wrote:
> From 26f9e08ed236c602fa92b9de93b272f78cc4026b Mon Sep 17 00:00:00 2001
> rt2x00usb.h contains a wrapper for writing multiple
> bytes to the hardware in a single action. Replace
> all individual calls to rt2x00usb_vendor_request_buff
> with rt2x00usb_register_multiwrite.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    9 ++-------
>  drivers/net/wireless/rt2x00/rt73usb.c   |   31 ++++++++-----------------------
>  2 files changed, 10 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 9e630e7..164deb9 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -348,7 +348,6 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
>  				struct rt2x00lib_crypto *crypto,
>  				struct ieee80211_key_conf *key)
>  {
> -	int timeout;
>  	u32 mask;
>  	u16 reg;
>  
> @@ -376,12 +375,8 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
>  		 * rt2x00usb_vendor_request() to send the key to the hardware.
>  		 */
>  		reg = KEY_ENTRY(key->hw_key_idx);
> -		timeout = REGISTER_TIMEOUT32(sizeof(crypto->key));
> -		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
> -						    USB_VENDOR_REQUEST_OUT, reg,
> -						    crypto->key,
> -						    sizeof(crypto->key),
> -						    timeout);
> +		rt2500usb_register_multiwrite(rt2x00dev, reg,
> +					      crypto->key, sizeof(crypto->key));
>  
>  		/*
>  		 * The driver does not support the IV/EIV generation
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 24fdfdf..80ceb16 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -273,7 +273,6 @@ static int rt73usb_config_shared_key(struct rt2x00_dev *rt2x00dev,
>  {
>  	struct hw_key_entry key_entry;
>  	struct rt2x00_field32 field;
> -	int timeout;
>  	u32 mask;
>  	u32 reg;
>  
> @@ -309,12 +308,8 @@ static int rt73usb_config_shared_key(struct rt2x00_dev *rt2x00dev,
>  		       sizeof(key_entry.rx_mic));
>  
>  		reg = SHARED_KEY_ENTRY(key->hw_key_idx);
> -		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
> -		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
> -						    USB_VENDOR_REQUEST_OUT, reg,
> -						    &key_entry,
> -						    sizeof(key_entry),
> -						    timeout);
> +		rt2x00usb_register_multiwrite(rt2x00dev, reg,
> +					      &key_entry, sizeof(key_entry));
>  
>  		/*
>  		 * The cipher types are stored over 2 registers.
> @@ -375,7 +370,6 @@ static int rt73usb_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
>  {
>  	struct hw_pairwise_ta_entry addr_entry;
>  	struct hw_key_entry key_entry;
> -	int timeout;
>  	u32 mask;
>  	u32 reg;
>  
> @@ -410,12 +404,8 @@ static int rt73usb_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
>  		       sizeof(key_entry.rx_mic));
>  
>  		reg = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
> -		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
> -		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
> -						    USB_VENDOR_REQUEST_OUT, reg,
> -						    &key_entry,
> -						    sizeof(key_entry),
> -						    timeout);
> +		rt2x00usb_register_multiwrite(rt2x00dev, reg,
> +					      &key_entry, sizeof(key_entry));
>  
>  		/*
>  		 * Send the address and cipher type to the hardware register.
> @@ -1112,11 +1102,8 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev,
>  	/*
>  	 * Write firmware to device.
>  	 */
> -	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
> -					    USB_VENDOR_REQUEST_OUT,
> -					    FIRMWARE_IMAGE_BASE,
> -					    data, len,
> -					    REGISTER_TIMEOUT32(len));
> +	rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
> +				      (void *)data, len);
>  
>  	/*
>  	 * Send firmware request to device to load firmware,
> @@ -1554,10 +1541,8 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
>  	 * Write entire beacon with descriptor to register.
>  	 */
>  	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
> -	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
> -					    USB_VENDOR_REQUEST_OUT, beacon_base,
> -					    entry->skb->data, entry->skb->len,
> -					    REGISTER_TIMEOUT32(entry->skb->len));
> +	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base,
> +				      entry->skb->data, entry->skb->len);
>  
>  	/*
>  	 * Clean up the beacon skb.


