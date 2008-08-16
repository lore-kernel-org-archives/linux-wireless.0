Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40758 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYHPTgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 15:36:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
Date: Sat, 16 Aug 2008 21:36:19 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200808160029.56876.mb@bu3sch.de> <48A65100.9050407@lwfinger.net> <48A717C0.6020705@lwfinger.net>
In-Reply-To: <48A717C0.6020705@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808162136.19680.mb@bu3sch.de> (sfid-20080816_213658_969026_6C3DCCA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 16 August 2008, Larry Finger wrote:
> Larry Finger wrote:
> > 
> > The patch works fine on the 802.11g portion of my BCM4312/1, which seems 
> > to be the same as a BCM4311/1. This card has a PCIe format. I also 
> > tested on my PCMCIA version of a BCM4318. That card works, but the 
> > maximum transmit rate is only about 1/2 of what I get without it. The 
> > card has a rev 09 802.11 core, a rev 7 PHY, and a rev 3 analog part. I 
> > still have to test on a PCI format BCM4306/3 card, but I suspect that 
> > you have already tested the 4306.
> 
> Forget what I said about the loss of transmit rate. Once I did a 
> proper test, it is the same with or without the patch. For the 
> BCM4318, the b43 rate is slightly reduced from using bcm43xx. The 
> difference is not really great, but a reproducible reduction from 16.6 
> to 14.2 Mbs with the iwconfig rate set at 54 Mbs. By comparison, the 
> BCM4312 is over 20 Mbs.

Thanks a lot for retesting.
Loss of TX rate would be the worst thing that can happen with this patch, as
it's very very hard to debug due to the size.

I didn't test it on all of my devices, yet. I just tried a 4306, where it
doesn't cause any regression.
