Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:43135 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1LaQJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Dec 2011 11:09:54 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sat, 31 Dec 2011 16:59:48 +0100
Cc: Matthew Garrett <mjg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
References: <Pine.LNX.4.44L0.1112311028270.22327-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112311028270.22327-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201112311659.48427.oliver@neukum.org> (sfid-20111231_170958_240013_00E64F3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 31. Dezember 2011, 16:33:12 schrieb Alan Stern:

> Nothing has changed in the USB layer -- it has always been true that
> devices could be reset during a suspend/resume cycle.  This isn't a
> matter of how the stack is written or anything like that; some
> motherboards simply do not provide suspend power to their USB
> controllers.  Or the firmware reinitializes the controllers and
> attached devices during resume, forcing Linux's USB core to reset
> every device on the affected buses.
> 
> When it comes to suspend/resume, there are almost no guarantees.  :-(

We are definitely going through do_unbind_rebind(). But I don't think
it matters why we got there. We seem to be calling probe() too early.
And we need to guarantee that a driver can request firmware in probe()

So something has changed in the resume code path further up.

	Regards
		Oliver

