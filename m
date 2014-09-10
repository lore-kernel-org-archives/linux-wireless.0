Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.106]:49151 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaIJBek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 21:34:40 -0400
Message-ID: <540FA8D9.2070803@netcommwireless.com> (sfid-20140910_033444_775835_4A1CE44B)
Date: Wed, 10 Sep 2014 11:26:49 +1000
From: Sourav <sourav.chakraborty@netcommwireless.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: Not reaching optimum speeds with IEEE 802.11n
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
We are using Ralink chip Rt3072L (using rt2800usb drivers rt2800usb.c), 
mac80211, and hostapd in our routers.
root:~# lsmod
Module                  Size  Used by    Tainted: P
rt2800usb              15371  0
rt2800lib              74214  1 rt2800usb
rt2x00usb               9718  1 rt2800usb
rt2x00lib              39328  3 rt2800usb,rt2800lib,rt2x00usb
mac80211              266596  3 rt2800lib,rt2x00usb,rt2x00lib
cfg80211              214073  2 rt2x00lib,mac80211
compat                 17406  4 rt2800usb,rt2x00lib,mac80211,cfg80211

When we are measuring performance using iperf, we see  ~20Mbps, using 
Channel 11 of 2.4GHZ, using 802.11n. The following is the iperf stats 
with iperf client running on the router and iperf server running on a 
laptop with IEEE802.11n adapter.

root:~# iperf -c 192.168.1.194 -p 5001 -i1 -fk -w146k -t100
------------------------------------------------------------
Client connecting to 192.168.1.194, TCP port 5001
TCP window size:   292 KByte (WARNING: requested   146 KByte)
------------------------------------------------------------
[  3] local 192.168.1.1 port 42520 connected with 192.168.1.194 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  1560 KBytes  12780 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  1.0- 2.0 sec  2672 KBytes  21889 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  2.0- 3.0 sec  2800 KBytes  22938 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  3.0- 4.0 sec  2624 KBytes  21496 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  4.0- 5.0 sec  2712 KBytes  22217 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  5.0- 6.0 sec  2664 KBytes  21823 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  6.0- 7.0 sec  2424 KBytes  19857 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  7.0- 8.0 sec  2424 KBytes  19857 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  8.0- 9.0 sec  2592 KBytes  21234 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  9.0-10.0 sec  2752 KBytes  22544 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3] 10.0-11.0 sec  3024 KBytes  24773 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3] 11.0-12.0 sec  2568 KBytes  21037 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3] 12.0-13.0 sec  2832 KBytes  23200 Kbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3] 13.0-14.0 sec  2624 KBytes  21496 Kbits/sec

We are expecting speeds of upto 300Mbps(as per 802.11n specs), though 
those speeds are achievable using channel bonding over 5GHZ?
However at 2.4GHZ also we believe the speeds we are seeing are far too 
low....what are the maximum achievable speeds that we can expect in our 
setup and how to achieve them.....are there
any performance tuning techniques that we can use....please reply asap 
as this is very urgent.

-- 
Warm Regards,
Sourav


______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________
