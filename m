Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbXHCLXW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 07:23:22 -0400
Subject: RE: [ipw3945-devel] chaning mode only when interface down?
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1186134177.4647.19.camel@johannes.berg>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	 <1186058047.24230.38.camel@johannes.berg>
	 <1186080675.9527.10.camel@xo-13-A4-25.localdomain>
	 <1186134177.4647.19.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 07:20:19 -0400
Message-Id: <1186140019.22438.6.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-03 at 11:42 +0200, Johannes Berg wrote:
> On Thu, 2007-08-02 at 14:51 -0400, Dan Williams wrote:
> 
> > Well, to be honest none of the drivers before mac80211 required you to
> > down the device to change modes.  But they were mostly fullmac, or
> > half-mac like ipw2x00.  Since mac80211 has only just become useful in
> > the past couple of months for most people, it's not really fair to
> > expect versions of NM that were out before mac80211 landed to play nice
> > with what mac80211 expects, which is different from what other drivers
> > implement.
> 
> True.
> 
> > Not to say NM shouldn't be fixed for this.  The other problem is that
> > there's really not a good way to determine whether the driver is
> > actually _ready_ after down it and bringing it back up.  You basically
> > have to spin & block until the interface gets IFF_UP set on it again,
> > and even then that's not entirely reliable.
> 
> Not sure I understand? Drivers can fully well block the userspace task
> that is doing the IFF_UP until they're read? bcm43xx does that.

Well, I'd rather that the driver actually not block (NM uses netlink
here anyway, not an ioctl) but there be some flag to look for when the
device actually is up.  That implies that the device not set IFF_UP on
itself until it actually _is_ up.  I think the biggest offender for
up-misbehavior used to be prism54 FullMAC, because it had to reload the
firmware for almost every operation, and that could take over a second
or two to load & reboot the firmware.  There wasn't a good way of
telling when that was done and the firmware was ready for business.  So
you end up having sleep(2) calls littering the code to deal with these
sorts of little things.

Dan

