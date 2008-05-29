Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:26007 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYE2CCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 22:02:31 -0400
Subject: Re: [PATCH 2.6.26 1/3] iwlwifi: fix in-column rate scaling
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <20080528202201.GC25770@tuxdriver.com>
References: <1211858975-21424-1-git-send-email-yi.zhu@intel.com>
	 <20080528202201.GC25770@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 29 May 2008 10:02:00 +0800
Message-Id: <1212026521.7814.276.camel@debian.sh.intel.com> (sfid-20080529_040236_505977_18BD82D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-28 at 16:22 -0400, John W. Linville wrote:
> On Tue, May 27, 2008 at 11:29:33AM +0800, Zhu Yi wrote:
> > From: Guy Cohen <guy.cohen@intel.com>
> > 
> > This patch fixes cases that the code raised or didn't decrease
> > the rate although the success ratio was not good.
> > 
> > Signed-off-by: Guy Cohen <guy.cohen@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   45 ++++++++++++++-------------
> >  1 files changed, 23 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> > index 2adc228..fa41ed1 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> > @@ -1339,7 +1339,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
> >  				lq_sta->search_better_tbl = 1;
> >  				goto out;
> >  			}
> > -
> > +			break;
> >  		case IWL_LEGACY_SWITCH_SISO:
> >  			IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
> >  
> > @@ -1425,9 +1425,9 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
> >  				lq_sta->search_better_tbl = 1;
> >  				goto out;
> >  			}
> > -
> > +			break;
> >  		case IWL_SISO_SWITCH_MIMO2:
> > -			IWL_DEBUG_RATE("LQ: SISO switch to MIMO\n");
> > +			IWL_DEBUG_RATE("LQ: SISO switch to MIMO2\n");
> >  			memcpy(search_tbl, tbl, sz);
> >  			search_tbl->is_SGI = 0;
> >  			search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
> 
> These hunks don't apply to wireless-2.6.

Oops, please ignore these hunks.

Thanks,
-yi

