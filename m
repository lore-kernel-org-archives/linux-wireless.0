Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63466 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965370Ab2CPVv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 17:51:26 -0400
Received: by wibhq7 with SMTP id hq7so1467744wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2012 14:51:24 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/5 V2] p54usb: Load firmware from work queue and not from probe routine
Date: Fri, 16 Mar 2012 22:51:20 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1331267337-19605-1-git-send-email-Larry.Finger@lwfinger.net> <4F5A9612.8040301@lwfinger.net> <201203100121.54274.chunkeey@googlemail.com>
In-Reply-To: <201203100121.54274.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201203162251.20440.chunkeey@googlemail.com> (sfid-20120316_225131_205092_A136D011)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 March 2012 01:21:53 Christian Lamparter wrote:
> On Saturday 10 March 2012 00:45:22 Larry Finger wrote:
> > On 03/09/2012 03:45 PM, Christian Lamparter wrote:
> > > On Friday, March 09, 2012 05:28:57 AM Larry Finger wrote:
> > >> Drivers that load firmware from their probe routine have problems with the
> > >> latest versions of udev as they get timeouts while waiting for user
> > >> space to start. The problem is fixed by loading the firmware and starting
> > >> mac80211 from a work queue. By using this method, most of the
> > >> original code is preserved.
> > >>
> > >> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> > >> ---
> > > Well, I thought this over and I think unless we change the Kconfig
> > > and make the backend modules [p54pci, p54usb and p54spi]
> > > module-only options, we have to go with request_firmware_nowait.
> > >
> > > You see, if the p54* modules are compiled into the very bzImage:
> > > The instant workqueue option wouldn't work because the device
> > > might be initialized before the filesystem is. A combo approach
> > > [delayed workqueue, when no userspacehelper is available and a
> > > direct call to request_firmware (when it is availabe)] would
> > > work too, but then we would be reimplementing
> > > request_firmware_nowait ...
> > 
> > Christian,
> > 
> > Your point is well taken. I will rewrite this one. John was
> > holding it for 3.5 anyway.
> Thanks, I really appreciate your help. In the meantime. I'll try
> to talk some sense into the pcmcia and firmware_class people [or
> they talk some sense into me ;)].
Just a heads up: [No, I haven't forgotten about this]

While my patches certainly caused some "noise" @ lkml. So far
there hasn't been any progress about request_firmware_nowait.
I'll keep at it but it could take a while longer...
In the meantime: I think we could get atleast fix p54pci and friends.
Larry, what do you say?

And John:
Would you accept the patches? even though they need the listed
pcmcia and firmware_class fixes in order to work
[without those, on resume you get WARNINGs and an you need to
reload the driver/replug the device]

Regards,
	Chr
