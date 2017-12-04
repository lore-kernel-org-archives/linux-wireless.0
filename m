Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46084 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbdLDM55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 07:57:57 -0500
Message-ID: <1512392273.4827.127.camel@intel.com> (sfid-20171204_135800_245132_CB43350A)
Subject: Re: [PATCH 13/15] iwlwifi: mvm: mark MIC stripped MPDUs
From: Luciano Coelho <luciano.coelho@intel.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Mon, 04 Dec 2017 14:57:53 +0200
In-Reply-To: <20171202162858.4167-14-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
         <20171202162858.4167-14-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-12-02 at 18:28 +0200, Luca Coelho wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> When RADA is active, the hardware decrypts the packets and strips off
> the MIC as it is useless after decryption. Indicate that to mac80211.
> 
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> index 0e6a7dd30aa9..a81ff4163d05 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> @@ -253,6 +253,8 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm,
> struct ieee80211_hdr *hdr,
>  			return -1;
>  
>  		stats->flag |= RX_FLAG_DECRYPTED;
> +		if (pkt_flags & FH_RSCSR_RADA_EN)
> +			stats->flag |= RX_FLAG_MIC_STRIPPED;
>  		*crypt_len = IEEE80211_CCMP_HDR_LEN;
>  		return 0;
>  	case IWL_RX_MPDU_STATUS_SEC_TKIP:

Same thing here, I'll move it to the -fixes series, since it's needed
by 9000-series NICs.

--
Cheers,
Luca.
