Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:61487 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3EETJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 15:09:57 -0400
Received: by mail-la0-f47.google.com with SMTP id fh20so2733986lab.6
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 12:09:55 -0700 (PDT)
Date: Sun, 5 May 2013 21:09:47 +0200 (CEST)
From: Thommy Jakobsson <thommyj@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, m@bues.ch, piotras@gmail.com,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
In-Reply-To: <CACna6rwc-XPXJcbk=oEJh=+nTaQrV3-UPwfsNODQpB9gtkktkg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1305052104410.1284@kelly.ryd.net> (sfid-20130505_211012_303942_BBB86FA3)
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com> <CACna6rwc-XPXJcbk=oEJh=+nTaQrV3-UPwfsNODQpB9gtkktkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sun, 5 May 2013, Rafa? Mi?ecki wrote:

> 2013/5/5 Rafa? Mi?ecki <zajec5@gmail.com>:
> > 2013/4/23 Thommy Jakobsson <thommyj@gmail.com>:
> >> Add handling of rx descriptor underflow. This fixes a fault that could
> >> happen on slow machines, where data is received faster than the CPU can
> >> handle. In such a case the device will use up all rx descriptors and
> >> refuse to send any more data before confirming that it is ok. This
> >> patch enables necessary interrupt to discover such a situation and will
> >> handle them by dropping everything in the ring buffer.
> >
> > Thommy: does it mean firmware actually ignores what we write to the
> > B43_DMA64_RXINDEX (recently renamed to the B43_DMA64_RXSTOPINDEX)? Is
> > our set_current_rxslot and op64_set_current_rxslot (same for 32bit
> > version) useless in this situation?
> 
> I've done some tests with this register. First I've added simple debugging:
> 
> [  326.496207] [DBG] old current:0      new current:1
> [  326.496215] [DBG] reading slot 0
> [  326.496237] [DBG] writing stop slot 1
> 
> [  326.921657] [DBG] old current:1      new current:2
> [  326.921665] [DBG] reading slot 1
> [  326.921691] [DBG] writing stop slot 2
> 
> I'm not sure how does it work. If we write 1 to RXSTOPINDEX it means
> firmware should not use slot "1", right? But then it'll IRQ and
> "current" will be 2 meaning there is a packet on slot 1.
> So I'm not sure anymore meaning of that index register.

See that this got stuck in my outbox, sorry. Michael already answered the 
question I think, but I send it anyway.


If we write 1 to rxstopindex it means stop when you reach that index. The 
difference in the normal loop is that the device has already marked what 
we write to RXSTOPINDEX as current. One cannot remove a slot from the 
firmware.

//Thommy


