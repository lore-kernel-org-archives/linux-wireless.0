Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753909AbeFLLY5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 07:24:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: snoc: use module_platform_driver() macro
References: <20180611193540.190255-1-briannorris@chromium.org>
Date: Tue, 12 Jun 2018 14:24:51 +0300
In-Reply-To: <20180611193540.190255-1-briannorris@chromium.org> (Brian
        Norris's message of "Mon, 11 Jun 2018 12:35:40 -0700")
Message-ID: <87sh5sckn0.fsf@kamboji.qca.qualcomm.com> (sfid-20180612_132517_090870_DF65F03E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> ath10k_snoc_init()/ath10k_snoc_exit() don't add much value;
> module_platform_driver() can remove the boilerplate.
>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/ath/ath10k/snoc.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index a3a7042fe13a..ee74e0060504 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -1388,25 +1388,7 @@ static struct platform_driver ath10k_snoc_driver = {
>  			.of_match_table = ath10k_snoc_dt_match,
>  		},
>  };
> -
> -static int __init ath10k_snoc_init(void)
> -{
> -	int ret;
> -
> -	ret = platform_driver_register(&ath10k_snoc_driver);
> -	if (ret)
> -		pr_err("failed to register ath10k snoc driver: %d\n",
> -		       ret);
> -
> -	return ret;
> -}
> -module_init(ath10k_snoc_init);
> -
> -static void __exit ath10k_snoc_exit(void)
> -{
> -	platform_driver_unregister(&ath10k_snoc_driver);
> -}
> -module_exit(ath10k_snoc_exit);
> +module_platform_driver(ath10k_snoc_driver);

Yeah, makes sense. And I also checked that this shouldn't conflict with
Govind's qmi patch:

https://patchwork.kernel.org/patch/10448183/

-- 
Kalle Valo
