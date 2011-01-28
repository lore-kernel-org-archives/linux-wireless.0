Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58665 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab1A1Qn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:43:56 -0500
Subject: Re: [PATCH 6/8] iwl3945: do not use agn specific IWL_RATE_COUNT
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110128163301.GE2452@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-6-git-send-email-sgruszka@redhat.com>
	 <1296231648.7388.16.camel@wwguy-ubuntu>  <20110128163301.GE2452@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:42:22 -0800
Message-ID: <1296232942.7388.24.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Fri, 2011-01-28 at 08:33 -0800, Stanislaw Gruszka wrote:
> On Fri, Jan 28, 2011 at 08:20:48AM -0800, wwguy wrote:
> > > --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
> > > @@ -213,6 +213,7 @@ enum {
> > >  	 IWL_CCK_BASIC_RATES_MASK)
> > >  
> > >  #define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
> > > +#define IWL_RATES_MASK_3945 ((1 << IWL_RATE_COUNT_3945) - 1)
> > >  
> > 
> > Why define 3945 in agn header file?
> > I understand iwl-agn-rs.h is include in iwl-dev.h, which is not the
> > right thing to do. but specify 3945 in agn header file make it even more
> > confuse.
> 
> $ grep 3945 drivers/net/wireless/iwlwifi/iwl-agn-rs.h
> struct iwl3945_rate_info {
> 	IWL_RATE_COUNT_3945 = IWL_RATE_COUNT - 1,
>  * iwl3945_rate_scale_init - Initialize the rate scale table based on
>  * assoc info
> extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32
> sta_id);
> extern void iwl3945_rs_rate_init(struct iwl_priv *priv,
> extern int iwl3945_rate_control_register(void);
> extern void iwl3945_rate_control_unregister(void);
> 
> This file contains 3945 data, I agree this is confused
> and need cleanup :)
> 
we are in the process of split 3945/4965 driver from _agn_

if it is ok for you, could you wait for we done the work to see if
anything need to be clean up 


Thanks
Wey



