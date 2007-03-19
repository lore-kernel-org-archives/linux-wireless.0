Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49577 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXCSOYt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 10:24:49 -0400
Subject: Re: wireless chipsets not supported by current wireless tree
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703190847.31321.hs4233@mail.mn-solutions.de>
References: <20070316224417.792d77d6@oldman>
	 <20070316225727.d3327d7a.rdunlap@xenotime.net>
	 <200703190847.31321.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 10:27:01 -0400
Message-Id: <1174314421.10751.8.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-03-19 at 08:47 +0100, Holger Schurig wrote:
> > Is there a chance of or anyone already working on Marvell
> > (non-OLPC) support, e.g., for one of these?
> >
> > 00:09.0 Ethernet controller: Marvell Technology Group Ltd.
> > 88w8335 [Libertas] 802.11b/g Wireless (rev 03)

That chip has some significant differences to the 838x line that the
OLPC and others are using.  I'm not sure we can support that chipset in
the same driver, unless its firmware interface is quite similar.

> Yes, there is someone working there. A bunch of my patches to 
> shape the OLPC driver in a way libertas_lib.ko, libertas_usb.ko, 

small note: I'd rather have the bus-independent part be called
"libertas.ko" rather than _lib.

> libertas_cs.ko got already applied. I made some experiments with 
> firmware download, David Anders wrote a fwcutter and so on.
> 
> I once created a project 
> http://projects.linuxtogo.org/projects/marvell8385/, but most of 
> the discussion happend now in the OLPC Marvell mailing list. 
> From time to time we're also on #libertas on *.freenode.net.

The list and channel aren't supposed to be OLPC specific, really, hence
the generic "libertas-dev" name and such.  Since you're around, it's no
longer only OLPC people happening to work on the driver, and that's the
way it should be.

> Nothing works yet, and I got (and will get) distracted because my 
> company switched to SAP Business One and I'm mostly busy 
> extracting data out of our old system and putting that into 
> SAPB1 :-(  Maybe I have again time this week.

Great.  Let's make the driver Not Suck :)

Dan


