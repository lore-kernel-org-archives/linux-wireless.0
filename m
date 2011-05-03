Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:31082 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750748Ab1ECMxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 08:53:10 -0400
Message-ID: <484421.61252.qm@web161619.mail.bf1.yahoo.com> (sfid-20110503_145331_203318_B432AC5B)
Date: Tue, 3 May 2011 05:53:09 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DBF574E.80309@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Just an update, this driver has been solid so far:
> > rt2870sta
> > 
> > With the Media Link 150 USB stick, not a single crash
> yet--
> > The rt2800usb driver is laggy and crashes the kernel
> (as of 2.6.38.x)--
> > Is there a possiblity to get rtl2870sta into the
> mainline?
> 
> Not a chance. As of 2.6.39, it is gone.
> 
> > It is the best wireless driver I've used for Linux
> with various usb wifi
> > adapters--
> 
> That driver was in staging because it does not use
> mac80211, which is an absolute requirement for a new
> mainline driver. Keeping things like rt2870sta that contain
> their own MAC layer just bloats the kernel and has code
> persist that no one really understands.
> 
> Please try the version of rt2800usb from compat-wireless
> with the latest firmware. If it still crashes the kernel,
> then post the bugs.
> 
> Larry

I agree to some extent that rt2870sta performs better compared to rt2800usb, as of now. However, significant strides have been made towards improving the rt2800usb as it pertains to these chips and I'm sure in due time, problems will be resolved.

The staging driver had to be removed in part because it collided with the rt2800usb, which in essence constitutes a race condition between the two drivers. When you plug your USB dongle, both of them load and both of them try to service your chip. The result isn't pretty. You have to manually blacklist one to enable the other to operate properly.

Now, if you're bent on using the staging driver, you can always grab it from Ralink's web site and ignore the future default rt2800usb.


Walter
