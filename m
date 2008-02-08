Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2564 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759966AbYBHEfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 23:35:11 -0500
Message-ID: <20080207233510.cyfxcv1y8g4gg48w@webmail.spamcop.net> (sfid-20080208_043517_491730_4F9F68A4)
Date: Thu, 07 Feb 2008 23:35:10 -0500
From: Pavel Roskin <proski@gnu.org>
To: Andrew Lunn <andrew.lunn@ascom.ch>
Cc: linux-wireless@vger.kernel.org
Subject: Re: B43 not seeing MadWifi AP
References: <20080206095908.GU25912@donkey.ma.tech.ascom.ch>
	<1202321870.9673.9.camel@dv>
	<20080206185330.GB28210@donkey.ma.tech.ascom.ch>
In-Reply-To: <20080206185330.GB28210@donkey.ma.tech.ascom.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Andrew Lunn <andrew.lunn@ascom.ch>:

>> I suggest that you check in the monitor mode that there are indeed
>> beacons sent with this MAC address.  Maybe they are not.  It's quite
>> possible.  MadWifi has an option to disable beacons for some virtual
>> APs.
>
> Well, other devices are seeing it, eg other Atheros devices and intel
> IPW2200. So somehow i doubt it is not sending beacons.

What I have found is that there are beacons for every ESSID, but  
scanning finds only one ESSID.  I tested that with orinoco driver,  
which doesn't depend on mac80211.

>> Maybe mac80211 decided to do a passive scan, perhaps due to your country
>> regulations?
>
> CH has no such regulations...

You are right, it's more like the opposite is happening.  It looks  
like mac80211 relies only on probe requests and not on beacons.

>> It's quite possible that b43 will associate if you set the ESSID
>> correctly.  Maybe you'll need to set "ap" with iwconfig as well.
>
> I hacked the madwifi driver a little, to disable the wme_ie and the
> ath_ie IEs in the beacon and probe response messages. Only then did
> the b43 device list the Atheros device in its scan list. However i
> could not get it to associate. Authentication always failed. The b43
> driver gives error messages and the MadWifi driver never received the
> Authentication request messages.

It seems to me that the problem is on the MadWifi side.  Changing the  
code may be irrelevant.  MadWifi replied to probe requests only on one  
virtual interface,  and this time it was the interface you needed (for  
whatever reason).  Maybe it switched back when you tried to associate.

> In the end i gave up. I have another machine with an ipw2100 card
> which worked first time and i don't see any point using the B43 device
> when it causes me to much pain.

Maybe b43 does something different, so that the trick with virtual  
devices doesn't work.  But it looks like some problems don't even need  
b43 on the client side.

-- 
Regards,
Pavel Roskin
