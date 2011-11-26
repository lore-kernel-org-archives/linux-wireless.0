Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1KZTbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Nov 2011 14:31:18 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 26 Nov 2011 21:31:14 +0200
Subject: RE: [PATCH 7/7] iwlwifi: help to debug AGG SM inconsistencies
Message-ID: <4825B8A2C4E264489E57869F0DCFB223445BEF1A9A@hasmsx502.ger.corp.intel.com> (sfid-20111126_203124_761529_F831DDFE)
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
 <1322248308-5113-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1322248308-5113-8-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BTW, tomorrow I will send a fix for a bug in mac80211: a race in tx agg stop that made this warn_on trigger from time to time.

> 
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> Add more data when inconsistencies occur in the AGG state machine.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> index 527e795..2ac7542 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> @@ -1099,13 +1099,21 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans,
> struct sk_buff *skb,
>  		hdr->seq_ctrl = hdr->seq_ctrl &
>  				cpu_to_le16(IEEE80211_SCTL_FRAG);
>  		hdr->seq_ctrl |= cpu_to_le16(seq_number);
> -		seq_number += 0x10;
>  		/* aggregation is on for this <sta,tid> */
>  		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
> -			WARN_ON_ONCE(tid_data->agg.state != IWL_AGG_ON);
> +			if (WARN_ON_ONCE(tid_data->agg.state != IWL_AGG_ON)) {
> +				IWL_ERR(trans, "TX_CTL_AMPDU while not in AGG:"
> +					" Tx flags = 0x%08x, agg.state = %d",
> +					info->flags, tid_data->agg.state);
> +				IWL_ERR(trans, "sta_id = %d, tid = %d "
> +					"txq_id = %d, seq_num = %d", sta_id,
> +					tid, tid_data->agg.txq_id,
> +					seq_number >> 4);
> +			}
>  			txq_id = tid_data->agg.txq_id;
>  			is_agg = true;
>  		}
> +		seq_number += 0x10;
>  	}
> 
>  	/* Copy MAC header from skb into command buffer */
> --
> 1.7.0.4

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

