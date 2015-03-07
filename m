Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44812 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbCGQhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 11:37:16 -0500
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] staging: vt6656: vnt_rf_setpower: fix missing rate RATE_12M
Date: Sat,  7 Mar 2015 16:36:37 +0000
Message-Id: <1425746197-6614-1-git-send-email-tvboxspy@gmail.com> (sfid-20150307_173722_972179_CE891972)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver sets this rate a power of zero value is set causing
data flow stoppage until another rate is tried.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/staging/vt6656/rf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index c42cde5..c4286cc 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -640,6 +640,7 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 		break;
 	case RATE_6M:
 	case RATE_9M:
+	case RATE_12M:
 	case RATE_18M:
 	case RATE_24M:
 	case RATE_36M:
-- 
2.1.4

