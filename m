Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:44749 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYI2QZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 12:25:11 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KkLYV-0006YZ-3v
	for linux-wireless@vger.kernel.org; Mon, 29 Sep 2008 16:25:03 +0000
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 16:25:03 +0000
Received: from niemayer by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 16:25:03 +0000
To: linux-wireless@vger.kernel.org
From: Peter Niemayer <niemayer@isg.de>
Subject: "ip link set address" fails with ath5k and newer madwifi drivers
Date: Mon, 29 Sep 2008 18:23:10 +0200
Message-ID: <gbqvde$e4l$1@ger.gmane.org> (sfid-20080929_182517_115390_FC32597A)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I recently noticed that changing the MAC address of an
atheros WLAN adapter fails with all ath5k and newer
madwifi drivers.

To reproduce, just say something like

  ip link set <yourdevice> address 11:22:33:44:55:66

before attaching to your access point. This worked
fine with old madwifi drivers. (Alas, I cannot narrow
down "old" much finer, must have been ~2 years)

With a current ath5k driver, the attachment to the AP
fails, and if I look into the NIC registers using
athtool, I can see the new MAC address has not consistently
been stored there.

With a current madwifi driver, the attachment to the AP
works, and the NIC registers do contain the newly set
address. But any further communication fails, as packets
sent from the local machine to the AP contain the wrong
(old, original, before "ip link set ...") MAC source
address.

Is this a known problem? Does anybody have a hint on
where to look for a resolution?

Thanks in advance,

Peter Niemayer

