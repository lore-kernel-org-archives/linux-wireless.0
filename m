Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36072 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab1JLVSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 17:18:25 -0400
Received: by eye27 with SMTP id 27so1182904eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 14:18:23 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: report signal to mac80211
Date: Wed, 12 Oct 2011 23:18:15 +0200
Message-Id: <1318454295-20573-2-git-send-email-zajec5@gmail.com> (sfid-20111012_231827_688902_1AEE6F9A)
In-Reply-To: <1318454295-20573-1-git-send-email-zajec5@gmail.com>
References: <1318454295-20573-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: do you think it is still possible to get this for 3.2?
---
 drivers/net/wireless/b43/xmit.c |   18 ++++++++++++------
 drivers/net/wireless/b43/xmit.h |   10 +++++++++-
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index b8de62c..c73e860 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -735,16 +735,22 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	}
 
 	/* Link quality statistics */
-	if ((chanstat & B43_RX_CHAN_PHYTYPE) == B43_PHYTYPE_N) {
-//		s8 rssi = max(rxhdr->power0, rxhdr->power1);
-		//TODO: Find out what the rssi value is (dBm or percentage?)
-		//      and also find out what the maximum possible value is.
-		//      Fill status.ssi and status.signal fields.
-	} else {
+	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
+	case B43_PHYTYPE_N:
+		if (rxhdr->power0 == 16 || rxhdr->power0 == 32)
+			status.signal = max(rxhdr->power1, rxhdr->power2);
+		else
+			status.signal = max(rxhdr->power0, rxhdr->power1);
+		break;
+	case B43_PHYTYPE_A:
+	case B43_PHYTYPE_B:
+	case B43_PHYTYPE_G:
+	case B43_PHYTYPE_LP:
 		status.signal = b43_rssi_postprocess(dev, rxhdr->jssi,
 						  (phystat0 & B43_RX_PHYST0_OFDM),
 						  (phystat0 & B43_RX_PHYST0_GAINCTL),
 						  (phystat3 & B43_RX_PHYST3_TRSTATE));
+		break;
 	}
 
 	if (phystat0 & B43_RX_PHYST0_OFDM)
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index f6e8bc4..16c514d 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -248,7 +248,15 @@ struct b43_rxhdr_fw4 {
 			__s8 power1;	/* PHY RX Status 1: Power 1 */
 		} __packed;
 	} __packed;
-	__le16 phy_status2;	/* PHY RX Status 2 */
+	union {
+		/* RSSI for N-PHYs */
+		struct {
+			__s8 power2;
+			PAD_BYTES(1);
+		} __packed;
+
+		__le16 phy_status2;	/* PHY RX Status 2 */
+	} __packed;
 	__le16 phy_status3;	/* PHY RX Status 3 */
 	union {
 		/* Tested with 598.314, 644.1001 and 666.2 */
-- 
1.7.3.4

