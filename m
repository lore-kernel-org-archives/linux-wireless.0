Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759877Ab3BYWil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 17:38:41 -0500
Message-ID: <1361831918.9192.1.camel@jlt4.sipsolutions.net> (sfid-20130225_233847_074612_15E5A2EA)
Subject: Re: regression with kernel 3.8
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Fabio Rossi <rossi.f@inwind.it>, linux-wireless@vger.kernel.org
Date: Mon, 25 Feb 2013 23:38:38 +0100
In-Reply-To: <20130225192629.GH13296@thinkpad-t410>
References: <11214452.15864921361816296422.JavaMail.defaultUser@defaultHost>
	 <20130225192629.GH13296@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 13:26 -0600, Seth Forshee wrote:
> On Mon, Feb 25, 2013 at 07:18:16PM +0100, Fabio Rossi wrote:
> > I'm using the latest wireless-testing.git and I have found a regression with 
> > kernel 3.8. I don't know if this is related to the driver I'm using (ath5k) but 
> > I have bisected the problem to the commit 
> > 6c17b77b67587b9f9e3070fb89fe98cef3187131 (mac80211: Fix tx queue handling 
> > during scans). Basically the authentication and association infos don't appear 
> > anymore in the kernel logs during a connection to my access point.
> > 
> > Tell me what you need to further debug the issue and solve the problem.
> 
> That patch is after 3.8.
> 
> Johannes, this looks like a problem with the changes you made when
> applying that patch. I really should have tested the result before now.

Hmm, crap. Sorry about that!

> I think the off-channel frames are getting queued rather than passed
> down to the driver, which obviously isn't what we want. I'll get this
> fixed.

I saw you posted it, I'll take a closer look tomorrow morning.

johannes

