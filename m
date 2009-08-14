Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53936 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbZHNVAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:00:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] b43: Fix sparse warnings
Date: Fri, 14 Aug 2009 23:00:01 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net> <200908142215.38112.mb@bu3sch.de> <1250283133.8137.16.camel@mj>
In-Reply-To: <1250283133.8137.16.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908142300.01397.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 22:52:13 Pavel Roskin wrote:
> On Fri, 2009-08-14 at 22:15 +0200, Michael Buesch wrote:
> 
> > > -			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> > > +			b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
> > 

> I would just use 0x7fff here.

That does not work if 0x8000 is a #defined bit.

-- 
Greetings, Michael.
