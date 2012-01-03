Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46282 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2ACAqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:46:38 -0500
Date: Tue, 3 Jan 2012 00:47:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: Jack Stone <jwjstone@fastmail.fm>,
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
Message-ID: <20120103004702.0bcabe65@pyramind.ukuu.org.uk> (sfid-20120103_014641_880425_472BB633)
In-Reply-To: <20120103003831.GB17606@srcf.ucam.org>
References: <20120102215028.GA15701@srcf.ucam.org>
	<CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
	<20120102221235.GA16012@srcf.ucam.org>
	<CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
	<20120102222920.GA16160@srcf.ucam.org>
	<CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
	<20120102230037.GA16458@srcf.ucam.org>
	<4F023E6B.2020307@fastmail.fm>
	<20120103001356.GA17183@srcf.ucam.org>
	<8e95c7e3-e9d5-43c4-8e6a-b8d40584cbd6@email.android.com>
	<20120103003831.GB17606@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 3 Jan 2012 00:38:31 +0000
Matthew Garrett <mjg@redhat.com> wrote:

> On Tue, Jan 03, 2012 at 12:22:58AM +0000, Jack Stone wrote:
> 
> > So we have a table of USB ids that list the devices that need firmware drivers. When the uvcvideo driver registers the firmware interface with a USB id that matches the list we load the firmware driver and pass it a "warm start" event so it can cache the firmware.
> > 
> > As long as we can identify the devices that *might* need firmware then we are ok.
> 
> We could do all of this. Or we could just push the responsibility for 
> this specific case back to userspace, and maybe that's what I should 
> have done in the first place.

My guess is this

For small firmware and most devices we ought to just grab the firmware on
module load, drop it on module unload. Whoopee its 8K or so.

For the really big horrors where we can be fairly sure its not part of a
critical path like big DVB firmware or 3G modems like qcserial then user
space.

and pray there are none that are large and problematic (eg iscsi, wireless
or some other similar sort of suspect)


Going back to loading the small firmwares at module load is exactly the
same as when they were compiled in, which didn't seem to cause much pain.

Alan
