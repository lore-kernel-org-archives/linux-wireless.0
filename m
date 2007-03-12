Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alnrmhc15.comcast.net ([204.127.225.95]:65320 "EHLO
	alnrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965412AbXCLN2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 09:28:36 -0400
Message-ID: <45F55452.3000704@gentoo.org>
Date: Mon, 12 Mar 2007 09:23:30 -0400
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net> <1173685989.3584.2.camel@shinybook.infradead.org>
In-Reply-To: <1173685989.3584.2.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Fri, 2007-03-02 at 11:30 -0600, Larry Finger wrote:
>> There was an error in the B5PHY init specifications.
> 
> This patch doesn't fix the machine check in bcm43xx_phy_initb5 which
> Pavel Roskin and I reported a couple of weeks ago. To get rid of that
> crash, I still have to revert an earlier 'spec update' patch
> (740ac4fb08866d702be90f167665d03759bd27d0).
> 

Yeah, the issue is that the Rev1 cards have to be init'd with g mode
off.  I'm not sure anyone has picked up this fix yet. The relevant
spec fix is here: http://bcm-v4.sipsolutions.net/802.11/PHY/calinit

-Joe
