Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1217 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0HVUJA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 16:09:00 -0400
Subject: Re: [PATCH] b43: N-PHY: add missing phyrxchain setting and fix
 warning in RX core function
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTikP5hQKMyJD1-7+gaY8PykQ77At+Vpkqf=HRT0H@mail.gmail.com>
References: <1282506452-8159-1-git-send-email-zajec5@gmail.com>
	 <AANLkTikP5hQKMyJD1-7+gaY8PykQ77At+Vpkqf=HRT0H@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Aug 2010 13:08:59 -0700
Message-ID: <1282507739.1879.50.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-08-22 at 21:49 +0200, Gábor Stefanik wrote:
> 2010/8/22 Rafał Miłecki <zajec5@gmail.com>:
> > @@ -3103,7 +3105,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
> >        b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXEN,
> >                        (mask & 0x3) << B43_NPHY_RFSEQCA_RXEN_SHIFT);
> >
> > -       if (mask & 0x3 != 0x3) {
> > +       if ((mask & 0x3) != 0x3) {
> 
> Why is this needed? An & doesn't magically transform into an && under
> any circumstances...

For the same reason it's used in the b43_phy_maskset call.
Clarity.

