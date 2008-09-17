Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46027 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbYIQO0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 10:26:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Wed, 17 Sep 2008 16:26:28 +0200
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
	bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48CFC03A.8020708@lwfinger.net> <200809162125.18978.mb@bu3sch.de> <20080916223729.GC26035@khazad-dum.debian.net>
In-Reply-To: <20080916223729.GC26035@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809171626.28782.mb@bu3sch.de> (sfid-20080917_162758_614360_F2F22414)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 September 2008 00:37:29 Henrique de Moraes Holschuh wrote:
> On Tue, 16 Sep 2008, Michael Buesch wrote:
> > But I don't know how to tell the rfkill subsystem about the states and
> 
> rfkill_force_state().  Must NOT be called from within atomic contextes,
> something I haven't got around to find a proper way of fixing, and nobody
> else seems to be on a rfkill coding frenzy right now.

That's a showstopper for us, as we have to change the state from
within an interrupt tasklet.

> I won't go on the rfkill-allocate/-free stuff, messing with that API means
> you need to fix a lot of other people's drivers.  But you have the
> rfkill-hw-state-changed now, it is called rfkill_force_state().  The only
> crap is that it cannot be called from atomic contexts.

Yeah well. I didn't know. I lost interest in rfkill pretty much when it
stopped blowing up (until it started again when somebody merged a patch
recently).

-- 
Greetings Michael.
