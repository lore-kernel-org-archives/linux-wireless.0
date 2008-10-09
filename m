Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYJIQH4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 12:07:56 -0400
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic
	loading firmware with PCMCIA adapter
From: Dan Williams <dcbw@redhat.com>
To: Andrey Borzenkov <arvidjaar@newmail.ru>
Cc: Matthew Wilcox <matthew@wil.cx>,
	orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200810091959.54987.arvidjaar@newmail.ru>
References: <200810091722.56812.arvidjaar@newmail.ru>
	 <20081009133125.GW25780@parisc-linux.org>
	 <200810091959.54987.arvidjaar@newmail.ru>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 12:06:50 -0400
Message-Id: <1223568410.18104.42.camel@dhcp-100-3-195.bos.redhat.com> (sfid-20081009_180802_733859_1B860608)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-09 at 19:59 +0400, Andrey Borzenkov wrote:
> On Thursday 09 October 2008, Matthew Wilcox wrote:
> > 
> > On Thu, Oct 09, 2008 at 05:22:55PM +0400, Andrey Borzenkov wrote:
> > > After loading orinoco and "inserting" adapter I get either BUG with
> > > endless loop (attached) or kernel panic on NULL pointer dereference
> > > (was not able capture). Adapter works fine with wlags49 driver.
> > 
> > It looks like you've fallen off the bottom of the kernel stack.  Do you
> > have 4k stacks enabled in your config?
> > 
> 
> You are right. Using 8K stacks load and runs fine. Hmm ... not nice
> from it :p

== driver bug; the driver should not require large stacks and this
should get fixed.

Dan


