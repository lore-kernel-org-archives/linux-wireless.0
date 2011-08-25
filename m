Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48614 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab1HYVrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 17:47:48 -0400
Received: by fxh19 with SMTP id 19so2088502fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 14:47:47 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Use do_div for 64-bit division to fix 32-bit kernels
Date: Thu, 25 Aug 2011 23:47:35 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201108252347.35706.chunkeey@googlemail.com> (sfid-20110825_234752_519482_D05C2AC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the do_div macro for 64-bit division. Otherwise, the module will
reference __udivdi3 under 32-bit kernels, which is not allowed in
kernel space.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 44a3bd4..9865881 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
+#include <asm/div64.h>
 
 #include <net/mac80211.h>
 
@@ -582,10 +583,13 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	if (chan) {
 		struct survey_info *survey = &priv->survey[chan->hw_value];
 		survey->noise = clamp_t(s8, priv->noise, -128, 127);
-		survey->channel_time = priv->survey_raw.active / 1024;
-		survey->channel_time_tx = priv->survey_raw.tx / 1024;
-		survey->channel_time_busy = priv->survey_raw.cca / 1024 +
-			survey->channel_time_tx;
+		survey->channel_time = priv->survey_raw.active;
+		survey->channel_time_tx = priv->survey_raw.tx;
+		survey->channel_time_busy = priv->survey_raw.tx +
+			priv->survey_raw.cca;
+		do_div(survey->channel_time, 1024);
+		do_div(survey->channel_time_tx, 1024);
+		do_div(survey->channel_time_busy, 1024);
 	}
 
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
