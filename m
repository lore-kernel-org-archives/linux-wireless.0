Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 091/113] rtl8xxxu: Add additional tx descriptor bits for data word 0
Date: Mon, 29 Feb 2016 17:05:29 -0500
Message-Id: <1456783551-28315-92-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230633_385184_6375731E)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This adds documentation for some additional bits in TX descriptor word
0.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index d53912a..9364a31 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -407,8 +407,12 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_OWN			BIT(31)
 #else
 #define TXDESC_BROADMULTICAST		BIT(0)
+#define TXDESC_HTC			BIT(1)
 #define TXDESC_LAST_SEGMENT		BIT(2)
 #define TXDESC_FIRST_SEGMENT		BIT(3)
+#define TXDESC_LINIP			BIT(4)
+#define TXDESC_NO_ACM			BIT(5)
+#define TXDESC_GF			BIT(6)
 #define TXDESC_OWN			BIT(7)
 #endif
 
-- 
2.5.0

