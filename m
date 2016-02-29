Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 088/113] rtl8xxxu: Add definition for 8723bu tx descriptor
Date: Mon, 29 Feb 2016 17:05:26 -0500
Message-Id: <1456783551-28315-89-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230636_052391_1EE8302C)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Newer generation chips use a 40 byte TX descriptor, compared to the
32 byte descriptor used on older chips.

This adds the definition for the 40 byte descriptor.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index fe23561..f06b88b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -346,6 +346,22 @@ struct rtl8xxxu_tx_desc {
 	__le16 txdw7;
 };
 
+struct rtl8723bu_tx_desc {
+	__le16 pkt_size;
+	u8 pkt_offset;
+	u8 txdw0;
+	__le32 txdw1;
+	__le32 txdw2;
+	__le32 txdw3;
+	__le32 txdw4;
+	__le32 txdw5;
+	__le32 txdw6;
+	__le16 csum;
+	__le16 txdw7;
+	__le32 txdw8;
+	__le32 txdw9;
+};
+
 /*  CCK Rates, TxHT = 0 */
 #define DESC_RATE_1M			0x00
 #define DESC_RATE_2M			0x01
-- 
2.5.0

