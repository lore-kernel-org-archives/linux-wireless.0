Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:42750 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaIJO6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 10:58:17 -0400
Message-ID: <541065D5.1020307@maya.org> (sfid-20140910_165820_746113_7AD0ABDB)
Date: Wed, 10 Sep 2014 16:53:09 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Sourav <sourav.chakraborty@netcommwireless.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Not reaching optimum speeds with IEEE 802.11n
References: <540FA8D9.2070803@netcommwireless.com>
In-Reply-To: <540FA8D9.2070803@netcommwireless.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sourav wrote:
> Hi All,
> We are using Ralink chip Rt3072L (using rt2800usb drivers rt2800usb.c),
> mac80211, and hostapd in our routers.
> root:~# lsmod
> Module                  Size  Used by    Tainted: P
> rt2800usb              15371  0
> rt2800lib              74214  1 rt2800usb
> rt2x00usb               9718  1 rt2800usb
> rt2x00lib              39328  3 rt2800usb,rt2800lib,rt2x00usb
> mac80211              266596  3 rt2800lib,rt2x00usb,rt2x00lib
> cfg80211              214073  2 rt2x00lib,mac80211
> compat                 17406  4 rt2800usb,rt2x00lib,mac80211,cfg80211
> 
> When we are measuring performance using iperf, we see  ~20Mbps, using
> Channel 11 of 2.4GHZ, using 802.11n.

Known problem of rt2800usb. You might try the original vendor driver[1]
if you want to use the device as STA. Are you running this test on ARM?
rt2800usb runs *extremely* poor with Raspi, e.g.

With the vendor driver rt5572..., I'm getting > 100MBit/s (measured w/
netperf) running at 2.4 GHz and 40 MHz even through reinforced concrete
floor using a rt5372 chip, e.g. - even w/ Raspberry Pi.

[1] http://www.mediatek.com/en/downloads/



Kind regards,
Andreas
