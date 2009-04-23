Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34904 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbZDWLP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 07:15:58 -0400
Subject: Re: Using wpa_supplicant in D-Bus mode with nl80211 driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1240484281.18245.16.camel@localhost.localdomain>
References: <1240419177.12282.3.camel@localhost.localdomain>
	 <20090422170852.GA7298@jm.kir.nu>
	 <1240426517.12282.11.camel@localhost.localdomain>
	 <1240441752.14995.8.camel@localhost.localdomain>
	 <1240475973.30504.1.camel@localhost.localdomain>
	 <1240484281.18245.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 12:15:52 +0100
Message-Id: <1240485352.15894.3.camel@localhost.localdomain> (sfid-20090423_131611_377917_54FDE223)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > > > > > I am trying to use wpa_supplicant in D-Bus mode with the nl80211 driver
> > > > > > instead of WEXT. I don't seem to be able to control the from the command
> > > > > > line and the -D option doesn't take.
> > > > > 
> > > > > I would assume you are doing this with NM. You could either change it to
> > > > > register the interface (this is not from -D option, but from the D-Bus
> > > > > message) with the nl80211 driver or try to build wpa_supplicant without
> > > > > WEXT support (which would make the nl80211 wrapper the default one). I
> > > > > don't think either of these are yet acceptable as a generic solution,
> > > > > but making NM request driver "nl80211,wext" could be a suitable first
> > > > > step when moving to wpa_supplicant 0.7.x (this makes wpa_supplicant
> > > > > first try with nl80211 and if needed, fall back to WEXT).
> > > > 
> > > > I am doing manual testing and with ConnMan. However I would prefer to
> > > > have a global driver setting "nl80211,wext" that I can give on the
> > > > command line and that will then chosen as default if the addInterface
> > > > method doesn't give a driver. I really don't need a per interface
> > > > setting here.
> > > 
> > > Um, you can specify a driver for the interface you add in the dbus call
> > > for addInterface.  Add a "driver" key to your dict with the driver you
> > > want in the value.  Is there a bug with that?
> > 
> > I know that I can do that. I was just looking for a global configuration
> > switch to default to nl80211,wext via D-Bus system activation and not
> > via changing the code.
> 
> Even with system activation you still need to call addInterface, which
> can take the driver.  I still don't quite understand what you're getting
> at here, I guess...  When you say "not change code" you mean in the
> process that's calling wpa_supplicant?

that is exactly what I mean. So to switch NM to use nl80211 you would
have to change the NM code. I prefer to have this a command line option
so people can turn it back to wext in case something breaks. Or a vendor
driver for that matter (not that I care about these).

Regards

Marcel


