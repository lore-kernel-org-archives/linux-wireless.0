Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37331 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566AbZKFTOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 14:14:22 -0500
Received: by bwz27 with SMTP id 27so1513008bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 11:14:25 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: James Grossmann <cctsurf@gmail.com>
Subject: Re: Prism54/p54pci
Date: Fri, 6 Nov 2009 20:14:19 +0100
Cc: linux-wireless@vger.kernel.org
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com> <200911061848.21681.chunkeey@googlemail.com> <167ae39b0911061045i63b1650qa1573aa2427f9812@mail.gmail.com>
In-Reply-To: <167ae39b0911061045i63b1650qa1573aa2427f9812@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911062014.19363.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 19:45:53 James Grossmann wrote:
> Here's the iwconfig:
> wlan1     IEEE 802.11bg  ESSID:"newton"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:xx:xx:xx:xx:xx
>           Bit Rate=48 Mb/s   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=50/70  Signal level=-60 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> I was unable to run the iperf as the client on the laptop 
> (it hard locked the computer twice),
huu, that's really bad. especially, since a new release is around the corner.

Do you think you can catch the oops/bug report?
(switch to virtual terminal Alt-Ctrl-F1 and start iperf -c there)

> I ran it as server and received the
> following at a fair distance from the router (a couple of rooms, same
> as the iwconfig above)
> Client connecting to 192.168.1.3, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.5 port 47866 connected with 192.168.1.3 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.4 sec  14.6 MBytes  11.7 Mbits/sec
> 
> Same test across the room from the router:
> iperf -c 192.168.1.3
> ------------------------------------------------------------
> Client connecting to 192.168.1.3, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.5 port 47867 connected with 192.168.1.3 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  21.4 MBytes  17.9 Mbits/sec
> 
> wlan1     IEEE 802.11bg  ESSID:"newton"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:xx:xx:xx:xx:xx
>           Bit Rate=54 Mb/s   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=70/70  Signal level=-37 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> Here's a little bit more I've been getting in my dmesg:
> [   91.453279] wlan1: deauthenticating from 00:xx:xx:xx:xx:xx by local choice (reason=3)
> [   91.453421] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 1)
> [   91.457825] wlan1: direct probe responded
> [   91.457839] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx (try 1)
> [   91.462748] wlan1: authenticated
> [   91.462808] wlan1: associate with AP 00:xx:xx:xx:xx:xx (try 1)
> [   91.465574] wlan1: RX AssocResp from 00:xx:xx:xx:xx:xx (capab=0x401
> status=0 aid=2)
> [   91.465584] wlan1: associated
> [   91.467208] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [  101.500094] wlan1: no IPv6 routers present
> [  101.893294] ondemand governor failed, too long transition latency
> of HW, fallback to performance governor

> [  773.648180] wlan1: deauthenticated from 00:xx:xx:xx:xx:xx (Reason: 7)
> [  773.649900] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 1)
> [  773.654069] wlan1: direct probe responded
> [  773.654082] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx (try 1)
> [  773.655939] wlan1: deauthenticated from 00:xx:xx:xx:xx:xx (Reason: 7)
 
Reason 7 => Class 3 (usually data frames) frame from non-assoc station.
Either, your STA timed out (due to lack of traffic?) or the AP lost
the connection state for some strange reason (reset?).

Regards,
	Chr
