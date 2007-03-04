Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34105 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXCDD6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 22:58:44 -0500
Message-ID: <45EA43EF.1080009@garzik.org>
Date: Sat, 03 Mar 2007 22:58:39 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: remove ethtool
References: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net> <45EA3272.7090101@garzik.org> <45EA3D21.3080203@lwfinger.net>
In-Reply-To: <45EA3D21.3080203@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Jeff Garzik wrote:
>> Larry Finger wrote:
>>> Ethtool is useless for bcm43xx - remove it.
>>>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> How is GDRVINFO useless?  Where does mac80211 provide equivalent
>> information?
> 
> I cannot speak for mac80211, but the current implementation for SoftMAC only implements the GDRVINFO
> call. From it, you get that the driver is bcm43xx (big surprise), the kernel version (easier gotten
> by a uname -r), and the bus info. None of the operational parameters can be changed or interrogated.
> 
> Is this enough to keep the ethtool interface? Because of the EOL for SoftMAC, this code will never
> be enhanced or extended. Does some userland code need this info?

It's a highly standardized interface that provides information that's 
either impossible or highly difficult to obtain elsewhere.

If you are a userland process querying a network interface, that's the 
only way to know which driver is attached, or the only way to build an 
association between a PCI device and a network interface.

So NAK this change.  All network drivers should implement GDRVINFO, even 
if they are not strictly ethernet drivers.

	Jeff



