Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45484 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaLHNiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 08:38:01 -0500
Date: Mon, 8 Dec 2014 13:55:38 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	David Miller <davem@davemloft.net>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: using DMA-API on ARM
Message-ID: <20141208125538.GA26983@sig21.net> (sfid-20141208_143822_659391_0084A767)
References: <5481794E.4050406@broadcom.com>
 <20141205183945.GE31222@e104818-lin.cambridge.arm.com>
 <20141205185303.GG31222@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141205185303.GG31222@e104818-lin.cambridge.arm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 05, 2014 at 06:53:03PM +0000, Catalin Marinas wrote:
> On Fri, Dec 05, 2014 at 06:39:45PM +0000, Catalin Marinas wrote:
> > 
> > Does your system have an L2 cache? What's the SoC topology, can PCIe see
> > such L2 cache (or snoop the L1 caches)?
> 
> BTW, if you really have a PL310-like L2 cache, have a look at some
> patches (I've seen similar symptoms) and make sure your configuration is
> correct:
> 
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6395/1
> 
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6529/1
> 
> The first one is vexpress specific. The second one was eventually
> discarded by Russell (I don't remember the reason, I guess it's because
> SoC code is supposed to set the right bits in there anyway). In your
> case, such bits may be set up by firmware, so Linux cannot fix anything
> up.

How do you avoid the unpredictable behavior mentioned in the
PL310 TRM when the Shared Attribute Invalidate Enable bit is set?
http://infocenter.arm.com/help/topic/com.arm.doc.ddi0246h/Ceggcfcj.html

I think this bit does not do what you seem to think it does, it only
changes behaviour for "writes targeting a full cache line, for example
4x64-bit bursts with all strobes active", which then cause the
cacheline to be invalidated.  "Other cases are identical to the default
shared behavior", which is "cacheable no allocate for reads"
and "write through no write allocate for writes".

If the problem is really speculative reads via the cachable
alias mapping, it seems this bit cannot solve the problem, right?


Johannes
