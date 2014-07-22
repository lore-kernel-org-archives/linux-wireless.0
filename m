Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:58414 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbaGVVui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 17:50:38 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so280209wes.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 14:50:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/7] staging: vt6656: struct vnt_tx_short_buf_head change base type of fifo_ctl to __le16
Date: Tue, 22 Jul 2014 22:49:49 +0100
Message-Id: <1406065789-3374-7-git-send-email-tvboxspy@gmail.com> (sfid-20140722_235042_020379_0EBE8E5E)
In-Reply-To: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
References: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Base type is always little endian.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 64ec206..2d1ef88 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1013,7 +1013,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 				vnt_time_stamp_off(priv, current_rate);
 	} else {
 		current_rate = RATE_1M;
-		short_head->fifo_ctl |= FIFOCTL_11B;
+		short_head->fifo_ctl |= cpu_to_le16(FIFOCTL_11B);
 
 		/* Get SignalField,ServiceField,Length */
 		vnt_get_phy_field(priv, frame_size, current_rate,
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 3f0ff7a..90b34ab2 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -237,7 +237,7 @@ struct vnt_tx_buffer {
 } __packed;
 
 struct vnt_tx_short_buf_head {
-	u16 fifo_ctl;
+	__le16 fifo_ctl;
 	u16 time_stamp;
 	struct vnt_phy_field ab;
 	__le16 duration;
-- 
2.0.1

