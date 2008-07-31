Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:34960 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYGaHAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 03:00:08 -0400
Received: by nf-out-0910.google.com with SMTP id d3so172661nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 00:00:06 -0700 (PDT)
To: Peter Chubb <peterc@gelato.unsw.edu.au>,
	John Linville <linville@tuxdriver.com>
Subject: Re: Fixing rt2500pci [PATCH]
Date: Thu, 31 Jul 2008 09:21:41 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au> <200807302115.03865.IvDoorn@gmail.com> <87vdym6fct.wl%peterc@chubb.wattle.id.au>
In-Reply-To: <87vdym6fct.wl%peterc@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807310921.42176.IvDoorn@gmail.com> (sfid-20080731_090013_921329_6858B1A6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 31 July 2008, Peter Chubb wrote:
> 
> In kernel version 2.6.26-rc9 my wireless LAN card worked; but in the
> released 2.6.26, my RaLink rt2500 card wouldn't associate.
> 
> Git-bisect led me to this patch:
> 
> 	61486e0f68d1f8966c09b734566a187d42d65c54
> 	rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
> 
> I believe that there is a problem with that patch --- it
> (inadvertantly) removes an extra line of code, that used to set the
> DATABYTE_COUNT field.
>  
> This patch reinstates that line, and with it my card works again.
>  
> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Thanks,

John, please push this patch upstream. This one is really important. :)

> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 1724ce9..4ba2165 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1198,6 +1198,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>  	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
>  	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
>  			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
> +	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
>  	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
>  	rt2x00_desc_write(txd, 0, word);
>  }
> 
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
> 


