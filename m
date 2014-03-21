Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53086 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135AbaCUJcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 05:32:46 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so1569645eek.23
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 02:32:45 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/8] ath10k: introduce ieee80211_rx_status to htt_rx_info
Date: Fri, 21 Mar 2014 10:32:16 +0100
Message-Id: <1395394341-3958-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140321_103254_010511_BF47F528)
In-Reply-To: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will be used as a template, and final storage for
rx_status.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |    2 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 654867f..e80f033 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -21,6 +21,7 @@
 #include <linux/bug.h>
 #include <linux/interrupt.h>
 #include <linux/dmapool.h>
+#include <net/mac80211.h>
 
 #include "htc.h"
 #include "rx_desc.h"
@@ -1174,6 +1175,7 @@ struct htt_peer_unmap_event {
 
 struct htt_rx_info {
 	struct sk_buff *skb;
+	struct ieee80211_rx_status rx_status;
 	enum htt_rx_mpdu_status status;
 	enum htt_rx_mpdu_encrypt_type encrypt_type;
 	s8 signal;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fd14c3a..f18e41c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -756,7 +756,7 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
 
 	status = IEEE80211_SKB_RXCB(info->skb);
-	memset(status, 0, sizeof(*status));
+	memcpy(status, &info->rx_status, sizeof(*status));
 
 	if (info->encrypt_type != HTT_RX_MPDU_ENCRYPT_NONE) {
 		status->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED |
-- 
1.7.9.5

