Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37217 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161373AbXBZXDY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 18:03:24 -0500
Date: Mon, 26 Feb 2007 15:02:41 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Pavel Roskin <proski@gnu.org>, Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070226150241.1b5b63b2@freekitty>
In-Reply-To: <45E112F7.9090908@lwfinger.net>
References: <510326.55988.qm@web50211.mail.yahoo.com>
	<20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
	<45E112F7.9090908@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 24 Feb 2007 22:39:19 -0600
Larry Finger <larry.finger@lwfinger.net> wrote:

> Pavel Roskin wrote:
> > Quoting Alex Davis <alex14641@yahoo.com>:
> > 
> >> This patch will allow you to specify the interface name prefix of wireless
> >> devices.
> >>
> >> On my machine, the wireless devices under the bcm43xx driver are named
> >> 'ethx'; I
> >> would really rather have them called 'wlanx', like bcm43xx-d80211 does.
> > 
> > You can use ifrename from wireless tools.  Use the option that checks the
> > ethtool information.
> > 
> > Jean has just released Wireless Tools 29-pre12, which can read symlinks in
> > sysfs.  That would allow renaming d80211 based network devices by checking the
> > "driver" symlinks in sysfs.  I asked Jean to do that with bcm43xx_d80211 in
> > mind.
> > 
> > It's not that I'm against your patch.  I'm rather ambivalent.  But I think using
> > ifrename could reduce the need in kernel support for interface renaming.
> 
> NACK.
> 
> On my system (openSUSE 10.2), one sets the name in /etc/udev/rules.d/30-net_persistent_names.rule. I
> feel that interface renaming is handled perfectly well in userland, and kernel support is not needed.
> 

This was hashed out on netdev 2+ years ago and decided that both ethernet
and wireless devices should show up as 'eth%d'. For inclusion d80211 needs to conform
to existing mainline kernel practice. If this means breaking the expectation of older
out of tree wireless support (ie madwifi), sorry.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
