Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47143 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030236AbXCDD3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 22:29:50 -0500
Message-ID: <45EA3D21.3080203@lwfinger.net>
Date: Sat, 03 Mar 2007 21:29:37 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: remove ethtool
References: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net> <45EA3272.7090101@garzik.org>
In-Reply-To: <45EA3272.7090101@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> Larry Finger wrote:
>> Ethtool is useless for bcm43xx - remove it.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> How is GDRVINFO useless?  Where does mac80211 provide equivalent
> information?

I cannot speak for mac80211, but the current implementation for SoftMAC only implements the GDRVINFO
call. From it, you get that the driver is bcm43xx (big surprise), the kernel version (easier gotten
by a uname -r), and the bus info. None of the operational parameters can be changed or interrogated.

Is this enough to keep the ethtool interface? Because of the EOL for SoftMAC, this code will never
be enhanced or extended. Does some userland code need this info?

Larry
