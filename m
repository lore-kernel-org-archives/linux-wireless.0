Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8960 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbZHNUwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:52:21 -0400
Subject: Re: [PATCH] b43: Fix sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200908142215.38112.mb@bu3sch.de>
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
	 <200908142215.38112.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 16:52:13 -0400
Message-Id: <1250283133.8137.16.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-08-14 at 22:15 +0200, Michael Buesch wrote:

> > -			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> > +			b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
> 
> Uh come on...
> The u16 cast already is stupid as hell, but this is becoming braindead.
> The code is perfectly fine. Sparse should instead provide an option to disable
> this fragile check.

There are cases where we want to know that a constant was truncated.  In
fact, in most cases it's a useful warning.

In this case, we intuitively expect that it's OK to cast a result of a
bitwise operation to its original type, as if it was never promoted.
But sparse will need to have a special exception for this case.

I would just use 0x7fff here.

-- 
Regards,
Pavel Roskin
