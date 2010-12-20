Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab0LTJ0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 04:26:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 01:26:03 -0800
Date: Mon, 20 Dec 2010 14:56:14 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Dan Carpenter <error27@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: smatch stuff: potential read past the end of the buffer
Message-ID: <20101220092614.GA1414@senthil-lnx.users.atheros.com>
References: <20101220083041.GQ1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101220083041.GQ1936@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 02:00:41PM +0530, Dan Carpenter wrote:
> Hello Vasanthakumar,
> 
> Smatch complains that in linux-next 60e0c3a7 "ath9k_hw: Eeeprom changes
> for AR9485" means there is a potential read past the end of the buffer
> int ar9300_eeprom_restore_internal().
> 
> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c +3381
> 	ar9300_eeprom_restore_internal(81)
> 	error: buffer overflow 'word' 2048 <= 4099
> 
> "word" is allocated with 2048 bytes:
>         word = kzalloc(2048, GFP_KERNEL);
> 
> "length" can be up to 4099:
>                 if ((!AR_SREV_9485(ah) && length >= 1024) ||
>                     (AR_SREV_9485(ah) && length >= (4 * 1024))) {
>                                          ^^^^^^^^^^^^^^^^^^^^^
> 
> so "osize" can be up to 4099 as well:
>                 osize = length;
> 
> We're reading way past the end of the word array here:
>                 mchecksum = word[COMP_HDR_LEN + osize] |
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^
>                     (word[COMP_HDR_LEN + osize + 1] << 8);
> 
> I don't know how to fix this.  Can you take a look?
thanks for pointing this out. we shall look into this.
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
