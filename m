Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ascomax.hasler.ascom.ch ([139.79.135.1]:61906 "EHLO
	ascomax.hasler.ascom.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYBFSxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 13:53:51 -0500
Date: Wed, 6 Feb 2008 19:53:30 +0100
From: Andrew Lunn <andrew.lunn@ascom.ch>
To: Pavel Roskin <proski@gnu.org>
Cc: Andrew Lunn <andrew.lunn@ascom.ch>, linux-wireless@vger.kernel.org
Subject: Re: B43 not seeing MadWifi AP
Message-ID: <20080206185330.GB28210@donkey.ma.tech.ascom.ch> (sfid-20080206_185357_066786_66CDB41B)
References: <20080206095908.GU25912@donkey.ma.tech.ascom.ch> <1202321870.9673.9.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1202321870.9673.9.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 01:17:50PM -0500, Pavel Roskin wrote:
> On Wed, 2008-02-06 at 10:59 +0100, Andrew Lunn wrote:
> > iwlist ath0 scan lists the "missing" AP as:
> > 
> >    Cell 04 - Address: 06:03:7F:03:42:0B
> 
> This MAC address is not reserved for any vendor, but MAC addresses
> starting with 00:03:7f belong to Atheros.  I think it indicates the
> Atheros card uses several virtual interfaces, one of which is what you
> are seeing.

Correct. 

> I suggest that you check in the monitor mode that there are indeed
> beacons sent with this MAC address.  Maybe they are not.  It's quite
> possible.  MadWifi has an option to disable beacons for some virtual
> APs.

Well, other devices are seeing it, eg other Atheros devices and intel
IPW2200. So somehow i doubt it is not sending beacons.

 
> Maybe mac80211 decided to do a passive scan, perhaps due to your country
> regulations?

CH has no such regulations... 
 
> It's quite possible that b43 will associate if you set the ESSID
> correctly.  Maybe you'll need to set "ap" with iwconfig as well.

I hacked the madwifi driver a little, to disable the wme_ie and the
ath_ie IEs in the beacon and probe response messages. Only then did
the b43 device list the Atheros device in its scan list. However i
could not get it to associate. Authentication always failed. The b43
driver gives error messages and the MadWifi driver never received the
Authentication request messages.

In the end i gave up. I have another machine with an ipw2100 card
which worked first time and i don't see any point using the B43 device
when it causes me to much pain.

     Andrew
