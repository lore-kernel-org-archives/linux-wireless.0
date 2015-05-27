Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59165 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbbE0SuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 14:50:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YxgOy-0000Qa-F6
	for linux-wireless@vger.kernel.org; Wed, 27 May 2015 20:50:04 +0200
Received: from 147.83.206.82 ([147.83.206.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2015 20:50:04 +0200
Received: from ranker72 by 147.83.206.82 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2015 20:50:04 +0200
To: linux-wireless@vger.kernel.org
From: ferran <ranker72@gmail.com>
Subject: modify mac address with multiple interfaces on a device
Date: Wed, 27 May 2015 18:44:24 +0000 (UTC)
Message-ID: <loom.20150527T185540-223@post.gmane.org> (sfid-20150527_205017_356125_B96B0167)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I have noticed that having more than one interface pointing to the same
physical device, modifying the address of any of these interfaces gets
limited to the last 3 bits of the address, thus giving only 8 possible values.

Moreover, the mac address is set after the previous interface's one. Let's
put it in a example (output copied by hand)

---

$ iw dev
phy#0
     Interface wlan0
            ifindex 7
            type managed
$ sudo ip link set wlan0 down
$ sudo ip link set wlan0 address 00:11:22:33:44:55
[ mac is changed ]
$ sudo iw phy phy0 interface add mywlan type managed
$ iw dev
phy#0
     Interface mywlan
            ifindex 9
            type managed
     Interface wlan0
            ifindex 7
            type managed
$ ip link
[ ... ]
7: wlan0: [...]
    link/ether 00:11:22:33:44:55 [...]
7: mywlan: [...]
    link/ether 00:11:22:33:44:56 [...]

$ sudo ip link set wlan0 down
$ sudo ip link set wlan0 address aa:bb:cc:dd:ee:ff
RTNETLINK answers: Invalid argument

$ sudo ip link set wlan0 address 00:11:22:33:44:5f
RTNETLINK answers: Invalid argument

$ sudo ip link set wlan0 address 00:11:22:33:44:57
[ mac is changed ]

$ sudo iw mywlan del
$ sudo ip link set wlan0 address aa:bb:cc:dd:ee:ff

$ ip link
[ ... ]
7: wlan0: [...]
    link/ether aa:bb:cc:dd:ee:ff [...]

---

However, in another machine, using an iwlwifi card, I can change mac
addresses disregarding other interfaces on same physical device. Another
fact, when adding a new interface to a phy, the assigned mac address is
derived from the factory immutable one, instead of from the other interface's.

---

Where can I confirm this behaviour, is it docummented? Am I right saying
that this depends on the actual driver? And how much difference is between
one and another?

Thank you very much

