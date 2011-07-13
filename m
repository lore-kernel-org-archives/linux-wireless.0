Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3947 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1GMEbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 00:31:04 -0400
Subject: Re: [PATCH 21/24] ath6kl: add txrx.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713013630.8517.77720.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013630.8517.77720.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:31:03 -0700
Message-ID: <1310531463.1143.31.camel@Joe-Laptop> (sfid-20110713_063108_235031_403C6F59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 04:36 +0300, Kalle Valo wrote:
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>  drivers/net/wireless/ath/ath6kl/txrx.c | 1471 ++++++++++++++++++++++++++++++++
[]
> +int ath6kl_control_tx(void *devt, struct sk_buff *skb,
> +		      enum htc_endpoint_id eid)
> +{
[]
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
> +		   "%s: skb=0x%lx, len=0x%x eid =%d\n", __func__,
> +		   (unsigned long)skb, skb->len, eid);


This style of casting a pointer to an unsigned long is used
unnecessarily quite often.

I think it's more intelligible to use %p without the case.
Also, hex length is often not as readable as decimal.

	ath6kl_dbg(ATH6KL_DBG_WLAN_TX, "%s: skb=%p, len=%u eid=%d\n",
		   __func__, skb, skb->len, eid);


