Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42896 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751499AbdHGNrM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 09:47:12 -0400
Message-ID: <1502113630.15969.124.camel@coelho.fi> (sfid-20170807_154715_883386_A7DC6C69)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Date: Mon, 07 Aug 2017 16:47:10 +0300
In-Reply-To: <87mv7bjy74.fsf@kamboji.qca.qualcomm.com>
References: <20170805184743.23650-1-luca@coelho.fi>
         <20170805184743.23650-2-luca@coelho.fi>
         <87d187len2.fsf@kamboji.qca.qualcomm.com>
         <1502111497.15969.120.camel@coelho.fi>
         <87mv7bjy74.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 1/3] iwlwifi: mvm: Fix a memory leak in an error
 handling path in 'iwl_mvm_sar_get_wgds_table()'
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-08-07 at 16:37 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > On Mon, 2017-08-07 at 15:57 +0300, Kalle Valo wrote:
> > > Luca Coelho <luca@coelho.fi> writes:
> > > 
> > > > From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> > > > 
> > > > We should free 'wgds.pointer' here as done a few lines above in another
> > > > error handling path.
> > > > It was allocated within 'acpi_evaluate_object()'.
> > > > 
> > > > Fixes: c52030a01ccc ("iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table")
> > > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > > > ---
> > > >  drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> > > > index 79e7a7a285dc..82863e9273eb 100644
> > > > --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> > > > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> > > > @@ -1275,8 +1275,10 @@ static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
> > > >  
> > > >  			entry = &wifi_pkg->package.elements[idx++];
> > > >  			if ((entry->type != ACPI_TYPE_INTEGER) ||
> > > > -			    (entry->integer.value > U8_MAX))
> > > > -				return -EINVAL;
> > > > +			    (entry->integer.value > U8_MAX)) {
> > > > +				ret = -EINVAL;
> > > > +				goto out_free;
> > > > +			}
> > > 
> > > How likely is this leak to happen in real world? To me it looks like
> > > more like a theoretical issue and could have easily waited for 4.14. But
> > > it's fine this time, just something to keep in mind in the future.
> > 
> > This is a one-liner fix and I consider memory leaks serious enough to
> > deserve a fix for rc5.  This bug can happen with broken ACPI tables and,
> > trust me, broken ACPI tables are not that hard to find.
> 
> Sure, anything's possible. But what I'm reading here this is still a
> theoretical issue, not a leak which we _know_ will happen to thousands
> of people.
> 
> > But you rule here, feel free to NACK my patches whenever you see fit! :)
> 
> I'm trying to minimise the numbers of patches going to wireless-drivers
> and striving for only fixes which really matter and keep the theoretical
> stuff for -next. The is mostly selfish reasons as wireless-drivers are a
> lot more work, especially if there are conflicts.

I totally understand.  It's a lot more work for me too, with all the
reordering I need to do and the conflicts these cause.


> But like I said in my previous mail, no need to drop this.

Okay, thanks!

--
Cheers,
Luca.
