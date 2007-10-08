Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbXJHMxm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 08:53:42 -0400
Subject: Re: libertas and endianness
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710081106.06475.hs4233@mail.mn-solutions.de>
References: <Pine.LNX.4.64.0710071209290.8127@anakin>
	 <200710081106.06475.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 08:55:20 -0400
Message-Id: <1191848120.2703.16.camel@localhost.localdomain> (sfid-20071008_135345_384769_184E5856)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-08 at 11:06 +0200, Holger Schurig wrote:
> > I.e. it tries to store 0x0100 resp. 0x0200 into keytype[i],
> > which is is u8.
> >
> > Gr{oetje,eeting}s,
> 
> Dan Williams partially fixed this on 2nd August. Seems that 
> libertas patches needs ages to trickle upwards.

The patches are queued for 2.6.24 and are already in net-2.6.24.
They've been in net-2.6.24 for quite a while.  Anything that's in
libertas-2.6 is already queued for 2.6.24 when the merge window opens.  

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.24.git;a=commit;h=1118759a15da6e97e8101a7f025b2947f190505f

The order is:

libertas-2.6 -> wireless-2.6 -> net-2.6.x -> linus

So these will go upstream.  Where these patches _could_ go is to stable,
for fixing up what's already out there in 2.6.22 and 2.6.23.

Dan

> The patch is buried in the libertas-2.6 tree, in the 
> branch "libertas". See here:
> 
> http://git.infradead.org/?p=libertas-2.6.git;a=commitdiff;h=1bf710a1f1bd816897be3b0441d3c916ea1b9ab9
> 
> 
> 
> However, in my next mail I'm attaching a cosmetic change for 
> this. There's no need to define a constant for an u8 as 0x0001
> and 0x0002 ...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

