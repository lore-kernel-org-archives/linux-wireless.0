Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39858 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab2CVH4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 03:56:31 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "Lapuyade, Eric" <eric.lapuyade@intel.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] [PATCH] NFC: The core part should generate the target
 index
Date: Thu, 22 Mar 2012 07:56:27 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803516A896FF@DNCE03.ent.ti.com> (sfid-20120322_085635_483754_833A45AD)
References: <20120322005305.GD3875@sortiz-mobl>
In-Reply-To: <20120322005305.GD3875@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,
 
> Ilan, could you please comment on this patch and also make 
> sure that it
> doesn't break multiple targets support for NCI ?
It seems to me that this patch doesn't break multiple targets support for NCI.

> diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
> index 5a839ce..47fcf0d 100644
> --- a/net/nfc/rawsock.c
> +++ b/net/nfc/rawsock.c
> @@ -92,6 +92,18 @@ static int rawsock_connect(struct socket 
> *sock, struct sockaddr *_addr,
>  		goto error;
>  	}
>  
> +	if (addr->target_idx > dev->target_idx - 1 ||
> +	    addr->target_idx < dev->target_idx - dev->n_targets) {
> +		rc = -EINVAL;
> +		goto error;
> +	}
> +
> +	if (addr->target_idx > dev->target_idx - 1 ||
> +	    addr->target_idx < dev->target_idx - dev->n_targets) {
> +		rc = -EINVAL;
> +		goto error;
> +	}
> +
It looks like the 'if' statement you added appears twice.

Thanks & BR,
Ilan
