Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43643 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408AbbIUNgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 09:36:24 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 23/38] rndis_wlan: fix checking for default value
Date: Mon, 21 Sep 2015 15:33:55 +0200
Message-id: <1442842450-29769-24-git-send-email-a.hajda@samsung.com> (sfid-20150921_154601_011412_9A94B866)
In-reply-to: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thresholds uses -1 to indicate that default value should be used.
Since thresholds are unsigned sign checking makes no sense.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/net/wireless/rndis_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 71a825c..a13d1f2 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1236,7 +1236,7 @@ static int set_rts_threshold(struct usbnet *usbdev, u32 rts_threshold)
 
 	netdev_dbg(usbdev->net, "%s(): %i\n", __func__, rts_threshold);
 
-	if (rts_threshold < 0 || rts_threshold > 2347)
+	if (rts_threshold == -1 || rts_threshold > 2347)
 		rts_threshold = 2347;
 
 	tmp = cpu_to_le32(rts_threshold);
-- 
1.9.1

