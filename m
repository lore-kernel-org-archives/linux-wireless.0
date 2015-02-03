Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46926 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676AbbBCRP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 12:15:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH RESEND 2/2] rtlwifi: rtl8192ee: Fix problems with calculating free space in FIFO
Date: Tue,  3 Feb 2015 11:15:18 -0600
Message-Id: <1422983718-21432-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150203_181535_195749_45AB2894)
In-Reply-To: <1422983718-21432-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1422983718-21432-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver utilizes a FIFO buffer for RX descriptors. There are four places
in the code where it calculates the number of free slots. Several of those
locations do the calculation incorrectly. To fix these and to prevent future
mistakes, a common inline routine is created.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [V3.18]
---
 drivers/net/wireless/rtlwifi/pci.h           | 7 +++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c | 9 +--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index 5e83230..d4567d1 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -325,4 +325,11 @@ static inline void pci_write32_async(struct rtl_priv *rtlpriv,
 	writel(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
+static inline u16 calc_fifo_space(u16 rp, u16 wp)
+{
+	if (rp <= wp)
+		return RTL_PCI_MAX_RX_COUNT - 1 + rp - wp;
+	return rp - wp - 1;
+}
+
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
index 1245e2f..d39ee67 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
@@ -499,14 +499,7 @@ u16 rtl92ee_rx_desc_buff_remained_cnt(struct ieee80211_hw *hw, u8 queue_index)
 	if (!start_rx)
 		return 0;
 
-	if ((last_read_point > (RX_DESC_NUM_92E / 2)) &&
-	    (read_point <= (RX_DESC_NUM_92E / 2))) {
-		remind_cnt = RX_DESC_NUM_92E - write_point;
-	} else {
-		remind_cnt = (read_point >= write_point) ?
-			     (read_point - write_point) :
-			     (RX_DESC_NUM_92E - write_point + read_point);
-	}
+	remind_cnt = calc_fifo_space(read_point, write_point);
 
 	if (remind_cnt == 0)
 		return 0;
-- 
2.1.4

