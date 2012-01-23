Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49480 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754157Ab2AWVeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 16:34:04 -0500
Date: Mon, 23 Jan 2012 16:34:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Hauke Mehrtens <hauke@hauke-m.de>
cc: Greg KH <greg@kroah.com>, <ralf@linux-mips.org>,
	<linux-mips@linux-mips.org>, USB list <linux-usb@vger.kernel.org>,
	<zajec5@gmail.com>, <linux-wireless@vger.kernel.org>, <m@bues.ch>,
	<george@znau.edu.ua>
Subject: Re: [PATCH 4/7] USB: EHCI: Add a generic platform device driver
In-Reply-To: <4F1DC9D4.8090008@hauke-m.de>
Message-ID: <Pine.LNX.4.44L0.1201231626080.1372-100000@iolanthe.rowland.org> (sfid-20120123_223410_647738_7C7CDFF9)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Jan 2012, Hauke Mehrtens wrote:

> > The work doesn't have to be all done right away.  Still, I think it 
> > makes sense to separate out the "generic platform" drivers from the 
> > rest of this patch series.
> Ok, but how should these patches being merged as my plan is to get them
> all into 3.4 in some way? The bcma hcd driver depends on changes in
> drivers/bcma and will also depend on these generic platform driver.

Like I said, we don't need a fully general generic platform driver
right away.  If you make a small number of additions so that it is
clear how to use the two generic drivers instead of some of the
existing platform drivers, and then submit the generic drivers as a
separate standalone patch series, that should be good enough.  Greg
will probably be very happy to merge it, if it includes an explicit
plan for replacing some existing drivers.

Then the bcma stuff can be added on top, as a separate patch series.  
Once that's done, we can start making an effort to assimilate the
platform drivers into the generic drivers.

Alan Stern

