Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:57006 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616AbZGSRzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 13:55:46 -0400
Message-ID: <4A635E04.4050204@redfish-solutions.com>
Date: Sun, 19 Jul 2009 10:55:16 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Using compat-wireless w/ 2.6.27.26
References: <4A612514.4050708@redfish-solutions.com> <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com>
In-Reply-To: <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Fri, Jul 17, 2009 at 9:27 PM, Philip A.
> Prindeville<philipp_subx@redfish-solutions.com> wrote:
>> + modprobe ath5k
>> ath5k phy0: Atheros AR5413 chip found (MAC: 0xa4, PHY: 0x61)
>>
>> + iw dev wlan0 interface add ap0 type managed
>> + ip link set ap0 up
>> + iw dev ap0 connect xxxx
>> command failed: Operation not supported (-95)
> 
> Why are you adding another interface?  Should be able to use "iw dev wlan0..."

Because I might want to run two access points (two SSIDs, anyway) on the same radio...  one with WEP on one VLAN (for Wifi SIP handsets), and one with WPA-PSK2 on another VLAN (for laptops, etc).

>> pbx ~ # iw phy phy0 info
>> command failed: No buffer space available (-105)
> 
> Means the netlink buffer was exceeded.  In the past this was because there
> were too many channels -- are you sure you're loading the compat-wireless
> ath5k instead of the .29 one (and not using all_channels modparam)?
> 

Reasonably sure, yes.  I stopped the distro build and did an "ls -R" after building linux, and there were no drivers other than cfg80211.ko and mac80211.ko that get duplicated.

After resuming the rest of the build, there were drivers from compat-wireless including ath5k, and cfg80211.ko and mac80211.ko also had refreshed timestamps matching everything else.

But, if you think there's still a doubt, what to look for in the modinfo?

-Philip
