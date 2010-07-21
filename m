Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32940 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0GUQp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 12:45:27 -0400
Date: Wed, 21 Jul 2010 12:38:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] b43: silense most sparse warnings
Message-ID: <20100721163803.GC2355@tuxdriver.com>
References: <1279727142-25234-1-git-send-email-linville@tuxdriver.com>
 <4C471AC2.5040003@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4C471AC2.5040003@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 06:05:22PM +0200, Michael Büsch wrote:
> On 07/21/2010 05:45 PM, John W. Linville wrote:
> >diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
> >index 29bf34c..0dc33b6 100644
> >--- a/drivers/net/wireless/b43/phy_g.c
> >+++ b/drivers/net/wireless/b43/phy_g.c
> >@@ -972,7 +972,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
> >  		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
> >
> >  		if (phy->rev>= 3) {
> >-			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> >+			b43_phy_mask(dev, 0x048A, 0x7FFF);
> 
> This cast was introduced to silense a GCC warning. Do we end up in an
> infinite loop now? ;)

This version has the beauty of pleasing both gcc and sparse. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
