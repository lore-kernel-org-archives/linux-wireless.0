Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37610 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1CBHcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 02:32:36 -0500
Received: by fxm17 with SMTP id 17so5623081fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 23:32:35 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 4/9] [cfg80211] add preliminary radar processing code
Date: Wed, 2 Mar 2011 08:32:16 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"dubowoj@neratec.com" <dubowoj@neratec.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"simon.wunderlich@saxnet.de" <simon.wunderlich@saxnet.de>
References: <201102281740.37036.bernhard.schmidt@saxnet.de> <201102281748.50054.bernhard.schmidt@saxnet.de> <20110301215856.GF6835@tux>
In-Reply-To: <20110301215856.GF6835@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103020832.17550.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 01, 2011 22:58:56 Luis R. Rodriguez wrote:
> On Mon, Feb 28, 2011 at 08:48:49AM -0800, Bernhard Schmidt wrote:
> > --- /dev/null
> > +++ b/net/wireless/radar.c
> > @@ -0,0 +1,86 @@
> > +/*
> > + * Radar handling
> > + *
> > + * Copyright 2011 Bernhard Schmidt <bernhard.schmidt@saxnet.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/ieee80211.h>
> > +#include <net/cfg80211.h>
> > +#include "radar.h"
> > +
> > +static struct radar_parameters regdomain_params[] = {
> > +	{ 60, 1800, 1000 },	/* FCC, correct? */
> > +	{ 60, 1800, 1000 },	/* ETSI */
> > +	{ 60, 1800, 1000 },	/* JP, correct? */
> > +};
> 
> If FCC or JP are not supported, I rather code not be present for it, or some
> sort of flag for now to allow the radar enablement thingy to fail all the
> time. In fact if FCC / JP regions are not supported you should not even
> be able to operate in the mode of operation desired if your target channel
> is a DFS one. If you do enter into an allowed non-DFS channel for that region
> and you later try to switch to a DFS chanel then we'd hit another failure.

That just means that I hadn't yet looked up the correct values, those
are not available on the wiki either.

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
