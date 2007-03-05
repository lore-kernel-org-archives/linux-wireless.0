Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:43223 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751316AbXCESst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 13:48:49 -0500
From: David Brownell <david-b@pacbell.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.21-rc2-mm1: drivers/usb/host/ohci-ssb.c doesn't compile
Date: Mon, 5 Mar 2007 10:42:05 -0800
Cc: greg@kroah.com, Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-usb-devel@lists.sourceforge.net
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <200703051157.16822.mb@bu3sch.de> <200703051226.46402.mb@bu3sch.de>
In-Reply-To: <200703051226.46402.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703051042.06802.david-b@pacbell.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 March 2007 3:26 am, Michael Buesch wrote:

> > Actually, it seems like I will run into other kinds of nasty problems
> > due to stupid design of the HCD code. The OHCI code #includes
> > the various drivers, which have a module_init each. So if you
> > compile PCI and SSB support, you have two module_init for one
> > OHCI module. Not sure how to fix this. Any idea?
> 
> A real problem is that the HCD core seems to have the assumption
> built-in that there can only be one OHCI driver per machine/arch.

What ancient version of the driver are you referring to??

CURRENT code has one module_init, and can hook up to several
different kinds of bus glue.  There *is* only one OHCI driver.
It can hook up through several different kinds of bus glue; a
few platforms support more than one way to connect to various
implementations of OHCI.


> That's not the case for SSB, where we can have both PCI and SSB
> bus enabled, so both ohci drivers compiled.
> Any idea? Greg perhaps?

This already works in the current code ...

- Dave
