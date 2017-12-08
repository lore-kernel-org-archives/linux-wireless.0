Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27540 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbdLHMkz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:40:55 -0500
Message-ID: <1512736850.4827.288.camel@intel.com> (sfid-20171208_134059_625542_24627C1B)
Subject: Re: [PATCH v2 06/15] iwlwifi: mvm: rs: add ops for the new rate
 scaling in the FW
From: Luciano Coelho <luciano.coelho@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>
Date: Fri, 08 Dec 2017 14:40:50 +0200
In-Reply-To: <87374ls8bt.fsf@kamboji.qca.qualcomm.com>
References: <20171202162858.4167-7-luca@coelho.fi>
         <20171202213603.12512-1-luca@coelho.fi>
         <87374ls8bt.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-08 at 14:38 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Gregory Greenman <gregory.greenman@intel.com>
> > 
> > This patch introduces a new instance of rate_control_ops for
> > the new API (adding only empty stubs here and the subsequent
> > patches in the series will fill in the implementation).
> > The decision which API to use is done during the register
> > step according to FW TLV.
> > 
> > Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> [...]
> 
> > +void iwl_mvm_rs_add_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta
> > *mvmsta)
> > +{
> > +	struct iwl_lq_sta_rs_fw *lq_sta = &mvmsta->lq_sta.rs_fw;
> > +
> > +	IWL_DEBUG_RATE(mvm, "create station rate scale window\n");
> > +
> > +	lq_sta->pers.drv = mvm;
> > +	lq_sta->pers.sta_id = mvmsta->sta_id;
> > +	lq_sta->pers.chains = 0;
> > +	memset(lq_sta->pers.chain_signal, 0, sizeof(lq_sta-
> > >pers.chain_signal));
> > +	lq_sta->pers.last_rssi = S8_MIN;
> > +	lq_sta->last_rate_n_flags = 0;
> > +
> > +#ifdef CPTCFG_MAC80211_DEBUGFS
> > +	lq_sta->pers.dbg_fixed_rate = 0;
> > +#endif
> > +}
> 
> CPTCFG_ doesn't look right. But no need to resend just because of
> this,
> you can send a followup patch.

Gack, how come I let this go through? My (actually Emmanuel's ;)
checker script should catch this.  Maybe I forgot to run it on v2?
Sorry, dude!

--
Luca.
