Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55967 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYKLVbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:31:11 -0500
Date: Wed, 12 Nov 2008 16:15:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Message-ID: <20081112211530.GH2411@tuxdriver.com> (sfid-20081112_223116_784090_795A741F)
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <200811031747.16326.IvDoorn@gmail.com> <20081103170243.GB2417@khazad-dum.debian.net> <200811031820.41165.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200811031820.41165.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 03, 2008 at 06:20:40PM +0100, Ivo van Doorn wrote:
> On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> > On Mon, 03 Nov 2008, Ivo van Doorn wrote:
> > > On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> > > > This small patchset contains two fixes to issues in the suspend/resume
> > > > handling of the rfkill class core.
> > > > 
> > > > It needs to go to 2.6.28.  These patches are based on 2.6.28-rc3.
> > > 
> > > Are they real regressions or normal bugfixes?
> > 
> > I am not sure if they regress anything, but I am pretty sure there is no
> > bugzilla entry about them yet.  I have added two more interested parties to
> > the CC.
> > 
> > So, if there is a strong feeling this would best be held until the next
> > merge window, I can certainly respin the patches to on top of
> > wireless-testing...
> 
> Well I'll give my ACK to the 2 patches, but I'll let john decide if they
> are "regression" enough for 2.6.28. ;)

So I keep looking at these patches, and I'm not sure about them.
It seems that they restore the rfkill state after resume to what it
was before the suspend.  What I am unsure about is whether or not
that is the appropriate thing to do.  I suppose it makes sense under
the rule of least surprise.

I guess the safer alternative would be to always resume with rfkill
enabled, but that is probably undesirable in the most common case.
So, I have no objection to these patches.

Still, I don't see how they qualify for 2.6.28.  How serious do you
think this potential problem really is?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
