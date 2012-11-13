Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36456 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KMR3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:07 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133294eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:29:07 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 10/17] staging: rtl8187se: Fixed typo in TransmitConfig
Date: Tue, 13 Nov 2012 19:28:16 +0200
Message-Id: <1352827703-4659-11-git-send-email-maxtram95@gmail.com> (sfid-20121113_182916_118927_0D4A26D0)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed typo in TransmitConfig and removed always false condition

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index be2344d..642508e 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2581,11 +2581,10 @@ short rtl8180_init(struct net_device *dev)
 
 	priv->CSMethod = (0x01 << 29);
 
-	priv->TransmitConfig =	TCR_DurProcMode_OFFSET |
+	priv->TransmitConfig =	(1<<TCR_DurProcMode_OFFSET) |
 				(7<<TCR_MXDMA_OFFSET) |
 				(priv->ShortRetryLimit<<TCR_SRL_OFFSET) |
-				(priv->LongRetryLimit<<TCR_LRL_OFFSET) |
-				(0 ? TCR_SAT : 0);
+				(priv->LongRetryLimit<<TCR_LRL_OFFSET);
 
 	priv->ReceiveConfig =	RCR_AMF | RCR_ADF | RCR_ACF |
 				RCR_AB | RCR_AM | RCR_APM |
-- 
1.7.10.4

