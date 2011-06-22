Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33369 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab1FVCYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 22:24:45 -0400
Subject: Re: [RFC][PATCH v2 2/7] NFC: add nfc subsystem core
From: Marcel Holtmann <marcel@holtmann.org>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Date: Tue, 21 Jun 2011 19:24:32 -0700
In-Reply-To: <20110621215551.GF2628@joana>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1308592212-5755-3-git-send-email-aloisio.almeida@openbossa.org>
	 <20110621215551.GF2628@joana>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1308709475.2196.67.camel@aeonflux> (sfid-20110622_042448_579340_5CC491E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gustavo,

> > The NFC subsystem core is responsible for providing the device driver
> > interface. It is also responsible for providing an interface to the control
> > operations and data exchange.

<snip>

> > +config NFC_DEBUG
> > +	bool "NFC verbose debug messages"
> > +        depends on NFC
> > +        help
> > +	  Say Y here if you want the NFC core and drivers to produce a bunch
> > +	  of debug messages to the system log. Select this if you are having a
> > +	  problem with NFC support and want to see more of what is going on.
> 
> I think that use only dynamic debug is a lot nicer. I don't see a point to
> have a NFC debug option in Kconfig. We've been using dynamic debug in the
> Bluetooth subsystem for a while and it works fine. If we have dynamic debug
> there is no need to recompile a module to add debug support to it.
> 
> Also it's a good idea use macros for pr_debug, instead of calling it every
> time with the same paramenters (__func__, for example). In the Bluetooth
> subsystem we do like this:
> 
> #define BT_INFO(fmt, arg...) printk(KERN_INFO "Bluetooth: " fmt "\n" , ## arg)
> #define BT_ERR(fmt, arg...)  printk(KERN_ERR "%s: " fmt "\n" , __func__ , ##
> arg)
> #define BT_DBG(fmt, arg...)  pr_debug("%s: " fmt "\n" , __func__ , ## arg)

I would clearly second this. Switching the Bluetooth subsystem to
dynamic debug made so many things so much easier. And using a macro like
NFC_DBG makes it pretty nice and clean.

Regards

Marcel


