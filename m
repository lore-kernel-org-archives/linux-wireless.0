Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58704 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2ACA6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:58:14 -0500
Date: Tue, 3 Jan 2012 00:58:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Marek Vasut <marek.vasut@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20120103005839.618af359@pyramind.ukuu.org.uk> (sfid-20120103_015831_503436_86AE0AAC)
In-Reply-To: <c163595a-163e-4e68-ba0f-de5ca58e8de9@email.android.com>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<201201022331.27562.marek.vasut@gmail.com>
	<4F023D02.1030403@fastmail.fm>
	<201201030131.15397.marek.vasut@gmail.com>
	<c163595a-163e-4e68-ba0f-de5ca58e8de9@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >Hm ... and we can't have memory type that "can be swapped-out, but must
> >be 
> >loaded back before suspend" in kernel, right?
> 
> Nope. Kernel swapping is a big headache and Linux doesn't do it. The only thing we can do is drop any clean cache pages, but that has performance implications.

You could however have an arrangement where the firmware refmanager does
a list of request_firmware()s at the very start of the suspend process. It
cannot be done during suspend for obvious reasons (sorry I already
suspended the hard disk) but it can be done just before.

In that case with get/put_firmware you'd just need to extend the API to

	get_firmware()
	put_firmware()
	get_for_suspend_firmware()

and a driver might do something like


module_init

	fw = get_for_suspend_firmware("wombatdepolariser.fw");
	

open:  /* just optimising */
	kref_get(&fw->kref);

close:
	put_firmware(fw);


module_unload:
	put_firmware(fw);


Now the uglier side of that is how you make sure that if
get_for_suspend_firmware() works that when we suspend the firmware is
present. We could keep the file handle open but that might block unmounts
or we could assume that as its superuser stuff that the distro authors
don't screw up - in which case we'd refuse to suspend with a nasty
complaint if the firmware turned out to have been deleted behind our back.

You'd also have to be in situation where new device probes were not
processed but userspace (eg the fw loader helper) were still running.

That seems to me to be a useful optimisation project for bigger firmwares
but not something to implement on day 1 ?

Alan
