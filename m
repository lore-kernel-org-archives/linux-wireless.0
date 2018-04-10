Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33875 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754326AbeDJPBz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:01:55 -0400
Received: by mail-pf0-f194.google.com with SMTP id q9so8536600pff.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:01:55 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 5/7] rsi: parse TID from data frame correctly
Date: Tue, 10 Apr 2018 20:34:15 +0530
Message-Id: <1523372657-6067-6-git-send-email-siva8118@gmail.com> (sfid-20180410_170200_114199_9C2B6ACA)
In-Reply-To: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Currently TID is extracted by checking at specific offset in data frame.
This approach doesn't work for some of the frames. This patch uses mac80211
API and do it correctly

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 3ca468b9..1f1b972 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -432,7 +432,9 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 		}
 	} else {
 		if (ieee80211_is_data_qos(wh->frame_control)) {
-			tid = (skb->data[24] & IEEE80211_QOS_TID);
+			u8 *qos = ieee80211_get_qos_ctl(wh);
+
+			tid = *qos & IEEE80211_QOS_CTL_TID_MASK;
 			skb->priority = TID_TO_WME_AC(tid);
 		} else {
 			tid = IEEE80211_NONQOS_TID;
-- 
2.7.4
