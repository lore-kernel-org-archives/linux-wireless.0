Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60747
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXCDNAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 08:00:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] bcm43xx: remove ethtool
Date: Sun, 4 Mar 2007 13:59:21 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net> <45EA3D21.3080203@lwfinger.net> <45EA43EF.1080009@garzik.org>
In-Reply-To: <45EA43EF.1080009@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703041359.21869.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 March 2007 04:58, Jeff Garzik wrote:
> Larry Finger wrote:
> > Jeff Garzik wrote:
> >> Larry Finger wrote:
> >>> Ethtool is useless for bcm43xx - remove it.
> >>>
> >>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >> How is GDRVINFO useless?  Where does mac80211 provide equivalent
> >> information?
> > 
> > I cannot speak for mac80211, but the current implementation for SoftMAC only implements the GDRVINFO
> > call. From it, you get that the driver is bcm43xx (big surprise), the kernel version (easier gotten
> > by a uname -r), and the bus info. None of the operational parameters can be changed or interrogated.
> > 
> > Is this enough to keep the ethtool interface? Because of the EOL for SoftMAC, this code will never
> > be enhanced or extended. Does some userland code need this info?
> 
> It's a highly standardized interface that provides information that's 
> either impossible or highly difficult to obtain elsewhere.
> 
> If you are a userland process querying a network interface, that's the 
> only way to know which driver is attached, or the only way to build an 
> association between a PCI device and a network interface.

sysfs provides all this information.

-- 
Greetings Michael.
