Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2LJK0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 05:26:20 -0500
Message-ID: <1355135199.9857.11.camel@jlt4.sipsolutions.net> (sfid-20121210_112642_228421_90E55E02)
Subject: Re: Wireless network problem with Access Point selection using ifup
From: Johannes Berg <johannes@sipsolutions.net>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 11:26:39 +0100
In-Reply-To: <50C5B65F.4040104@cfl.rr.com>
References: <50C0A743.3000305@compro.net>
	   (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>
	  <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net>
	 <1354913688.9124.2.camel@jlt4.sipsolutions.net>
	 <50C25A4B.8030302@compro.net> <50C5B65F.4040104@cfl.rr.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-10 at 05:15 -0500, Mark Hounschell wrote:

> I have more info. Attached are 3 files. One for each of the APs selected. 
> The furthest away, the router in the middle and even one for the 
> closest/correct AP. In each file is the logfile for wpa_s with the -dd 
> option added, the dmesg output for that particular boot, and the iwconfig 
> output.

You seem to have driver issues. After getting disconnected (for some
reason, but this isn't surprising), you get:

wlan0: State: COMPLETED -> DISCONNECTED
...
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
Scan timeout - try to get results

^ timeout here

wlan0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (0 BSSes)
wlan0: BSS: Start scan result update 3
wlan0: New scan results available
wlan0: Selecting BSS from priority group 0
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
Scan SSID - hexdump_ascii(len=12):
     68 6f 75 6e 73 63 68 65 6c 6c 2d 31               hounschell-1    
wlan0: Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=12):
     68 6f 75 6e 73 63 68 65 6c 6c 2d 31               hounschell-1    
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
nl80211: Scan trigger failed: ret=-16 (Device or resource busy)

^ new trigger fails


So whatever driver you're using seems to be broken.

johannes

