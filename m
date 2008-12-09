Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbYLIUIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 15:08:10 -0500
Subject: Re: [RFC] mac80211: Disable requests for new scans in AP mode
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081209193351.GB16905@jm.kir.nu>
References: <20081209145722.GA2285@jm.kir.nu>
	 <1228844410.17539.1.camel@localhost.localdomain>
	 <20081209193351.GB16905@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 15:07:16 -0500
Message-Id: <1228853236.18616.1.camel@localhost.localdomain> (sfid-20081209_210814_025117_B90F808F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-09 at 21:33 +0200, Jouni Malinen wrote:
> On Tue, Dec 09, 2008 at 12:40:10PM -0500, Dan Williams wrote:
> 
> > Every 120 seconds usually (it uses a simple backoff algorithm), but
> > yeah, this is a good thing to do.  You probably want to make NM ignore
> > the device if you're configuring it as an AP though, since obviously NM
> > shouldn't be driving an AP mode interface.
> 
> Actually, I would like to be able to NM to set up a simple AP similarly
> to IBSS configuration.. If I'm setting up the interface manually (either
> for AP or even for client modes), I would like NM to ignore the device
> from that point on, but that is a separate point.

NM only knows about devices that NM controls, thus we can't have NM set
up the device and then subsequently ignore it...  However, at some point
in the near future, if we can get reliable information as to whether the
driver *does* in fact support AP mode, we can make NM drive the
interface in AP mode instead of IBSS.  The only reason it's using IBSS
right now is that the driver support for AP mode was so inconsistent and
buggy.

Dan

