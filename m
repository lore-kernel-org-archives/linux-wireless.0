Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:59192 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYGHUr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 16:47:29 -0400
Received: by yx-out-2324.google.com with SMTP id 8so687168yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 13:47:29 -0700 (PDT)
Subject: [PATCH 3/6] b43legacy: use le16 frame control directly, avoid
	byteswapping
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 13:47:23 -0700
Message-Id: <1215550043.476.41.camel@brick> (sfid-20080708_224733_108782_913B0E95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43legacy/xmit.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index a354078..5e8a575 100644
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
@@ -295,8 +293,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 	/* MAC control */
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43legacy_TX4_MAC_ACK;
-	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
+	if (!ieee80211_is_pspoll(wlhdr->frame_control))
 		mac_ctl |= B43legacy_TX4_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43legacy_TX4_MAC_STMSDU;
-- 
1.5.6.1.322.ge904b


