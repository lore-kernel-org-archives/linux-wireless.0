Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35753 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2CJAWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 19:22:00 -0500
Received: by wejx9 with SMTP id x9so1519051wej.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 16:21:59 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/5 V2] p54usb: Load firmware from work queue and not from probe routine
Date: Sat, 10 Mar 2012 01:21:53 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1331267337-19605-1-git-send-email-Larry.Finger@lwfinger.net> <201203092245.14420.chunkeey@googlemail.com> <4F5A9612.8040301@lwfinger.net>
In-Reply-To: <4F5A9612.8040301@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201203100121.54274.chunkeey@googlemail.com> (sfid-20120310_012205_437061_C64698ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 March 2012 00:45:22 Larry Finger wrote:
> On 03/09/2012 03:45 PM, Christian Lamparter wrote:
> > On Friday, March 09, 2012 05:28:57 AM Larry Finger wrote:
> >> Drivers that load firmware from their probe routine have problems with the
> >> latest versions of udev as they get timeouts while waiting for user
> >> space to start. The problem is fixed by loading the firmware and starting
> >> mac80211 from a work queue. By using this method, most of the
> >> original code is preserved.
> >>
> >> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> >> ---
> > Well, I thought this over and I think unless we change the Kconfig
> > and make the backend modules [p54pci, p54usb and p54spi]
> > module-only options, we have to go with request_firmware_nowait.
> >
> > You see, if the p54* modules are compiled into the very bzImage:
> > The instant workqueue option wouldn't work because the device
> > might be initialized before the filesystem is. A combo approach
> > [delayed workqueue, when no userspacehelper is available and a
> > direct call to request_firmware (when it is availabe)] would
> > work too, but then we would be reimplementing
> > request_firmware_nowait ...
> 
> Christian,
> 
> Your point is well taken. I will rewrite this one. John was
> holding it for 3.5 anyway.
Thanks, I really appreciate your help. In the meantime. I'll try
to talk some sense into the pcmcia and firmware_class people [or
they talk some sense into me ;)].

> Do we still want to try for the legacy firmware if the primary
> is not available?
It's not like we drop support for legacy firmware, I just want to
get rid of the confusing name [The first generation usb devices
uses a isl3886 chip too [behind a net2280 pci<->usb bridge]. So
people tried to use the usb firmwares with pcmcia/pci cards -
needless to say that didn't work]. Of course, this wasn't the only
reason why I hated the idea of having them in the first place, so
while I lost the argument back then... At least I managed to keep
the legacy firmware names from being listed by modinfo.
So officially we "never" really claimed we know them :-D.

Regards,
	Christan
