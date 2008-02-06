Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28866 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYBFSRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 13:17:52 -0500
Subject: Re: B43 not seeing MadWifi AP
From: Pavel Roskin <proski@gnu.org>
To: Andrew Lunn <andrew.lunn@ascom.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080206095908.GU25912@donkey.ma.tech.ascom.ch>
References: <20080206095908.GU25912@donkey.ma.tech.ascom.ch>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 13:17:50 -0500
Message-Id: <1202321870.9673.9.camel@dv> (sfid-20080206_181755_762160_5D0816C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-06 at 10:59 +0100, Andrew Lunn wrote:
> iwlist ath0 scan lists the "missing" AP as:
> 
>    Cell 04 - Address: 06:03:7F:03:42:0B

This MAC address is not reserved for any vendor, but MAC addresses
starting with 00:03:7f belong to Atheros.  I think it indicates the
Atheros card uses several virtual interfaces, one of which is what you
are seeing.

I suggest that you check in the monitor mode that there are indeed
beacons sent with this MAC address.  Maybe they are not.  It's quite
possible.  MadWifi has an option to disable beacons for some virtual
APs.

Maybe mac80211 decided to do a passive scan, perhaps due to your country
regulations?

It's quite possible that b43 will associate if you set the ESSID
correctly.  Maybe you'll need to set "ap" with iwconfig as well.

-- 
Regards,
Pavel Roskin
