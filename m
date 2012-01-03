Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54518 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2ACNUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 08:20:41 -0500
Date: Tue, 3 Jan 2012 13:20:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103132053.44ade1e3@pyramind.ukuu.org.uk> (sfid-20120103_142046_636629_25793BC5)
In-Reply-To: <4F02F244.6040902@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F0220F5.30309@fastmail.fm>
	<20120103004220.084d61f3@pyramind.ukuu.org.uk>
	<201201031257.47265.oliver@neukum.org>
	<4F02F244.6040902@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> That said, I guess there are more complicated / difficult pieces of
> hardware that might not do that. Is that the case here? Can we detect
> that the firmware needs reloading and have the primary driver "yield" to
> the firmware driver?

That doesn't really make any sense in the way USB works.

However if you've got a system to load and pin firmware *on suspend* and
flush it post resume then you don't actually need special 'firmware'
drivers just a slightly fancier lib/firmware that refcounts and handles
load on suspend/delayed flush.

(and probably a sysctl for cache tuning so that typical small firmwares
get cached on bigger boxes anyway for speed)
