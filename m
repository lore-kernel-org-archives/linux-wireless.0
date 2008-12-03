Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16621 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbYLCCVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 21:21:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 18:21:11 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <Sujith.Manoharan@atheros.com>, <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/2] ath9k: Use GFP_ATOMIC when allocating TX private area
Date: Tue, 2 Dec 2008 18:21:06 -0800
Message-ID: <1228270866-21516-3-git-send-email-lrodriguez@atheros.com> (sfid-20081203_032115_767501_C305736B)
In-Reply-To: <1228270866-21516-2-git-send-email-lrodriguez@atheros.com>
References: <1228270866-21516-1-git-send-email-lrodriguez@atheros.com>
 <1228270866-21516-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using GFP_KERNEL was wrong and produces a 'scheduling while atomic'
bug. Also, check for proper return values now, in case allocation
fails.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index ef209b5..c815198 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1663,7 +1663,9 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	int hdrlen;
 	__le16 fc;
 
-	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_KERNEL);
+	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_ATOMIC);
+	if (!tx_info_priv)
+		return -ENOMEM;
 	tx_info->rate_driver_data[0] = tx_info_priv;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
-- 
1.5.6.rc2.15.g457bb.dirty

