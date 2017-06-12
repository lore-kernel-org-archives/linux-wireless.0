Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35591 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbdFLPDa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 11:03:30 -0400
Received: by mail-lf0-f66.google.com with SMTP id v20so9680024lfa.2
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jun 2017 08:03:29 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 10/10] ath10k: wmi: disable softirq's while calling ieee80211_rx
Date: Mon, 12 Jun 2017 17:03:11 +0200
Message-Id: <1497279791-9598-11-git-send-email-erik.stromdahl@gmail.com> (sfid-20170612_170334_289072_BB119A74)
In-Reply-To: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
References: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 472b42b..d5d0d5c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2383,7 +2383,10 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
 
+	local_bh_disable();
 	ieee80211_rx(ar->hw, skb);
+	local_bh_enable();
+
 	return 0;
 }
 
-- 
2.7.4
