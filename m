Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51543 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1JQO71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 10:59:27 -0400
Received: by eye27 with SMTP id 27so3042543eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 07:59:25 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 3.2] b43: fill ctl1 word on all newer PHYs, fix PHY errors
Date: Mon, 17 Oct 2011 16:59:25 +0200
Message-Id: <1318863565-27145-1-git-send-email-zajec5@gmail.com> (sfid-20111017_165930_699462_D279B06E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes PHY transmission errors reported on some LP-PHY and HT-PHY
cards. For LP-PHY they were quite rare and not really noticable. On
HT-PHY they were critical, OFDM rates were not available at all.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: don't use >= for checking "old" vs. "new" PHY type, that was a
little hacky.
---
 drivers/net/wireless/b43/xmit.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index c73e860..8d69f7f 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -175,6 +175,7 @@ void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
 	}
 }
 
+/* TODO: verify if needed for SSLPN or LCN  */
 static u16 b43_generate_tx_phy_ctl1(struct b43_wldev *dev, u8 bitrate)
 {
 	const struct b43_phy *phy = &dev->phy;
@@ -256,6 +257,9 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	unsigned int plcp_fragment_len;
 	u32 mac_ctl = 0;
 	u16 phy_ctl = 0;
+	bool fill_phy_ctl1 = (phy->type == B43_PHYTYPE_LP ||
+			      phy->type == B43_PHYTYPE_N ||
+			      phy->type == B43_PHYTYPE_HT);
 	u8 extra_ft = 0;
 	struct ieee80211_rate *txrate;
 	struct ieee80211_tx_rate *rates;
@@ -531,7 +535,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			extra_ft |= B43_TXH_EFT_RTSFB_CCK;
 
 		if (rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS &&
-		    phy->type == B43_PHYTYPE_N) {
+		    fill_phy_ctl1) {
 			txhdr->phy_ctl1_rts = cpu_to_le16(
 				b43_generate_tx_phy_ctl1(dev, rts_rate));
 			txhdr->phy_ctl1_rts_fb = cpu_to_le16(
@@ -552,7 +556,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		break;
 	}
 
-	if (phy->type == B43_PHYTYPE_N) {
+	if (fill_phy_ctl1) {
 		txhdr->phy_ctl1 =
 			cpu_to_le16(b43_generate_tx_phy_ctl1(dev, rate));
 		txhdr->phy_ctl1_fb =
-- 
1.7.3.4

