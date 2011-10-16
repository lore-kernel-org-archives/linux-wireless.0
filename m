Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54747 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1JPVat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Oct 2011 17:30:49 -0400
Received: by bkbzt19 with SMTP id zt19so2782896bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Oct 2011 14:30:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.2 REQUEST] b43: HT-PHY: report signal to mac80211
Date: Sun, 16 Oct 2011 23:30:49 +0200
Message-Id: <1318800649-5609-1-git-send-email-zajec5@gmail.com> (sfid-20111016_233053_144541_F398BE47)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John, this is new feature, not a bug fix. However I still think it'd be
great to take this for 3.2. This is hopefully final b43 patch for 3.2
related to HT-PHY support. With this last one, basic support should be
100% implemented now.

This can be even more important, as there isn't any native Linux driver
(open or closed source) for HT-PHY (BCM4331) other than b43.

This has been succesfully tested by David, reported signal looked sane
for him. Unfortunately we still lack info about the noise, but having
signal gives users some basic overview on the available networks.
---
 drivers/net/wireless/b43/xmit.c |    7 +++++++
 drivers/net/wireless/b43/xmit.h |   16 +++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 390c234..ed54f7d 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -737,7 +737,14 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 
 	/* Link quality statistics */
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
+	case B43_PHYTYPE_HT:
+		/* TODO: is max the right choice? */
+		status.signal = max(
+			(__s8) max(rxhdr->phy_ht_power0, rxhdr->phy_ht_power1),
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

