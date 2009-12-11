Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34314 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761309AbZLKWhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 17:37:08 -0500
Date: Fri, 11 Dec 2009 23:37:09 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Message-ID: <20091211233709.29fc5312@strolchi.home.s3e.de>
In-Reply-To: <1260559270.6254.2.camel@localhost.localdomain>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
	<20091211133603.46bec686@strolchi.home.s3e.de>
	<20091211144221.GA6663@tuxdriver.com>
	<20091211160124.4db2da76@strolchi.home.s3e.de>
	<1260559270.6254.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 11 Dec 2009 11:21:10 -0800
Dan Williams <dcbw@redhat.com> wrote:

> On Fri, 2009-12-11 at 16:01 +0100, Stefan Seyfried wrote:
> > Maybe a separate driver that is ejecting all those fake storage
> > devices, be it 3G modems or wireless LAN might be a good idea, but I am
> > probably not the right one to code that ;)
> > Or maybe we decide that userspace should handle it for all devices...
> 
> If the device actually changes USB IDs after the switch, then the right

Yes, it does.

> place to put this code is probably unusual_devs instead of
> touching /two/ drivers.  I'd say extract the code from zd1211rw and put
> the new code that works for both zd1211rw/ar9170 into unusual_devs.  In
> fact, people might be happier if you posted two patches, (1) move the
> code to unusual_devs unchanged, and (2) fix up the moved code to support
> the new device's behavior.

Ok, I'll do this next week (might take some time, since I need to get
familiar with the usb / unusual_devs code). I guess this will mostly go
through Greg then?

John, please take the patch 1, that adds the USB ID to ar9170usb. It is
useful on its own since the device can also be switched with
usb_modeswitch from userspace, and it is really trivial.

Thanks,

	Stefan
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
