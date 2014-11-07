Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36839 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaKGTGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:55 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so5777098wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:51 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/10] staging: vt6655: always keep abyCurrentNetAddr aligned to 2
Date: Fri,  7 Nov 2014 19:06:09 +0000
Message-Id: <1415387169-3843-10-git-send-email-tvboxspy@gmail.com> (sfid-20141107_201320_747909_ECDCD323)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because the driver now uses ether_addr_copy the alignment of this
variable must be maintained at 2.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 55aa48b..83efbfb 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -283,7 +283,7 @@ struct vnt_private {
 	bool bZoneRegExist;
 	unsigned char byOriginalZonetype;
 
-	unsigned char abyCurrentNetAddr[ETH_ALEN];
+	unsigned char abyCurrentNetAddr[ETH_ALEN]; __aligned(2)
 	bool bLinkPass;          /* link status: OK or fail */
 
 	/* Adapter statistics */
-- 
2.1.0

