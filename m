Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62752 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaE0UGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:08 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so10063458wev.5
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/10] staging: vt6656: IFRFbWriteEmbedded use ARRAY_SIZE
Date: Tue, 27 May 2014 21:05:18 +0100
Message-Id: <1401221126-4219-2-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220625_812716_E1CFA184)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace magic number with ARRAY_SIZE of pbyData

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index d244dab..9126156 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -716,7 +716,7 @@ int IFRFbWriteEmbedded(struct vnt_private *pDevice, u32 dwData)
 	pbyData[3] = (u8)(dwData >> 24);
 
 	vnt_control_out(pDevice,
-		MESSAGE_TYPE_WRITE_IFRF, 0, 0, 4, pbyData);
+		MESSAGE_TYPE_WRITE_IFRF, 0, 0, ARRAY_SIZE(pbyData), pbyData);
 
 	return true;
 }
-- 
1.9.1

