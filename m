Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34843 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbbILSLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:08 -0400
Received: by wicge5 with SMTP id ge5so96622552wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/11] staging: vt6655: remove unused multicast_limit.
Date: Sat, 12 Sep 2015 19:10:31 +0100
Message-Id: <1442081438-3485-4-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201652_127455_41E67400)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

multicast_limit is assigned a vale that is never used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 1 -
 drivers/staging/vt6655/device_main.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index be42e44..f020bb1 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -256,7 +256,6 @@ struct vnt_private {
 
 	u32                         rx_buf_sz;
 	u8 rx_rate;
-	int                         multicast_limit;
 
 	u32                         rx_bytes;
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 4bc9ba0..fcc4510 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -442,7 +442,6 @@ static void vt6655_init_info(struct pci_dev *pcid,
 	memset(*ppDevice, 0, sizeof(**ppDevice));
 
 	(*ppDevice)->pcid = pcid;
-	(*ppDevice)->multicast_limit = 32;
 
 	spin_lock_init(&((*ppDevice)->lock));
 }
-- 
2.5.0

