Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41512 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2ACNge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 08:36:34 -0500
Date: Tue, 3 Jan 2012 13:36:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jack Stone <jwjstone@fastmail.fm>,
	Matthew Garrett <mjg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103133656.56646781@pyramind.ukuu.org.uk> (sfid-20120103_143652_793830_79AFED4F)
In-Reply-To: <201201031430.26064.oliver@neukum.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02F244.6040902@fastmail.fm>
	<20120103132053.44ade1e3@pyramind.ukuu.org.uk>
	<201201031430.26064.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> How so? You still need to get the firmware to the device before
> you unfreeze user space to get a benefit from this. Having it in
> RAM is only half the deal.

And this can be handled by the existing drivers happily as they do now
rather than centralised in some kind of giant firmware turd that will be
horrible to maintain.

The driver visible differences will be

- you can take a reference to a firmware to ensure it will be there at
  resume
- an actual grab and use of that firmware during resume will not block


Alan
