Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:30501 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab0CXXBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 19:01:08 -0400
Message-ID: <4BAA9960.9070102@oracle.com>
Date: Wed, 24 Mar 2010 15:59:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix build error for CONFIG_IWLAGN=n
References: <4BAA73D2.1000301@oracle.com> <1269465799-19060-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1269465799-19060-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/10 14:23, John W. Linville wrote:
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_good_ack_health':
> drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: 'struct iwl_priv' has no member named '_agn'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

ACK if you end up using this one.

Thanks.

> ---
>  drivers/net/wireless/iwlwifi/iwl-rx.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> index b6a64d8..2fa30df 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -621,6 +621,7 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
>  #define BA_TIMEOUT_CNT (5)
>  #define BA_TIMEOUT_MAX (16)
>  
> +#if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
>  /**
>   * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
>   *
> @@ -670,6 +671,7 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
>  	return rc;
>  }
>  EXPORT_SYMBOL(iwl_good_ack_health);
> +#endif
>  
>  /**
>   * iwl_good_plcp_health - checks for plcp error.


-- 
~Randy
