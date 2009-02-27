Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43412 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbZB0Isj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 03:48:39 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 00:48:38 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18855.43002.100899.931613@gargle.gargle.HOWL> (sfid-20090227_094851_036127_025D664A)
Date: Fri, 27 Feb 2009 14:14:42 +0530
To: Alina Friedrichsen <x-alina@gmx.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: IBSS issues
In-Reply-To: <20090227082545.291220@gmx.net>
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	<20090227082545.291220@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alina Friedrichsen wrote:
> > Scenario:
> >
> >  * Create a new cell using ath9k.
> >  * Wait for a while to do a background merge scan run.
> >  * Join the cell from another peer ( say, using ath5k ).
> >  * Station dump in peer1 1 doesn't show the new peer right away.
> >  * The merge runs are not supposed to happen if a cell has more than one
> > peer.
> >    It didn't happen before, but it keeps running repeatedly now.
> >  * Ping from peer2 to peer1 doesn't go through - peer1 to peer2 works
> > though.
> 
> The strange thing is after the ping from peer1 to peer2, the ping from peer2 to peer1 works too.
> The same is if I start tcpdump on peer1. After stopping tcpdump it keeps working. Looking...
> 

Yep. It works after the ping from peer1 to peer2.

> > I identified one bug, where the timestamp in the beacon template was not
> > updated.
> > Patch below. But it doesn't fix the issue.
> 
> The TSF of the beacon is setted by the hardware automatically, so to write it in the template is not needed.

When peer2 joins the cell, the next TBTT is calculated based on the received beacon's
timestamp. And since the TSF is reset in __ieee80211_sta_join_ibss(), to program
the TBTT timers, the timestamp is needed.

Sujith
