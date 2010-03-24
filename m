Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab0CXVdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:33:41 -0400
Subject: Re: [PATCH] iwlwifi: fix build error for CONFIG_IWLAGN=n
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1269465799-19060-1-git-send-email-linville@tuxdriver.com>
References: <4BAA73D2.1000301@oracle.com>
	 <1269465799-19060-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 14:33:46 -0700
Message-ID: <1269466426.6935.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 17:23 -0400, John W. Linville wrote:
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_good_ack_health':
> drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: 'struct iwl_priv' has no member named '_agn'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
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
>   * iwl_good_ack_health - checks for ACK count ratios, BA timeout
> retries.

I thought we had a patch moving it?

johannes

