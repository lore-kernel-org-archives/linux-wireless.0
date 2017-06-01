Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32859 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFATKx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 15:10:53 -0400
Received: by mail-pf0-f196.google.com with SMTP id f27so8394235pfe.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jun 2017 12:10:53 -0700 (PDT)
MIME-Version: 1.0
From: Norik Dzhandzhapanyan <norikd@gmail.com>
Date: Thu, 1 Jun 2017 12:10:52 -0700
Message-ID: <CAAV6Hgmjq9DDpcUUTZtDwodUjKrkzjnKSNZ+sK8U=M_AQgr-iQ@mail.gmail.com> (sfid-20170601_211056_736915_DB1C23D4)
Subject: [PATCH 1/1] Add per chain RSSI reporting.
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report per chain RSSI

Signed-off-by: Norik Dzhandzhapanyan <norikd@gmail.com>

---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c
b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6c0a821fe79d..110953e0bff9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -829,6 +829,22 @@ static void ath10k_htt_rx_h_signal(struct ath10k *ar,
                    struct ieee80211_rx_status *status,
                    struct htt_rx_desc *rxd)
 {
+    int i;
+
+    for(i=0;i<IEEE80211_MAX_CHAINS;i++)
+    {
+        status->chains &= ~BIT(i);
+
+        if (rxd->ppdu_start.rssi_chains[i].pri20_mhz != 0x80)
+        {
+            status->chain_signal[i] = ATH10K_DEFAULT_NOISE_FLOOR +
+                rxd->ppdu_start.rssi_chains[i].pri20_mhz;
+
+            status->chains |= BIT(i);
+
+        }
+    }
+
     /* FIXME: Get real NF */
     status->signal = ATH10K_DEFAULT_NOISE_FLOOR +
              rxd->ppdu_start.rssi_comb;
