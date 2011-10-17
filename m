Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65153 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab1JQPPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 11:15:45 -0400
Received: by eye27 with SMTP id 27so3059039eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 08:15:44 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.2 REQ V2] b43: HT-PHY: report signal to mac80211
Date: Mon, 17 Oct 2011 17:15:44 +0200
Message-Id: <1318864544-27943-1-git-send-email-zajec5@gmail.com> (sfid-20111017_171549_383392_CDED0DE4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: use ready max_t function instead of manual casting.
The problem is that max(a, b) doesn't return "correct" type, even if
both values are the same type.
---
 drivers/net/wireless/b43/xmit.c |    7 +++++++
 drivers/net/wireless/b43/xmit.h |   16 +++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 8d69f7f..438f10f 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -740,7 +740,14 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 
 	/* Link quality statistics */
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
+	case B43_PHYTYPE_HT:
+		/* TODO: is max the right choice? */
+		status.signal = max_t(__s8,
+			max(rxhdr->phy_ht_power0, rxhdr->phy_ht_power1),
+			rxhdr->phy_ht_power2);
+		break;
 	case B43_PHYTYPE_N:
+		/* Broadcom has code for min and avg, but always uses max */
 		if (rxhdr->power0 == 16 || rxhdr->power0 == 32)
 			status.signal = max(rxhdr->power1, rxhdr->power2);
 		else
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index 16c514d..98d9074 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -249,6 +249,12 @@ struct b43_rxhdr_fw4 {
 		} __packed;
 	} __packed;
 	union {
+		/* HT-PHY */
+		struct {
+			PAD_BYTES(1);
+			__s8 phy_ht_power0;
+		} __packed;
+
 		/* RSSI for N-PHYs */
 		struct {
 			__s8 power2;
@@ -257,7 +263,15 @@ struct b43_rxhdr_fw4 {
 
 		__le16 phy_status2;	/* PHY RX Status 2 */
 	} __packed;
-	__le16 phy_status3;	/* PHY RX Status 3 */
+	union {
+		/* HT-PHY */
+		struct {
+			__s8 phy_ht_power1;
+			__s8 phy_ht_power2;
+		} __packed;
+
+		__le16 phy_status3;	/* PHY RX Status 3 */
+	} __packed;
 	union {
 		/* Tested with 598.314, 644.1001 and 666.2 */
 		struct {
-- 
1.7.3.4

