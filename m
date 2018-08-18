Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63656 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbeHRLsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:48:22 -0400
Message-ID: <c052cdda16fa0df1b3672f4be9c20df053703ac0.camel@intel.com> (sfid-20180818_104256_448497_1BD0CE4D)
Subject: Re: [PATCH] Fix Bug 199967 - change WARN_ON(1) to IWL_ERR()
From: Luciano Coelho <luciano.coelho@intel.com>
To: Nye Liu <nyet@nyet.org>, Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Date: Sat, 18 Aug 2018 11:41:27 +0300
In-Reply-To: <20180818033555.18110-1-nyet@nyet.org>
References: <20180818033555.18110-1-nyet@nyet.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-17 at 20:35 -0700, Nye Liu wrote:
> The TX_STATUS_FAIL_DEST_PS case fills logs with full backtraces, which
> are pretty useless. Just do IWL_ERR() printk.
> 
> Signed-off-by: Nye Liu <nyet@nyet.org>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> index cf2591f2ac23..87044953e6b4 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> @@ -1407,8 +1407,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
>  			/* the FW should have stopped the queue and not
>  			 * return this status
>  			 */
> -			WARN_ON(1);
>  			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
> +			IWL_ERR(mvm, "TX_STATUS_FAIL_DEST_PS: "
> +				"tid %d, status %x, flags %x\n", tid, status,
> +				info->flags);
>  			break;
>  		default:
>  			break;

I think this error is serious enough and we would like to catch it when
it occurs so we can debug the actual cause.

But I agree that we shouldn't be repeating it millions of times.  What
about just changing it to WARN_ON_ONCE() instead?

--
Cheers,
Luca.
