Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:55889 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYEWFo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 01:44:59 -0400
Received: by wa-out-1112.google.com with SMTP id j37so454002waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 22:44:58 -0700 (PDT)
Subject: Re: [PATCH] iwlwifi: impelemnt 5000 tx response path
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1211508569-3163-51-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-39-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-41-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-42-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-43-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-44-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-46-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-47-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-48-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-49-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-50-git-send-email-yi.zhu@intel.com>
	 <1211508569-3163-51-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 22:44:57 -0700
Message-Id: <1211521497.6888.24.camel@brick> (sfid-20080523_074515_445085_33F177BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-23 at 10:09 +0800, Zhu Yi wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> 
> This patch implements 5000 HW tx response path
> 
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-5000.c |  235 +++++++++++++++++++++++++++++++
>  net/mac80211/mlme.c                     |   10 +-
>  2 files changed, 240 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
> index 685a84e..5d6a28c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
> @@ -972,6 +972,240 @@ static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
>  	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
>  }
>  
> +
> +static inline u32 iwl5000_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
> +{
> +	__le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
> +				tx_resp->frame_count);
> +	return le32_to_cpu(*scd_ssn) & MAX_SN;

How about:

	return le32_to_cpup((__le32 *)&tx_resp->status + tx_resp->frame_count);

Cheers,

Harvey

