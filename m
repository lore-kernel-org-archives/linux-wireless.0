Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43977 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbZHXXWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 19:22:39 -0400
Subject: Re: [PATCH 1/1] iwmc3200: add more SDIO device ids
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
In-Reply-To: <1ba2fa240908241520q5be2060co145ec0745954dcf0@mail.gmail.com>
References: <1251149659-32212-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890908241436o5f30cfe6xa7bdda8b25ac082@mail.gmail.com>
	 <1ba2fa240908241520q5be2060co145ec0745954dcf0@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 16:21:58 -0700
Message-Id: <1251156118.2950.82.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> add WiFi BGN SKU and WiMAX 2.4GHz SKU device ids
> >>
> >> Cc:inaky.perez-gonzalez@intel.com
> >> Cc:cindy.h.kao@intel.com
> >> Cc:yi.zhu@intel.com
> >> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> >
> > Since it seems we are preferring to not do this for PCI for cases
> > where the ID will only be used for 1 device perhaps its best to remove
> > all those ids and stuff them directly into the intel driver itself
> > that will use it.
> >
> I don't have strong opinion about it but this is the current habit
> IIRC there was a mail thread that explicitly asked to move SDIO IDs
> there,  of course I cannot locate it right now :(

first thing is that IDs should only be added if there are users for it.
I am missing the patches that are actually using them. Send them all
together.

Second, we have to establish what is the preferred method of IDs for the
SDIO subsystem. In general I would prefer we have a global policy for
this, but in reality it is up to the subsystem maintainers.

My personal vote is for keeping all IDs inside the drivers. And I also
prefer to keep the plain hex values and just put a comment above them
which device this is. Something like this:

static struct usb_device_id btusb_table[] = {
	/* Generic Bluetooth USB device */
	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },

	/* AVM BlueFRITZ! USB v2.0 */
	{ USB_DEVICE(0x057c, 0x3800) },

	{ }	/* Terminating entry */
};

Regards

Marcel


