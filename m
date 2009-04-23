Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33990 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZDWK4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 06:56:54 -0400
Subject: Re: Using wpa_supplicant in D-Bus mode with nl80211 driver
From: Dan Williams <dcbw@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1240475973.30504.1.camel@localhost.localdomain>
References: <1240419177.12282.3.camel@localhost.localdomain>
	 <20090422170852.GA7298@jm.kir.nu>
	 <1240426517.12282.11.camel@localhost.localdomain>
	 <1240441752.14995.8.camel@localhost.localdomain>
	 <1240475973.30504.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 06:58:01 -0400
Message-Id: <1240484281.18245.16.camel@localhost.localdomain> (sfid-20090423_125658_802666_36563851)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-04-23 at 09:39 +0100, Marcel Holtmann wrote:
> Hi Dan,
> 
> > > > > I am trying to use wpa_supplicant in D-Bus mode with the nl80211 driver
> > > > > instead of WEXT. I don't seem to be able to control the from the command
> > > > > line and the -D option doesn't take.
> > > > 
> > > > I would assume you are doing this with NM. You could either change it to
> > > > register the interface (this is not from -D option, but from the D-Bus
> > > > message) with the nl80211 driver or try to build wpa_supplicant without
> > > > WEXT support (which would make the nl80211 wrapper the default one). I
> > > > don't think either of these are yet acceptable as a generic solution,
> > > > but making NM request driver "nl80211,wext" could be a suitable first
> > > > step when moving to wpa_supplicant 0.7.x (this makes wpa_supplicant
> > > > first try with nl80211 and if needed, fall back to WEXT).
> > > 
> > > I am doing manual testing and with ConnMan. However I would prefer to
> > > have a global driver setting "nl80211,wext" that I can give on the
> > > command line and that will then chosen as default if the addInterface
> > > method doesn't give a driver. I really don't need a per interface
> > > setting here.
> > 
> > Um, you can specify a driver for the interface you add in the dbus call
> > for addInterface.  Add a "driver" key to your dict with the driver you
> > want in the value.  Is there a bug with that?
> 
> I know that I can do that. I was just looking for a global configuration
> switch to default to nl80211,wext via D-Bus system activation and not
> via changing the code.

Even with system activation you still need to call addInterface, which
can take the driver.  I still don't quite understand what you're getting
at here, I guess...  When you say "not change code" you mean in the
process that's calling wpa_supplicant?

Dan


