Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdLNMoO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:44:14 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] rtlwifi: always initialize variables given to RT_TRACE()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171210195159.7454-1-nicolas.iooss_linux@m4x.org>
References: <20171210195159.7454-1-nicolas.iooss_linux@m4x.org>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-Id: <20171214124413.A4A5560A60@smtp.codeaurora.org> (sfid-20171214_134433_696062_E2F65E16)
Date: Thu, 14 Dec 2017 12:44:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Iooss <nicolas.iooss_linux@m4x.org> wrote:

> In rtl_rx_ampdu_apply(), when rtlpriv->cfg->ops->get_btc_status()
> returns false, RT_TRACE() is called with the values of variables
> reject_agg and agg_size, which have not been initialized.
> 
> Always initialize these variables in order to prevent using
> uninitialized values.
> 
> This issue has been found with clang. The compiler reported:
> 
>     drivers/net/wireless/realtek/rtlwifi/base.c:1665:6: error: variable
>     'agg_size' is used uninitialized whenever 'if' condition is false
>     [-Werror,-Wsometimes-uninitialized]
>             if (rtlpriv->cfg->ops->get_btc_status())
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     drivers/net/wireless/realtek/rtlwifi/base.c:1671:31: note:
>     uninitialized use occurs here
>                      reject_agg, ctrl_agg_size, agg_size);
>                                                 ^~~~~~~~
> 
>     drivers/net/wireless/realtek/rtlwifi/base.c:1665:6: error: variable
>     'reject_agg' is used uninitialized whenever 'if' condition
>           is false [-Werror,-Wsometimes-uninitialized]
>             if (rtlpriv->cfg->ops->get_btc_status())
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     drivers/net/wireless/realtek/rtlwifi/base.c:1671:4: note:
>     uninitialized use occurs here
>                      reject_agg, ctrl_agg_size, agg_size);
>                      ^~~~~~~~~~
> 
> Fixes: 2635664e6e4a ("rtlwifi: Add rx ampdu cfg for btcoexist.")
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Patch applied to wireless-drivers-next.git, thanks.

e4779162f737 rtlwifi: always initialize variables given to RT_TRACE()

-- 
https://patchwork.kernel.org/patch/10103995/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
