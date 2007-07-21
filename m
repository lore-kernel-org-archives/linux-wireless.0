Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:3975 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592AbXGUU6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:58:52 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: fix handling of packets without ACKs
Message-Id: <20070721205852.5E4167B40A1@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:58:52 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

Currently the driver doesn't report about the transfer of packets
that will not create an ACK by the AP if it is requested. This
patch fixes this.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 2b998c7..d093841 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -288,9 +288,7 @@ static int zd_mac_stop(struct ieee80211_hw *dev)
  * @dev: pointer to the mac80221 device
  * @control: mac80211 tx control applying for the frame in @skb
  *
- * Initializes the control block of the skbuff to be transmitted. Notify that
- * the control parameter will be only copied into the control block, if ACKs
- * are requieed.
+ * Initializes the control block of the skbuff to be transmitted.
  */
 static int init_tx_skb_control_block(struct sk_buff *skb,
 				     struct ieee80211_hw *dev,
@@ -302,12 +300,10 @@ static int init_tx_skb_control_block(struct sk_buff *skb,
 	ZD_ASSERT(sizeof(*cb) <= sizeof(skb->cb));
 	memset(cb, 0, sizeof(*cb));
 	cb->dev = dev;
-	if (!(control->flags & IEEE80211_TXCTL_NO_ACK)) {
-		cb->control = kmalloc(sizeof(*control), GFP_ATOMIC);
-		if (cb->control == NULL)
-			return -ENOMEM;
-		memcpy(cb->control, control, sizeof(*control));
-	}
+	cb->control = kmalloc(sizeof(*control), GFP_ATOMIC);
+	if (cb->control == NULL)
+		return -ENOMEM;
+	memcpy(cb->control, control, sizeof(*control));
 
 	return 0;
 }
@@ -378,7 +374,9 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 
 	if (likely(cb->control)) {
 		skb_pull(skb, sizeof(struct zd_ctrlset));
-		if (unlikely(error)) {
+		if (unlikely(error ||
+		    (cb->control->flags & IEEE80211_TXCTL_NO_ACK)))
+		{
 			struct ieee80211_tx_status status = {{0}};
 			tx_status(dev, skb, &status);
 		} else {
-- 
1.5.2.2

