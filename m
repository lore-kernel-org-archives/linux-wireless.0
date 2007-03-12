Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2834 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030325AbXCLPDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 11:03:08 -0400
Date: Mon, 12 Mar 2007 10:53:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joseph Jezak <josejx@gentoo.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
Message-ID: <20070312145309.GB8878@tuxdriver.com>
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net> <1173685989.3584.2.camel@shinybook.infradead.org> <45F55452.3000704@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45F55452.3000704@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2007 at 09:23:30AM -0400, Joseph Jezak wrote:
> David Woodhouse wrote:
> > On Fri, 2007-03-02 at 11:30 -0600, Larry Finger wrote:
> >> There was an error in the B5PHY init specifications.
> > 
> > This patch doesn't fix the machine check in bcm43xx_phy_initb5 which
> > Pavel Roskin and I reported a couple of weeks ago. To get rid of that
> > crash, I still have to revert an earlier 'spec update' patch
> > (740ac4fb08866d702be90f167665d03759bd27d0).
> > 
> 
> Yeah, the issue is that the Rev1 cards have to be init'd with g mode
> off.  I'm not sure anyone has picked up this fix yet. The relevant
> spec fix is here: http://bcm-v4.sipsolutions.net/802.11/PHY/calinit

FWIW, by inspection it looks like the mac80211-based driver is
(trying?) to implement this change.

David, have you tried the mac80211 version?  Does it still have the
same crash?

John
-- 
John W. Linville
linville@tuxdriver.com
