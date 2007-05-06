Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40426
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbXEFSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2007 14:45:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Merging SSB upstream
Date: Sun, 6 May 2007 20:44:51 +0200
Cc: Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gary Zambrano <zambrano@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, ralf@linux-mips.org,
	davej@codemonkey.org.uk, mtakahashi@kanno.co.jp
References: <200705060303.17594.mb@bu3sch.de> <200705061144.27817.mb@bu3sch.de> <20070506173833.GA4717@tuxdriver.com>
In-Reply-To: <20070506173833.GA4717@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705062044.52408.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 May 2007 19:38:33 John W. Linville wrote:
> On Sun, May 06, 2007 at 11:44:27AM +0200, Michael Buesch wrote:
> > On Sunday 06 May 2007 04:00:51 John W. Linville wrote:
> 
> > > I had to remove 
> > > the b44 ssb changes from fedora because a) users reported problems;
> > 
> > Which problems were that? The 2 compile issues?
> > Trivial to fix if that's the only issue. ;)
> 
> I knew you would ask that... :-)

:P

> I don't think there was a bugzilla, but Dave Jones forwarded an email
> to me from "MASAO TAKAHASHI" in late February.  Takahashi-san (forgive
> me if I did that wrong) was complaining about tx timeouts after I
> had added the full wireless-dev patchset to rawhide.  Removing the
> b44 bits of the patch seemed to remove the problem.
> 
> That's all the info I have.  Perhaps Dave or Takahashi-san can add
> to the description?

Hm, interesting issue.
But I'm not convinced that it's caused by the SSB port, though.
What the SSB port essentially does is modifying small areas in the
init and exit paths. The modified things in the TX and RX hotpaths
are really tiny and trivial. TX timeout sounds like something in the
TX/RX paths is going wrong.
But anyway, maybe I got something wrong.
I'll run some burn-in tests on it now.

-- 
Greetings Michael.
