Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:32779 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbaCRT0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:21 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so6169976wes.22
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/14] staging: vt6656: struct vnt_tx_short_buf_head correct base types
Date: Tue, 18 Mar 2014 19:25:02 +0000
Message-Id: <1395170708-2990-8-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202650_065880_198F0C2E)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both variables duration and time_stamp_off are __le16 types

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 3978174..6d6539d 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -234,8 +234,8 @@ struct vnt_tx_short_buf_head {
 	u16 fifo_ctl;
 	u16 time_stamp;
 	struct vnt_phy_field ab;
-	u16 duration;
-	u16 time_stamp_off;
+	__le16 duration;
+	__le16 time_stamp_off;
 } __packed;
 
 struct vnt_beacon_buffer {
-- 
1.9.0

