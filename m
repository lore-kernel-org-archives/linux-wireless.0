Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33652 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbbGIQBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 12:01:42 -0400
Received: by wiwl6 with SMTP id l6so23092011wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 09:01:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4 v2] staging: vt6655: Fix missing power saving support
Date: Thu,  9 Jul 2015 17:01:25 +0100
Message-Id: <1436457687-3113-2-git-send-email-tvboxspy@gmail.com> (sfid-20150709_180147_551431_8F4295EE)
In-Reply-To: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com>
References: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IEEE80211_HW_SUPPORTS_PS to ieee80211_hw flags
enabling this feature.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
v2 rebased for 4.2

 drivers/staging/vt6655/device_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index b0c8e23..e78bd5e 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1811,6 +1811,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	ieee80211_hw_set(priv->hw, SIGNAL_DBM);
 	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(priv->hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(priv->hw, SUPPORTS_PS);
 
 	priv->hw->max_signal = 100;
 
-- 
2.1.4

