Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41500 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0GTGmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 02:42:46 -0400
Received: by qwh6 with SMTP id 6so2013377qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jul 2010 23:42:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
	<AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Tue, 20 Jul 2010 16:39:29 +1000
Message-ID: <AANLkTimgt_HdXyGneQMOz7wR7Xs7BBrDUCGoxP1qDcYg@mail.gmail.com>
Subject: Re: ath5k Ad Hoc Association
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks heaps for replying.

Yes, I've checked the channel (36, 5180) allows beaconing. I've tried
the commands you mentioned, but no luck. If I monitor the interface
from another station, the ath5k drive never appears to beacon.

What I've managed to get working, however, is to start one station
using MadWifi. This definitely beacons, then I bring up the ath5k
interfaces on the other machines using these commands:
*******
# Create interfaces
iw phy phy0 interface add wlan0 type adhoc
iw wlan0 set channel 36
iwconfig wlan0 channel 36
iwconfig wlan0 essid txctest

# Set IP and bring up
ifconfig wlan0 10.0.1.64 netmask 255.255.255.0 up
ifconfig mon0 up

sleep 5
# Scan trick to force association
iwlist scan
*****

They ath5k stations will then correctly join the SSID and I am able to
ping them.

Using the ibss join command doesn't seem to help when I only bring up
ath5k stations - they never seem to beacon at all. This was run from a
monitor interface on the MadWifi node:
****
tcpdump -s 2048 -i mon0 -w dump.pcap
tcpdump: WARNING: mon0: no IPv4 address assigned
tcpdump: listening on mon0, link-type IEEE802_11_RADIO (802.11 plus
radiotap header), capture size 2048 bytes
^C0 packets captured
0 packets received by filter
0 packets dropped by kernel
****

Thanks,

--
Jonathan Guerin



On Tue, Jul 20, 2010 at 5:22 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Jul 19, 2010 at 12:35 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
>> Hi,
>>
>> I'm trying to get my wireless nodes to associate in ad hoc mode.
> [...]
>> I've built and installed the compat package for this kernel version:
>> compat-wireless-2.6.32.16
>
> Ok, I'm not sure which mainline kernel this corresponds to, but I
> just tested ath5k adhoc with success in the latest wireless-testing
> kernel.  Here's what I did:
>
> (had dnsmasq running dhcp for 192.168.10.x, network manager disabled)
>
> $ su
> # modprobe -r ath5k
> # modprobe ath5k
> # iw dev wlan0 set type ibss
> # ifconfig wlan0 192.168.10.1 up
> # iw dev wlan0 ibss join myibss 2462
>
> Then on the other machine (Vista) I just located 'myibss' (so beacons
> are working) and selected it, then successfully pinged 192.168.10.1.
>
> It may depend on which channel you are trying to use; are you on
> a channel that allows beaconing in your regulatory domain?
>
> --
> Bob Copeland %% www.bobcopeland.com
>
