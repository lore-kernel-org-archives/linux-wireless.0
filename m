Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:43238 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932829AbcI1PLf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 11:11:35 -0400
Date: Wed, 28 Sep 2016 08:11:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Bruno Herrera <bruherrera@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] wlcore: sdio: drop kfree for memory allocated with
 devm_kzalloc
Message-ID: <20160928151131.xmqarrx5he4kggsp@atomide.com> (sfid-20160928_171138_926265_446B5FD9)
References: <1475073516-7328-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475073516-7328-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Wei Yongjun <weiyj.lk@gmail.com> [160928 07:39]:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> It's not necessary to free memory allocated with devm_kzalloc
> and using kfree leads to a double free.
> 
> Fixes: d776fc86b82f ("wlcore: sdio: Populate config firmware data")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Oops thanks for catching this:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/net/wireless/ti/wlcore/sdio.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> index a6e94b1..47fe7f9 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -391,7 +391,6 @@ static void wl1271_remove(struct sdio_func *func)
>  	pm_runtime_get_noresume(&func->dev);
>  
>  	platform_device_unregister(glue->core);
> -	kfree(glue);
>  }
>  
>  #ifdef CONFIG_PM
> 
