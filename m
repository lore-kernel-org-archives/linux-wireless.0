Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55448 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767AbZKFUpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 15:45:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Martin Fuzzey <mfuzzey@gmail.com>
Subject: Re: b43: firmware loading problem and sleeping BUG
Date: Fri, 6 Nov 2009 21:45:12 +0100
Cc: linux-wireless@vger.kernel.org
References: <ba4215e10911060819y1175e003g695281fe084e07ab@mail.gmail.com> <ba4215e10911061027t413d2c34g8ad66a7982f7c43c@mail.gmail.com> <200911062008.06159.mb@bu3sch.de>
In-Reply-To: <200911062008.06159.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911062145.14448.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 20:08:04 Michael Buesch wrote:
> On Friday 06 November 2009 19:27:17 Martin Fuzzey wrote:
> > > I think this is easy to fix, because we can replace the spinlock by a mutex, as
> > > the b43 driver (which is the only user of the code) always allows sleeping now.
> > > I'll send a patch for testing soon.
> > >
> > Great - happy to test it.
> 
> There you go.

This doesn't actually work, because the lowlevel interrupt handler is atomic on PCMCIA.
So scratch that patch, it will just oops your machine.

-- 
Greetings, Michael.
