Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8AEC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 178EE20989
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbfA1JEQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:04:16 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51826 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726415AbfA1JEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:04:16 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1go2py-0002YT-5r; Mon, 28 Jan 2019 11:04:14 +0200
Message-ID: <8fcf8d8c61726dcd4466fd82f66701e8841f2af7.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date:   Mon, 28 Jan 2019 11:04:13 +0200
In-Reply-To: <87pnsh17j0.fsf@codeaurora.org>
References: <20190125201305.5616-1-luca@coelho.fi>
         <20190125201305.5616-18-luca@coelho.fi> <87pnsh17j0.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 17/17] iwlwifi: mvm: add an option to dereference vif by
 id
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-01-28 at 11:00 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Sara Sharon <sara.sharon@intel.com>
> > 
> > Currently whenever we get firmware notification with mac id,
> > we iterate over all the interfaces to find the ID. This is a
> > bit cumbersome. Instead, adding an array of RCU pointers, like
> > we have for station IDs. This is not expensive space wise
> > since we have only up to 4 active MACs, and not complicated
> > code wise, since we have a clear point to init and de-init it.
> > 
> > Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> [...]
> 
> > +static inline struct ieee80211_vif *
> > +iwl_mvm_rcu_dereference_vif_id(struct iwl_mvm *mvm, u8 vif_id,
> > bool rcu)
> > +{
> > +	if (WARN_ON(vif_id >= ARRAY_SIZE(mvm->vif_id_to_mac)))
> > +		return NULL;
> > +
> > +	if (rcu)
> > +		return rcu_dereference(mvm->vif_id_to_mac[vif_id]);
> > +
> > +	return rcu_dereference_protected(mvm->vif_id_to_mac[vif_id],
> > +					 lockdep_is_held(&mvm->mutex));
> > +}
> 
> No need to change anything, but IMHO foo(bar) and foo_protected(bar)
> is a lot easier to read than foo(bar, true) and foo(bar, false).

Indeed! And Greg already warned us about the usage of booleans in our
APIs (on another, unrelated matter). ;)

I'll pay more attention to this kind of stuff during our internal
reviews.

Thanks!

--
Cheers,
Luca.

