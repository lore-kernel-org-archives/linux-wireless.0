Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147AbYDCD20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 23:28:26 -0400
Subject: Re: [RFC] libertas: convert libertas driver to use an
	event/cmdresp queue
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1207191923.9250.6.camel@localhost.localdomain>
References: <200803271700.58477.hs4233@mail.mn-solutions.de>
	 <1206722403.3392.9.camel@localhost.localdomain>
	 <200804011439.54618.hs4233@mail.mn-solutions.de>
	 <1207191923.9250.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 23:26:46 -0400
Message-Id: <1207193206.9435.0.camel@localhost.localdomain> (sfid-20080403_042829_804189_1FB71FC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-02 at 23:05 -0400, Dan Williams wrote:
> On Tue, 2008-04-01 at 14:39 +0200, Holger Schurig wrote:
> > > It's been tested lightly on USB, SDIO, and CF.  I'd like wider
> > > testing on CF as this patch causes SSH transfers to stall
> > > (only on CF!)
> > 
> > I've modified if_cs.c somewhat and did
> > 
> > $ scp inkscape inkview emacs-snapshot-x mtn \
> >   emacs-snapshot-nox pgadmin3 quanta gs-gpl \
> >   root@10.2.1.4:/tmp
> > inkscape           100% 5856KB 650.7KB/s   00:09
> > inkview            100% 5853KB 585.3KB/s   00:10
> > emacs-snapshot-x   100% 5333KB 666.6KB/s   00:08
> > mtn                100% 5263KB 657.9KB/s   00:08
> > emacs-snapshot-nox 100% 4913KB 614.1KB/s   00:08
> > pgadmin3           100% 3925KB 654.2KB/s   00:06
> > quanta             100% 3597KB 719.5KB/s   00:05
> > gs-gpl             100% 3597KB 599.4KB/s   00:06
> > 
> > I didn't notice any stall so far.  What test did you make?
> 
> Just tried a 300MB scp; got up to 37MB @ 715KB/s and then stalled.  I
> think my card is somehow "special" or the controller sucks (Ricoh
> RL5c476 II) or something.  I'll try to find another machine with a CF
> slot.  No amount of ifconfig or iwconfig magic will help it, the card
> accepts a TX packet with if_cs_send_data() and then apparently never
> sends an interrupt to say the TX is done.  The driver then does the RSSI
> thing to poke the firmware, which of course times out, and then all is
> lost.
> 
> Maybe I have dodgy firmware?  Can you point me to some known working
> stuff?

I'm running 5.0.16.p0 BTW.

Dan


