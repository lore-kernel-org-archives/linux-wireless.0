Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44764 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab1LaOZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Dec 2011 09:25:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Rgzrv-00025N-3n
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 15:25:07 +0100
Received: from pD9F88DF8.dip.t-dialin.net ([217.248.141.248])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 31 Dec 2011 15:25:07 +0100
Received: from drahemmaps by pD9F88DF8.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 31 Dec 2011 15:25:07 +0100
To: linux-wireless@vger.kernel.org
From: Martin Schleier <drahemmaps@gmx.net>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sat, 31 Dec 2011 14:20:26 +0000 (UTC)
Message-ID: <loom.20111231T150655-670@post.gmane.org> (sfid-20111231_152538_164806_0A4D7CFA)
References: <20111230235421.GA6054@redhat.com> <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds <torvalds@...> writes:
> On Fri, Dec 30, 2011 at 3:54 PM, Dave Jones <davej@...> wrote:
> > We're getting a bunch of reports against Fedora 16
> > (still using 3.1) which look like some drivers are trying to
> > load firmware on resume from suspend, while usermodehelper
> > is disabled.
> 
> Ok, buggy drivers. You *must*not* load firmware in your resume path,
> since there is no actual guarantee that any particular device will be
> resumed after the disk that contains the firmware images.
> 
> So it's very simple: drivers that load firmware at resume time are
> buggy. No ifs, buts, or maybes about it.
Or are they?

You see, PCMCIA cards [don't know about the pccard express stuff]
have to deal with a notable exception from this rule since:

pcmcia: improve check for same card in slot after resume
"88b060d6c03fcb9e4d2018b4349954c4242a5c7f"

This patch changed the way how suspend/resume is handled.
On resume, the pcmcia subsystem obviously does not know
if the card has been removed and reinserted, therefore
it does not call the resume method of the driver but
instead goes for "probe" and things go south from there.

[And now for the $64 question, what happens to USB drivers
that are managing devices which are connected to pcmcia
usb host cards?]

