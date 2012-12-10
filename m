Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:44461 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2LJLK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 06:10:26 -0500
Message-ID: <50C5C321.1090501@cfl.rr.com> (sfid-20121210_121029_028890_2B01763B)
Date: Mon, 10 Dec 2012 06:10:25 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: markh@compro.net, linux-wireless@vger.kernel.org
Subject: Re: Wireless network problem with Access Point selection using ifup
References: <50C0A743.3000305@compro.net>    (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>   <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net>  <1354913688.9124.2.camel@jlt4.sipsolutions.net>  <50C25A4B.8030302@compro.net> <50C5B65F.4040104@cfl.rr.com> <1355135199.9857.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355135199.9857.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2012 05:26 AM, Johannes Berg wrote:
> On Mon, 2012-12-10 at 05:15 -0500, Mark Hounschell wrote:
>
>> I have more info. Attached are 3 files. One for each of the APs selected.
>> The furthest away, the router in the middle and even one for the
>> closest/correct AP. In each file is the logfile for wpa_s with the -dd
>> option added, the dmesg output for that particular boot, and the iwconfig
>> output.
>
> You seem to have driver issues. After getting disconnected (for some
> reason, but this isn't surprising), you get:
>
> wlan0: State: COMPLETED -> DISCONNECTED
> ...
> Scan requested (ret=0) - scan timeout 30 seconds
> nl80211: Event message available
> nl80211: Scan trigger
> Scan timeout - try to get results
>
> ^ timeout here
>
> wlan0: Event SCAN_RESULTS (3) received
> nl80211: Received scan results (0 BSSes)
> wlan0: BSS: Start scan result update 3
> wlan0: New scan results available
> wlan0: Selecting BSS from priority group 0
> wlan0: No suitable network found
> wlan0: Setting scan request: 5 sec 0 usec
> wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
> Scan SSID - hexdump_ascii(len=12):
>       68 6f 75 6e 73 63 68 65 6c 6c 2d 31               hounschell-1
> wlan0: Starting AP scan for wildcard SSID
> nl80211: Scan SSID - hexdump_ascii(len=12):
>       68 6f 75 6e 73 63 68 65 6c 6c 2d 31               hounschell-1
> nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
> nl80211: Scan trigger failed: ret=-16 (Device or resource busy)
>
> ^ new trigger fails
>
>
> So whatever driver you're using seems to be broken.
>
> johannes
>
>

The driver is use has was identified in the original email. So I guess this 
is the right place to report this issue? In each of the wpa log files I See 
in the beginning, a section like this:

nl80211: Received scan results (4 BSSes)
wlan0: BSS: Start scan result update 1
wlan0: BSS: Add new id 0 BSSID c8:d7:19:7a:ab:1e SSID 'hounschell-1'
wlan0: BSS: Add new id 1 BSSID 20:aa:4b:b2:dd:79 SSID 'hounschell-1'
wlan0: BSS: Add new id 2 BSSID 00:18:f8:ff:72:d5 SSID 'hounschell-1'
wlan0: BSS: Add new id 3 BSSID 00:1a:70:6d:99:50 SSID 'MACDONALD'

Every time the first one listed is the one actually selected and each time 
is different and usually NOT the closest. Why? This machine is NOT roaming. 
It is a Desktop in a fixed location. The AP is within 15ft of the ASUS USB 
adapter and in direct line of sight.  There may be more than one problem 
here. I think one of the problems is right here. Above 20:aa:4b:b2:dd:79 is 
the closest AP. Why is it not first in the list? Why, when it selects one 
of the others and it can't figure out it selected the wrong one and 
reselect the right one seems like a different problem. After all when it 
does select the correct one, all is good but the actual bandwidth.

Mark
