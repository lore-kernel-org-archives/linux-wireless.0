Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35963 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZEUKRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 06:17:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: b43 : under high load, ack are lost
Date: Thu, 21 May 2009 12:16:52 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20090517T085823-487@post.gmane.org> <loom.20090520T210546-24@post.gmane.org> <200905202334.40841.mb@bu3sch.de>
In-Reply-To: <200905202334.40841.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905211216.53012.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 May 2009 23:34:40 Michael Buesch wrote:
> On Wednesday 20 May 2009 23:09:47 matthieu castet wrote:
> > I see also some period were the AP seem to drop all packet.
> > I am wondering if it can be due to slow recalibration.
> > Do you now how much take calibration were mac is down ?
> 
> Something like 30/40/50 milliseconds. I don't know. Somewhere in that range.
> 
> But I think it doesn't drop packets due to recal. I think it's simply
> because the b43 PHY code is completely broken.
> 

Btw, you can easily test this with 
echo -n 1 > /debug/b43/phy0/debug_pwork_stop
This completely stops periodic recalibration.

-- 
Greetings, Michael.
