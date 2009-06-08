Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:45725 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbZFHXNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 19:13:40 -0400
Message-ID: <4A2D9B23.20208@lwfinger.net>
Date: Mon, 08 Jun 2009 18:13:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BUG at net/wireless/reg.c:2132 on PowerPC
References: <1244501988.25158.57.camel@mj>
In-Reply-To: <1244501988.25158.57.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Hello!
> 
> After upgrading a PowerPC system from Fedora 10 to Fedora 11, I started
> getting a BUG on startup.  I'm using a self-compiled kernel from
> writeless-testing.git.  The current source is affected, and so is an
> older revision identified as 2.6.30-rc6-wl.
> 
> The BUS causes a long wait on startup (about 3 minutes).  Perhaps it's
> caused by udev waiting for something.
> 
> mac80211 is compiled into the kernel, but ath5k is not:
> 
> $ lsmod
> Module                  Size  Used by
> hfs                    52980  1 
> ath5k                 130428  0 
> ath                     7564  1 ath5k
> 
> The system has 2 Atheros devices:
> 
> 01:02.0 Ethernet controller: Atheros Communications Inc. Atheros AR5001X+ Wireless Network Adapter (rev 01)
> 01:03.0 Network controller: Atheros Communications Inc. Atheros AR5001X+ Wireless Network Adapter (rev 01)
> 
> That's the relevant part of the kernel log:
> 
> udevd version 127 started
> ath5k 0000:01:02.0: enabling device (0014 -> 0016)
> ath5k 0000:01:02.0: registered as 'phy0'
> ath: EEPROM regdomain: 0x0
> ath: EEPROM indicates default country code should be used
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x3a
> ath: Country alpha2 being used: US
> ath: Regpair used: 0x3a
> phy0: Selected rate control algorithm 'minstrel'
> ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
> ath5k 0000:01:03.0: enabling device (0014 -> 0016)
> ath5k 0000:01:03.0: registered as 'phy1'
> ath: EEPROM regdomain: 0x0
> ath: EEPROM indicates default country code should be used
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x3a
> ath: Country alpha2 being used: US
> ath: Regpair used: 0x3a
> cfg80211: Calling CRDA for country: US
> phy1: Selected rate control algorithm 'minstrel'
> ath5k phy1: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
> ath5k phy1: RF2112B 2GHz radio found (0x46)
> udev: renamed network interface wlan0 to wlan1
> udev: renamed network interface wlan1_rename to wlan0

I don't know what is triggering the kernel BUG, but you have an error
in your udev rules. The pertinent file is
/etc/udev/rules.d/70-persistent-net.rules. Any rule that renames a
wireless device should look like the following:

SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", \
ATTR{address}=="00:90:4b:d2:1f:cd", ATTR{type}=="1", \
KERNEL=="wlan*", NAME="wlan0"

The ATTR{address} should match the MAC address of the device, but the
ATTR{type}=="1" is really important as it keeps the master device from
being renamed, which is the usual cause of the presence of a name like
wlanX_rename.

