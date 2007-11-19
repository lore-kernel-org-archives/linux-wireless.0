Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbXKSRgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 12:36:08 -0500
Subject: Re: 88w8335 [Libertas] 802.11b/g
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200711190934.59367.hs4233@mail.mn-solutions.de>
References: <43e72e890711161733o72b557ccs63fa1c0104bc656a@mail.gmail.com>
	 <200711190934.59367.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 12:32:38 -0500
Message-Id: <1195493558.3248.11.camel@localhost.localdomain> (sfid-20071119_173630_533582_BFA83AFD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-11-19 at 09:34 +0100, Holger Schurig wrote:
> > vendor:device -- 11ab:1faa
> >
> > libertas_cs isn't picking up though.
> 
> libertas wasn't written for 8335 chips. The whole of libertas, 
> including "if_cs.c", is currently only for 8385 chips.
> 
> I saw a driver for 8335 chips at 
> http://david.woodhou.se/mrv.tar.gz. Do you refer to the same 
> one?

There's also mrv8k which apparently Ubuntu is shipping (although it
doesn't work).  Google around for it.  OpenSolaris and OpenBSD have the
'malo(4)' driver for this part, including the 8310 and 8335 chips.

I also picked up a cardbus card with an 8300 or 8335 in it this past
week.  (TrendNET branded).  I cleaned it up for There are problems with
the mrv8k driver where it appears to panic in the interrupt handler.

The 8335 is a _softmac_ part and therefore won't work (ever) with the
current libertas driver, which is a fullmac part.  The best solution is
to write a new mac80211 driver for the 8335 parts.

The firmware situation is a lot like the broadcom parts where you need a
firmware cutter to pull firmware out of the Windows .sys driver file.
Two firmware are required, the boot firmware and the main firmware.

Dan

> As this driver was originally written for mac80211, I'd prefer it 
> over a driver/net/wireless/libertas based driver, e.g. via an 
> hyptothetical "if_pci.c". Maybe you need to dust of a bit of 
> bitrot. Maybe it's even worth pushing this driver into shape and 
> submitting it to Linville for kernel adoption.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

