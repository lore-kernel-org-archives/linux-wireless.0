Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64018 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAQQSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 11:18:12 -0500
From: ZHAO Gang <gamerh2o@gmail.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jonas Gorski <jogo@openwrt.org>, Luca Coelho <luca@coelho.fi>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<b43-dev@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH v4 1/2] b43: fix the wrong assignment of status.freq in b43_rx()
Date: Sat, 18 Jan 2014 00:17:38 +0800
Message-Id: <d4d1340a176aee1e58ffe80e83ddc3394f2829e3.1389975095.git.gamerh2o@gmail.com> (sfid-20140117_171816_222299_59D26795)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the right function to update frequency value.

If rx skb is probe response or beacon, the wrong frequency value can
cause problem that bss info can't be updated when it should be.

Cc: <stable@vger.kernel.org>
Fixes: 8318d78a44d4 ("cfg80211 API for channels/bitrates, mac80211
and driver conversion")
Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
v4: change commit message
    suggested by Johannes Berg

 drivers/net/wireless/b43/xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 4ae63f4..50e5ddb 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -821,10 +821,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		 * channel number in b43. */
 		if (chanstat & B43_RX_CHAN_5GHZ) {
 			status.band = IEEE80211_BAND_5GHZ;
-			status.freq = b43_freq_to_channel_5ghz(chanid);
+			status.freq = b43_channel_to_freq_5ghz(chanid);
 		} else {
 			status.band = IEEE80211_BAND_2GHZ;
-			status.freq = b43_freq_to_channel_2ghz(chanid);
+			status.freq = b43_channel_to_freq_2ghz(chanid);
 		}
 		break;
 	default:
-- 
1.8.4.2

