Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34299 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYBGJY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 04:24:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH stable] b43: Reject new firmware early
Date: Thu, 7 Feb 2008 10:24:27 +0100
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
References: <200801261354.52659.mb@bu3sch.de> <20080207072624.GB15657@kroah.com>
In-Reply-To: <20080207072624.GB15657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802071024.27445.mb@bu3sch.de> (sfid-20080207_092503_904525_118EFE5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 February 2008 08:26:24 Greg KH wrote:
> On Sat, Jan 26, 2008 at 01:54:52PM +0100, Michael Buesch wrote:
> > We must reject new incompatible firmware early to avoid
> > running into strange transmission failures.
> > 
> > The current development tree supports newer firmware revisions.
> > These revisions cause strange failures on the stable 2.6.24 kernel.
> > Add a check to avoid confusing users a lot.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Oh wait, I see why it's not in Linus's tree, it doesn't pertain :)
> 
> I'll queue this up, sorry for the noise.

Yeah, Linus' tree does have support for this firmware revision we are
rejecting with this patch. :) This patch was lost in the 2.6.24
release cycle, so I'd like to push it through -stable to confuse users
less with strange warnings caused by using wrong firmware.
This patch doesn't remove any functionality or something, it simply
transforms a blowing up firmware into a nice error message. :)

-- 
Greetings Michael.
