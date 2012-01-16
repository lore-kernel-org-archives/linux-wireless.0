Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33390 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2APUb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 15:31:29 -0500
Subject: Re: [PATCH] NFC: Add NCI data exchange timer
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326024683-30313-1-git-send-email-ilane@ti.com>
References: <1326024683-30313-1-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 21:37:32 +0100
Message-ID: <1326746252.22824.15.camel@sortiz-mobl> (sfid-20120116_213135_464885_E50CA755)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

A couple of nitpicks:

On Sun, 2012-01-08 at 14:11 +0200, ilanelias78@gmail.com wrote:

> @@ -454,8 +464,10 @@ static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
>  		return -EINVAL;
>  	}
>  
> -	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags))
> +	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags)) {
> +		pr_err("unable to exchange data, already in progress\n");
This is not really related to that patch.

> @@ -473,6 +485,8 @@ static struct nfc_ops nci_nfc_ops = {
>  	.dev_down = nci_dev_down,
>  	.start_poll = nci_start_poll,
>  	.stop_poll = nci_stop_poll,
> +	.dep_link_up = NULL,
> +	.dep_link_down = NULL,
Ditto.

Cheers,
Samuel.

