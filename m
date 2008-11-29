Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39311 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYK2MPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 07:15:04 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: add power state transition callbacks
Date: Sat, 29 Nov 2008 13:15:01 +0100
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
References: <200811282345.48379.chunkeey@web.de> <1227951709.3542.1.camel@johannes.berg>
In-Reply-To: <1227951709.3542.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811291315.01685.chunkeey@web.de> (sfid-20081129_131520_951372_3391A224)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 November 2008 10:41:49 Johannes Berg wrote:
> On Fri, 2008-11-28 at 23:45 +0100, Christian Lamparter wrote:
> 
> >  /**
> >   * enum sta_notify_cmd - sta notify command
> >   *
> > - * Used with the sta_notify() callback in &struct ieee80211_ops, this
> > - * indicates addition and removal of a station to station table.
> > + * Used with the sta_notify() callback in &struct ieee80211_ops.
> > + * this command indicates addition and removal of a station to
> > + * station table, or if a station made a power state transition.
> >   *
> >   * @STA_NOTIFY_ADD: a station was added to the station table
> >   * @STA_NOTIFY_REMOVE: a station being removed from the station table
> > + * @STA_NOTIFY_SLEEP: a station is now sleeping
> > + * @STA_NOTIFY_AWAKE: a sleeping station woke up
> >   */
> >  enum sta_notify_cmd {
> > -	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
> > +	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
> > +	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
> >  };
> 
> You know, I'm sorry, but I've come to realise that adding it to
> sta_notify isn't a good idea after all. The one thing I forgot is that
> this new callback has to be atomic because it's called from the rx path,
> and sta_notify doesn't have to be.
> 
> Unless we want to defer RX packet processing to a workqueue rather than
> a tasklet?
> 
Hmm, but if we put the RX packet processing into a workqueue, we have to
put the tx status report processing in one too (see comment about rx/tx race
in main.c line 400)?

Or do you mean I should only put ap_sta_ps_end  (& ap_sta_ps_start) 
resending stuff into a workqueue? (Yeah, this makes a lot more sense,
and might actually work!, well let's prepare another patch)

Regards,
	Chr
