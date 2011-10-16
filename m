Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43842 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1JPVX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Oct 2011 17:23:57 -0400
Received: by bkbzt19 with SMTP id zt19so2777984bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Oct 2011 14:23:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.2] b43: fill ctl1 word on all new PHYs, fix PHY errors
Date: Sun, 16 Oct 2011 23:23:56 +0200
Message-Id: <1318800236-5329-1-git-send-email-zajec5@gmail.com> (sfid-20111016_232400_329274_76E552AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes PHY transmission errors reported on some LP-PHY and HT-PHY
cards. For LP-PHY they were quite rare and not really noticable. On
HT-PHY they were critical, OFDM rates were not available at all.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
I've this patch since August or earlier, just didn't submit it yet. It
was succesfully tested on LP-PHY cards and fixed performance for every
tested HT-PHY case.
---
 drivers/net/wireless/b43/xmit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index c73e860..390c234 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -175,6 +175,7 @@ void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
 	}
 }
 
+/* TODO: verify for SSLPN and LCN if support is implemented */
 static u16 b43_generate_tx_phy_ctl1(struct b43_wldev *dev, u8 bitrate)
 {
 	const struct b43_phy *phy = &dev->phy;
@@ -531,7 +532,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			extra_ft |= B43_TXH_EFT_RTSFB_CCK;
 
 		if (rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS &&
-		    phy->type == B43_PHYTYPE_N) {
+		    phy->type >= B43_PHYTYPE_N) {
 			txhdr->phy_ctl1_rts = cpu_to_le16(
 				b43_generate_tx_phy_ctl1(dev, rts_rate));
 			txhdr->phy_ctl1_rts_fb = cpu_to_le16(
@@ -552,7 +553,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		break;
 	}
 
-	if (phy->type == B43_PHYTYPE_N) {
+	if (phy->type >= B43_PHYTYPE_N) {
 		txhdr->phy_ctl1 =
 			cpu_to_le16(b43_generate_tx_phy_ctl1(dev, rate));
 		txhdr->phy_ctl1_fb =
-- 
1.7.3.4

