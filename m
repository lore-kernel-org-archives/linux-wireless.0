Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:46319 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751580AbdF1UnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:43:10 -0400
Message-ID: <1498682585.8633.6.camel@perches.com> (sfid-20170628_224313_728318_5E9E21C5)
Subject: Re: [PATCH 19/31] iwlwifi: pcie: improve debug in
 iwl_pcie_rx_handle_rb()
From: Joe Perches <joe@perches.com>
To: Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 13:43:05 -0700
In-Reply-To: <20170628201330.9432-20-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
         <20170628201330.9432-20-luca@coelho.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 23:13 +0300, Luca Coelho wrote:
> Print the queue for the existing debug message and add a new
> debug message indicating where the RB ended.

trivia:

> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
[]
> @@ -1137,8 +1141,8 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
>  			FH_RSCSR_RXQ_POS);
>  
>  		IWL_DEBUG_RX(trans,
> -			     "cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
> -			     rxcb._offset,
> +			     "Q %d: cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
> +			     rxq->id, offset,
>  			     iwl_get_cmd_string(trans,
>  						iwl_cmd_id(pkt->hdr.cmd,
>  							   pkt->hdr.group_id,

Perhaps %02x.%02x instead of %.2x.%2x

Most uses are %.2x.%.2x, but %02x.%02x seems clearer
at least to me.
