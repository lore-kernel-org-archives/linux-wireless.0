Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp146.iad.emailsrvr.com ([207.97.245.146]:40954 "EHLO
	smtp146.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbXGBCLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2007 22:11:17 -0400
Message-ID: <46885E74.8000501@gentoo.org>
Date: Sun, 01 Jul 2007 22:09:56 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Ulrich Kunitz <kune@deine-taler.de>,
	Joerg Mayer <jmayer@loplof.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: basic regulatory domain support
References: <20070701163907.39B6B7B409F@zog.reactivated.net> <20070701203238.GE8218@thot.informatik.uni-kl.de> <20070701213515.GA6829@deine-taler.de> <200707020015.32480.mb@bu3sch.de>
In-Reply-To: <200707020015.32480.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Which registers do control power and where are they written?

We don't know - we program the vendor driver with the default map that 
the vendor driver supplies, based on RF type. e.g. see zd_rf_al2230.c 
zd1211_al2230_init_hw()

The vendor driver does do some kind of TX power calibration, but it is 
not in absolute terms. Instead it is done in increments based on the 
current level. So, if we studied the vendor driver enough we might be 
able to figure out how to make the TX frames be transmitted with 
slightly higher or lower power, but there's no way we'd be able to TX at 
  a specific strength measured in dBm. (the long term plan is to port 
such functionality over from the vendor driver, but there are also many 
other items on the list)

I do not recall the vendor driver imposing any TX power restrictions 
based on regulatory domain, which is the discussion at hand. So, I don't 
think we'll be implementing regdomain-based TX power restrictions in 
zd1211rw. That said, patches considered, if someone does manage to 
figure it out :)

Daniel

