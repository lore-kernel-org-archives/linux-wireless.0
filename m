Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbcIXLTn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 07:19:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 10/25] iwlwifi: mvm: support packet injection
References: <1474270071.5664.89.camel@coelho.fi>
        <20160919073028.22065-10-luca@coelho.fi>
Date: Sat, 24 Sep 2016 14:19:38 +0300
In-Reply-To: <20160919073028.22065-10-luca@coelho.fi> (Luca Coelho's message
        of "Mon, 19 Sep 2016 10:30:13 +0300")
Message-ID: <87oa3d1r5h.fsf@kamboji.qca.qualcomm.com> (sfid-20160924_132316_051238_1C7DC22C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Sara Sharon <sara.sharon@intel.com>
>
> For automatic testing packet injection can be useful.
> Support injection through debugfs.
>
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

The commit log doesn't tell a lot. I started to wonder why use debugfs
and not the proper interface through mac80211?

> --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> @@ -917,6 +917,59 @@ static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
>  	return ret ?: count;
>  }
>  
> +static ssize_t iwl_dbgfs_inject_packet_write(struct iwl_mvm *mvm,
> +					     char *buf, size_t count,
> +					     loff_t *ppos)
> +{
> +	struct iwl_rx_cmd_buffer rxb = {
> +		._rx_page_order = 0,
> +		.truesize = 0, /* not used */
> +		._offset = 0,
> +	};
> +	struct iwl_rx_packet *pkt;
> +	struct iwl_rx_mpdu_desc *desc;
> +	int bin_len = count / 2;
> +	int ret = -EINVAL;
> +
> +	/* supporting only 9000 descriptor */
> +	if (!mvm->trans->cfg->mq_rx_supported)
> +		return -ENOTSUPP;
> +
> +	rxb._page = alloc_pages(GFP_ATOMIC, 0);
> +	if (!rxb._page)
> +		return -ENOMEM;
> +	pkt = rxb_addr(&rxb);
> +
> +	ret = hex2bin(page_address(rxb._page), buf, bin_len);
> +	if (ret)
> +		goto out;
> +
> +	/* avoid invalid memory access */
> +	if (bin_len < sizeof(*pkt) + sizeof(*desc))
> +		goto out;
> +
> +	/* check this is RX packet */
> +	if (WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd) !=
> +	    WIDE_ID(LEGACY_GROUP, REPLY_RX_MPDU_CMD))
> +		goto out;
> +
> +	/* check the length in metadata matches actual received length */
> +	desc = (void *)pkt->data;
> +	if (le16_to_cpu(desc->mpdu_len) !=
> +	    (bin_len - sizeof(*desc) - sizeof(*pkt)))
> +		goto out;
> +
> +	local_bh_disable();
> +	iwl_mvm_rx_mpdu_mq(mvm, NULL, &rxb, 0);
> +	local_bh_enable();
> +	ret = 0;

But reading from the code makes me suspect that this isn't really normal
packet injection, more like passing full descriptors to the hw. Did I
understand correctly?

-- 
Kalle Valo
