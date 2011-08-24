Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37088 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1HXXHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:07:49 -0400
Received: by wyg24 with SMTP id 24so1231399wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 16:07:48 -0700 (PDT)
Date: Thu, 25 Aug 2011 02:05:31 +0300
From: Dan Carpenter <error27@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110824230531.GJ5975@shale.localdomain> (sfid-20110825_010753_438540_1B0E43B9)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110824222801.GA5280@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 03:28:01PM -0700, Henry Ptasinski wrote:
> diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm8021
> index 05dad9f..73e5841 100644
> --- a/drivers/staging/brcm80211/brcmsmac/dma.c
> +++ b/drivers/staging/brcm80211/brcmsmac/dma.c
> @@ -815,7 +815,7 @@ struct sk_buff *dma_rx(struct dma_pub *pub)
>                 tail = head;
>                 while ((resid > 0) && (p = _dma_getnextrxp(di, false))) {
>                         tail->next = p;
> -                       pkt_len = min(resid, (int)di->rxbufsize);
> +                       pkt_len = min_t(int, resid, (int)di->rxbufsize);

This isn't right.  It should be:
			pkt_len = min_t(uint, resid, di->rxbufsize);

Casting it to int would mean that high values of ->rxbufsize would be
treated as lower than "resid".

>                         __skb_trim(p, pkt_len);
>  
>                         tail = p;

regards,
dan carpenter


