Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53119 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0CXWjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 18:39:23 -0400
Date: Wed, 24 Mar 2010 18:37:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: fix build error for CONFIG_IWLAGN=n
Message-ID: <20100324223719.GA32563@tuxdriver.com>
References: <4BAA73D2.1000301@oracle.com>
 <1269465799-19060-1-git-send-email-linville@tuxdriver.com>
 <1269466426.6935.8.camel@jlt3.sipsolutions.net>
 <1269466948.2446.3216.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1269466948.2446.3216.camel@rchatre-DESK>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 24, 2010 at 02:42:28PM -0700, reinette chatre wrote:
> On Wed, 2010-03-24 at 14:33 -0700, Johannes Berg wrote:
> > On Wed, 2010-03-24 at 17:23 -0400, John W. Linville wrote:
> > > drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_good_ack_health':
> > > drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: 'struct iwl_priv' has no member named '_agn'
> > > 
> > > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > > ---
> > >  drivers/net/wireless/iwlwifi/iwl-rx.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> > > index b6a64d8..2fa30df 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> > > @@ -621,6 +621,7 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
> > >  #define BA_TIMEOUT_CNT (5)
> > >  #define BA_TIMEOUT_MAX (16)
> > >  
> > > +#if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
> > >  /**
> > >   * iwl_good_ack_health - checks for ACK count ratios, BA timeout
> > > retries.
> > 
> > I thought we had a patch moving it?
> > 
> 
> We do, but it has not been pushed upstream yet. 
> 
> John, I'd prefer
> http://viggo.jf.intel.com/~wifi/repos.git/?p=iwlwifi-2.6.git;a=commit;h=bc745eb7d28285f3b437c00253bf01ef501eb3f1 
> 
> Should we push it upstream asap or can it wait until our next series
> goes out after all our validation cycles pass?

I can't see that link.  How does the patch differ?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
