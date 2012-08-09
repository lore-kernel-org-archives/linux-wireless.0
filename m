Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:38075 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab2HISTq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:19:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Thu, 9 Aug 2012 11:19:36 -0700
Subject: RE: [patch] mwifiex: use GFP_ATOMIC under spin lock
Message-ID: <477F20668A386D41ADCC57781B1F7043083AF361C0@SC-VEXCH1.marvell.com> (sfid-20120809_201951_659636_8D4D5162)
References: <20120809065757.GB7925@elgon.mountain>
In-Reply-To: <20120809065757.GB7925@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the patch.

> We're holding the sta_list_spinlock here so we can't sleep.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
> index 14d4f04..ca4a1f3 100644
> --- a/drivers/net/wireless/mwifiex/uap_event.c
> +++ b/drivers/net/wireless/mwifiex/uap_event.c
> @@ -63,7 +63,7 @@ mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac)
>  	if (node)
>  		goto done;
> 
> -	node = kzalloc(sizeof(struct mwifiex_sta_node), GFP_KERNEL);
> +	node = kzalloc(sizeof(struct mwifiex_sta_node), GFP_ATOMIC);
>  	if (!node)
>  		goto done;
> 
