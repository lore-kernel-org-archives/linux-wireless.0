Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1DJAln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 20:41:43 -0400
Received: by eyx24 with SMTP id 24so1411820eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Apr 2011 17:41:42 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Sun, 10 Apr 2011 04:41:36 +0400
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <201104020058.17232.chunkeey@googlemail.com> <201104100334.22689.jcmvbkbc@gmail.com> <201104100154.37008.chunkeey@googlemail.com>
In-Reply-To: <201104100154.37008.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104100441.37852.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > In the multicast case filter seems to work correctly, but it treats broadcast
> > > > as subject to that filtering too. By default only 01:00:5e:00:00:01 gets into
> > > > priv->mc_maclist, so we miss all broadcasts.
> > > ok, so we have to reserve a spot for ff:ff:ff:ff:ff:ff.
> > 
> > But currently that cancels ARP filtering completely.
> 
> Ok, so we can't have both [atm] and we can't really choose between them either.
> Or do you think it's worth salvaging the multicast filter for a [PATCH]?

Well, multicast filtering appears to work good with that additional broadcast entry. So, why not.

> > > interesting, well a unnamed [but trustworthy] source told us that ST identified
> > > a problem with the arp/multicast filter some time ago, unfortunately I haven't
> > > seen any updated p54spi firmwares lately. Maybe this sagred stuff works?
> > 
> > "sagred stuff" ?
> yeah, it was a while ago... 
> "p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)"
> http://www.spinics.net/lists/linux-wireless/msg55967.html
> 
> AFAIK they have another p54spi firmware
> "phy0: FW rev 2.19.0.0.A.14 Private - Softmac protocol 5.6"

Ok, I'll try to test it with firmware images other than nokia's native.

Thanks.
-- Max
