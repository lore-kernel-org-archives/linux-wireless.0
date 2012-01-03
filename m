Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47412 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab2ACAmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:42:03 -0500
Date: Tue, 3 Jan 2012 00:42:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Matthew Garrett <mjg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103004220.084d61f3@pyramind.ukuu.org.uk> (sfid-20120103_014222_477086_FF33E216)
In-Reply-To: <4F0220F5.30309@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
	<CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
	<20120102211904.GA15316@srcf.ucam.org>
	<4F0220F5.30309@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Can we tell by the USB ids that this is a device that might need
> firmware and load it into memory anyway - it would use more memory but
> would always work as we would have the firmware.

Only by wasting a lot of memory in some cases. For the majority of cases
however yes you can take a good guess that id X might need firmware Y and
the firmware will only be a few K.

In that case however you don't want some generic firmware module knowing
all this crap, your driver can just request_firmware() the stuff as
modprobe and free it up on the module unload. For a typical 8bit firmware
of a few K you'll free a ton more memory unloading the module than the
firmware ! That I think actually covers the majority of devices under
discussion.

For the giant-firmware cases, it's unworkable on small devices - but they
are special cases anyway and almost entirely video - so not currently
ones that cause a problem unless you are doing RFC4824 in which case your
nearest asylum should be consulted.

Alan
