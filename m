Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57866 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab1GPXJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 19:09:16 -0400
Received: by iyb12 with SMTP id 12so2124102iyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 16:09:15 -0700 (PDT)
Message-ID: <4E221A18.2070504@lwfinger.net> (sfid-20110717_010926_801372_9A49E0AA)
Date: Sat, 16 Jul 2011 18:09:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Olivier_Cr=EAte?= <olivier.crete@ocrete.ca>
CC: linux-wireless@vger.kernel.org
Subject: Re: Sometimes rtl8187 stops sending/receiving packets under load
References: <1310851053.5700.14.camel@TesterBox.tester.ca>
In-Reply-To: <1310851053.5700.14.camel@TesterBox.tester.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2011 04:17 PM, Olivier Crête wrote:
> Hello,
>
> It's a regularly reproducible bug: under some load, like a couple
> torrents running, but not enough to saturate the wireless link (and not
> even enough to saturate the ADSL link on the other side), the card stops
> sending or receiving any packet. Unloading and reloading the rtl8187
> driver fixes the problem.
>
> Kernel version is 2.6.38, but it also happened with older versions, and
> I haven't bothered testing new ones since there are no changes in that
> driver.

This assumption may not be valid as there have been a lot of changes in 
mac80211, which might fix this.

> I get this on my dmesg:
> ieee80211 phy0: wlan0: No probe response from AP 00:0f:66:e2:5f:dd after 500ms, disconnecting.
> cfg80211: Calling CRDA to update world regulatory domain
> wlan0: authenticate with 00:0f:66:e2:5f:dd (try 1)
> wlan0: authenticate with 00:0f:66:e2:5f:dd (try 2)
> wlan0: authenticate with 00:0f:66:e2:5f:dd (try 3)
> wlan0: authentication with 00:0f:66:e2:5f:dd timed out
>
> The wireless card is the one built-in a Asus P5K-E/wifi-ap motherboard.
> And the router is a WRT54G v2 running the latest OpenWRT.
>
> This bit of dmesg output may also be useful:
> usb 1-3: reset high speed USB device using ehci_hcd and address 2
> cfg80211: Calling CRDA to update world regulatory domain
> ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> ieee80211 phy0: hwaddr 00:15:af:37:19:b3, RTL8187vB (default) V1 + rtl8225z2, rfkill mask 2

I have the same device as you as shown in the following:

ieee80211 phy1: hwaddr 00:1b:2f:a2:07:ca, RTL8187vB (default) V1 + rtl8225z2, 
rfkill mask 2

I have run this card extensively in the past several months and have not seen 
any problems. One of my APs is a WRT54GL running a fairly recent openWRT.

Does this only happen when running torrents, or does it happen with a different 
heavy load?

Please try to repeat with a 2.6.39 or 3.0 kernel.

Larry
