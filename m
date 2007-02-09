Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:32936
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992772AbXBIT0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 14:26:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Joseph Jezak <josejx@gentoo.org>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Date: Fri, 9 Feb 2007 20:26:42 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <200702091945.25187.mb@bu3sch.de> <45CCC8B5.3060108@gentoo.org>
In-Reply-To: <45CCC8B5.3060108@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702092026.43006.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 February 2007 20:17, Joseph Jezak wrote:
> > 
> > The specs are unclear at this point:
> > "Write the value to the offset"
> > Offset in which register type?
> 
> PHY Register.  I've clarified it in the specs, I think this was said 
> before, I made it worse when I cleaned it up.
> 
> >>  	// Initialization
> >> -	if (phy->version == 0) {
> >> +	if (phy->analog == 0) {
> >>  		bcm43xx_write16(bcm, 0x03E6, 0x0122);
> >>  	} else {
> >> -		if (phy->version >= 2)
> >> -			bcm43xx_write16(bcm, 0x03E6, 0x0040);
> >> +		if (phy->analog >= 2)
> >> +			bcm43xx_write16(bcm, 0x0003, (bcm43xx_read16(bcm, 0x0003)
> >> +					& 0xFFBF) | 0x0040);
> > 
> > I think here is a specs bug.
> 
> This is correct.  Why do you think it's a specs bug?

Because
a) The old one made more sense to me.
b) Write MMIO register 0x3? I mean. What is that?
   Could this be PHY or radio register 0x3?

-- 
Greetings Michael.
