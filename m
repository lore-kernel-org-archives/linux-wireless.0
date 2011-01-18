Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60078 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1ARMBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:01:47 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7110367fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 04:01:46 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/5] mac80211: add primarily CAC support
Date: Tue, 18 Jan 2011 13:01:44 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201101171621.29863.bernhard.schmidt@saxnet.de> <20110117161133.8150D2084@mx.techwires.net> <1295347515.3563.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295347515.3563.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101181301.45021.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 18, 2011 11:45:15 Johannes Berg wrote:
> On Mon, 2011-01-17 at 11:24 +0100, Bernhard Schmidt wrote:
> > ---
> > 
> >  net/mac80211/radar.c |   65
> >  ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  net/mac80211/radar.h |    4 +++
> >  2 files changed, 69 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/radar.c b/net/mac80211/radar.c
> > index e90b8bf..afb2ae1 100644
> > --- a/net/mac80211/radar.c
> > +++ b/net/mac80211/radar.c
> > @@ -15,6 +15,66 @@
> > 
> >  #include "driver-ops.h"
> >  #include "radar.h"
> > 
> > +static void cac_timer(unsigned long data)
> > +{
> > +	struct ieee80211_local *local = (void *) data;
> > +	struct ieee80211_radar *radar = &local->radar;
> > +	struct ieee80211_channel *chan;
> > +
> > +	printk(KERN_INFO "CAC done\n");
> > +
> > +	chan = local->oper_channel;
> > +	mutex_lock(&radar->mtx);
> 
> Clearly, you haven't even tested this code. I'm not sure why I'm even
> reviewing it.

Granted, I did only some basic tests with only a few predefined 
scenarios, not at all is just wrong. Anyways, I should have mentioned in 
0/13 that preventing channel changes while in CAC should be considered 
and chan should be assigned to local variable then.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
