Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39964 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2ABXuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 18:50:39 -0500
Date: Mon, 2 Jan 2012 23:50:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jack Stone <jwjstone@fastmail.fm>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg@redhat.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120102235044.23935096@pyramind.ukuu.org.uk> (sfid-20120103_005116_568271_29E5ECEB)
In-Reply-To: <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
	<CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So the only thing we need is to fix the braindamaged firmware
> interfaces. We need caching, and we need to replace (or at least
> extend) "load_firware()" with "[get|put]_firmware()".

So at what moment after a resume does a firmware that was in use with a
device go away and what do we do about devices inserted while suspended ?

Remembering that

- there is no moment when USB says 'we have finished re-enumeration'.
  There is no point at which you can say 'we have finished
  re-enumeration, we are now starting on enumeration of new stuff'. New
  stuff wanting firmware will pop up on resume mixed in with old stuff.

- we don't seem to have any device or bus infrastructure for doing a
  'post resume' purge of such data if we could decide when that moment
  is ?

Alan
