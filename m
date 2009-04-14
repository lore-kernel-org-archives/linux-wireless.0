Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:60245 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZDNQUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 12:20:24 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Fabio Rossi <rossi.f@inwind.it>
Subject: Re: [PATCH 2/3] p54: more SoftLED updates
Date: Tue, 14 Apr 2009 18:20:21 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200903250312.18264.chunkeey@web.de> <200904141712.34220.rossi.f@inwind.it>
In-Reply-To: <200904141712.34220.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200904141820.21965.chunkeey@web.de> (sfid-20090414_182031_017155_723C0370)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 April 2009 17:12:33 Fabio Rossi wrote:
> On Wednesday 25 March 2009, Christian Lamparter wrote:
> 
> > This patch hopefully finishes the SoftLED code:
> > - It adds two more LEDs (rx and radio).
> >   (the FW claims it can support up to 16 LEDs,
> >    but I doubt that any vendor put more than 4 on a board)
> > - update the LEDs in a _delayed_ workqueue.
> >   No one reported any more crashes.
> >   (see: "PATCH] p54: fix race condition in memory management")
> >   So we can stop burning the mm code.
> 
> My device has 2 LEDs and I can see 4 registrations (assoc, tx, rx and radio). 
> Does it make sense to register LEDs which are not available?
Well, trouble is that you can look (with your eyes) at your device and see the
number of LEDs... This is something we cannot do with the driver. 
(Unless we find a EEPROM field which stores the # of LEDs and 
maybe even what they are used for?)

4 is just a "save" guess which should cover most - if not all - customer devices.

Regards,
	Chr
