Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45126 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966694AbZLHXxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 18:53:21 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors in
 =?utf-8?q?=092=2E6=2E32?=
Date: Wed, 9 Dec 2009 00:53:24 +0100
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
References: <20091204233202.GA13658@basil.fritz.box> <200912082339.16893.s.L-H@gmx.de> <1260312016.32227.6.camel@johannes.local>
In-Reply-To: <1260312016.32227.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912090053.25798.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tuesday 08 December 2009, Johannes Berg wrote:
> On Tue, 2009-12-08 at 23:39 +0100, Stefan Lippers-Hollmann wrote:
> 
> > Unfortunately this fails to compile for me:
> 
> well remove the spurious opening brace? :)

yes, of course - but I have to admit that I didn't look too well at the 
patch, after your other subthread - sorry about the noise.


with the patch applied (powersaving enabled):

- Downloading a larger file and therefore keeping the interface busy works 
  now pretty well, while I did hit connection time outs before with 
  powersaving enabled:
	Fetched 89.7MB in 30s (2926kB/s)

- pinging rt61pci results in rather unsteady response times (packet loss 
  can happen, but rarely), which might be a side effect of the card trying 
  to sleep.
	# ping rt61
	PING rt61 (192.168.0.71): 56 data bytes
	64 bytes from 192.168.0.71: seq=0 ttl=64 time=1016.131 ms
	64 bytes from 192.168.0.71: seq=1 ttl=64 time=17.574 ms
	64 bytes from 192.168.0.71: seq=2 ttl=64 time=906.219 ms
	64 bytes from 192.168.0.71: seq=3 ttl=64 time=1.499 ms
	64 bytes from 192.168.0.71: seq=4 ttl=64 time=801.945 ms
	64 bytes from 192.168.0.71: seq=5 ttl=64 time=1.498 ms
	64 bytes from 192.168.0.71: seq=6 ttl=64 time=644.036 ms
	^C
	--- rt61 ping statistics ---
	7 packets transmitted, 7 packets received, 0% packet loss
	round-trip min/avg/max = 1.498/484.128/1016.131 ms

- connecting to the rt61pci through ssh now works again, but typing exposes
  pretty high latencies whenever the interface is otherwise idle - I'm not
  sure if this is to be expected with powersaving enabled, though.
	$ while true; do time ssh rt61 exit; sleep 5; done

	real    0m1.867s
	user    0m0.040s
	sys     0m0.003s

	real    0m0.997s
	user    0m0.042s
	sys     0m0.005s

	real    0m0.214s
	user    0m0.044s
	sys     0m0.003s
	^C
  while the latency is much better when the interface is busy (downloading 
  a large file) and therefore can't power down:
	$ while true; do time ssh rt61 exit; sleep 5; done

	real    0m0.395s
	user    0m0.041s
	sys     0m0.003s
	
	real    0m0.491s
	user    0m0.043s
	sys     0m0.001s
	
	real    0m0.518s
	user    0m0.044s
	sys     0m0.000s
^C



without the patch applied (powersaving enabled):

- Downloading a larger file in a loop times out pretty often and doesn't 
  reach expected throughputs (very unsteady), if the interface is kept busy
  (ping in parallel), the situation improves significantly.

- pinging rt61pci exposes large latencies and exposes significant packet loss
	# ping rt61
	PING rt61 (192.168.0.71): 56 data bytes
	64 bytes from 192.168.0.71: seq=3 ttl=64 time=6.415 ms
	64 bytes from 192.168.0.71: seq=6 ttl=64 time=999.531 ms
	64 bytes from 192.168.0.71: seq=7 ttl=64 time=2.695 ms
	64 bytes from 192.168.0.71: seq=8 ttl=64 time=1.179 ms
	64 bytes from 192.168.0.71: seq=9 ttl=64 time=0.974 ms
	64 bytes from 192.168.0.71: seq=13 ttl=64 time=8650.425 ms
	64 bytes from 192.168.0.71: seq=14 ttl=64 time=7653.903 ms
	64 bytes from 192.168.0.71: seq=15 ttl=64 time=6653.707 ms
	64 bytes from 192.168.0.71: seq=16 ttl=64 time=5653.463 ms
	64 bytes from 192.168.0.71: seq=17 ttl=64 time=4653.132 ms
	64 bytes from 192.168.0.71: seq=18 ttl=64 time=3652.887 ms
	64 bytes from 192.168.0.71: seq=19 ttl=64 time=2652.628 ms
	64 bytes from 192.168.0.71: seq=20 ttl=64 time=1652.377 ms
	64 bytes from 192.168.0.71: seq=21 ttl=64 time=652.126 ms
	^C
	--- rt61 ping statistics ---
	23 packets transmitted, 14 packets received, 39% packet loss
	round-trip min/avg/max = 0.974/3063.245/8650.425 ms

- ssh connections are affected accordingly and basically unusable.
	$ while true; do time ssh rt61 exit; sleep 5; done

	real    0m5.242s
	user    0m0.044s
	sys     0m0.002s
	
	real    0m1.682s
	user    0m0.043s
	sys     0m0.001s
	
	real    0m5.797s
	user    0m0.044s
	sys     0m0.002s
^C



without the patch applied (powersaving disabled, see patch below which 
unfortunately disables powersaving for all rt2x00 devices, even though 
rt2500usb and rt73usb don't seem to be affected):

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -837,6 +837,15 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 		    BIT(NL80211_IFTYPE_WDS);
 
 	/*
+	 * Disable power saving for the time being, it breaks at least:
+	 * - rt61pci
+	 * while it isn't necessary for:
+	 * - rt2500usb
+	 * - rt73usb
+	 */
+	rt2x00dev->hw->wiphy->ps_default = false;
+
+	/*
 	 * Let the driver probe the device to detect the capabilities.
 	 */
 	retval = rt2x00dev->ops->lib->probe_hw(rt2x00dev);

- Downloading a larger file in a loop works as expected, with steady 
  results - independent of teh interface being idle or busy:
	Fetched 89.7MB in 30s (2903kB/s)

- ping times are good, no packet loss:
	# ping rt61
	PING rt61 (192.168.0.71): 56 data bytes
	64 bytes from 192.168.0.71: seq=0 ttl=64 time=1.267 ms
	64 bytes from 192.168.0.71: seq=1 ttl=64 time=1.208 ms
	64 bytes from 192.168.0.71: seq=2 ttl=64 time=1.197 ms
	64 bytes from 192.168.0.71: seq=3 ttl=64 time=1.106 ms
	64 bytes from 192.168.0.71: seq=4 ttl=64 time=1.123 ms
	^C
	--- rt61 ping statistics ---
	5 packets transmitted, 5 packets received, 0% packet loss
	round-trip min/avg/max = 1.106/1.180/1.267 ms

- ssh connections are snappy as expected:
	$ while true; do time ssh rt61 exit; sleep 5; done
	
	real    0m0.188s
	user    0m0.042s
	sys     0m0.003s
	
	real    0m0.145s
	user    0m0.041s
	sys     0m0.004s
	
	real    0m0.146s
	user    0m0.041s
	sys     0m0.003s
	^C

Regards
	Stefan Lippers-Hollmann
