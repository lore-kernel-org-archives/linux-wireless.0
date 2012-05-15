Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2928 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab2EOOVk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:21:40 -0400
Message-ID: <4FB26664.2080008@broadcom.com> (sfid-20120515_162145_439955_E9D2C422)
Date: Tue, 15 May 2012 16:21:24 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcm80211: brcmu_pkt_buf_free_skb() should handle
 NULL
References: <20120515090027.GG30265@elgon.mountain>
In-Reply-To: <20120515090027.GG30265@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2012 11:00 AM, Dan Carpenter wrote:
> This is potentially called with NULL pointers, for example, look at
> brcmf_c_prec_enq().  Since it's a free() function, probably people
> expect it to handle NULL pointers.

Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
> index b45ab34..3e6405e 100644

Is the diff command filtered properly here. In most patches I usually
see '---' immediatly after the Signed-off-by line.

> --- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
> +++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
> @@ -43,6 +43,8 @@ EXPORT_SYMBOL(brcmu_pkt_buf_get_skb);
>  /* Free the driver packet. Free the tag if present */
>  void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
>  {
> +	if (!skb)
> +		return;
>  	WARN_ON(skb->next);
>  	if (skb->destructor)
>  		/* cannot kfree_skb() on hard IRQ (net/core/skbuff.c) if
> 

Gr. AvS

