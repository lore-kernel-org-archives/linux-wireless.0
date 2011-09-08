Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51783 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab1IHI6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 04:58:12 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so1276683fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 01:58:12 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/2] rt2x00: Remove special case for rate probe frames
Date: Thu,  8 Sep 2011 10:58:02 +0200
Message-Id: <1315472282-21051-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20110908_105815_243499_CA584276)
In-Reply-To: <1315472282-21051-1-git-send-email-helmut.schaa@googlemail.com>
References: <1315472282-21051-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is handled in minstrel_ht now. No need to special case it here
again.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
---

Ivo, I'm sending this directly to John due to the dependency on the
minstrel_ht patch.

 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index ba0d7e6..033d2cd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -330,11 +330,9 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
-	 * This frame is eligible for an AMPDU, however, don't aggregate
-	 * frames that are intended to probe a specific tx rate.
+	 * This frame is eligible for an AMPDU.
 	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU &&
-	    !(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
+	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
 		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
 
 	/*
-- 
1.7.3.4

