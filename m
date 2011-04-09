Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61556 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1DIXe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 19:34:27 -0400
Received: by eyx24 with SMTP id 24so1406817eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Apr 2011 16:34:26 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Sun, 10 Apr 2011 03:34:21 +0400
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <201104020058.17232.chunkeey@googlemail.com> <201104100023.52526.jcmvbkbc@gmail.com> <201104100024.30155.chunkeey@googlemail.com>
In-Reply-To: <201104100024.30155.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104100334.22689.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > In the ARP case, when there's no other traffic on p54spi, all ARP requests
> > are dropped. But if there's some egress traffic from p54spi, filter seems
> > to work correctly: only ARP requests that match filter pass through.
> "no other traffic" sounds like a the psm filter at work, have you disabled
> it before starting the experiment?

I ran tests first without "iwconfig wlan0 power on", rebooted and re-ran them with PSM.
Didn't notice any difference.

And having ingress traffic only doesn't help ARPs to get through. They need egress to get in.
In other words: I saw ingress packets in tcpdump, but no ARPs matching filter among them.
But once packets start to go out of p54spi, ARPs matching filter get in. Looks very strange.

> > In the multicast case filter seems to work correctly, but it treats broadcast
> > as subject to that filtering too. By default only 01:00:5e:00:00:01 gets into
> > priv->mc_maclist, so we miss all broadcasts.
> ok, so we have to reserve a spot of ff:ff:ff:ff:ff:ff.

But currently that cancels ARP filtering completely.

> > These two filters seem to interfere:
> > - if we set ARP filter and multicast filter without broadcast, we miss all
> > ARPs if there's no egress traffic;
> > - if we set ARP filter and multicast filter with broadcast, or don't set
> > multicast filter at all we get all ARPs.
> > 
> > This effect does not depend on filter setup order.
> interesting, well a unnamed [but trustworthy] source told us that ST identified
> a problem with the arp/multicast filter some time ago, unfortunately I haven't
> seen any updated p54spi firmwares lately. Maybe this sagred stuff works?

"sagred stuff" ?

Thanks.
-- Max
