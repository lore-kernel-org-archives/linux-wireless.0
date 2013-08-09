Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56104 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757707Ab3HIOwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 10:52:02 -0400
Date: Fri, 9 Aug 2013 10:52:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oleksij Rempel <linux@rempel-privat.de>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: FUSB200 xhci issue
In-Reply-To: <5204FDEF.5010108@rempel-privat.de>
Message-ID: <Pine.LNX.4.44L0.1308091043220.1405-100000@iolanthe.rowland.org> (sfid-20130809_165207_414573_C3FCB582)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Aug 2013, Oleksij Rempel wrote:

> > What about a "get firmware version" sort of thing?  There really should
> > be a way for the driver to tell whether the firmware has already been
> > updated.
> 
> I was not able to find good direct way to check firmware version. If i 
> would add some new command then i will get option like: if responding FW 
> is updated; if not, then dead or old.
> How about overwriting iProduct field? Let say, if iProduct == ath9k_htc, 
> then firmware is updated? Is it more or less acceptable method? I need 
> to ask this because it is really new for me.

Changing the iProduct string descriptor would work, because the 
descriptors_changed() routine doesn't compare the old value of that 
string with the new value.  (On the other hand, it does compare the 
iSerialNumber strings.)

Is there any way to read the firmware back from the device?  Then you 
could check directly.

Alan Stern

