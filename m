Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33198 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdFLPDV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 11:03:21 -0400
Received: by mail-lf0-f67.google.com with SMTP id u62so9692139lfg.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jun 2017 08:03:21 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 01/10] ath10k: high_latency detection
Date: Mon, 12 Jun 2017 17:03:02 +0200
Message-Id: <1497279791-9598-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20170612_170325_823543_C49E0647)
In-Reply-To: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
References: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The setup of high latency chips (USB and SDIO) is
sometimes different than for chips using low latency
interfaces.

The bus type is used to determine if the interface is
a high latency interface.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 drivers/net/wireless/ath/ath10k/core.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 3fb1429..d3bf5c4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2455,6 +2455,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	ar->hw_rev = hw_rev;
 	ar->hif.ops = hif_ops;
 	ar->hif.bus = bus;
+	ar->is_high_latency = ath10k_is_high_latency(bus);
 
 	switch (hw_rev) {
 	case ATH10K_HW_QCA988X:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1efe0a1..90069b8 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -789,6 +789,8 @@ struct ath10k {
 
 	bool p2p;
 
+	bool is_high_latency;
+
 	struct {
 		enum ath10k_bus bus;
 		const struct ath10k_hif_ops *ops;
@@ -1008,6 +1010,11 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
 	return false;
 }
 
+static inline bool ath10k_is_high_latency(enum ath10k_bus bus)
+{
+	return ((bus == ATH10K_BUS_SDIO) || (bus == ATH10K_BUS_USB));
+}
+
 struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  enum ath10k_bus bus,
 				  enum ath10k_hw_rev hw_rev,
-- 
2.7.4
