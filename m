Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:48337 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0JZPkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 11:40:16 -0400
Date: Tue, 26 Oct 2010 17:40:12 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Lee <lee-in-berlin@web.de>, linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101026154012.GA6908@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <4CC33E83.4020505@web.de>
 <201010260740.47692.helmut.schaa@googlemail.com>
 <20101026110332.GA3982@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101026110332.GA3982@sig21.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 26, 2010 at 01:03:32PM +0200, Johannes Stezenbach wrote:
> 
> (The client is sending ARP requests but not getting answer:
> zzz:~# tcpdump -p -i wlan0
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on wlan0, link-type EN10MB (Ethernet), capture size 65535 bytes
> 13:00:35.740957 ARP, Request who-has 172.28.120.1 tell 172.28.120.2, length 28
> 13:00:36.740924 ARP, Request who-has 172.28.120.1 tell 172.28.120.2, length 28
> 13:00:37.740926 ARP, Request who-has 172.28.120.1 tell 172.28.120.2, length 28
> )

I used a third machine (using ath9k) to dump the traffic with airodump-ng.
ARP requests are sent to broadcast address.

- first I checked power save is off on the client
  (iw dev wlan0 set power_save off)
- then I made static ARP entry on the client (arp -i wlan0 -s 172.28.120.1 00:22:B0:xx:xx:xx)

Then I can see in the dump data packets going to the AP address, and
the AP returns ACK packets.
On AP, "tcpdump -i mon0" outputs one  packet per second (corresponding with
the ping), but "tcpdump -p -i wlan0" does not output anything at all.
RX packet count in "ifconfig wlan0" output does not increase.

on AP:
 # cd /sys/kernel/debug/ieee80211/phy0/stations/00*
 # grep . *
agg_status:next dialog_token: 0x1
agg_status:(snip, all zeros)
dev:wlan0
flags:AUTH
flags:ASSOC
flags:AUTHORIZED
flags:SHORT PREAMBLE
ht_capa:ht not supported
inactive_ms:1160
last_seq_ctrl:ffff ffff ffff ffff ffff ffff ffff ffff ffff ffff ffff ffff ffff ffff ffff ffff cc0 
last_signal:-40
num_ps_buf_frames:0
rc_stats:(snip, all zeors)
rc_stats:Total packet count::    ideal 2      lookaround 0
rx_bytes:1476
rx_dropped:80
rx_duplicates:0
rx_fragments:19
rx_packets:19
tx_bytes:2238
tx_filtered:0
tx_fragments:18
tx_packets:18
tx_retry_count:0
tx_retry_failed:0
wep_weak_iv_count:0

(rx_ + tx_packets does not increase with the ping)

  # cd /sys/kernel/debug/ieee80211/phy0/keys/18
(keys/18 appears after the station is connected)
  # grep . *
algorithm:CCMP
flags:0x1
hw_key_idx:0
ifindex:wlan0
key:1a62718edaf300998cc974f709a0baed
keyidx:0
keylen:16
replays:1
rx_spec:000000000000
  (snip repeats)
tx_rx_count:18
tx_spec:000000000000

  tx_rx_count increases with the ping


HTH,
Johannes
