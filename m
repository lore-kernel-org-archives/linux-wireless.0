Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56963 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab1COJVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 05:21:41 -0400
Subject: Re: [patch 2/2] iwlwifi: remove duplicate initialization in
 __iwl_down()
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20110315070324.GR2008@bicker>
References: <20110315070324.GR2008@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 02:05:14 -0700
Message-ID: <1300179914.5082.214.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-15 at 00:03 -0700, Dan Carpenter wrote:
> We initialize exit_pending twice.  It's the second initialization which
> is correct.  That was added in d745d472af "iwlwifi: cancel scan when
> down the device".
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 321b18b..7adc60e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2537,7 +2537,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv);
>  static void __iwl_down(struct iwl_priv *priv)
>  {
>  	unsigned long flags;
> -	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
> +	int exit_pending;
>  
>  	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
>  


