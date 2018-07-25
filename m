Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:50523 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbeGYUN2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 16:13:28 -0400
From: Varsha Rao <rvarsha016@gmail.com>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] net: wireless: cw1200: Remove extra parentheses
Date: Wed, 25 Jul 2018 21:00:07 +0200
Message-Id: <20180725190011.4317-1-rvarsha016@gmail.com> (sfid-20180725_210041_746733_AD8FA103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary parentheses to fix the extraneous parentheses clang
warning.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 drivers/net/wireless/st/cw1200/txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index f7b1b0062db3..8c800ef23159 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -624,9 +624,9 @@ cw1200_tx_h_bt(struct cw1200_common *priv,
 			priority = WSM_EPTA_PRIORITY_ACTION;
 		else if (ieee80211_is_mgmt(t->hdr->frame_control))
 			priority = WSM_EPTA_PRIORITY_MGT;
-		else if ((wsm->queue_id == WSM_QUEUE_VOICE))
+		else if (wsm->queue_id == WSM_QUEUE_VOICE)
 			priority = WSM_EPTA_PRIORITY_VOICE;
-		else if ((wsm->queue_id == WSM_QUEUE_VIDEO))
+		else if (wsm->queue_id == WSM_QUEUE_VIDEO)
 			priority = WSM_EPTA_PRIORITY_VIDEO;
 		else
 			priority = WSM_EPTA_PRIORITY_DATA;
-- 
2.17.0
