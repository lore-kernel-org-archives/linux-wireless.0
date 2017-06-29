Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36364 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751936AbdF2S7Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:59:25 -0400
Message-ID: <1498762757.22048.145.camel@coelho.fi> (sfid-20170629_205929_144363_9E6CA868)
From: Luca Coelho <luca@coelho.fi>
To: Joe Perches <joe@perches.com>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Thu, 29 Jun 2017 21:59:17 +0300
In-Reply-To: <1498682585.8633.6.camel@perches.com>
References: <20170628201330.9432-1-luca@coelho.fi>
         <20170628201330.9432-20-luca@coelho.fi>
         <1498682585.8633.6.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 19/31] iwlwifi: pcie: improve debug in
 iwl_pcie_rx_handle_rb()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Wed, 2017-06-28 at 13:43 -0700, Joe Perches wrote:
> On Wed, 2017-06-28 at 23:13 +0300, Luca Coelho wrote:
> > Print the queue for the existing debug message and add a new
> > debug message indicating where the RB ended.
> 
> trivia:
> 
> > diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> 
> []
> > @@ -1137,8 +1141,8 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
> >  			FH_RSCSR_RXQ_POS);
> >  
> >  		IWL_DEBUG_RX(trans,
> > -			     "cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
> > -			     rxcb._offset,
> > +			     "Q %d: cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
> > +			     rxq->id, offset,
> >  			     iwl_get_cmd_string(trans,
> >  						iwl_cmd_id(pkt->hdr.cmd,
> >  							   pkt->hdr.group_id,
> 
> Perhaps %02x.%02x instead of %.2x.%2x
> 
> Most uses are %.2x.%.2x, but %02x.%02x seems clearer
> at least to me.

Sure, I tend to agree, but in this sort of debugging, people usually go
down into the code to see exactly what it means anyway...  So we'll keep
it in mind for the next time, but we won't change this one right now.

Thanks!

--
Cheers,
Luca.
