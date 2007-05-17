Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36097 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbXEQF5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 01:57:12 -0400
Message-ID: <464BEEB0.8030402@garzik.org>
Date: Thu, 17 May 2007 01:57:04 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <20070516182700.912a21ed.randy.dunlap@oracle.com> <464BD9D4.4020909@linux.intel.com>
In-Reply-To: <464BD9D4.4020909@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lindent is only the first step.

You then have to go through the code and undo the damage it does.

For instance,

> +               rc = wait_event_interruptible_timeout(priv->
> +                                                     wait_command_queue,
> +                                                     !(priv->
> +                                                       status &
> +                                                       STATUS_HCMD_ACTIVE),
> +                                                     HOST_COMPLETE_TIMEOUT);

you SHOULD (using IETF RFC language) violate the 80-column limit, when 
the alternative is word-wrapping at silly boundaries like the middle of 
a de-ref.

Or,

> +       iwl_write_restricted(priv, FH_RCSR_CONFIG(0),
> +                            ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE
> +                            |
> +                            ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE
> +                            |
> +                            ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN
> +                            |
> +                            ALM_FH_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128
> +                            | (RX_QUEUE_SIZE_LOG <<
> +                               ALM_FH_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE)
> +                            |
> +                            ALM_FH_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST
> +                            | (1 << ALM_FH_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH)
> +                            | ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH);
> +

you SHOULD NOT waste an entire line on a single '|'.

As an aside, remove the redundant "_REG_BIT_" and "_REG_VAL_" stuff.  It 
makes too-long symbols even longer.

As an aside #2,

> +#if IWL == 4965
> +           (rxon1->ofdm_ht_single_stream_basic_rates ==
> +            rxon2->ofdm_ht_single_stream_basic_rates) &&
> +           (rxon1->ofdm_ht_dual_stream_basic_rates ==
> +            rxon2->ofdm_ht_dual_stream_basic_rates) &&
> +           (rxon1->rx_chain == rxon2->rx_chain) &&
> +#endif


those #if's should go away.

	Jeff


