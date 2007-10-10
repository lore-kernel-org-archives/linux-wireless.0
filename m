Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27971 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXJJHYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 03:24:21 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 2] libertas: fixes for slow hardware
Date: Wed, 10 Oct 2007 09:24:11 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200710081118.27468.hs4233@mail.mn-solutions.de> <200710091041.57159.hs4233@mail.mn-solutions.de> <20071009211822.GA3175@tuxdriver.com>
In-Reply-To: <20071009211822.GA3175@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710100924.11565.hs4233@mail.mn-solutions.de> (sfid-20071010_082427_210259_30CF1880)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > @@ -148,11 +148,11 @@ static int
> > if_cs_poll_while_fw_download( {
> >  	int i;
> >
> > -	for (i = 0; i < 500; i++) {
> > +	for (i = 0; i < 1000; i++) {
> >  		u8 val = if_cs_read8(card, addr);
> >  		if (val == reg)
> >  			return i;
> > -		udelay(100);
> > +		udelay(500);
> >  	}
> >  	return -ETIME;
> >  }
>
> 10x the maximum delay?  Is this really necessary?
>
> How did you determine this was needed?

For my hardware, it was not necessary. My CF card worked with the 
old settings.

The documentation, in 2.2.1.2 "CF Interface" says at point 3. a)

   "The host polls this for 50 ms before declaring a failure on
   the particular block of firmware being downloaded".

Some lines below, in the section about the real firmware (the 
former citation was from the section about the helper firmware), 
it just says in "8.", after polling card status register:

   "The is no definite time period that the host polls this bit
   before declaring a failure on this particular block of
   firmware".

and in "9.", after card configuration and scratch port register:

   "The host polls this 50ms before declaring a failure ..."

So, two times it's 50ms, once it's unspecified.





For me 50ms worked in all cases (my hardware actually reacts in 
way less than 50 millisends). 

However, Vitaly sent this patch, he had hardware where the 
firmware download was failing with the original approach and 
where it was necessary to make those values larger. I'm actually 
don't know in which of the three cases it failed for him. But 
this code piece isn't so time critical:

* the routine will only called during firmware download, not for 
normal operation. Especially not when sending commands, 
receiving responses or sending/receiving packets

* for my hardware, I never reach the upper ceilings, the routine 
routines always way faster.

This are my findings how often it spun loops in 
if_cs_poll_while_fw_download():

* While programming the helper firmware: 10 * 1 loop
* While programming the real firmware, 1 * 0 loop, 363 * 1 loop
* While waiting for the expected value in the scratch pad 
register: 88 loops

With the original code:

* While programming the helper firmware: 8 * 3 loops, 2 * 1 loop
* While programming the real firmware: 1 * 0 loop, 363 * 1 loop
* While waiting for the expected value in the scratch pad 
register: 434 loops



> If it really is necessary, you need to change the "The host
> polls the Card Status register for 50 ms..." comment in
> if_cs_prog_helper as well.

As this is an excerpt from the docs, I don't want to change this 
arbitrary.

My problem is that I don't have the hardware that failed with the 
original code. If I would have this hardware, I would have 
changed if_cs_poll_while_fw_download() so that I could specify 
the amount of time it should wait. Or so that I can change the 
number of loops it should wait.
