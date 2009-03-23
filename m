Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:8920 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbZCWQG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:06:26 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] Marvell CF8381 and CF8305
Date: Mon, 23 Mar 2009 17:06:16 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903231659.05158.marek.vasut@gmail.com> <200903231700.21627.marek.vasut@gmail.com>
In-Reply-To: <200903231700.21627.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903231706.16489.hs4233@mail.mn-solutions.de> (sfid-20090323_170629_577139_87D4B6BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +#define CF8305_MANFID		0x02db
> +#define CF8305_CARDID		0x8103

It's 8385, not 8305.

>  	/* Check if we have a current silicon */
> -	if (if_cs_read8(card, IF_CS_PRODUCT_ID) <
> IF_CS_CF8385_B1_REV) { -		lbs_pr_err("old chips like 8385 rev
> B1 aren't supported\n"); +	prod_id = if_cs_read8(card,
> IF_CS_PRODUCT_ID);
> +	if (!(if_cs_hw_is_cf8305(p_dev) ||
> +		(if_cs_hw_is_cf8381(p_dev) &&
> +		prod_id >= IF_CS_CF8381_B3_REV)) &&
> +		(prod_id < IF_CS_CF8385_B1_REV)) {
> +		lbs_pr_err("old chips like 8385 rev B1 or "
> +			"8381 rev B3 aren't supported\n");

I still find this if hard to read. Why not something like this:

if ((if_cs_is_8385() && prod_id < IF_CS_CF8385_B1_REV) ||
    (if_cs_Is_8381() && prod_id < IF_CS_CF8381_B3_REV)) {
      ....
}

>  static struct pcmcia_device_id if_cs_ids[] = {
> +	PCMCIA_DEVICE_MANF_CARD(CF8305_MANFID, CF8305_CARDID),
> +	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
>  	PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
>  	PCMCIA_DEVICE_NULL,
>  };

Now we end with two entries of 0x02df, 0x8103 :-/
