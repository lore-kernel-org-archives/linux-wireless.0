Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53958 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0F2Up0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 16:45:26 -0400
Date: Tue, 29 Jun 2010 16:32:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: do not export iwl_leds_background
Message-ID: <20100629203239.GE5296@tuxdriver.com>
References: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
 <1277840378-18305-1-git-send-email-linville@tuxdriver.com>
 <1277842739.4197.54.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1277842739.4197.54.camel@rchatre-DESK>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 29, 2010 at 01:18:59PM -0700, reinette chatre wrote:
> On Tue, 2010-06-29 at 12:39 -0700, John W. Linville wrote:
> > It is only used from within the iwlcore module.
> > 
> > Reported-by: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-led.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
> > index db5bfcb..486244b 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-led.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
> > @@ -214,7 +214,6 @@ void iwl_leds_background(struct iwl_priv *priv)
> >  	priv->last_blink_time = jiffies;
> >  	priv->last_blink_rate = blink_idx;
> >  }
> > -EXPORT_SYMBOL(iwl_leds_background);
> >  
> >  void iwl_leds_init(struct iwl_priv *priv)
> >  {
> 
> Nack.
> 
> Please take a closer look at how it is used ... it is used in iwl-core.h
> in an inline (iwl_update_stats) function that is used by both iwlagn and
> iwl3945.

OK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
