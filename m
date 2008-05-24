Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760251AbYEXSIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 14:08:17 -0400
Subject: [PATCH] b43legacy: fix build errors when DMA or PIO are not
	selected
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080523102811.1dfc50df.rdunlap@xenotime.net> (sfid-20080523_192821_931342_75EA810D)
References: <20080523102811.1dfc50df.rdunlap@xenotime.net>
	 (sfid-20080523_192821_931342_75EA810D)
Content-Type: text/plain
Date: Sat, 24 May 2008 20:07:55 +0200
Message-Id: <1211652475.18247.4.camel@johannes.berg> (sfid-20080524_200821_225063_D9B82F33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, b43legacy is broken due to

commit fbad4598ca826b994d0fd4ce3deebc9cd1960b31
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu May 15 12:55:29 2008 +0200

    mac80211: move TX info into skb->cb

when compiled with only PIO or only DMA because I forgot to update two
stubs. This patch fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43legacy/dma.h |    3 +--
 drivers/net/wireless/b43legacy/pio.h |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- everything.orig/drivers/net/wireless/b43legacy/dma.h	2008-05-24 20:01:48.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/dma.h	2008-05-24 20:01:55.000000000 +0200
@@ -321,8 +321,7 @@ void b43legacy_dma_get_tx_stats(struct b
 }
 static inline
 int b43legacy_dma_tx(struct b43legacy_wldev *dev,
-		     struct sk_buff *skb,
-		     struct ieee80211_tx_control *ctl)
+		     struct sk_buff *skb)
 {
 	return 0;
 }
--- everything.orig/drivers/net/wireless/b43legacy/pio.h	2008-05-24 20:02:05.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/pio.h	2008-05-24 20:02:12.000000000 +0200
@@ -130,8 +130,7 @@ void b43legacy_pio_free(struct b43legacy
 }
 static inline
 int b43legacy_pio_tx(struct b43legacy_wldev *dev,
-		   struct sk_buff *skb,
-		   struct ieee80211_tx_control *ctl)
+		   struct sk_buff *skb)
 {
 	return 0;
 }


