Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbZJKKUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 06:20:05 -0400
Subject: [PATCH] b43: fix ieee80211_rx() context
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, Kalle Valo <kalle.valo@iki.fi>,
	Dave Young <hidave.darkstar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 12:19:21 +0200
Message-Id: <1255256361.4095.56.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the way it interacts with the networking
stack and other parts of mac80211, ieee80211_rx()
must be called with disabled softirqs.

Michael, the former maintainer of this driver,
has refused to fix the problem this way instead
proposing a much more invasive patch that could
not even be proved correct wrt. locking inside
mac80211. Regardless of that, he believes this
to be a bug in mac80211, and has also publicly
stated [1] that he does not care about this even
though it is a regression introduced by his own
patches.

Since nobody else seems to be wanting to fix the
problem, I'll just fix it for the benefit of the
many users of this driver.

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440/focus=40266

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/xmit.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-10-11 12:11:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-10-11 12:12:06.000000000 +0200
@@ -690,7 +690,10 @@ void b43_rx(struct b43_wldev *dev, struc
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+
+	local_bh_disable();
 	ieee80211_rx(dev->wl->hw, skb);
+	local_bh_enable();
 
 #if B43_DEBUG
 	dev->rx_count++;


