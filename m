Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49550 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbZGENYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 09:24:23 -0400
Date: Sun, 5 Jul 2009 10:24:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: prep for rfkill API changes
Message-ID: <20090705132422.GA30334@khazad-dum.debian.net>
References: <1246798266.4411.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1246798266.4411.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 05 Jul 2009, Johannes Berg wrote:
> We've designed the /dev/rfkill API in a way that we
> can increase the event struct by adding members at
> the end, should it become necessary. To validate the
> events, userspace and the kernel need to have the
> proper event size to check for -- when reading from
> the other end they need to verify that it's at least
> version 1 of the event API, with the current struct
> size, so define a constant for that and make the
> code a little more 'future proof'.
> 
> Not that I expect that we'll have to change the event
> size any time soon, but it's better to write the code
> in a way that lends itself to extending.
> 
> Due to the current size of the event struct, the code
> is currently equivalent, but should the event struct
> ever need to be increased the new code might not need
> changing.

This is good, but not complete.  Changes to the API that don't change the
size (or those which reduces it) are a problem: they are impossible with a
schema that detects API version by the size alone.

Maybe a new field with a API serial number should be added right _now_ while
it is still not too painful to do it?  This would be V2 of the API
(detectable by the size change), but there aren't many users yet, so the
effort to support it would not be daunting.

You can also publish the API version through a read-only sysfs attribute or
a separate IOCTL... it doesn't really need to be in-band (although in-band
is a lot better).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
