Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27843 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab3KBTlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 15:41:35 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: iwlwifi: mvm: BT Coex - don't limit agg size in loose scheme
Date: Sat, 2 Nov 2013 19:41:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DE641D@HASMSX103.ger.corp.intel.com> (sfid-20131102_204140_677835_C3B8A02D)
References: <20131101102848.GI29795@longonot.mountain>
In-Reply-To: <20131101102848.GI29795@longonot.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Hello Emmanuel Grumbach,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 9145d15128bd: "iwlwifi: mvm: BT Coex - don't limit agg size in loose
> scheme" from Jul 18, 2013, leads to the following Smatch
> complaint:
> 
> drivers/net/wireless/iwlwifi/mvm/rs.c:2491 rs_fill_link_cmd()
> 	 error: we previously assumed 'mvm' could be null (see line 2412)

Thanks Dan - I believe we can remove all the checks. Will send a patch.

> 
> drivers/net/wireless/iwlwifi/mvm/rs.c
>   2411		repeat_rate--;
>   2412		if (mvm)
>                     ^^^
> Existing check.
> 
>   2413			valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
>   2414
>   2415		/* Fill rest of rate table */
>   2416		while (index < LINK_QUAL_MAX_RETRY_NUM) {
>   2417			/* Repeat initial/next rate.
>   2418			 * For legacy IWL_NUMBER_TRY == 1, this loop will
> not execute.
>   2419			 * For HT IWL_HT_NUMBER_TRY == 3, this executes
> twice. */
> 
> [snip]
> 
>   2481		}
>   2482
>   2483		lq_cmd->agg_frame_cnt_limit =
> LINK_QUAL_AGG_FRAME_LIMIT_DEF;
>   2484		lq_cmd->agg_disable_start_th =
> LINK_QUAL_AGG_DISABLE_START_DEF;
>   2485
>   2486		lq_cmd->agg_time_limit =
>   2487			cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
>   2488
>   2489		if (sta)
>   2490			lq_cmd->agg_time_limit =
>   2491
> 	cpu_to_le16(iwl_mvm_bt_coex_agg_time_limit(mvm, sta));
>                                                                            ^^^ Patch introduces new unchecked
> dereference.
> 
>   2492	}
>   2493
> 
> regards,
> dan carpenter
