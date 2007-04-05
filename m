Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cvs.openbsd.org ([199.185.137.3]:37969 "EHLO cvs.openbsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767323AbXDEV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 17:26:31 -0400
Message-Id: <200704052123.l35LNLjr001630@cvs.openbsd.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: "Pavel Roskin" <proski@gnu.org>, "Michael Buesch" <mb@bu3sch.de>,
	"Joseph Jezak" <josejx@gentoo.org>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Marcus Glocker" <mglocker@openbsd.org>,
	"Jon Simola" <jsimola@gmail.com>,
	"Theo de Raadt" <deraadt@theos.com>,
	"Martin Langer" <martin-langer@gmx.de>,
	"Danny van Dyk" <kugelfang@gentoo.org>,
	"Andreas Jaggi" <andreas.jaggi@waterwave.ch>,
	"Larry Finger" <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	"Greg kh" <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues 
In-reply-to: Your message of "Thu, 05 Apr 2007 15:57:33 EDT."
             <43e72e890704051257n1ae26c64k3e05614bea843729@mail.gmail.com>
Date: Thu, 05 Apr 2007 15:23:21 -0600
From: Theo de Raadt <deraadt@cvs.openbsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Please understand that the fact that Linux is under the GPL prohibits
> us from accepting purely BSD licensed code, it's not Linus' decision
> -- that is just the way the license works.

Just to make it clear to anyone that this is not the way the GPL
works, I want to point you all to a little known directory called

	binutils/gprof/

This contains files like i386.c which starts as you can see below.

So you can see that the GPL does not prohibit mixing GPL'd files and
3-term BSD licenses.  Who prohibits it?  Linus.  Or someone near him,
with an agenda.  It is a policy decision.  So waving around the GPL
and saying things like you do above, in bad faith, is not cool.

If you go grep for 'Regents' through other FSF source distributions
you can find many more 3-term BSD licensed code all over the place.
So don't lie to us Luis, pretty please?  If 3-term BSD is good enough
for the the FSF, then we can justly come to the conclusion that this
"no BSD code in Linux" problem is in fact just Linus' decision.

---
/*
 * Copyright (c) 1983, 1993, 2001
 *      The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
#include "gprof.h"
#include "search_list.h"
#include "source.h"
#include "symtab.h"
#include "cg_arcs.h"
#include "corefile.h"
#include "hist.h"

static int i386_iscall PARAMS ((unsigned char *));
void i386_find_call PARAMS ((Sym *, bfd_vma, bfd_vma));

static int
i386_iscall (ip)
...
