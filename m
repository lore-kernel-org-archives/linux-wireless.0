Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:13273 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYGALhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:37:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so574725nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 04:37:20 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61 and TSF reporting?
Date: Tue, 1 Jul 2008 13:41:38 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1214907990.7763.40.camel@johannes.berg> <200807011315.09296.IvDoorn@gmail.com> <1214911794.29181.3.camel@johannes.berg>
In-Reply-To: <1214911794.29181.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807011341.38815.IvDoorn@gmail.com> (sfid-20080701_133725_094323_FFBD7CD7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 July 2008, Johannes Berg wrote:
> On Tue, 2008-07-01 at 13:15 +0200, Ivo van Doorn wrote:
> > On Tuesday 01 July 2008, Johannes Berg wrote:
> > > 
> > > > > > Note that these undocumented fields only are present in rt2500pci and rt61pci.
> > > > > 
> > > > > Ok cool, I'll play with that, I should be able to make a patch myself,
> > > > > thanks.
> > > > 
> > > > Oh wait, just found a reference about those RXD words:
> > > > 
> > > >  * The following fields are for DMA block and HOST usage only.
> > > >  * Can't be touched by ASIC MAC block.
> > > > 
> > > > In other words, they are for driver usage only. :S
> > > 
> > > The only ones that are ever non-zero are 0, 1, 4 and 5. Guess not then.
> > 
> > 4 contains data?
> > 2 and 3 I understand since HW crypto is disabled in wireless-testing,
> > but that should mean that 4 should also be 0 unless my estimation about
> > it being the ICV field is wrong...
> > 
> > What data is in there?
> 
> Heh. I was connected to an encrypted AP with a different device and
> monitoring the traffic no that channel, and got the following:
> 
> [139528.433872] rt61pci rx word 4: 0x60483004
> [139528.433882] rt61pci rx word 5: 0x012c30a8
> [139528.468947] rt61pci rx word 4: 0x60483004
> [139528.468956] rt61pci rx word 5: 0x01566138
> [139528.571350] rt61pci rx word 4: 0x60483004
> [139528.571361] rt61pci rx word 5: 0x1dba1048
> [139528.673744] rt61pci rx word 4: 0x60483004
> [139528.673753] rt61pci rx word 5: 0x18e02078
> [139528.776153] rt61pci rx word 4: 0x60483004
> [139528.776165] rt61pci rx word 5: 0x01568018
> [139528.878538] rt61pci rx word 4: 0x60483004
> [139528.878549] rt61pci rx word 5: 0x072a9048
> 
> In fact, through the whole uptime of the card word 4 never changed, so
> maybe it's just bogus data from the disabled hwcrypto engine.

Ok, I'll run some experiments with HW crypto enabled and see if the value
is different for each frame in there.

Ivo

