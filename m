Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33836 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYH0E4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 00:56:30 -0400
Date: Wed, 27 Aug 2008 01:56:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <gregkh@suse.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Message-ID: <20080827045624.GA21804@khazad-dum.debian.net> (sfid-20080827_065634_727886_46047144)
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <1219762681-26911-6-git-send-email-hmh@hmh.eng.br> <20080826153948.GA18563@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080826153948.GA18563@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Aug 2008, Greg KH wrote:
> > Drivers that need rfkill's older behaviour will have to implement it by
> > themselves in their own suspend handling.
[...]

> > The following drivers need to check if they need to explicitly block
> > their transmitters in their own suspend handlers (maintainers Cc'd):
> 
> Normally when you change a kernel-api to operate differently, you also
> fix up the relevant parts of the kernel as well.  Have you looked into

That requires one to actually KNOW the details of the relevant parts of the
kernel.  In this case, the particular needs of several devices and their
device drivers.

Which I don't, for many of them.

> these drivers to see if they do have this problem or not?

Those I know enough to be 100% certain that do not need it (or actually
REQUIRE it not to happen, like libertas) have not been added to the CC.
There were none I could be 100% certain that would need the toggle_radio
call (if there were, they would have been fixed by the patch as well).

For all the others that I am not sure of, I CC'd the maintainers.  If any of
them reply indicating that they need the explicit toggle_radio() call, we
can add such changes to the patch (or in a future patch).  I consider this
equivalent to emailing everyone and asking about it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
