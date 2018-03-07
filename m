Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35056 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbeCGJ0K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 04:26:10 -0500
Received: by mail-wm0-f67.google.com with SMTP id x7so3334653wmc.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2018 01:26:10 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt7601u: simplify mt7601u_mcu_msg_alloc signature
Date: Wed,  7 Mar 2018 10:25:50 +0100
Message-Id: <bfc6bf9aa8dc2fe89ad283c457030797d75ec3b8.1520414446.git.lorenzo.bianconi@redhat.com> (sfid-20180307_102614_049927_63E6C8E0)
In-Reply-To: <cover.1520414446.git.lorenzo.bianconi@redhat.com>
References: <cover.1520414446.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove mt7601u_dev parameter from mt7601u_mcu_msg_alloc signature since
dev pointer is never used in routine body

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/mcu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index 65a8004418ea..d9d6fd7eff5e 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -58,8 +58,7 @@ static inline void trace_mt_mcu_msg_send_cs(struct mt7601u_dev *dev,
 	trace_mt_mcu_msg_send(dev, skb, csum, need_resp);
 }
 
-static struct sk_buff *
-mt7601u_mcu_msg_alloc(struct mt7601u_dev *dev, const void *data, int len)
+static struct sk_buff *mt7601u_mcu_msg_alloc(const void *data, int len)
 {
 	struct sk_buff *skb;
 
@@ -171,7 +170,7 @@ static int mt7601u_mcu_function_select(struct mt7601u_dev *dev,
 		.value = cpu_to_le32(val),
 	};
 
-	skb = mt7601u_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	skb = mt7601u_mcu_msg_alloc(&msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
 	return mt7601u_mcu_msg_send(dev, skb, CMD_FUN_SET_OP, func == 5);
@@ -208,7 +207,7 @@ mt7601u_mcu_calibrate(struct mt7601u_dev *dev, enum mcu_calibrate cal, u32 val)
 		.value = cpu_to_le32(val),
 	};
 
-	skb = mt7601u_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	skb = mt7601u_mcu_msg_alloc(&msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
 	return mt7601u_mcu_msg_send(dev, skb, CMD_CALIBRATION_OP, true);
-- 
2.14.3
