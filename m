Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45340 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZDVXII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 19:08:08 -0400
Subject: Re: Using wpa_supplicant in D-Bus mode with nl80211 driver
From: Dan Williams <dcbw@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1240426517.12282.11.camel@localhost.localdomain>
References: <1240419177.12282.3.camel@localhost.localdomain>
	 <20090422170852.GA7298@jm.kir.nu>
	 <1240426517.12282.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 19:09:12 -0400
Message-Id: <1240441752.14995.8.camel@localhost.localdomain> (sfid-20090423_010814_139577_1AF283AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-04-22 at 19:55 +0100, Marcel Holtmann wrote:
> Hi Jouni,
> 
> > > I am trying to use wpa_supplicant in D-Bus mode with the nl80211 driver
> > > instead of WEXT. I don't seem to be able to control the from the command
> > > line and the -D option doesn't take.
> > 
> > I would assume you are doing this with NM. You could either change it to
> > register the interface (this is not from -D option, but from the D-Bus
> > message) with the nl80211 driver or try to build wpa_supplicant without
> > WEXT support (which would make the nl80211 wrapper the default one). I
> > don't think either of these are yet acceptable as a generic solution,
> > but making NM request driver "nl80211,wext" could be a suitable first
> > step when moving to wpa_supplicant 0.7.x (this makes wpa_supplicant
> > first try with nl80211 and if needed, fall back to WEXT).
> 
> I am doing manual testing and with ConnMan. However I would prefer to
> have a global driver setting "nl80211,wext" that I can give on the
> command line and that will then chosen as default if the addInterface
> method doesn't give a driver. I really don't need a per interface
> setting here.

Um, you can specify a driver for the interface you add in the dbus call
for addInterface.  Add a "driver" key to your dict with the driver you
want in the value.  Is there a bug with that?

Dan

> > > Can we fix this somehow? I really wanna get rid of using WEXT.
> > 
> > There still one remaining WEXT operation even with driver_nl80211.c in
> > wpa_supplicant, so we are not yet there, but there is work going on in
> > getting that added to nl80211 after which point -Dnl80211 (or
> > -Dnl80211,wext for more likely distro use) should allow this goal to be
> > met.
> 
> Fair enough, but we are getting there and when testing, I like to be
> using as much nl80211 as possible.
> 
> Regards
> 
> Marcel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

