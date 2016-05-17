Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57410 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbcEQIeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 04:34:20 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix legacy rate packet debug messages
Date: Tue, 17 May 2016 14:05:31 +0530
Message-ID: <1463474131-26835-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160517_103437_971913_8FDB3247)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Legacy rate packets may not necessarily be having a rx status
flag of '0' always, for example management frame have flags
like RX_FLAG_ONLY_MONITOR / RX_FLAG_MACTIME_END also set

Just check 'VHT' and 'HT' flags are not set , and simply clasify it as
legacy rate packets

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cc979a4..0419a21 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -939,7 +939,8 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
 							"mcast" : "ucast",
 		   (__le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4,
-		   status->flag == 0 ? "legacy" : "",
+		   (status->flag & (RX_FLAG_HT | RX_FLAG_VHT)) == 0 ?
+							"legacy" : "",
 		   status->flag & RX_FLAG_HT ? "ht" : "",
 		   status->flag & RX_FLAG_VHT ? "vht" : "",
 		   status->flag & RX_FLAG_40MHZ ? "40" : "",
-- 
1.7.9.5

