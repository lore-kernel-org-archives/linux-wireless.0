Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53145 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZEXVxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 17:53:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: b43 : under high load, ack are lost
Date: Sun, 24 May 2009 23:53:02 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20090517T085823-487@post.gmane.org> <200905211747.43882.mb@bu3sch.de> <4A19BF2A.3030101@free.fr>
In-Reply-To: <4A19BF2A.3030101@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905242353.02633.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 May 2009 23:42:02 matthieu castet wrote:
> Michael Buesch wrote:
> > On Wednesday 20 May 2009 23:09:47 matthieu castet wrote:
> >> I see also some period were the AP seem to drop all packet.
> >> I am wondering if it can be due to slow recalibration.
> >> Do you now how much take calibration were mac is down ?
> > 
> > I think you should try without QoS.
> > Try specifying the qos=0 module parameter to b43.
> > If that does not work, additionally apply the following patch.
> > I think there are some problems with QoS and I think somebody reported some bugs
> > some time ago. I think they are still not addressed.
> Thank you for your help.
> 
> First I used a ipw2200 for monitoring traffic, but it seems it doesn't 
> not capture all packets. That what explain the strange pattern I saw 
> before (missing ack or 2 following ack).

An ipw2200 is absolutely not usable in monitor mode.
You should dispose of it properly ;)

> Disabling pwork doesn't help, but some stuff is still done with 
> b43_phy_txpower_check on tx path.

Ok, this was just to falsify your "broken by calibration" theory.

-- 
Greetings, Michael.
