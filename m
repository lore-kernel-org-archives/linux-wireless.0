Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:65256 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXCWR7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 13:59:49 -0400
Date: Fri, 23 Mar 2007 10:57:47 -0700
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323175747.GA4915@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1174640787.3588.65.camel@johannes.berg> <1174665384.4470.0.camel@johannes.berg> <20070323161339.GA4713@bougret.hpl.hp.com> <200703231753.31485.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200703231753.31485.mb@bu3sch.de>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2007 at 05:53:31PM +0100, Michael Buesch wrote:
> On Friday 23 March 2007 17:13, Jean Tourrilhes wrote:
> > value. It seems that it's too late for the next release of Debian or
> > Fedora,
> 
> Wtf? It's too late for a security fix?
> How can it be too late for a security fix?

	Note that I was making a prediction. We'll see if I'm right.

	Let's not make blanket statements like this about security,
security is all about level of risk, there are various level of
"security issues" and you need to assign the proper level to this one.
	One one hand of the scale you have issues that allow remote
penetration. Those require immediate attention.
	On the other end of the scale you have random information
leaks. Those are clearly important, but clearly not in the same
category. They don't allow remote penetration. They don't allow
priviledge escalation. They don't allow denial of service. The 4 bytes
leaked are comming from mostly random allocated buffers. The potential
of exploitation is very limited.

	Both the Debian release and Fedora release are well into their
respective freeze. In particular, the Debian kernel is frozen and
won't change until release. With the amount of issues and open bugs
those kernel packagers have, everything is prioritised, and many
things in their queue tend to be ignored.
	The priority those maintainers will assign to this issue will
mostly go along the lines outlined above. Risk of changes and
potential regression versus risk of attack.
	This is why I made this prediction.

> Greetings Michael.

	Jean
