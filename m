Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbcCKT5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 14:57:35 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 3/7] rtl8xxxu: Correct txdesc40 gid definition
Date: Fri, 11 Mar 2016 14:57:30 -0500
Message-Id: <1457726254-28178-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160311_205740_366511_098305F5)
In-Reply-To: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

txdesc40 dword2 gid is a 6 bit field, not a single bit

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 38d4f56..af1d504 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -464,7 +464,7 @@ struct rtl8xxxu_txdesc40 {
 #define TXDESC40_SPE_RPT		BIT(19)
 #define TXDESC_AMPDU_DENSITY_SHIFT	20
 #define TXDESC40_BT_INT			BIT(23)
-#define TXDESC40_GID			BIT(24)
+#define TXDESC40_GID_SHIFT		24
 
 /* Word 3 */
 #define TXDESC40_USE_DRIVER_RATE	BIT(8)
-- 
2.5.0

