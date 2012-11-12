Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55841 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2KLV7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:06 -0500
Received: by mail-ea0-f174.google.com with SMTP id o11so438714eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:05 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 10/17] Fixed typo in TransmitConfig
Date: Mon, 12 Nov 2012 23:58:24 +0200
Message-Id: <1352757511-26957-11-git-send-email-maxtram95@gmail.com> (sfid-20121112_231527_036159_AF882466)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/r8180_core.c b/r8180_core.c
index ded5cd0..4e872d9 100644
--- a/r8180_core.c
+++ b/r8180_core.c
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

