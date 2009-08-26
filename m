Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:59152 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZHZHZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 03:25:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 1/1] iwmc3200: add more SDIO device ids
Date: Wed, 26 Aug 2009 09:25:03 +0200
Cc: Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <1251149659-32212-1-git-send-email-tomas.winkler@intel.com> <1ba2fa240908241520q5be2060co145ec0745954dcf0@mail.gmail.com> <1251156118.2950.82.camel@localhost.localdomain>
In-Reply-To: <1251156118.2950.82.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908260925.03437.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 August 2009 01:21:58 Marcel Holtmann wrote:
> My personal vote is for keeping all IDs inside the drivers.
> And I also prefer to keep the plain hex values and just put a
> comment above them which device this is. Something like this:
>
> static struct usb_device_id btusb_table[] = {
> 	/* Generic Bluetooth USB device */
> 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },

+1

When I have an unknown device (and not compiled all modules) it's 
so much easier to do an

grep -ri 057c drivers/usb

then to do the same on include/ and then again to find the driver 
that uses this id. For the same reason, I prefer 0x057c in the 
source and not 0x57c.

-- 
http://www.holgerschurig.de
