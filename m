Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:45017 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYEPDOI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 23:14:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Date: Fri, 16 May 2008 12:01:48 +1000
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ron.rindjunsky@intel.com, tomasw@gmail.com,
	ivdoorn@gmail.com, peter.p.waskiewicz.jr@intel.com
References: <20080507130548.GA26977@gondor.apana.org.au> <20080508032208.GA401@gondor.apana.org.au> <20080507.202606.242037993.davem@davemloft.net>
In-Reply-To: <20080507.202606.242037993.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805161201.48835.rusty@rustcorp.com.au> (sfid-20080516_051440_602223_EE554220)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 May 2008 13:26:06 David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Thu, 8 May 2008 11:22:08 +0800
>
> > On Wed, May 07, 2008 at 03:48:06PM +0200, Michael Buesch wrote:
> > > So there's no way to actually fail in a TX handler? Drivers
> > > are doomed to drop the packet, if they cannot handle it due to
> > > ring overflow?
> >
> > You're supposed to stop the queue before the ring overflows.
>
> Right, and this is why drivers choose a TX wakeup threshold such
> that they can accept an arbitrarily sized TSO frame.

Dave, please allow me to ask a heretical question.  Returning TX_BUSY has some 
appeal for virtio_net: is it fundamentally a flawed idea, or simply a matter 
of coding?

Currently we have no virtio interface to ask how many descriptors are left; 
it's not clear that it's a fair question to ask, since for Xen it's depends 
on the actual buffers we're trying to put in the descirptors.

Thanks,
Rusty.
