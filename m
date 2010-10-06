Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42552 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966Ab0JFOAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 10:00:08 -0400
Date: Wed, 6 Oct 2010 09:52:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Tony Lindgren <tony@atomide.com>,
	Anand Gadiyar <gadiyar@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH] omap: zoom2/3: fix build caused by wl1271 support
Message-ID: <20101006135221.GE2472@tuxdriver.com>
References: <1285965206-17777-1-git-send-email-gadiyar@ti.com>
 <20101001231026.GH3117@atomide.com>
 <1286279588.15401.28.camel@chilepepper>
 <1286280426.15401.29.camel@chilepepper>
 <1286284790.15401.53.camel@chilepepper>
 <1286311187.2793.7.camel@powerslave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286311187.2793.7.camel@powerslave>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 05, 2010 at 11:39:47PM +0300, Luciano Coelho wrote:
> On Tue, 2010-10-05 at 15:19 +0200, ext Luciano Coelho wrote:
> > On Tue, 2010-10-05 at 14:07 +0200, ext Luciano Coelho wrote:
> > > On Tue, 2010-10-05 at 13:53 +0200, ext Luciano Coelho wrote:
> > > > On Sat, 2010-10-02 at 01:10 +0200, ext Tony Lindgren wrote:
> > > > > * Anand Gadiyar <gadiyar@ti.com> [101001 13:25]:
> > > > > > Patch "omap: zoom: add mmc3/wl1271 device support" in the
> > > > > > wireless tree still uses .wires in struct omap2_hsmmc_info.
> > > > > > .wires has now been replaced with .caps in patch "omap: mmc:
> > > > > > extended to pass host capabilities from board file" in the
> > > > > > OMAP tree.
> > > > > > 
> > > > > > This causes linux-next as of 20101001 build to break as
> > > > > > below. Fix this.
> > > > > > 
> > > > > >   CC      arch/arm/mach-omap2/board-zoom-peripherals.o
> > > > > > arch/arm/mach-omap2/board-zoom-peripherals.c:217: error: unknown field 'wires' specified in initializer
> > > > > > make[1]: *** [arch/arm/mach-omap2/board-zoom-peripherals.o] Error 1
> > > > > > make: *** [arch/arm/mach-omap2] Error 2
> > > > > 
> > > > > Can you guys please queue this via the wireless tree along with
> > > > > the other wl1271 patches?
> > > > > 
> > > > > Acked-by: Tony Lindgren <tony@atomide.com>
> > > > 
> > > > I can apply this to the wl12xx tree.  I just need John's confirmation.  
> > > > 
> > > > The pull request I sent to John last week is still pending.  I don't
> > > > know if it is possible to substitute it for a newer one with more
> > > > patches (and still try to make it to 2.6.37).  What do you think, John?
> > > 
> > > Damn, for some reason I had a bug in John's email in my contact book.
> > > Now sending to the correct email address.
> > 
> > Applied to the wl12xx tree.  I'll send a new replacement pull to John
> > today, including this patch.  Thanks.
> 
> Hmmm... We got a problem here.  This patch breaks builds when we *don't*
> have "omap: mmc extended to pass host capabilities from board file".  We
> don't have that on wireless-next yet, so builds with zoom boards
> selected are broken.
> 
> Any ideas on how to solve this dilemma? I guess the proper way to handle
> this would be to make the changes proposed in this patch when merging
> instead of having a normal commit for it, wouldn't it?

Just cherry-pick that change into the branch of your tree that I do
_not_ pull from.  I presume that it is already available in linux-next?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
