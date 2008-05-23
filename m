Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:55756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYEWQNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 12:13:47 -0400
Received: by fg-out-1718.google.com with SMTP id 19so433797fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 09:13:39 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/4] rt2x00: Fix memleak in tx() path
Date: Fri, 23 May 2008 18:13:41 +0200
References: <200805231811.38557.IvDoorn@gmail.com>
In-Reply-To: <200805231811.38557.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805231813.41562.IvDoorn@gmail.com> (sfid-20080523_181351_712498_C5B821F5)
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the tx() handler runs while the device has disapeared,
we did return NETDEV_TX_OK but didn't free the skb.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2333b53..d068ea9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -114,6 +114,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags)) {
 		ieee80211_stop_queues(hw);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
1.5.5.1

