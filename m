Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45897 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZETUhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 16:37:24 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M6sXT-0000CH-Kd
	for linux-wireless@vger.kernel.org; Wed, 20 May 2009 20:37:23 +0000
Received: from cac94-1-81-57-151-96.fbx.proxad.net ([81.57.151.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 20:37:23 +0000
Received: from castet.matthieu by cac94-1-81-57-151-96.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 20:37:23 +0000
To: linux-wireless@vger.kernel.org
From: matthieu castet <castet.matthieu@free.fr>
Subject: Re: b43 : under high load, ack are lost
Date: Wed, 20 May 2009 20:37:11 +0000 (UTC)
Message-ID: <loom.20090520T203218-265@post.gmane.org>
References: <loom.20090517T085823-487@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthieu CASTET <castet.matthieu@...> writes:

> 
> Hi,
> 
> I use a 4306 (core rev 5) with compat-wireless-2009-05-08 as wireless driver
> and
> 4.150.10.5 firmware.
> My station is an airo card in wpa-psk mode (802.11b).
> 
> After resolving my beacon problem [1], when I download at max speed my 
> station
> disconnect from AP because "LostSync-MaxRetry".
> After looking in my station statistic it seems the retry (RetryLong) are due 
> to
> noack received from the AP.
I take a monitor trace of the trafic and I see weird stuff from the b43 AP, 
there is lot of case of :
- client send data to AP
- AP send data to client
- ack from client
- AP send data to client
- ack from client
- AP send data to client
- ack from client
- ack from AP (for 1 packet)


Sometimes it is :
- client send data to AP
- AP send data to client
- ack from client
- AP send data to client
- ack from client
- AP send data to client
- ack from client
- client resend data to AP
- ack from AP
- client send data to AP
- ack from AP
- ack from AP (for 1 packet)


It seems like ack are queued somewhere with low priority.

