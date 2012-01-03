Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:36505 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2ACN2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 08:28:41 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Tue, 3 Jan 2012 14:30:25 +0100
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
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F02F244.6040902@fastmail.fm> <20120103132053.44ade1e3@pyramind.ukuu.org.uk>
In-Reply-To: <20120103132053.44ade1e3@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201031430.26064.oliver@neukum.org> (sfid-20120103_142858_443200_AFF8B0F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 3. Januar 2012, 14:20:53 schrieb Alan Cox:
> > That said, I guess there are more complicated / difficult pieces of
> > hardware that might not do that. Is that the case here? Can we detect
> > that the firmware needs reloading and have the primary driver "yield" to
> > the firmware driver?
> 
> That doesn't really make any sense in the way USB works.
> 
> However if you've got a system to load and pin firmware on suspend and
> flush it post resume then you don't actually need special 'firmware'
> drivers just a slightly fancier lib/firmware that refcounts and handles
> load on suspend/delayed flush.

How so? You still need to get the firmware to the device before
you unfreeze user space to get a benefit from this. Having it in
RAM is only half the deal.

	Regards
		Oliver
