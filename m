Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47275 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZLTPmY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 10:42:24 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NMNvK-0003kx-Ru
	for linux-wireless@vger.kernel.org; Sun, 20 Dec 2009 16:42:23 +0100
Received: from p4FF0D2AC.dip.t-dialin.net ([79.240.210.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 16:42:22 +0100
Received: from Markus_Baier by p4FF0D2AC.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 16:42:22 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom for alignment operations.
Date: Sun, 20 Dec 2009 15:42:00 +0000 (UTC)
Message-ID: <loom.20091220T163829-137@post.gmane.org>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <1259012694-14869-2-git-send-email-gwingerde@gmail.com> <1259012694-14869-3-git-send-email-gwingerde@gmail.com> <1259012694-14869-4-git-send-email-gwingerde@gmail.com> <1259012694-14869-5-git-send-email-gwingerde@gmail.com> <1259012694-14869-6-git-send-email-gwingerde@gmail.com> <1259012694-14869-7-git-send-email-gwingerde@gmail.com> <1259012694-14869-8-git-send-email-gwingerde@gmail.com> <1259012694-14869-9-git-send-email-gwingerde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After my latest git pull to the kernel version 2.6.33-rc1-wl
no client was able to connect to my hostapd (v0.6.9) AP.
I found a lot of the following entries in the syslog:

wlan0: STA xx:xx:xx:xx:xx:xx
IEEE 802.11: did not acknowledge authentication response

I bisected the problem to the commit e77f5ff92f5ef43c842e97136edcb68c61afe588
above.

After I removed the lines below in rt2x00dev.c:
rt2x00dev->hw->extra_tx_headroom =
        max_t(unsigned int, IEEE80211_TX_STATUS_HEADROOM,
              rt2x00dev->ops->extra_tx_headroom);

/*
* Take TX headroom required for alignment into account.
*/
if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
        rt2x00dev->hw->extra_tx_headroom += RT2X00_L2PAD_SIZE;
else if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
        rt2x00dev->hw->extra_tx_headroom += RT2X00_ALIGN_SIZE;

added the line:
rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;

and compiled the kernel 2.6.33-rc2 again, all worked fine.

