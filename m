Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41292 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759207AbZKFSps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:45:48 -0500
Received: by ewy28 with SMTP id 28so1452393ewy.18
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 10:45:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911061848.21681.chunkeey@googlemail.com>
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
	 <200911021611.37354.chunkeey@googlemail.com>
	 <167ae39b0911060900i2c8f4a78w4edecdcec36f1a38@mail.gmail.com>
	 <200911061848.21681.chunkeey@googlemail.com>
Date: Fri, 6 Nov 2009 12:45:53 -0600
Message-ID: <167ae39b0911061045i63b1650qa1573aa2427f9812@mail.gmail.com>
Subject: Re: Prism54/p54pci
From: James Grossmann <cctsurf@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's the iwconfig:
wlan1     IEEE 802.11bg  ESSID:"newton"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:xx:xx:xx:xx:xx
          Bit Rate=48 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=50/70  Signal level=-60 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I was unable to run the iperf as the client on the laptop (it hard
locked the computer twice), I ran it as server and received the
following at a fair distance from the router (a couple of rooms, same
as the iwconfig above)
Client connecting to 192.168.1.3, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.5 port 47866 connected with 192.168.1.3 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.4 sec  14.6 MBytes  11.7 Mbits/sec



Same test across the room from the router:
iperf -c 192.168.1.3
------------------------------------------------------------
Client connecting to 192.168.1.3, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.5 port 47867 connected with 192.168.1.3 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  21.4 MBytes  17.9 Mbits/sec

wlan1     IEEE 802.11bg  ESSID:"newton"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:xx:xx:xx:xx:xx
          Bit Rate=54 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=70/70  Signal level=-37 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Here's a little bit more I've been getting in my dmesg:
[   91.453279] wlan1: deauthenticating from 00:xx:xx:xx:xx:xx by local
choice (reason=3)
[   91.453421] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 1)
[   91.457825] wlan1: direct probe responded
[   91.457839] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx (try 1)
[   91.462748] wlan1: authenticated
[   91.462808] wlan1: associate with AP 00:xx:xx:xx:xx:xx (try 1)
[   91.465574] wlan1: RX AssocResp from 00:xx:xx:xx:xx:xx (capab=0x401
status=0 aid=2)
[   91.465584] wlan1: associated
[   91.467208] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  101.500094] wlan1: no IPv6 routers present
[  101.893294] ondemand governor failed, too long transition latency
of HW, fallback to performance governor
[  773.648180] wlan1: deauthenticated from 00:xx:xx:xx:xx:xx (Reason: 7)
[  773.649900] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 1)
[  773.654069] wlan1: direct probe responded
[  773.654082] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx (try 1)
[  773.655939] wlan1: deauthenticated from 00:xx:xx:xx:xx:xx (Reason: 7)

On Fri, Nov 6, 2009 at 11:48 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Friday 06 November 2009 18:00:54 James Grossmann wrote:
>> It connects up with the patch!
>> I'll attach a dmesg for any info you might be able to glean from that.
>>  THANKS!
>
> it's a start, but there are some serious implications.
>
> but first: what is your signal (dBm) reading (iwconfig / iw dev wlanX info)?
>
> I'm asking this because your device is only fine-tunable for
> channel 1, 7, 13 & 14 with the current data points.
>
> some performance figures would be nice as well.
> e.g.: iperf (tcp) should be > 18Mbit/s,
>      if you are close & free line of sight
>
> second: what should we do about these devices?
>
> Surely, the best thing would be to simply reprogram the eeprom,
> but this (being complicated work) requires soldering skills/tools,
> a steady hand and enough boredom. Therefor this is likely the least
> ideal option to put into the WIKI @ wireless.kernel.org .
> Any suitable ideas?
>
> Regards,
>        Chr
>
> ---
>> [ 5593.622225] cfg80211: Calling CRDA to update world regulatory
>> domain
>> [ 5593.756965] p54pci 0000:03:00.0: PCI INT A -> Link[LNKA] -> GSI 11
>> (level, low) -> IRQ 11
>> [ 5593.757087] p54pci 0000:03:00.0: firmware: requesting isl3886pci
>> [ 5593.799682] cfg80211: World regulatory domain updated:
>> [ 5593.799693]  (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [ 5593.799701]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
>> 2000 mBm)
>> [ 5593.799708]  (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
>> 2000 mBm)
>> [ 5593.799714]  (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
>> 2000 mBm)
>> [ 5593.799721]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [ 5593.799728]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [ 5593.826106] phy0: p54 detected a LM86 firmware
>> [ 5593.826115] p54: rx_mtu reduced from 3240 to 2376
>> [ 5593.826121] phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
>> [ 5593.826127] phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
>> [ 5593.943095] phy0: hwaddr 00:xx:xx:xx:xx:xx, MAC:isl3880 RF:Frisbee
>>
>> [ 5593.943532] phy0: Selected rate control algorithm 'minstrel'
>> [ 5593.945386] Registered led device: p54-phy0::assoc
>> [ 5593.945426] Registered led device: p54-phy0::tx
>> [ 5593.945466] Registered led device: p54-phy0::rx
>> [ 5593.945507] Registered led device: p54-phy0::radio
>> [ 5593.945521] p54pci 0000:03:00.0: is registered as 'phy0'
>> [ 5593.973148] udev: renamed network interface wlan0 to wlan1
>> [ 5594.105670] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>> [ 5601.380939] wlan1: deauthenticating from 00:xx:xx:xx:xx:xx by local
>> choice (reason=3)
>> [ 5601.381046] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 1)
>> [ 5601.385723] wlan1: direct probe responded
>> [ 5601.385738] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx (try 1)
>> [ 5601.387961] wlan1: authenticated
>> [ 5601.388049] wlan1: associate with AP 00:xx:xx:xx:xx:xx (try 1)
>> [ 5601.390237] wlan1: RX AssocResp from 00:xx:xx:xx:xx:xx (capab=0x401
>> status=0 aid=2)
>> [ 5601.390246] wlan1: associated
>> [ 5601.391891] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
>> [ 5612.024163] wlan1: no IPv6 routers present
>>
>
