Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3328 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYE3P2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 11:28:17 -0400
Date: Fri, 30 May 2008 11:04:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	Guy Cohen <guy.cohen@intel.com>
Subject: Re: [PATCH 2.6.26 1/3] iwlwifi: fix in-column rate scaling
Message-ID: <20080530150448.GA9490@tuxdriver.com> (sfid-20080530_172820_381035_30EEEBE7)
References: <1211858975-21424-1-git-send-email-yi.zhu@intel.com> <20080528202201.GC25770@tuxdriver.com> <1212026521.7814.276.camel@debian.sh.intel.com> <1ba2fa240805290005m171d8957kaedbbb42a7feb2de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240805290005m171d8957kaedbbb42a7feb2de@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 10:05:01AM +0300, Tomas Winkler wrote:
> On Thu, May 29, 2008 at 5:02 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> > On Wed, 2008-05-28 at 16:22 -0400, John W. Linville wrote:
> >> On Tue, May 27, 2008 at 11:29:33AM +0800, Zhu Yi wrote:
> >> > From: Guy Cohen <guy.cohen@intel.com>
> >> >
> >> > This patch fixes cases that the code raised or didn't decrease
> >> > the rate although the success ratio was not good.
> >> >
> >> > Signed-off-by: Guy Cohen <guy.cohen@intel.com>
> >> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> >> > ---
> >> >  drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   45 ++++++++++++++-------------
> >> >  1 files changed, 23 insertions(+), 22 deletions(-)
> >> >
> >> > diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> >> > index 2adc228..fa41ed1 100644
> >> > --- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> >> > +++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> >> > @@ -1339,7 +1339,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
> >> >                             lq_sta->search_better_tbl = 1;
> >> >                             goto out;
> >> >                     }
> >> > -
> >> > +                   break;
> >> >             case IWL_LEGACY_SWITCH_SISO:
> >> >                     IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
> >> >
> >> > @@ -1425,9 +1425,9 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
> >> >                             lq_sta->search_better_tbl = 1;
> >> >                             goto out;
> >> >                     }
> >> > -
> >> > +                   break;
> >> >             case IWL_SISO_SWITCH_MIMO2:
> >> > -                   IWL_DEBUG_RATE("LQ: SISO switch to MIMO\n");
> >> > +                   IWL_DEBUG_RATE("LQ: SISO switch to MIMO2\n");
> >> >                     memcpy(search_tbl, tbl, sz);
> >> >                     search_tbl->is_SGI = 0;
> >> >                     search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
> >>
> >> These hunks don't apply to wireless-2.6.
> >
> > Oops, please ignore these hunks.
> >
> 
> I think you've missed this one 'iwlwifi: don't switch to SGI if not
> supported by AP'
> This is actually real connectivity bug fix. Without this client will
> fail to talk to AP that doesn't support SGI and there are many of
> those.

That patch was not identified for 2.6.26, and it looks like it won't
apply to 2.6.26 either.

Back to the original patch, I can ignore the hunks in question and
send it to 2.6.26, but then we'll need a new patch to apply those
hunks for 2.6.27.  Or, I can just delay this one for 2.6.27...?

John
-- 
John W. Linville
linville@tuxdriver.com
