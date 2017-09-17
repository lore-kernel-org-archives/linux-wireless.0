Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35876 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdIQTke (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 15:40:34 -0400
Received: by mail-lf0-f66.google.com with SMTP id l196so3535742lfl.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 12:40:33 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 10/11] ath10k: wmi: disable softirq's while calling ieee80211_rx
Date: Sun, 17 Sep 2017 21:40:12 +0200
Message-Id: <20170917194013.8658-11-erik.stromdahl@gmail.com> (sfid-20170917_214043_220961_48A7817F)
In-Reply-To: <20170917194013.8658-1-erik.stromdahl@gmail.com>
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 38a97086708b..10bb5be6ab00 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2408,7 +2408,10 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
 
+	local_bh_disable();
 	ieee80211_rx(ar->hw, skb);
+	local_bh_enable();
+
 	return 0;
 }
 
-- 
2.14.1
