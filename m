Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48193 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1LHVaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 16:30:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl12xx: silence tx_attr uninitialized warning in wl1271_tx_fill_hdr
Date: Thu,  8 Dec 2011 16:15:58 -0500
Message-Id: <1323378958-13748-1-git-send-email-linville@tuxdriver.com> (sfid-20111208_223024_697429_89E61DBD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/wl12xx/tx.o
drivers/net/wireless/wl12xx/tx.c: In function ‘wl1271_tx_fill_hdr’:
drivers/net/wireless/wl12xx/tx.c:288:6: warning: ‘tx_attr’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 36eb0d6..7d727ee 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -285,7 +285,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	struct wl1271_tx_hw_descr *desc;
 	int aligned_len, ac, rate_idx;
 	s64 hosttime;
-	u16 tx_attr;
+	u16 tx_attr = 0;
 	bool is_dummy;
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
-- 
1.7.4.4

