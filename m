Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:51910 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZAUODG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 09:03:06 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH -stable] p54usb: fix traffic stalls / packet drop
Date: Wed, 21 Jan 2009 15:03:11 +0100
Cc: Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Artur Skawina <art.08.09@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Linux wireless <linux-wireless@vger.kernel.org>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <20090120223957.GA6088@suse.de> <20090120235626.GA3094@tuxdriver.com>
In-Reply-To: <20090120235626.GA3094@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901211503.11849.chunkeey@web.de> (sfid-20090121_150313_762381_121B6B48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 January 2009 00:56:26 John W. Linville wrote:
> On Tue, Jan 20, 2009 at 02:39:57PM -0800, Greg KH wrote:
> > On Tue, Jan 20, 2009 at 11:11:11PM +0100, Christian Lamparter wrote:
> > > All p54usb devices need a explicit termination packet, in oder to finish the pending transfer properly.
> > > Else, the firmware could freeze, or simply drop the frame.
> > > 
> > > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > > Cc: stable <stable@kernel.org>
> > > ---
> > > Attached is the patch is for the stable series only.
> > > Bugzilla reference: http://bugzilla.kernel.org/show_bug.cgi?id=12260
> > > (wireless-testing needs a different one)
> > 
> > What do you mean, this is for 2.6.28-stable or 2.6.27-stable only, and
> > not 2.6.29?  Why?
> 
> At least part of that patch is already in 2.6.29.  I think Christian
> may have combined another patch into the -stable version, one that
> he posted today for -rc inclusion.

Yup, the -stable patch includes the diff "hunks" for all devices.

linux-wireless is a different affair, because the fix for LM87
(aka "p54usb: fix random traffic stalls (LM87)" ) is already merged.
So the patch I posted on linux-wirelss (-rc inclusion) only has the
diffs for the 1st generation and 2nd generation with old firmwares.

Regards,
	Chr
