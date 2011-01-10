Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1AJTpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 14:45:09 -0500
Subject: Re: cfg80211 rfkill interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F059529@SJEXCHCCR02.corp.ad.broadcom.com>
References: <400C43189542CE41BC0A5B252FC90136952F059529@SJEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 20:45:09 +0100
Message-ID: <1294688709.3583.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> I am looking into implementing rfkill into our brcm80211 open-source
> driver. Our driver detects disable switch by an interrupt, but
> switching back does not give an interrupt. 

Interesting, but I guess it makes some sense.

> For the latter I wanted to use the rfkill_poll callback and
> wiphy_rfkill_start_polling.

Right, makes sense.

> However, I tried a wiphy_rfkill_stop_polling in the rfkill_poll
> callback when rf is unblocked, and this resulted in a system hang. 

Yeah, I'm not surprised. start_polling will work from anywhere, but
stop_polling needs to actually completely sync the poll stop so it can't
be done from within the poll or from within any rfkill callbacks.

> So I moved the wiphy_rfkill_stop_polling to the start callback. Does
> that make sense or is there another way you would recommend?

I think that makes sense.

However, where do you start polling? You have to poll even if the device
is not start()ed, I guess?

johannes

