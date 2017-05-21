Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33984 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932083AbdEUUBb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 16:01:31 -0400
Received: by mail-lf0-f68.google.com with SMTP id q24so3696081lfb.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 May 2017 13:01:25 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 1/9] ath10k: high_latency detection
Date: Sun, 21 May 2017 21:59:03 +0200
Message-Id: <1495396751-4805-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20170521_220202_491988_FECB933B)
In-Reply-To: <1495396751-4805-1-git-send-email-erik.stromdahl@gmail.com>
References: <1495396751-4805-1-git-send-email-erik.stromdahl@gmail.com>
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
index 46ce263..627954e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2445,6 +2445,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
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
