Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40588 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2LNPIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 10:08:54 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1998857eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 07:08:53 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Richard =?utf-8?q?R=C3=B6jfors?= <richard.rojfors@gmail.com>
Subject: Re: rtl8192cu in AP mode.
Date: Fri, 14 Dec 2012 16:08:48 +0100
Cc: linux-wireless@vger.kernel.org
References: <1355355956.2744.26.camel@asus> <201212141500.17643.chunkeey@googlemail.com> <1355495150.10239.63.camel@rorics.office.pelagicore.net>
In-Reply-To: <1355495150.10239.63.camel@rorics.office.pelagicore.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212141608.48548.chunkeey@googlemail.com> (sfid-20121214_160859_937043_C85A8D73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 December 2012 15:25:50 Richard Röjfors wrote:
> On Fri, 2012-12-14 at 15:00 +0100, Christian Lamparter wrote:
> > On Friday 14 December 2012 10:08:27 Richard Röjfors wrote:
> > > On Thu, 2012-12-13 at 19:30 +0100, Christian Lamparter wrote:
> > > > On Thursday, December 13, 2012 12:45:56 AM Richard Röjfors wrote:
> > > > > I've been playing with an rtl8192 the last days, I want it to act as an
> > > > > access point. It's connected to an ARM9 box.
> > > > > 
> > > > > I'm using the latest compat-wireless, with some additional patches for
> > > > > beacon support.
> > 
> > however, rtl8192cu doesn't generate any beacons
> > <http://comments.gmane.org/gmane.linux.kernel.wireless.general/96712>
> > so the AP mode isn't fully implemented anyway. So, it's a bit
> > pointless to debug the issue any further at this time.
> 
> I applied this patch hoping to get beacon support, it has the effect
> that the clients don't disconnect from the network at least.
> 
> http://www.spinics.net/lists/linux-wireless/msg96128.html

No this patch won't help and should be ignored.
AFAICT, the driver needs to prepare and send a
H2C_CREATEBSS_CMD to the firmware [and it will
take care of beaconing and keep track of the
power-save state of the associated stations].

Regards,
	Chr
