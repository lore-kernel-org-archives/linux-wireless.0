Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58178 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaFNNyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:54:47 -0400
Received: by mail-pb0-f52.google.com with SMTP id rq2so943452pbb.39
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:54:47 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id nw13sm37746610pab.37.2014.06.14.06.54.45
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:54:46 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/16] rsi: Sending QoS null packet via the mgmt queue.
Date: Sat, 14 Jun 2014 19:24:37 +0530
Message-Id: <1402754077-14225-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155450_220764_34CBFCC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send the QoS null packet via mgmt queue.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 6f6a4d0..1cd0914 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -339,7 +339,8 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	}
 
 	if ((ieee80211_is_mgmt(tmp_hdr->frame_control)) ||
-	    (ieee80211_is_ctl(tmp_hdr->frame_control))) {
+	    (ieee80211_is_ctl(tmp_hdr->frame_control)) ||
+	    (ieee80211_is_qos_nullfunc(tmp_hdr->frame_control))) {
 		q_num = MGMT_SOFT_Q;
 		skb->priority = q_num;
 	} else {
-- 
1.7.1

