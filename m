Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.193]:31048 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbaIZH1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 03:27:40 -0400
Message-ID: <542514D4.5000905@netcommwireless.com> (sfid-20140926_092743_948948_A5418F0A)
Date: Fri, 26 Sep 2014 17:25:08 +1000
From: Sourav <sourav.chakraborty@netcommwireless.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: occasional drops of packets and then recovery
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
We are using Ralink chip RT3072L (using rt2800usb drivers rt2800usb.c), 
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

when I run iperf server on a PC connected over WiFi to the router, and 
send UDP packets to it from another PC connected to the router via 
ethernet,I see occasional drops of packets and then recovery......this 
phenomena is not seen using TCP packets or if the direction of packets 
are reversed(i.e sending packets from WiFi client(running iperf client) 
to ethernet client(running iperf server). I have analysed and found that 
during the stall phase, the router is not sending packets on the wlan0 
interface(so it seems that the driver stops sending packets to wlan0 and 
after sometime recovers from this situation).
Can you suggest a root cause for this behaviour?

-- 
Warm Regards,
Sourav


______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________
