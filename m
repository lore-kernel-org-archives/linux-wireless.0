Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-202-190.clients.your-server.de ([88.198.202.190]:36180
	"EHLO kleinhenz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab0GOIvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 04:51:55 -0400
Date: Thu, 15 Jul 2010 10:51:50 +0200
From: Simon Richter <sjr@debian.org>
To: Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Ben Hutchings <ben@decadent.org.uk>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
Message-ID: <20100715085149.GA9922@richter>
References: <1278887148.6139.91.camel@localhost>
 <4C3A4C6E.6060801@lwfinger.net>
 <20100713051430.GA2625@honey.hogyros.de>
 <4C3BFB87.5030907@lwfinger.net>
 <20100713073751.GB3089@richter>
 <4C3C6350.50304@bu3sch.de>
 <20100713130614.GB25565@richter>
 <4C3C7296.3070700@bu3sch.de>
 <20100714075037.GA6128@richter>
 <4C3DB065.70009@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4C3DB065.70009@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Jul 14, 2010 at 02:41:09PM +0200, Michael Büsch wrote:

> The same applies to receiving. The RX queue is also dropped on switch
> from DMA to PIO.

Sure, but the packet is repeated every ten seconds. The problem is that
none of those packets is received, even long after the switch to PIO.

> >advertisement, sent to 33:33:00:00:00:01). I have no idea where the
> >packet is dropped; from my somewhat limited understanding of 802.11, I'd
> >expect the frames to be treated like broadcast frames by the AP, so it'd
> >be the receiver dropping them in the MAC filter.

> The actual switch from DMA to PIO mode completely reinitializes
> the hardware and drops all queues.

Would it be possible to reinitialize the multicast filter at this point?

   Simon
