Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:56265 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751166AbbCATmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:42:11 -0500
Message-ID: <1425238927.31561.5.camel@perches.com> (sfid-20150301_204219_113918_CF9CBC97)
Subject: Re: [PATCH 08/31] iwlwifi: mvm: rs: print single stream params via
 debugfs
From: Joe Perches <joe@perches.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>
Date: Sun, 01 Mar 2015 11:42:07 -0800
In-Reply-To: <1425238304-498-8-git-send-email-emmanuel.grumbach@intel.com>
References: <1425238186.30202.5.camel@egrumbacBox>
	 <1425238304-498-8-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-01 at 21:31 +0200, Emmanuel Grumbach wrote:
> From: Eyal Shapira <eyal@wizery.com>
> 
> Add this to the info printed when reading rate_scale_table.
> Useful for debugging.
[]
> diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
[]
> @@ -3369,6 +3370,16 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
>  			lq_sta->lq.agg_frame_cnt_limit);
>  
>  	desc += sprintf(buff+desc, "reduced tpc=%d\n", lq_sta->lq.reduced_tpc);
> +	ss_params = le32_to_cpu(lq_sta->lq.ss_params);
> +	desc += sprintf(buff+desc, "single stream params: %s%s%s%s\n",
> +			(ss_params & LQ_SS_PARAMS_VALID) ?
> +			"VALID," : "INVALID",
> +			(ss_params & LQ_SS_BFER_ALLOWED) ?
> +			"BFER," : "",
> +			(ss_params & LQ_SS_STBC_1SS_ALLOWED) ?
> +			"STBC," : "",
> +			(ss_params & LQ_SS_FORCE) ?
> +			"FORCE" : "");

Are all things exclusive?
If no, the output is not easily readable.

It would probably be better to use:
12345678901234567890123456789012345678901234567890123456789012345678901234567890
	desc += sprintf(buff+desc, "single stream params: %s%s%s%s\n",
			(ss_params & LQ_SS_PARAMS_VALID) ?
			"VALID" : "INVALID",
			(ss_params & LQ_SS_BFER_ALLOWED) ?
			", BFER" : "",
			(ss_params & LQ_SS_STBC_1SS_ALLOWED) ?
			", STBC" : "",
			(ss_params & LQ_SS_FORCE) ?
			", FORCE" : "");


