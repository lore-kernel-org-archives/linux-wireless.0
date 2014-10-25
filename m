Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43122 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaJYTKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:10:50 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so3130059wgh.29
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:10:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 22/31] staging: vt6655: phy type same as bb type
Date: Sat, 25 Oct 2014 09:20:32 +0100
Message-Id: <1414225241-5480-23-git-send-email-tvboxspy@gmail.com> (sfid-20141025_211052_668456_E23C6736)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
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
1.9.1

