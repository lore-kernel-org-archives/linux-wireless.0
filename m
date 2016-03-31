Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbcCaVIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:44 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 03/10] rtl8xxxu: Correct txdesc40 gid definition
Date: Thu, 31 Mar 2016 17:08:35 -0400
Message-Id: <1459458522-28686-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160331_230856_259659_08CD88C9)
In-Reply-To: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
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
2.5.5

