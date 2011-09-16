Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64406 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1IPNdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 09:33:53 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] rfkill: properly assign a boolean type
Date: Fri, 16 Sep 2011 19:03:40 +0530
Message-ID: <1316180020-9982-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110916_153356_698258_8D31ACF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/rfkill/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index be90640..5be1957 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -235,7 +235,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
 	else
 		rfkill->state &= ~RFKILL_BLOCK_HW;
 	*change = prev != blocked;
-	any = rfkill->state & RFKILL_BLOCK_ANY;
+	any = !!(rfkill->state & RFKILL_BLOCK_ANY);
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
 	rfkill_led_trigger_event(rfkill);
-- 
1.7.0.4

