Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:22567 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbXICSyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 14:54:02 -0400
Received: by nf-out-0910.google.com with SMTP id f5so1261272nfh
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2007 11:54:00 -0700 (PDT)
Message-ID: <46DC588D.40305@gmail.com>
Date: Mon, 03 Sep 2007 20:55:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Jiri Slaby <jirislaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Ath5k panic fix
References: <m3ejhfvbp3.fsf@maximus.localdomain>
In-Reply-To: <m3ejhfvbp3.fsf@maximus.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Krzysztof Halasa napsal(a):
> Ath5k panics on ath_open() because sc->pdev is never set, fixed.
> 
> Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

I wonder how it is possible that the driver works here.

> --- a/drivers/net/wireless/ath5k_base.c
> +++ b/drivers/net/wireless/ath5k_base.c
> @@ -2295,6 +2295,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
>  	hw->max_rssi = 127; /* FIXME: get a real value for this. */
>  	sc = hw->priv;
>  	sc->hw = hw;
> +	sc->pdev = pdev;
>  
>  	/*
>  	 * Mark the device as detached to avoid processing
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
