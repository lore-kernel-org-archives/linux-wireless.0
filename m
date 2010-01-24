Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35890 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0AXLwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 06:52:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: hwtkip hangs on b43
Date: Sun, 24 Jan 2010 12:52:30 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <201001241245.17176.mb@bu3sch.de> <1264333672.23766.26.camel@johannes.local>
In-Reply-To: <1264333672.23766.26.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001241252.32209.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 January 2010 12:47:52 Johannes Berg wrote:
> On Sun, 2010-01-24 at 12:45 +0100, Michael Buesch wrote:
> > On Sunday 24 January 2010 12:32:50 Johannes Berg wrote:
> > > > >>> We can just remove the lock and add a comment explaining why it is not locked...
> > > 
> > > Mind you, it won't work on SDIO hardware since the callback cannot
> > > sleep, contrary to what Kalle documented :(
> > 
> > I don't understand. Why wouldn't SDIO be allowed to sleep?
> 
> Because this is called within the RX path code which does
> rcu_read_lock() around it.

Ok, I see. I can live with that, because tkip hwcrypto defaults to off.

> Really, somebody just needs to go and add key TODO in mac80211 to pick
> up phase1 key changes and update them in the driver, that gets rid of
> all the locking and atomic problems.

Too bad I don't understand all that tkip key handling stuff. :)

-- 
Greetings, Michael.
