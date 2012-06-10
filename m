Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:33517 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab2FJPZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 11:25:08 -0400
Message-ID: <4FD4BC51.80407@bfs.de> (sfid-20120610_172553_284827_240C46DE)
Date: Sun, 10 Jun 2012 17:25:05 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] iwlwifi: turn on a lockdep assertion
References: <20120610112521.GA20676@elgon.mountain>
In-Reply-To: <20120610112521.GA20676@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 10.06.2012 13:25, schrieb Dan Carpenter:
> CMD_SYNC is zero so the if (cmd->flags & CMD_SYNC) is never true and we
> never check the assertion.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: enables the assertion even more than v1 (based on feedback from
> Johannes Berg).

The important part is CMD_SYNC -> CMD_ASYNC

re,
 wh


> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index e55ec6c..5c04895 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1259,7 +1259,7 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  	 * the mutex, this ensures we don't try to send two
>  	 * (or more) synchronous commands at a time.
>  	 */
> -	if (cmd->flags & CMD_SYNC)
> +	if (!(cmd->flags & CMD_ASYNC))
>  		lockdep_assert_held(&priv->mutex);
>  
>  	if (priv->ucode_owner == IWL_OWNERSHIP_TM &&
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
