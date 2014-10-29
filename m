Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45787 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbaJ2Rpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:49 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so2406536wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:48 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 22/34] staging: vt6655: phy type same as bb type
Date: Wed, 29 Oct 2014 17:43:57 +0000
Message-Id: <1414604649-9105-23-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184905_959262_A91B1AD4)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To maintain functionality

typedef enum _CARD_PHY_TYPE should have the same values as
typedef enum _VIA_PKT_TYPE

TODO both these types need merging.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 96f5b6c..a51a849 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -52,10 +52,10 @@
 #define CB_MAX_CHANNEL          (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
 
 typedef enum _CARD_PHY_TYPE {
-	PHY_TYPE_AUTO,
+	PHY_TYPE_11A = 0,
 	PHY_TYPE_11B,
 	PHY_TYPE_11G,
-	PHY_TYPE_11A
+	PHY_TYPE_AUTO
 } CARD_PHY_TYPE, *PCARD_PHY_TYPE;
 
 typedef enum _CARD_PKT_TYPE {
-- 
2.1.0

