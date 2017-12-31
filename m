Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:43985 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdLaRbs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:48 -0500
Received: by mail-lf0-f65.google.com with SMTP id o26so38041812lfc.10
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:47 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 15/18] ath10k: wmi: disable softirq's while calling ieee80211_rx
Date: Sun, 31 Dec 2017 18:29:22 +0100
Message-Id: <20171231172925.24014-16-erik.stromdahl@gmail.com> (sfid-20171231_183153_212148_F61C754A)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is done in order not to trig the below warning in
ieee80211_rx_napi:

WARN_ON_ONCE(softirq_count() == 0);

ieee80211_rx_napi requires that softirq's are disabled during
execution.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 58dc2189ba49..3a81d106789d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2409,7 +2409,8 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
 
-	ieee80211_rx(ar->hw, skb);
+	ieee80211_rx_ni(ar->hw, skb);
+
 	return 0;
 }
 
-- 
2.15.1
