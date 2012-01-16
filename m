Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2APR4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 12:56:47 -0500
Subject: Re: [PATCH] NFC: Export new attributes sensb_res and sensf_res
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
In-Reply-To: <1326012961-29832-1-git-send-email-ilane@ti.com>
References: <1326012961-29832-1-git-send-email-ilane@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 19:02:53 +0100
Message-ID: <1326736973.22824.9.camel@sortiz-mobl> (sfid-20120116_185652_287643_BE1D9AD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Sun, 2012-01-08 at 10:56 +0200, ilanelias78@gmail.com wrote:

> diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
> index 8696b77..d8aef2e 100644
> --- a/include/net/nfc/nfc.h
> +++ b/include/net/nfc/nfc.h
> @@ -66,6 +66,8 @@ struct nfc_ops {
>  #define NFC_TARGET_IDX_ANY -1
>  #define NFC_MAX_GT_LEN 48
>  #define NFC_MAX_NFCID1_LEN 10
> +#define NFC_MAX_SENSB_RES_LEN 12
> +#define NFC_MAX_SENSF_RES_LEN 18
I think those values should be exported to user space though
include/linux/nfc.h.
When fetching the byte stream from the netlink socket, you usually want
to check if it has a valid length in order to memcpy it to a static
array embedded with your target structure.
Same applies to NFC_MAX_NFCID1_LEN.

The rest of the code looks fine to me.

Cheers,
Samuel.


