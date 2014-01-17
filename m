Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59523 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaAQPTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 10:19:49 -0500
From: ZHAO Gang <gamerh2o@gmail.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Jonas Gorski <jogo@openwrt.org>, Luca Coelho <luca@coelho.fi>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<b43-dev@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH v3 1/2] b43: fix the wrong assignment of status.freq in b43_rx()
Date: Fri, 17 Jan 2014 23:19:13 +0800
Message-Id: <b28b37da08e43e0f459c5094ed210649ab1f7090.1389970392.git.gamerh2o@gmail.com> (sfid-20140117_161955_063280_BEA8D929)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the right function to update status.freq. The wrong frequency
value can cause problem that bss info can't be updated when it
should be.

This bug is introduced by commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
"cfg80211 API for channels/bitrates, mac80211 and driver conversion".

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
v3: change commit log
    suggested by Luca Coelho, Rafał Miłecki and Jonas Gorski

I'm not very familiar with wireless subsystem yet. If commit message needs
more changes, feel free to point it out.

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

