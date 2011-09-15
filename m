Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab1IOIfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 04:35:13 -0400
Date: Thu, 15 Sep 2011 09:42:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Michael Witten <mfwitten@gmail.com>,
	Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: [PATCH] ipw2x00: fix rtnl mutex deadlock
Message-ID: <20110915074249.GA2262@redhat.com> (sfid-20110915_103518_000688_3C832607)
References: <1316011670-6787-1-git-send-email-sgruszka@redhat.com>
 <1316020961.3506.4.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1316020961.3506.4.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 12:22:40PM -0500, Dan Williams wrote:
> On Wed, 2011-09-14 at 16:47 +0200, Stanislaw Gruszka wrote:
> > This fix regression introduced by:
> > 
> > commit: ecb4433550f0620f3d1471ae7099037ede30a91e
> > Author: Stanislaw Gruszka <sgruszka@redhat.com>
> > Date:   Fri Aug 12 14:00:59 2011 +0200
> > 
> >     mac80211: fix suspend/resume races with unregister hw
> > 
> > Above commit add rtnl_lock() into wiphy_register(), what cause deadlock
> > when initializing ipw2x00 driver, which itself call wiphy_register()
> > from register_netdev() internal callback with rtnl mutex taken.
> > 
> > To fix move wiphy_register() outside register_netdev(). This solution
> > have side effect of not creating /sys/class/net/wlanX/phy80211 link,
> > but that's a minor issue we can live with.
> 
> Unfortunately that path is one of the ways that programs distinguish
> wifi devices from plain ethernet devices.  The other way is to poke it
> with WEXT.  Should poking it with nl80211 be added to the mix instead?

Not sure, maybe device/ieee80211/phy0 could be used?

[stasiu@dhcp-27-172 ~]$ readlink -f /sys/class/net/wlan0/phy80211
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0
[stasiu@dhcp-27-172 ~]$ readlink -f /sys/class/net/wlan0/device/ieee80211/phy0
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0

> I guess for ipw2x00 it's not an issue since the driver depends on WEXT
> and thus the WEXT method will always work.

Hopefully yes.

Generally this link creation problem is fixable, but requires some more
rumble in ipw2x00 driver, which is old and orphaned, hence I'm reluctant
to modify it in some more way.

Stanislaw
