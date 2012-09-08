Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47934 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2IHCDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 22:03:47 -0400
Received: by ieje11 with SMTP id e11so210449iej.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 19:03:47 -0700 (PDT)
Message-ID: <504AA77F.2010906@lwfinger.net> (sfid-20120908_040352_235354_7DA6B6CD)
Date: Fri, 07 Sep 2012 21:03:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] NFC: pn544_hci: move the dereference below the NULL
 test
References: <CAPgLHd_gF6X91JPGZK0f7vhSAK+d74YfbcvPn+givzMr=44+Sw@mail.gmail.com>
In-Reply-To: <CAPgLHd_gF6X91JPGZK0f7vhSAK+d74YfbcvPn+givzMr=44+Sw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2012 08:53 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The dereference should be moved below the NULL test.
>
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/nfc/pn544_hci.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
> index aa71807..7b20f2d 100644
> --- a/drivers/nfc/pn544_hci.c
> +++ b/drivers/nfc/pn544_hci.c
> @@ -341,13 +341,14 @@ flush:
>   static irqreturn_t pn544_hci_irq_thread_fn(int irq, void *dev_id)
>   {
>   	struct pn544_hci_info *info = dev_id;
> -	struct i2c_client *client = info->i2c_dev;
> +	struct i2c_client *client;
>   	struct sk_buff *skb = NULL;
>   	int r;
>
>   	BUG_ON(!info);
>   	BUG_ON(irq != info->i2c_dev->irq);
>
> +	client = info->i2c_dev;

As long as you are reworking this section, doesn't BUG_ON seem a little harsh? I 
do not think the kernel should ever be crashed because a non-essential driver is 
messed up. As the patch would be a totally different change, it should be a new 
submission, but I think each of these conditions should trigger a WARN_ON_ONCE, 
and return IRQ_NONE when they occur.

Larry

>   	dev_dbg(&client->dev, "IRQ\n");
>
>   	if (info->hard_fault != 0)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

