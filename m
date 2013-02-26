Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3BZTNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 14:13:51 -0500
Date: Tue, 26 Feb 2013 13:13:47 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Fabio Rossi <rossi.f@inwind.it>, linux-wireless@vger.kernel.org
Subject: Re: regression with kernel 3.8
Message-ID: <20130226191347.GB19077@thinkpad-t410> (sfid-20130226_201356_511419_D975088C)
References: <11214452.15864921361816296422.JavaMail.defaultUser@defaultHost>
 <20130225192629.GH13296@thinkpad-t410>
 <1361831918.9192.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361831918.9192.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 25, 2013 at 11:38:38PM +0100, Johannes Berg wrote:
> On Mon, 2013-02-25 at 13:26 -0600, Seth Forshee wrote:
> > On Mon, Feb 25, 2013 at 07:18:16PM +0100, Fabio Rossi wrote:
> > > I'm using the latest wireless-testing.git and I have found a regression with 
> > > kernel 3.8. I don't know if this is related to the driver I'm using (ath5k) but 
> > > I have bisected the problem to the commit 
> > > 6c17b77b67587b9f9e3070fb89fe98cef3187131 (mac80211: Fix tx queue handling 
> > > during scans). Basically the authentication and association infos don't appear 
> > > anymore in the kernel logs during a connection to my access point.
> > > 
> > > Tell me what you need to further debug the issue and solve the problem.
> > 
> > That patch is after 3.8.
> > 
> > Johannes, this looks like a problem with the changes you made when
> > applying that patch. I really should have tested the result before now.
> 
> Hmm, crap. Sorry about that!
> 
> > I think the off-channel frames are getting queued rather than passed
> > down to the driver, which obviously isn't what we want. I'll get this
> > fixed.
> 
> I saw you posted it, I'll take a closer look tomorrow morning.

Have you had a chance to look at the patch yet? I think we ought to try
and get this fixed pretty quickly.

Seth

