Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752024AbeDJHih (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 03:38:37 -0400
From: zhichen@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
        Zhi Chen <zhichen@codeaurora.org>
Subject: [PATCH] ath10k: fix tlv 5ghz channel missing issue
Date: Tue, 10 Apr 2018 15:39:54 +0800
Message-Id: <1523345994-28800-2-git-send-email-zhichen@codeaurora.org> (sfid-20180410_093842_665305_4195D1D1)
In-Reply-To: <1523345994-28800-1-git-send-email-zhichen@codeaurora.org>
References: <1523345994-28800-1-git-send-email-zhichen@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhi Chen <zhichen@codeaurora.org>

The 5ghz channel parameters of TLV target wasn't passed to host, it caused
host can only use lower channels from 36 to 64.

Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 25efbb5..b8985ce 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1010,6 +1010,8 @@ static int ath10k_wmi_tlv_op_pull_svc_rdy_ev(struct ath10k *ar,
 	arg->phy_capab = ev->phy_capability;
 	arg->num_rf_chains = ev->num_rf_chains;
 	arg->eeprom_rd = reg->eeprom_rd;
+	arg->low_5ghz_chan = reg->low_5ghz_chan;
+	arg->high_5ghz_chan = reg->high_5ghz_chan;
 	arg->num_mem_reqs = ev->num_mem_reqs;
 	arg->service_map = svc_bmap;
 	arg->service_map_len = ath10k_wmi_tlv_len(svc_bmap);
-- 
2.1.4
