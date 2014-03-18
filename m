Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42181 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbaCRT0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:33 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so6235914wgh.31
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/14] staging: vt6656: vnt_rxtx_rsvtime_le16 fix return.
Date: Tue, 18 Mar 2014 19:25:07 +0000
Message-Id: <1395170708-2990-13-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202649_768127_75E9A3E7)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always returns to __le16 type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index d30e699..924d9a2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -359,7 +359,7 @@ static u32 s_uGetTxRsvTime(struct vnt_private *priv, u8 pkt_type,
 	return data_time;
 }
 
-static u16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
+static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 	u32 frame_length, u16 rate, int need_ack)
 {
 	return cpu_to_le16((u16)s_uGetTxRsvTime(priv, pkt_type,
-- 
1.9.0

