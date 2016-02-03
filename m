Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965729AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 07/28] rtl8xxxu: Add more RCR bits
Date: Wed,  3 Feb 2016 13:39:41 -0500
Message-Id: <1454524802-26763-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194818_793086_CBA261A2)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 89547b6..f752602 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -568,9 +568,18 @@
 #define  RCR_ACCEPT_CTRL_FRAME		BIT(12)
 #define  RCR_ACCEPT_MGMT_FRAME		BIT(13)
 #define  RCR_HTC_LOC_CTRL		BIT(14) /* MFC<--HTC=1 MFC-->HTC=0 */
+#define  RCR_UC_DATA_PKT_INT_ENABLE	BIT(16) /* Enable unicast data packet
+						   interrupt */
+#define  RCR_BM_DATA_PKT_INT_ENABLE	BIT(17) /* Enable broadcast data packet
+						   interrupt */
+#define  RCR_TIM_PARSER_ENABLE		BIT(18) /* Enable RX beacon TIM parser*/
 #define  RCR_MFBEN			BIT(22)
-#define  RCR_LSIGEN			BIT(23)
+#define  RCR_LSIG_ENABLE		BIT(23) /* Enable LSIG TXOP Protection
+						   function. Search KEYCAM for
+						   each rx packet to check if
+						   LSIGEN bit is set. */
 #define  RCR_MULTI_BSSID_ENABLE		BIT(24) /* Enable Multiple BssId */
+#define  RCR_FORCE_ACK			BIT(26)
 #define  RCR_ACCEPT_BA_SSN		BIT(27) /* Accept BA SSN */
 #define  RCR_APPEND_PHYSTAT		BIT(28)
 #define  RCR_APPEND_ICV			BIT(29)
-- 
2.5.0

