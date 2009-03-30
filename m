Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44301 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257AbZC3Jzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 05:55:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] rfkill: rewrite
Date: Mon, 30 Mar 2009 11:54:09 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@opfer-online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
References: <1238349195.24972.5.camel@johannes.local> <1238403987.24972.14.camel@johannes.local>
In-Reply-To: <1238403987.24972.14.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903301154.10067.mb@bu3sch.de> (sfid-20090330_115542_001932_2A670424)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 March 2009 11:06:27 Johannes Berg wrote:
> On Sun, 2009-03-29 at 19:53 +0200, Johannes Berg wrote:
> > This patch completely rewrites the rfkill core to address
> > the following deficiencies:
> > 
> >  * all rfkill drivers need to implement polling where necessary
> >    rather than having one central implementation
> 
> One thing I was wondering about -- should we just implement polling via
> a single work struct that iterates all those rfkill drivers that need
> polling? I've given them each an own right now, but that seems
> unnecessary.

If it doesn't add new locking problems (global locks, etc...) that'd be OK.

-- 
Greetings, Michael.
