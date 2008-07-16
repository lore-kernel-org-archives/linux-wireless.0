Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:37996 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbYGPBn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:43:58 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5533655wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:43:57 -0700 (PDT)
Subject: [PATCH 01/12] b43legacy: use le16 frame control directly, avoid
	byteswapping
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:43:56 -0700
Message-Id: <1216172636.6610.48.camel@brick> (sfid-20080716_034403_643728_10EDFC19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43legacy/xmit.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index e969ed8..e96c684 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -193,7 +193,6 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 {
 	const struct ieee80211_hdr *wlhdr;
 	int use_encryption = (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT));
-	u16 fctl;
 	u8 rate;
 	struct ieee80211_rate *rate_fb;
 	int rate_ofdm;
@@ -204,7 +203,6 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 	struct ieee80211_rate *tx_rate;
 
 	wlhdr = (const struct ieee80211_hdr *)fragment_data;
-	fctl = le16_to_cpu(wlhdr->frame_control);
 
 	memset(txhdr, 0, sizeof(*txhdr));
 
@@ -253,7 +251,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 			mac_ctl |= (key->algorithm <<
 				   B43legacy_TX4_MAC_KEYALG_SHIFT) &
 				   B43legacy_TX4_MAC_KEYALG;
-			wlhdr_len = ieee80211_get_hdrlen(fctl);
+			wlhdr_len = ieee80211_hdrlen(wlhdr->frame_control);
 			iv_len = min((size_t)info->control.iv_len,
 				     ARRAY_SIZE(txhdr->iv));
 			memcpy(txhdr->iv, ((u8 *)wlhdr) + wlhdr_len, iv_len);
-- 
1.5.6.3.499.geae9


