Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbcBGVoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 16:44:01 -0500
Date: Sun, 7 Feb 2016 13:44:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH RESEND 41/70] staging: wilc1000: linux_mon.c: replaces
 PRINT_ER with netdev_err
Message-ID: <20160207214400.GB31172@kroah.com> (sfid-20160207_224408_896074_83D3E363)
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
 <1454577871-667-2-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454577871-667-2-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 04, 2016 at 06:24:02PM +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patches replaces PRINT_ER with netdev_err.

It also does more than that:

> @@ -273,7 +266,9 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
>  	/* if source address and bssid fields are equal>>Mac header */
>  	/*send it to mgmt frames handler */
>  	if (!(memcmp(srcAdd, bssid, 6))) {
> -		mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
> +		ret = mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
> +		if (ret)
> +			netdev_err(dev, "fail to mgmt tx\n");

Look, proper error checking.

Which is great, but again, the changelog text was wrong :(

