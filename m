Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50946 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752024AbeDJHi3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 03:38:29 -0400
From: zhichen@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
        Zhi Chen <zhichen@codeaurora.org>
Subject: [PATCH] ath10k: fixed scan crash
Date: Tue, 10 Apr 2018 15:39:53 +0800
Message-Id: <1523345994-28800-1-git-send-email-zhichen@codeaurora.org> (sfid-20180410_093839_967991_06327848)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhi Chen <zhichen@codeaurora.org>

Length of WMI scan message was not calculated correctly. The allocated
buffer was smaller than what we expected. So WMI message corrupted
skb_info, which is at the end of skb->data. This fix takes TLV header
into account even if the element is zero-length.
Crash log:
  [49.629986] Unhandled kernel unaligned access[#1]:
  [49.634932] CPU: 0 PID: 1176 Comm: logd Not tainted 4.4.60 #180
  [49.641040] task: 83051460 ti: 8329c000 task.ti: 8329c000
  [49.646608] $ 0   : 00000000 00000001 80984a80 00000000
  [49.652038] $ 4   : 45259e89 8046d484 8046df30 8024ba70
  [49.657468] $ 8   : 00000000 804cc4c0 00000001 20306320
  [49.662898] $12   : 33322037 000110f2 00000000 31203930
  [49.668327] $16   : 82792b40 80984a80 00000001 804207fc
  [49.673757] $20   : 00000000 0000012c 00000040 80470000
  [49.679186] $24   : 00000000 8024af7c
  [49.684617] $28   : 8329c000 8329db88 00000001 802c58d0
  [49.690046] Hi    : 00000000
  [49.693022] Lo    : 453c0000
  [49.696013] epc   : 800efae4 put_page+0x0/0x58
  [49.700615] ra    : 802c58d0 skb_release_data+0x148/0x1d4
  [49.706184] Status: 1000fc03 KERNEL EXL IE
  [49.710531] Cause : 00800010 (ExcCode 04)
  [49.714669] BadVA : 45259e89
  [49.717644] PrId  : 00019374 (MIPS 24Kc)

Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ae77a00..25efbb5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1515,10 +1515,10 @@ ath10k_wmi_tlv_op_gen_start_scan(struct ath10k *ar,
 	bssid_len = arg->n_bssids * sizeof(struct wmi_mac_addr);
 	ie_len = roundup(arg->ie_len, 4);
 	len = (sizeof(*tlv) + sizeof(*cmd)) +
-	      (arg->n_channels ? sizeof(*tlv) + chan_len : 0) +
-	      (arg->n_ssids ? sizeof(*tlv) + ssid_len : 0) +
-	      (arg->n_bssids ? sizeof(*tlv) + bssid_len : 0) +
-	      (arg->ie_len ? sizeof(*tlv) + ie_len : 0);
+	      sizeof(*tlv) + chan_len +
+	      sizeof(*tlv) + ssid_len +
+	      sizeof(*tlv) + bssid_len +
+	      sizeof(*tlv) + ie_len;
 
 	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
-- 
2.1.4
