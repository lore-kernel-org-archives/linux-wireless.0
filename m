Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:23047 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750873AbeDNGTu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Apr 2018 02:19:50 -0400
Message-ID: <68a0f81d7212a652def13b76e250b88872686bb7.camel@intel.com> (sfid-20180414_082127_956084_05BFABB3)
Subject: Re: [PATCH 01/25] iwlwifi: mvm: add traffic condition monitoring
 (TCM)
From: Luciano Coelho <luciano.coelho@intel.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 14 Apr 2018 09:19:47 +0300
In-Reply-To: <20180413124256.21769-2-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
         <20180413124256.21769-2-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-04-13 at 15:42 +0300, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Traffic condition monitor gathers data about the traffic load and
> other conditions and can be used to make decisions regarding latency,
> throughput etc.  This patch introduces the code and data structures
> to
> collect this data for future use.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

[...]

> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
> b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h

[...]

> @@ -1906,6 +1956,16 @@ bool iwl_mvm_is_vif_assoc(struct iwl_mvm
> *mvm);
>  
>  void iwl_mvm_inactivity_check(struct iwl_mvm *mvm);
>  
> +#define MVM_TCM_PERIOD_MSEC 500
> +#define MVM_TCM_PERIOD (HZ * MVM_TCM_PERIOD_MSEC / 1000)
> +#define MVM_LL_PERIOD (10 * HZ)
> +void iwl_mvm_send_tcm_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif);

I accidentally left this function in, but it only sends a vendor
command event in our internal driver, so it's undefined in the mainline
(reported by kbuildbot).  I'll send v2.

--
Cheers,
Luca.
