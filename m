Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7903C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABECA206DD
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfDCVrF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:47:05 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:62551 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfDCVrF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:47:05 -0400
Received: from 79.184.254.219.ipv4.supernova.orange.pl (79.184.254.219) (HELO aspire.rjw.lan)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.213)
 id ab1511dd5a381330; Wed, 3 Apr 2019 23:47:02 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        ath10k@lists.infradead.org, Todd Brandt <todd.e.brandt@intel.com>,
        linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Claire Chang <tientzu@google.com>
Subject: Re: [PATCH] ath10k: Drop WARN_ON()s that always trigger during system resume
Date:   Wed, 03 Apr 2019 23:44:55 +0200
Message-ID: <1645947.WPhbVaNX0l@aspire.rjw.lan>
In-Reply-To: <20190403195718.GA74723@google.com>
References: <2884043.Jv1Mn93hE8@aspire.rjw.lan> <20190403195718.GA74723@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wednesday, April 3, 2019 9:57:20 PM CEST Brian Norris wrote:
> + Sriram, Pradeep, Claire
> 
> On Sun, Mar 03, 2019 at 06:24:33PM +0100, Rafael J. Wysocki wrote:
> 
> Ooh, exactly 1 month ago!
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > ath10k_mac_vif_chan() always returns an error for the given vif
> > during system-wide resume which reliably triggers two WARN_ON()s
> > in ath10k_bss_info_changed() and they are not particularly
> > useful in that code path, so drop them.
> > 
> 
> Particularly, when WOWLAN isn't enabled, we get called during resume via
> ieee80211_reconfig(), where we're not associated and don't have any
> channel contexts. AFAICT, we shouldn't need to communicate anything in
> particular to the firmware here, and so failing the 'if' is definitely
> not worth WARN-ing about.
> 
> I'd love to see this get applied with:
> 
> Fixes: cd93b83ad927 ("ath10k: support for multicast rate control")
> Fixes: f279294e9ee2 ("ath10k: add support for configuring management packet rate")
> 
> and sent to stable. This has been bugging people since 4.19. Spurious
> WARN_ON()s can trigger reports to various crash trackers, and on some
> systems appear as user-visible warnings ("System problem detected").
> 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Brian Norris <briannorris@chromium.org>

Thanks Brian, appreciated!

I have been wondering whether or not I need to resend this patch or something ...

> > ---
> >  drivers/net/wireless/ath/ath10k/mac.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: linux-pm/drivers/net/wireless/ath/ath10k/mac.c
> > ===================================================================
> > --- linux-pm.orig/drivers/net/wireless/ath/ath10k/mac.c
> > +++ linux-pm/drivers/net/wireless/ath/ath10k/mac.c
> > @@ -5705,7 +5705,7 @@ static void ath10k_bss_info_changed(stru
> >  	}
> >  
> >  	if (changed & BSS_CHANGED_MCAST_RATE &&
> > -	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
> > +	    !ath10k_mac_vif_chan(arvif->vif, &def)) {
> >  		band = def.chan->band;
> >  		rateidx = vif->bss_conf.mcast_rate[band] - 1;
> >  
> > @@ -5743,7 +5743,7 @@ static void ath10k_bss_info_changed(stru
> >  	}
> >  
> >  	if (changed & BSS_CHANGED_BASIC_RATES) {
> > -		if (WARN_ON(ath10k_mac_vif_chan(vif, &def))) {
> > +		if (ath10k_mac_vif_chan(vif, &def)) {
> >  			mutex_unlock(&ar->conf_mutex);
> >  			return;
> >  		}
> > 
> 


