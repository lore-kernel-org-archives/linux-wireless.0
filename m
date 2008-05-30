Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:47735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYE3XEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 19:04:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend vs. b43
Date: Sat, 31 May 2008 01:05:24 +0200
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212150713.4117.2.camel@johannes.berg> <200805310049.41782.rjw@sisk.pl> <1212188073.20421.5.camel@johannes.berg>
In-Reply-To: <1212188073.20421.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805310105.24781.rjw@sisk.pl> (sfid-20080531_010446_018262_D39DFAAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 31 of May 2008, Johannes Berg wrote:
> On Sat, 2008-05-31 at 00:49 +0200, Rafael J. Wysocki wrote:
> > On Saturday, 31 of May 2008, Johannes Berg wrote:
> > > 
> > > > It hangs for me either at read_unlock_irqrestore() in b43_op_tx() or somewhere
> > > > in ieee80211_tx() (at various places).
> > > 
> > > Huh. Why is it even getting into the tx path? And even then, why does it
> > > hang at an unlock?
> > 
> > Well, I saw that during hibernation, so it probably happened after creating the
> > image, when devices were being resumed for image saving.
> 
> Yeah, like I said earlier to somebody. Still doesn't make much sense
> here. I'll play with it next week, or you could try to put into
> suspend() a call to ieee80211_stop_queues() and in resume
> ieee80211_wake_queues(), maybe that fixes it? I probably won't have time
> over the weekend to look more into it, sorry.

No big deal. :-)

It's always been breaking for me like this ...

Thanks,
Rafael
