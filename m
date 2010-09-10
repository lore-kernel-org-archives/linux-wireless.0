Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2342 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0IJP4V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 11:56:21 -0400
Subject: Re: [PATCH 12/14] iwlwifi: cleanup scan initiate check
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284128807-11436-13-git-send-email-sgruszka@redhat.com>
References: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
	 <1284128807-11436-13-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 10 Sep 2010 08:55:33 -0700
Message-Id: <1284134133.6054.25.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-10 at 07:26 -0700, Stanislaw Gruszka wrote:
> Remove redundant checks and use iwl_is_ready_rf().
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |   17 +----------------
>  1 files changed, 1 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index af9a836..26dd8f3 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -361,7 +361,7 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
>  
>  	cancel_delayed_work(&priv->scan_check);
>  
> -	if (!iwl_is_ready(priv)) {
> +	if (!iwl_is_ready_rf(priv)) {
>  		IWL_WARN(priv, "request scan called when driver not ready.\n");
>  		return -EIO;
>  	}
> @@ -372,26 +372,11 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
>  		return -EBUSY;
>  	}
>  
> -	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
> -		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
> -		return -EIO;
> -	}
> -
>  	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
>  		IWL_DEBUG_HC(priv, "Scan request while abort pending.\n");
>  		return -EBUSY;
>  	}
>  
> -	if (iwl_is_rfkill(priv)) {
> -		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
> -		return -EIO;
> -	}
> -
> -	if (!test_bit(STATUS_READY, &priv->status)) {
> -		IWL_DEBUG_HC(priv, "Scan request while uninitialized.\n");
> -		return -EBUSY;
> -	}
> -
>  	IWL_DEBUG_INFO(priv, "Starting %sscan...\n",
>  			internal ? "internal short " : "");
>  

