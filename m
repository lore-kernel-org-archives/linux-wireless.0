Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57665 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbZHNWwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 18:52:01 -0400
Received: by bwz22 with SMTP id 22so1391213bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 15:52:02 -0700 (PDT)
Message-ID: <4A85EA92.80209@gmail.com>
Date: Sat, 15 Aug 2009 00:52:02 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Handle B43_PHYTYPE_LP in RX path
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't drop all packets received from an LP-PHY with WARN_ON.
Also update a comment with LP-specific information.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/wa.c   |    2 +-
 drivers/net/wireless/b43/xmit.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 73e97fa..97c7916 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -628,7 +628,7 @@ void b43_wa_all(struct b43_wldev *dev)
 			B43_WARN_ON(1);
 		}
 		b43_wa_boards_g(dev);
-	} else { /* No N PHY support so far */
+	} else { /* No N PHY support so far, LP PHY is in phy_lp.c */
 		B43_WARN_ON(1);
 	}
 
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 5280ebc..be1c53e 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -655,6 +655,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		status.freq = chanid + 2400;
 		break;
 	case B43_PHYTYPE_N:
+	case B43_PHYTYPE_LP:
 		/* chanid is the SHM channel cookie. Which is the plain
 		 * channel number in b43. */
 		if (chanstat & B43_RX_CHAN_5GHZ) {
-- 
1.6.2.4



