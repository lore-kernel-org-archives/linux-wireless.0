Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0FBFgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 01:36:39 -0400
Subject: Re: [PATCH]: libertas: fix uninitialized variable warning
From: Dan Williams <dcbw@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20100527183717.24368.49914.sendpatchset@prarit.bos.redhat.com>
References: <20100527183717.24368.49914.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:29:28 -0700
Message-ID: <1275456568.16492.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 14:41 -0400, Prarit Bhargava wrote:
> Fixes:
> 
> drivers/net/wireless/libertas/rx.c: In function ‘process_rxed_802_11_packet’:
> drivers/net/wireless/libertas/rx.c:354: error: ‘radiotap_hdr.flags’ may be used uninitialized in this function
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
> index e2b8d88..2319bde 100644
> --- a/drivers/net/wireless/libertas/rx.c
> +++ b/drivers/net/wireless/libertas/rx.c
> @@ -330,9 +330,8 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
>  	/* create the exported radio header */
>  
>  	/* radiotap header */
> -	radiotap_hdr.hdr.it_version = 0;
> -	/* XXX must check this value for pad */
> -	radiotap_hdr.hdr.it_pad = 0;
> +	memset(&radiotap_hdr, 0, sizeof(radiotap_hdr));
> +	/* XXX must check radiotap_hdr.hdr.it_pad for pad */
>  	radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
>  	radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
>  	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


