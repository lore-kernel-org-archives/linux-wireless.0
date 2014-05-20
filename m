Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41673 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaETGqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 02:46:35 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so179555eek.18
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 23:46:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: xmit: set 5 GHz bit depending on current band
Date: Tue, 20 May 2014 08:46:25 +0200
Message-Id: <1400568385-26182-1-git-send-email-zajec5@gmail.com> (sfid-20140520_084639_049087_D61056BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PHYs other than A may also work in 5 GHz mode.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 31adb8c..4f38f19 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -408,7 +408,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
-	if (phy->type == B43_PHYTYPE_A)
+	if (!phy->gmode)
 		mac_ctl |= B43_TXH_MAC_5GHZ;
 
 	/* Overwrite rates[0].count to make the retry calculation
-- 
1.8.4.5

