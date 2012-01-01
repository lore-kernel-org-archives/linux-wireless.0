Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41261 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab2AAUjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jan 2012 15:39:20 -0500
Date: Sun, 1 Jan 2012 20:39:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Matthew Garrett <mjg@redhat.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120101203945.0ebc2f55@pyramind.ukuu.org.uk> (sfid-20120101_214002_742691_97CE0DEA)
In-Reply-To: <201201011732.23069.marek.vasut@gmail.com>
References: <20111230235421.GA6054@redhat.com>
	<201201011054.47233.marek.vasut@gmail.com>
	<201201011328.41311.oliver@neukum.org>
	<201201011732.23069.marek.vasut@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Device IDs can morph due to a power loss. After resumption another driver
> > would bind.
> 
> What do you mean? I don't think I quite follow.

Lots of USB hardware appears as one device id when powered on, then when
the firmware is loaded turns into something else that becomes relevant to
the user.

So on powerup your wireless card goes

	'I've no idea what I am, feed me firmware for this id"

when it gets the firmware it disconnects, reconnects and says

	"I am a USB wireless card with this id"

When you suspend the power gets killed so the device loses its firmware
and goes back to being a firmware requesting thing on resume.

Worse still - you don't easily know if the device is in fact new and was
added while suspended, or was always there.

So for those devices you do need to load the firmware into them
automatically after the resume to work out what they are and get the MAC
to see if its the same wireless card or not.


Alan
