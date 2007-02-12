Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:50641 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbXBLEkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 23:40:49 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HGSyS-00016j-9E
	for linux-wireless@vger.kernel.org; Sun, 11 Feb 2007 23:39:32 -0500
Subject: Re: [PATCH] d80211: Fix wireless statistics reporting
From: Pavel Roskin <proski@gnu.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200702112329.21901.flamingice@sourmilk.net>
References: <200702112209.46093.flamingice@sourmilk.net>
	 <1171253350.27742.17.camel@dv> <200702112329.21901.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sun, 11 Feb 2007 23:40:46 -0500
Message-Id: <1171255246.28458.22.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-02-11 at 23:29 -0500, Michael Wu wrote:
> On Sunday 11 February 2007 23:09, Pavel Roskin wrote:
> > > -	int signal;
> > > +	int signal; /* used as qual in statistics reporting */
> >
> > I'm sorry but that the thing I have always hated about wireless
> > extensions.  Such tricks make the API context sensitive and loaded with
> > assumptions.
> >
> Ok, but I was merely clarifying the current situation. That problem has always 
> been there since the patch for statistics reporting went in.

Sorry, I should have made it clear that my post was more a reaction to
the comments than to the actual code changes.

> > I understand d80211 still has to interact with Wireless Extensions, but
> > let's not make things even worse.
> I'm making things better. Statistics reporting is pretty bad right now in 
> d80211 with drivers reporting bogus values when they don't know, and 
> statistics reporting of different d80211 drivers interacting with each other 
> when multiple devices are plugged in. This patch attempts to fix the worst 
> issues while attempting to avoid regressions. Feel free to follow up with 
> another patch to make statistics reporting perfect.

This effort is very much appreciated.  I'll have a closer look if I see
any issues after your patch is applied.

-- 
Regards,
Pavel Roskin

