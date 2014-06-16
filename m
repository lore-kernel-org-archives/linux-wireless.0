Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42181 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFPOQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:16:24 -0400
Received: by mail-pd0-f170.google.com with SMTP id z10so3032104pdj.29
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:16:24 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id bc4sm19069686pbb.2.2014.06.16.07.16.22
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:16:23 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 13/16] rsi: Sending QoS null packet via the mgmt queue.
Date: Mon, 16 Jun 2014 19:46:13 +0530
Message-Id: <1402928173-4174-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161628_184222_179FB99C)
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

