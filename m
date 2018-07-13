Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:60749 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbeGMJpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 05:45:36 -0400
Subject: Re: [PATCH 03/10] atmel: hide unused procfs helpers
To: <simon@thekelleys.org.uk>, <kvalo@codeaurora.org>
References: <20180713064658.10340-1-yuehaibing@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <ded55181-e1b0-99e9-ac68-2d93fb6168c0@huawei.com> (sfid-20180713_113157_717303_ED93F4C4)
Date: Fri, 13 Jul 2018 17:31:37 +0800
MIME-Version: 1.0
In-Reply-To: <20180713064658.10340-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pls ignore this,my bad.

On 2018/7/13 14:46, YueHaibing wrote:
> When CONFIG_PROC_FS isn't set, gcc warning this:
> 
> drivers/net/wireless/atmel/atmel.c:1402:12: warning: ‘atmel_proc_show’ defined but not used [-Wunused-function]
>  static int atmel_proc_show(struct seq_file *m, void *v)
>             ^
> fix this by adding #ifdef around it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/atmel/atmel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
> index b01dc34..3940876 100644
> --- a/drivers/net/wireless/atmel/atmel.c
> +++ b/drivers/net/wireless/atmel/atmel.c
> @@ -1399,6 +1399,7 @@ static int atmel_validate_channel(struct atmel_private *priv, int channel)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PROC_FS
>  static int atmel_proc_show(struct seq_file *m, void *v)
>  {
>  	struct atmel_private *priv = m->private;
> @@ -1481,6 +1482,7 @@ static int atmel_proc_show(struct seq_file *m, void *v)
>  	seq_printf(m, "Current state:\t\t%s\n", s);
>  	return 0;
>  }
> +#endif
>  
>  static const struct net_device_ops atmel_netdev_ops = {
>  	.ndo_open 		= atmel_open,
> 
