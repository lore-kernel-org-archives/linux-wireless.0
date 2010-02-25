Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58732 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0BYB6P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 20:58:15 -0500
Message-ID: <20100224205814.974teh5rf48w4g8o-cebfxv@webmail.spamcop.net>
Date: Wed, 24 Feb 2010 20:58:14 -0500
From: Pavel Roskin <proski@gnu.org>
To: prahal@yahoo.com
Cc: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00 : fix txdone implementation
References: <4B85CA62.8080208@yahoo.com>
In-Reply-To: <4B85CA62.8080208@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Alban Browaeys <prahal@yahoo.com>:

> Properly move to the headroom position in dma mapped skb. The hw extra
> headroom is now taken into account.
>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
...
> -	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
> -			   skbdesc->skb_dma + rt2x00dev->ops->extra_tx_headroom);
> +	rt2x00_set_field32(&word, TXD_W2_SD_PTR1, skbdesc->skb_dma
> +			   + rt2x00dev->ops->extra_tx_headroom);

I think it's just a formatting change.  I would not mix formatting  
changes with the real fixes.  I can understand reformatting code that  
is also modified in some other way, but that's even a separate function.

>  		txwi = (__le32 *)(entry->skb->data -
> -				  rt2x00dev->hw->extra_tx_headroom);
> +				  rt2x00dev->ops->extra_tx_headroom);

Now that's a real change.

-- 
Regards,
Pavel Roskin
