Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:36100 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbZDTTTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 15:19:49 -0400
Message-ID: <49ECCABE.40805@lwfinger.net> (sfid-20090420_211952_020915_53571E1A)
Date: Mon, 20 Apr 2009 14:19:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Jack Schneider <puck@dp-indexing.com>,
	"linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Problem with exclusive interrupt in hostap_cs
References: <20090420101340.142b6bc6@dp-indexing.com>
In-Reply-To: <20090420101340.142b6bc6@dp-indexing.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni,

This was posted on the PCMCIA mailing list by Jack Schneider:

> Hi, folks  Using Debian Lenny OS with 2.6.28.2-486 kernel.
> I have a very old DEC VP575 laptop which I want to use as back-up
> server.  I need two net connections.  When I use a single pccard,
> wired, all is well.  If I insert my second card, WIFI-Intersil Prism2.5 
> I get the following /var/log/messages error:
> pcmcia: request for exclusive IRQ couuld not be fulfilled.
> pcmcia: the driver needs updating to supported shared IRQ lines

The two drivers being loaded are hostap_cs and xirc2ps_cs. The latter one is
coded to handle shared interrupts, but hostap_cs is not.

I would have no problem changing the driver interrupt registration in the
link->irq structure, but I was not quite sure how change prism2_interrupt() to
detect the shared case when the interrupt status register is 0xFFFF.

Could you please take a look at this?

Thanks,

Larry

