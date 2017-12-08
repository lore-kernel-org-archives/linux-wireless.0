Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdLHMiu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:38:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v2 06/15] iwlwifi: mvm: rs: add ops for the new rate scaling in the FW
References: <20171202162858.4167-7-luca@coelho.fi>
        <20171202213603.12512-1-luca@coelho.fi>
Date: Fri, 08 Dec 2017 14:38:46 +0200
In-Reply-To: <20171202213603.12512-1-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 2 Dec 2017 23:36:03 +0200")
Message-ID: <87374ls8bt.fsf@kamboji.qca.qualcomm.com> (sfid-20171208_133854_176013_5B0F1934)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Gregory Greenman <gregory.greenman@intel.com>
>
> This patch introduces a new instance of rate_control_ops for
> the new API (adding only empty stubs here and the subsequent
> patches in the series will fill in the implementation).
> The decision which API to use is done during the register
> step according to FW TLV.
>
> Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> +void iwl_mvm_rs_add_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta)
> +{
> +	struct iwl_lq_sta_rs_fw *lq_sta = &mvmsta->lq_sta.rs_fw;
> +
> +	IWL_DEBUG_RATE(mvm, "create station rate scale window\n");
> +
> +	lq_sta->pers.drv = mvm;
> +	lq_sta->pers.sta_id = mvmsta->sta_id;
> +	lq_sta->pers.chains = 0;
> +	memset(lq_sta->pers.chain_signal, 0, sizeof(lq_sta->pers.chain_signal));
> +	lq_sta->pers.last_rssi = S8_MIN;
> +	lq_sta->last_rate_n_flags = 0;
> +
> +#ifdef CPTCFG_MAC80211_DEBUGFS
> +	lq_sta->pers.dbg_fixed_rate = 0;
> +#endif
> +}

CPTCFG_ doesn't look right. But no need to resend just because of this,
you can send a followup patch.

-- 
Kalle Valo
