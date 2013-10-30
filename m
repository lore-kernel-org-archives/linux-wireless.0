Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab3J3Omr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 10:42:47 -0400
Message-ID: <1383144122.21123.1.camel@dcbw.foobar.com> (sfid-20131030_154250_758944_FFD1152A)
Subject: Re: [PATCH -next] libertas: fix error return code in if_cs_probe()
From: Dan Williams <dcbw@redhat.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, hsweeten@visionengravers.com,
	gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Wed, 30 Oct 2013 09:42:02 -0500
In-Reply-To: <CAPgLHd9nCFPvSWMtrinySm=9bESiKXpYZgZYj6fhzUQKVJFkhw@mail.gmail.com>
References: <CAPgLHd9nCFPvSWMtrinySm=9bESiKXpYZgZYj6fhzUQKVJFkhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-30 at 13:22 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENODEV in the unknown model error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_cs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
> index ef8c98e..f499efc 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -902,6 +902,7 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>  	if (card->model == MODEL_UNKNOWN) {
>  		pr_err("unsupported manf_id 0x%04x / card_id 0x%04x\n",
>  		       p_dev->manf_id, p_dev->card_id);
> +		ret = -ENODEV;
>  		goto out2;
>  	}
>  
> 
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev


