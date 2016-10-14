Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43263 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbcJNJno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 05:43:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: chunkeey@googlemail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] p54: memset(0) whole array
Date: Fri, 14 Oct 2016 11:23:09 +0200
Message-Id: <20161014092309.24113-1-jslaby@suse.cz> (sfid-20161014_114410_955937_84983FCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 7 complains:
drivers/net/wireless/intersil/p54/fwio.c: In function 'p54_scan':
drivers/net/wireless/intersil/p54/fwio.c:491:4: warning: 'memset' used with length equal to number of elements without multiplication by element size [-Wmemset-elt-size]

Fix that by passing the correct size to memset.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/intersil/p54/fwio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index 257a9eadd595..4ac6764f4897 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -488,7 +488,7 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 
 			entry += sizeof(__le16);
 			chan->pa_points_per_curve = 8;
-			memset(chan->curve_data, 0, sizeof(*chan->curve_data));
+			memset(chan->curve_data, 0, sizeof(chan->curve_data));
 			memcpy(chan->curve_data, entry,
 			       sizeof(struct p54_pa_curve_data_sample) *
 			       min((u8)8, curve_data->points_per_channel));
-- 
2.10.1
