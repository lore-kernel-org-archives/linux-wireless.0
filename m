Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36864 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab1FIUkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 16:40:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QUm1O-00063T-Pg
	for linux-wireless@vger.kernel.org; Thu, 09 Jun 2011 22:40:07 +0200
Received: from 208-46-143-172.dia.static.qwest.net ([208.46.143.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 22:40:06 +0200
Received: from flamorce by 208-46-143-172.dia.static.qwest.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 22:40:06 +0200
To: linux-wireless@vger.kernel.org
From: Frederic <flamorce@calamp.com>
Subject: Problem with dhcp client *only* with encryption...
Date: Thu, 9 Jun 2011 20:36:59 +0000 (UTC)
Message-ID: <loom.20110609T223528-612@post.gmane.org> (sfid-20110609_224019_912793_6C2F196B)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My setup:

An ARM board running 2.6.27.9 kernel, compat-wireless-2011-05-24, iw-0.9.22,
libnl-1.1

If I set my AP with no encryption, I can connect with "iw wlan0 connect
wireless" fine then use "udhcpc -i wlan0" to grab an IP address and ping the AP,
it works.

If I set the AP with WEP, it seems that "iw wlan0 connect wireless keys 0:abcde
d:1:0011223344" works, I can see the MAC address in the AP device list, but
udhcpc is unable to take an IP address, it only sends “discover” packets but
never see an answer. I run tcpdump on the AP and I do not see the DHCP request
AFAIK.

I then compiled openssl-1.0.0d and wpa_supplicant-0.7.3 and set the AP in
WPA-TKIP and WPA2-AES ; connections, again, seem to work RF wise, but udhcpc
still does not work and I cannot have an IP address.

Setting a static IP address does not make ping work too.

Anyone has a clue as to why dhcp request, or it seems, any traffic, fail only
when using encryption?

Thanks in advance, Frédéric.


