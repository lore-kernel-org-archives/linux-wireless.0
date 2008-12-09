Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51152 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYLIPAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:00:11 -0500
Date: Tue, 9 Dec 2008 09:54:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2] p54usb: rewriting rx/tx routines to make use of
	usb_anchor's facilities
Message-ID: <20081209145439.GB3653@tuxdriver.com> (sfid-20081209_160016_884567_50685F3A)
References: <200812091514.37634.chunkeey@web.de> <20081209143530.GA3653@tuxdriver.com> <1228833999.1029.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228833999.1029.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 09, 2008 at 03:46:39PM +0100, Johannes Berg wrote:
> On Tue, 2008-12-09 at 09:35 -0500, John W. Linville wrote:
> > On Tue, Dec 09, 2008 at 03:14:37PM +0100, Christian Lamparter wrote:
> > > Alan Stern found several flaws in p54usb's implementation and annotated: 
> > > "usb_kill_urb() and similar routines do not expect an URB's completion
> > > routine to deallocate it.  This is almost obvious -- if the URB is deallocated
> > > before the completion routine returns then there's no way for usb_kill_urb
> > > to detect when the URB actually is complete."
> > > 
> > > This patch addresses all known limitations in the old implementation and fixes
> > > khub's "use-after-freed" hang, when SLUB debug's poisoning option is enabled.
> > > 
> > > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > > Cc: stable@kernel.org
> > 
> > That's a big patch for so late in the cycle.  Is there a bugzilla open for it?
> 
> No, but we can open one ;) It's strange, but nobody but me apparently
> found the bug so far, even though it has been in there forever. Might be
> due to slub debugging being disabled by default even if you enable
> SLUB_DEBUG in Kconfig (you also need to enable SLUB_DEBUG_ON)

It might be helpful to have open a bug that includes a backtrace or something.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
