Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39976 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2ABXxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 18:53:25 -0500
Date: Mon, 2 Jan 2012 23:53:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20120102235342.5ebcad41@pyramind.ukuu.org.uk> (sfid-20120103_005343_532360_D4058864)
In-Reply-To: <4F02165C.1060400@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 02 Jan 2012 20:41:00 +0000
Jack Stone <jwjstone@fastmail.fm> wrote:

> On 02/01/12 16:54, Alan Stern wrote:
> > What Oliver and I have been discussing is delaying the probe call until
> > after resume is finished, when userspace is back up and everything is
> > operating normally again.  It would be more awkward than the current
> > code, but it definitely can be done.
> 
> What about the case where the firmware that needs to be loaded is on the
> USB device that needs the firmware. This can be resolved at boot using
> an initrd but at resume time we don't have that.

There is a very simple answer to such conflicts - don't do it. If you
have firmware you need to reload to get stuff back which might form a
dependancy chain then cache it for the lifetime of the device being in
use. You will never sanely compute that dependancy chain IMHO (although
by all means prove me wrong!) given it might involve things like firmware
over raid over iscsi over nfs over a usb wireless link...

We have the same theoretical problem btw with kernel modules. if they are
on a usb device you need the driver loaded and kept loaded while the
driver is in use - we just happen to do that right anyway so it works
fine.

Alan
