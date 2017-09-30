Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37201 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbdI3Rih (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Sep 2017 13:38:37 -0400
Received: by mail-pg0-f66.google.com with SMTP id o1so540136pga.4
        for <linux-wireless@vger.kernel.org>; Sat, 30 Sep 2017 10:38:37 -0700 (PDT)
From: silexcommon@gmail.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>
Subject: [PATCH 05/11] ath10k_sdio: use clean packet headers
Date: Sat, 30 Sep 2017 23:07:42 +0530
Message-Id: <1506793068-27445-6-git-send-email-alagusankar@silex-india.com> (sfid-20170930_193801_265841_941C00D6)
In-Reply-To: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alagu Sankar <alagusankar@silex-india.com>

HTC header carries junk values that may be interpreted by the firmware
differently. Enable credit update only if flow control is enabled for
the corresponding endpoint.

PLL clock setting sequence does not mask the PLL_CONTROL
register value. Side effect of not masking the values is not known as
the entire pll clock setting sequence is undocumented.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 4 +++-
 drivers/net/wireless/ath/ath10k/hw.c  | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 75c2a3e..23e7216 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -84,11 +84,13 @@ static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 	struct ath10k_htc_hdr *hdr;
 
 	hdr = (struct ath10k_htc_hdr *)skb->data;
+	memset(hdr, 0, sizeof(struct ath10k_htc_hdr));
 
 	hdr->eid = ep->eid;
 	hdr->len = __cpu_to_le16(skb->len - sizeof(*hdr));
 	hdr->flags = 0;
-	hdr->flags |= ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE;
+	if (ep->tx_credit_flow_enabled)
+		hdr->flags |= ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE;
 
 	spin_lock_bh(&ep->htc->tx_lock);
 	hdr->seq_no = ep->seq_no++;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 07df7c6..2092392 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -812,6 +812,8 @@ static int ath10k_hw_qca6174_enable_pll_clock(struct ath10k *ar)
 	if (ret)
 		return -EINVAL;
 
+	reg_val &= ~(WLAN_PLL_CONTROL_REFDIV_MASK | WLAN_PLL_CONTROL_DIV_MASK |
+		     WLAN_PLL_CONTROL_NOPWD_MASK);
 	reg_val |= (SM(hw_clk->refdiv, WLAN_PLL_CONTROL_REFDIV) |
 		    SM(hw_clk->div, WLAN_PLL_CONTROL_DIV) |
 		    SM(1, WLAN_PLL_CONTROL_NOPWD));
-- 
1.9.1
