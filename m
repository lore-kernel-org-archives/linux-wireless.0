Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2497 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab2FFKYi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:24:38 -0400
Message-ID: <4FCF2FD4.6010103@broadcom.com> (sfid-20120606_122440_876920_C1DF0530)
Date: Wed, 6 Jun 2012 12:24:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/18] brcmsmac: extend xmtfifo_sz array
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-15-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-15-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> The xmtfifo_sz array contains the queue sizes for the different chip
> revs. This array missed the sizes for the core rev 17 and 28. This

Should probably use core revs instead of chip revs and I think we are
talking about the 80211 core rev here.

> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -268,7 +268,7 @@ struct brcms_c_bit_desc {
>   */
>  
>  /* Starting corerev for the fifo size table */
> -#define XMTFIFOTBL_STARTREV	20
> +#define XMTFIFOTBL_STARTREV	10

Why not start the table at rev 17? I do not expect any lower revs to get
brcmsmac support.

Gr. AvS

