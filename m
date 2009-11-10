Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40715 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZKJNpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 08:45:16 -0500
Date: Tue, 10 Nov 2009 08:34:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT 6/6] rtl8187se: Modify Kconfig and Makefile
Message-ID: <20091110133407.GA12682@tuxdriver.com>
References: <4af8a64a.OAu73X3xIXLBXo18%Larry.Finger@lwfinger.net> <1257844855.26914.1.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257844855.26914.1.camel@violet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2009 at 10:20:55AM +0100, Marcel Holtmann wrote:
> Hi Larry,
> 
> > Modify configuration and builod system for rtl8187se.
> > 
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > ---
> > 
> > Index: wireless-testing/drivers/net/wireless/Kconfig
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/Kconfig
> > +++ wireless-testing/drivers/net/wireless/Kconfig
> > @@ -294,6 +294,16 @@ config RTL8187_LEDS
> >  	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
> >  	default y
> >  
> > +config RTL8187SE
> > +	tristate "Realtek 8187SE PCI support"
> > +	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
> > +	select EEPROM_93CX6
> > +	---help---
> > +	  This is a driver for RTL8187SE PCI-based cards. If built as a
> > +	  module, it will be named rtl8187se.
> > +
> > +	  Thanks to Realtek for their support!
> 
> does this really belong into the help text. Having it in the copyright
> header seems enough. Especially since this help text is not offering any
> additional advice or information for the user.

FWIW, I think Larry basically copied that from the other Realtek
entries.  But you are right, it should probably be gone...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
