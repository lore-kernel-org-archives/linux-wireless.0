Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51235 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ABX7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 18:59:49 -0500
Date: Tue, 3 Jan 2012 00:00:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg@redhat.com>,
	Jack Stone <jwjstone@fastmail.fm>,
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
Message-ID: <20120103000016.640012da@pyramind.ukuu.org.uk> (sfid-20120103_010047_048602_224DE61A)
In-Reply-To: <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
	<CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
	<20120102211904.GA15316@srcf.ucam.org>
	<CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2 Jan 2012 13:27:03 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jan 2, 2012 at 1:19 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > On Mon, Jan 02, 2012 at 12:48:48PM -0800, Linus Torvalds wrote:
> >
> >> Why are you guys making it any more complicated than that?
> >
> > Because it's inadequate. You can't guarantee that we ever loaded
> > firmware.
> 
> If we didn't load the firmware before the suspend, then the resume
> function of a device sure as hell had better not load it at resume
> time either.

Get a clue. It is very common that devices keep firmware over OS warm
boots, particularly if onboard. "Lesser" beings than yourself consider it
a feature of good hardware design for fast booting and it works happily
in "lesser" OS products such Windows.

If you'd like a typical worked example the Fujitsu Q550 has a 3G modem on
it. So in the following cases we don't load firmware at boot but we do
need to after hibernate/resume

Boot windows, reboot to Linux
Boot Linux, reboot to Linux (first loads, second doesn't)

Break that and you have a regression and Linus says regressions are wrong
and we don't do them.

> And don't make the stupid argument that we don't know. That's just
> inane. Either the driver loads the firmware at startup, or it doesn't.

Wrong.

> Fix the 99%. Screw the crazy shit, don't even bother worrying about it
> until *after* the 99% is fixed.

This is the 99%. This is PC hardware, the 99% is crazy shit.

Alan
