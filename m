Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:56176 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934606Ab1IOThu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:37:50 -0400
Subject: Re: [PATCH 08/27] iwlagn: beautify the code - remove uneeded line
 break
From: Joe Perches <joe@perches.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 15 Sep 2011 12:37:49 -0700
In-Reply-To: <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1316115470.11236.1.camel@Joe-Laptop> (sfid-20110915_213754_035846_64F2EF67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 11:46 -0700, Wey-Yi Guy wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Two lines could be concatenated without exceeding the 80 char limit.
> diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
[]
> @@ -308,10 +308,8 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
>  
>  	txq->q.n_window = slots_num;
>  
> -	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num,
> -			    GFP_KERNEL);
> -	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num,
> -			   GFP_KERNEL);
> +	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num, GFP_KERNEL);
> +	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num, GFP_KERNEL);

kcalloc would be even prettier...


