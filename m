Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61640 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaBINbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Feb 2014 08:31:19 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Petko Manolov <petkan@nucleusys.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: iwlwifi crash with 3.13
Date: Sun, 9 Feb 2014 13:31:14 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D645E3@HASMSX103.ger.corp.intel.com> (sfid-20140209_143122_674215_12AEEC21)
References: <20140123091659.GE9077@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com>
 <20140123123125.GA3424@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
 <20140123200045.GA4064@localhost> <52E17698.9070607@gmail.com>
 <20140123202142.GC4064@localhost> <20140207214054.GB7167@localhost>
 <52F67313.1030706@gmail.com> <20140209132653.GA8352@localhost>
In-Reply-To: <20140209132653.GA8352@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On 14-02-08 20:10:27, Emmanuel Grumbach wrote:
> >
> > There is no problem to be fixed. When I said that I found the issue, I
> > meant that you are using a NIC which is not supposed to work on 5GHz on
> these channels and this leads to the issues.
> 
> Right, wireless-N 7260 is not advertised as 5GHz card.  I just got over my
> laziness and searched the net.
> 
> > The fact that it doesn't work for you with -8.ucode proves that I am correct.
> 
> This is something i'd rather not comment on. :P
> 
> > I sent a patch that will disable 5GHz band for you from the driver level so
> that you won't suffer from firmware asserts.
> 
> Sweet.
> 
> > You told me you could work on 5GHz with this NIC - good for you.
> > Conclude whatever you want from this, this is none of my business -
> > but for sure, the "issues" you are seeing are related to the fact that your
> NIC isn't supposed to be working on 5GHz, and hence, there is no bug to be
> fixed.
> 
> Now that's funny.  Intel made an effort to put 5GHz radio on this card.  They
> even released firmware that can actually make use of this band.  I am pretty
> sure you won't answer these, but i'll ask why is that anyway:
> 
> 	a) is the 'A' band implementation so buggy that you/Intel decided to
> disable it altogether?

Nope - band A works very well - but just like all the vendors, Intel has several SKUs and capabilities differ between the SKUs.

> 	b) it is on sale too cheap to give it's customers the 'A' band;

As a maintainer / communist / peace lover / whatever I was not chosen to be part of the pricing discussions at Intel...

> 	c) a mix of both (or none) of the above;
> 
> I kind of doubt it is a) since my laptop would happily stay connected to the
> router (on AN band) for days.  Were it not for the ugly 'dmesg' i'd never
> know there is a problem.  I have no idea of the device internals, but blowing
> up the workqueue (or whatever) is a bit too much.  With or without the A
> band functionality. ;)
> 
> Thanks for taking the time to look at my 'problem'.
> 
> 
> 		Petko
