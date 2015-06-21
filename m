Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38337 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbbFUKGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 06:06:19 -0400
Received: by wibdq8 with SMTP id dq8so51126893wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 03:06:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/3] staging: vt6655: Fix missing power saving support
Date: Sun, 21 Jun 2015 11:05:53 +0100
Message-Id: <1434881155-3464-1-git-send-email-tvboxspy@gmail.com> (sfid-20150621_120623_541718_1C705015)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IEEE80211_HW_SUPPORTS_PS to ieee80211_hw flags
enabling this feature.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 0bfc939..b1357af 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1819,7 +1819,8 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_TIMING_BEACON_ONLY;
+		IEEE80211_HW_TIMING_BEACON_ONLY |
+		IEEE80211_HW_SUPPORTS_PS;
 
 	priv->hw->max_signal = 100;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
