Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52465 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbXFNWbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 18:31:31 -0400
Date: Thu, 14 Jun 2007 23:31:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org
Subject: Re: libertas (private) ioctls vs. nl80211
Message-ID: <20070614223125.GA28235@infradead.org>
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org> <20070614103836.23b07a72.akpm@linux-foundation.org> <20070614181307.GA16856@infradead.org> <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org> <46718D81.9080402@garzik.org> <1181859755.23567.3.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1181859755.23567.3.camel@xo-28-0B-88.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2007 at 06:22:35PM -0400, Dan Williams wrote:
> And that's what I did in the last pull you got from John; all pointless
> and duplicated ioctls were removed.  The only ones left are mesh
> tweakables, an LED GPIO control ioctl, and a regulatory region/domain
> thing.  I agree the interface is somewhat ugly (like the
> char-128/char-128 ones that return information from the mesh forwarding
> table), and I also agree that we need to move to using netlink for this
> sort of stuff in the future.  There are _no_ ioctls that duplicate WEXT
> functionality.

The problem is not any kind of duplication.  The problem is that the
interface is plain and simply bad.  If anyone else would come in with
an ioctl interface using pointer indirections and subfunctions which
is horribly complex and not 32on64 clean they would get beaten up.

So even if the interface is not going to be generic it needs to be
done properly and document.  And once it's documented you've actually
layed down the first building block have it generic.  If no other
driver actually implements the same kind of non-standardized mesh
interface it'll stay that way, if other pop up they can implement
the same interface and eventually we'll grow a generic layer helping
out with it.
