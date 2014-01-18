Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17587 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751064AbaARRrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 12:47:12 -0500
Date: Sat, 18 Jan 2014 09:47:06 -0800
From: Tony Lindgren <tony@atomide.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 0/5] wl1251 device tree support
Message-ID: <20140118174705.GE7235@atomide.com> (sfid-20140118_184717_429352_20D0AEAA)
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
 <20140106225709.GA23070@earth.universe>
 <20140117014514.GA604@earth.universe>
 <20140117150127.GA15145@tuxdriver.com>
 <20140117174415.GG7993@atomide.com>
 <20140117192204.GB15145@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140117192204.GB15145@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [140117 11:32]:
> On Fri, Jan 17, 2014 at 09:44:16AM -0800, Tony Lindgren wrote:
> > * John W. Linville <linville@tuxdriver.com> [140117 07:17]:
> > > On Fri, Jan 17, 2014 at 02:45:15AM +0100, Sebastian Reichel wrote:
> > > > On Mon, Jan 06, 2014 at 11:57:09PM +0100, Sebastian Reichel wrote:
> > > > > Hi John,
> > > > > 
> > > > > > The following patchset adds device tree support to
> > > > > > the spi variant of the wl1251 driver.
> > > > > >
> > > > > > Luciano Coelho (1):
> > > > > >   wl1251: split wl251 platform data to a separate structure
> > > > > > 
> > > > > > Sebastian Reichel (4):
> > > > > >   wl1251: move power GPIO handling into the driver
> > > > > >   wl1251: spi: add vio regulator support
> > > > > >   wl1251: spi: add device tree support
> > > > > >   Documentation: dt: wireless: Add wl1251
> > > > > 
> > > > > What's the status of this patchset? Tony prepared an immutable
> > > > > branch for patches 1+2 [0]. I think the other patches are also ok
> > > > > (at least there were no more complains from the DT binding
> > > > > maintainers). It would be nice to have wl1251 DT support in 3.14.
> > > > > 
> > > > > [0] http://www.spinics.net/lists/linux-omap/msg101165.html
> > > > > 
> > > > > -- Sebastian
> > > > 
> > > > ping? I can't see it on wireless-next.
> > > 
> > > I can't pull it because the branch is based on a later source than
> > > that of wireless-next.
> > 
> > Hmm I thought v3.13-rc1 was the base we agreed on the immutable branch.
> > Care to explain what the issue is merging it in?
> 
> I think I was clear -- "the branch is based on a later source than
> that of wireless-next".

OK so it's the..
 
> > AFAIK merging it fast forwards your branch to v3.13-rc1 and then
> > you just need to do the pull request against v3.13-rc1.
> 
> It's not a forward, it's a merge.  And I don't want to do that in
> the wireless-next tree right now.

..merge part that you have problem. Fine with me.
 
> Are you sending that branch for 3.14?  Is there some reason that I
> have to have it in wireless-next?

The reason was for keeping things building and git bisect working.

I do have wl1251-pdata-signed as the base for branch
omap-for-v3.14/omap3-board-removal. However the board removal was
considered too early for v3.14, so that's been postponed. This is
because people are still updating their systems to device tree
based booting. So I can redo my omap-for-v3.14/omap3-board-removal
against v3.14.

So if you want to, feel free to pick all the wl12xx patches to your
wireless tree. AFAIK my omap-for-v3.14/omap3-board-removal is the
only other user for those patches, and that I can redo that on
v3.14.

So for the arch/arm/*omap* touching patches, feel free to add:

Acked-by: Tony Lindgren <tony@atomide.com>
