Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0IHX0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:26:05 -0400
Received: by mail-pz0-f46.google.com with SMTP id 34so248716pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:26:05 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 9/9] libertas_tf: Allow tx up to full chip buffers
Date: Wed,  8 Sep 2010 16:25:29 -0700
Message-Id: <1283988329-44549-10-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/libertas_tf.h |    1 +
 drivers/net/wireless/libertas_tf/main.c        |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index db6dd7b..5ccec4d 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -104,6 +104,7 @@ enum lbtf_mode {
 #define LBS_CMD_BUFFER_SIZE             (2 * 1024)
 #define MRVDRV_MAX_CHANNEL_SIZE		14
 #define MRVDRV_SNAP_HEADER_LEN          8
+#define LBS_NUM_BUFFERS				7
 
 #define	LBS_UPLD_SIZE			2312
 #define DEV_NAME_LEN			32
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 6c4a1b6..0b03fd5 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -315,8 +315,11 @@ static void lbtf_tx_work(struct work_struct *work)
 		dev_kfree_skb_any(skb);
 		skb_dequeue_tail(&priv->tx_skb_buf);
 		pr_err("TX error: %d", err);
+	} else {
+		if (LBS_NUM_BUFFERS > skb_queue_len(&priv->tx_skb_buf))
+			ieee80211_wake_queues(priv->hw);
+		lbtf_deb_tx("TX success");
 	}
-	lbtf_deb_tx("TX success");
 	lbtf_deb_leave(LBTF_DEB_MACOPS | LBTF_DEB_TX);
 }
 
-- 
1.7.0

