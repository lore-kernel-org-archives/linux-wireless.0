Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55512 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab0DHUYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:24:34 -0400
Subject: Re: [PATCH] iwlwifi: avoid warning by using result of
 iwl_send_cmd_pdu in iwl_sta_init_lq
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1270756089-9589-1-git-send-email-linville@tuxdriver.com>
References: <1270756089-9589-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 13:24:33 -0700
Message-ID: <1270758273.14052.217.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Thu, 2010-04-08 at 12:48 -0700, John W. Linville wrote:
> CC [M]  drivers/net/wireless/iwlwifi/iwl-sta.o
> drivers/net/wireless/iwlwifi/iwl-sta.c: In function ‘iwl_sta_init_lq’:
> drivers/net/wireless/iwlwifi/iwl-sta.c:461: warning: ignoring return value of ‘iwl_send_cmd_pdu’, declared with attribute warn_unused_result
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-sta.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
> index e34ac03..91aaf11 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> @@ -458,8 +458,9 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
>  	/* Update the rate scaling for control frame Tx to AP */
>  	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
>  
> -	iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
> -			       sizeof(link_cmd), &link_cmd);
> +	if (!iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
> +			       sizeof(link_cmd), &link_cmd))
> +		IWL_WARN(priv, "Tx link quality reply failed\n");
>  }
>  
>  /*

I made a mistake here somewhere since this is fixed in iwlwifi-2.6 but
did not propagate to wireless-next-2.6.

Wouldn't the above print the warning on success though?

In iwlwifi-2.6 the code looks like (whitespace broken copy&pasted) ...
it would be nice to have the return code available in error message:

        ret = iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
                               sizeof(link_cmd), &link_cmd);
        if (ret)
                IWL_ERR(priv, "REPLY_TX_LINK_QUALITY_CMD failed (%d)\n", ret);

If you want I can just fix my merging mistake.

Reinette


