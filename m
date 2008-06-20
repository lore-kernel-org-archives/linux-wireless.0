Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:32896 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbYFTNpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 09:45:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 suspend gotchas
Date: Fri, 20 Jun 2008 15:45:08 +0200
Cc: linux-wireless@vger.kernel.org
References: <1213966018.8967.176.camel@johannes.berg> <200806201507.29030.mb@bu3sch.de> <1213968673.8967.178.camel@johannes.berg>
In-Reply-To: <1213968673.8967.178.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806201545.08267.mb@bu3sch.de> (sfid-20080620_154605_656664_D8596F11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 June 2008 15:31:13 Johannes Berg wrote:
> 
> > > This is not a hard problem to solve.
> > 
> > >  - suspend does, in this order (callback used):
> > >     * stop aggregation (ampdu_action)
> > >     * remove all keys (set_key)
> > >     * remove all STAs (sta_notify)
> > >     * remove all interfaces (remove_interface)
> > >     * stop the hardware (stop)
> > 
> > I think the hardware-stop should probably be done in the driver
> > suspend routine after the mac80211 notification and not by a mac80211 callback.
> > Otherwise this is going to get complicated wrt locking.
> 
> All of those callbacks potentially require locks, you really want to
> call them outside of any locked section in your ->resume and ->suspend
> handlers.

ops->stop is special wrt suspend.

-- 
Greetings Michael.
