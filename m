Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59163 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3L1JmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Dec 2013 04:42:20 -0500
Message-ID: <52BE9CF9.7030305@broadcom.com> (sfid-20131228_104227_095418_0C2655D3)
Date: Sat, 28 Dec 2013 10:42:17 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>,
	<brcm80211-dev-list@broadcom.com>, <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <52BDE9DC.5040206@msgid.tls.msk.ru>
In-Reply-To: <52BDE9DC.5040206@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2013 09:58 PM, Michael Tokarev wrote:
> Hello.
>
> Got a Lenovo Thinkpad notebook with the following wifi card:
>
> 03:00.0 Network controller [0280]: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
> 	Subsystem: Broadcom Corporation Device [14e4:0608]
> 	Flags: bus master, fast devsel, latency 0, IRQ 17
> 	Memory at f1600000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: [40] Power Management version 3
> 	Capabilities: [58] Vendor Specific Information: Len=78 <?>
> 	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
> 	Capabilities: [d0] Express Endpoint, MSI 00
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [13c] Virtual Channel
> 	Capabilities: [160] Device Serial Number 00-00-24-ff-ff-fe-48-d2
> 	Capabilities: [16c] Power Budgeting <?>
> 	Kernel driver in use: bcma-pci-bridge
>
> With 3.12 kernel, the device is recognized and it is possible to
> connect to the access point and exchange some data.  In 3.10,
> even connection (assotiation with the AP) was quite a bit
> problematic, and packet exchange never worked).
>
> However, after receiving a few packets (about 100 packets), the
> interface almost stops receiving data, except a few packets once
> in a while.  For example, when d/loading some file over wifi, first
> part (very beginning) gets d/loaded fine, and next d/load stalls,
> with Rx counter of the card not changing.  Terminating the process
> makes the counter to increase by one or two.
>
> Stopping and re-starting the interface in NetworkManager makes
> it go again, also for just about 100 packets, till it stalls
> again.
>
> Sometimes it works longer, say, 500 or even 1000 packets, but
> at the end it stalls anyway.
>
> Here's a typical iwconfig output:
>
> wlan0     IEEE 802.11bgn  ESSID:"mjt"
>           Mode:Managed  Frequency:2.412 GHz  Access Point: 64:70:02:29:D9:30
>           Bit Rate=1 Mb/s   Tx-Power=19 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=56/70  Signal level=-54 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:84  Invalid misc:13   Missed beacon:0
>
> (Note the bitrate of 1Mbps: the AP is pretty much capable of
> running at 54Mbps, and actually my smartphone, when used in
> exactly the same place, goes at full 54Mbps just fine.  The
> signal conditions are very well in here, AP is about 15 meters
> away, stright visible.  When I force-reconnect it, it displays
> some more sane value here for a few moments but drops to 1mbps
> anyway).
>
> Here's some dmesg output when I start/stop wifi network and
> try to d/load something:
>
> ...
> [28031.696294] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
> [28031.696307] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
> [28033.640097] wlan0: authenticate with 64:70:02:29:d9:30
> [28033.642395] wlan0: send auth to 64:70:02:29:d9:30 (try 1/3)
> [28033.644624] wlan0: authenticated
> [28033.645452] wlan0: associate with 64:70:02:29:d9:30 (try 1/3)
> [28033.650163] wlan0: RX AssocResp from 64:70:02:29:d9:30 (capab=0x411 status=0 aid=1)
> [28033.651697] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
> [28033.651702] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
> [28033.651710] wlan0: associated
> [28033.921528] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
> [28149.522205] wlan0: deauthenticating from 64:70:02:29:d9:30 by local choice (reason=3)
> [28149.535454] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
> [28149.535469] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
> [28149.535476] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
> [28149.538431] cfg80211: Calling CRDA to update world regulatory domain
> [28152.718056] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
> [28152.718074] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
> [28154.564599] wlan0: authenticate with 64:70:02:29:d9:30
> [28154.567108] wlan0: send auth to 64:70:02:29:d9:30 (try 1/3)
> [28154.569527] wlan0: authenticated
> [28154.570232] wlan0: associate with 64:70:02:29:d9:30 (try 1/3)
> [28154.574687] wlan0: RX AssocResp from 64:70:02:29:d9:30 (capab=0x411 status=0 aid=1)
> [28154.575257] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
> [28154.575261] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
> [28154.575268] wlan0: associated
> ...
>
>
> The same notebook with the same wifi card works just fine under
> windows (both windows 7 and 8), demonstrating stable reliable
> about-54Mbps connection.
>
> Is there any hope to get this device working under linux?
>
> I can re-build kernels and stuff, enable debugging etc, -- that's
> no problem, but I've really limited time.
>
> I purchased this notebook especially to be used when travelling,
> to be able to access to my office/work network over hotel wifi,
> I plan to have a trip starting Jan-2.  After figuring out that
> it doesn't quite work as I'd expect it to do, I purchased another
> wifi card, just to face another issue: it my notebook refuses to
> _boot_ while that card is inserted! (it was a completely new
> and unexpected "feature", now I know what it is, and will avoid
> lenovo and HP notebooks in the future), -- so I returned the card
> back.  But now I'm again without wifi, and I can't return the
> notebook...
>
> P.S. I tried to find archives of brcm80211 list, or a way to
> subscribe to it before posting, but found neither.  Are there
> archives?

Nope. The brcm80211-dev-list is just a (hopefully) convenient way to get
your message to the brcm80211 driver developer within Broadcom. So it is
always best to Cc: the linux-wireless list as well.

Now about your card. I am not sure where to start, but can you dump
contents for following debugfs file:

/sys/kernel/debug/brcmsmac/bcma*/hardware

Also a capture file would be great so if you have wireshark or dumpcap 
you can add monitor interface and capture 802.11 packets from connect up 
until the stalls. Commands for adding/enabling monitor interface (ass 
root/sudo):

# iw dev wlan0 interface add mon0 type monitor
# ifconfig mon0 up

Regards,
Arend

> Thanks,
>
> /mjt
>

