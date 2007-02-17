Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:51514 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932754AbXBQS6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 13:58:08 -0500
Message-ID: <20070217135805.zfkg8kokc4s4owgg@webmail.spamcop.net>
Date: Sat, 17 Feb 2007 13:58:05 -0500
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: More breakage in wireless-dev.git
References: <1171690868.31103.17.camel@dv>
	<200702171914.06802.mb@bu3sch.de>
	<20070217132614.zfbt6sckkogosss8@webmail.spamcop.net>
	<200702171930.10830.mb@bu3sch.de>
In-Reply-To: <200702171930.10830.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Michael Buesch <mb@bu3sch.de>:

> Uh, why? I thought it is just an optimization and
> git walks the tree, if the server info is not updated.
>
> But I ran it manually now.

The driver is working now!

As for git, I think all you need to make hooks/post-update executable, since it
already has the right command in it.

The problem is that git-fetch trusts refs/info instead of making individual
requests to refs/branches/*.  Git needs to request refs/info anyway because it
never relies on the ability to request and parse http directory listings.  And
since refs/info already has the branch heads, why request more files?

I know, this sounds weird.  It must be caused by the git developers' attitude
towards http as a dumb protocol.

--
Regards,
Pavel Roskin
