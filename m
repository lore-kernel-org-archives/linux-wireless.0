Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:53497 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaBYUyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:54:03 -0500
Received: by mail-we0-f175.google.com with SMTP id q59so908101wes.34
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:54:01 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Joe Perches <joe@perches.com>
Subject: [PATCH 10/10] staging: vt6656: struct vnt_usb_send_context struct size optimization.
Date: Tue, 25 Feb 2014 20:51:52 +0000
Message-Id: <1393361512-13805-10-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215413_156516_D2EE0875)
In-Reply-To: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
References: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder in size and remove dead member Next.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 54c6383..ce1587a 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -179,10 +179,9 @@ struct vnt_usb_send_context {
 	void *pDevice;
 	struct sk_buff *pPacket;
 	struct urb *pUrb;
+	struct ethhdr sEthHeader;
 	unsigned int uBufLen;
 	u8 type;
-	struct ethhdr sEthHeader;
-	void *Next;
 	bool bBoolInUse;
 	unsigned char Data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
 };
-- 
1.9.0

