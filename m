Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34076 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbGIK1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 06:27:33 -0400
Received: by lbnk3 with SMTP id k3so72345674lbn.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 03:27:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath9k: fix moredata flag endianness in cabq tx
Date: Thu,  9 Jul 2015 12:27:22 +0200
Message-Id: <1436437642-18781-1-git-send-email-michal.kazior@tieto.com> (sfid-20150709_122736_719959_905CABCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While compiling ath9k with some extra flags I've
found that:

 ath9k/xmit.c +2473 ## 16: warning: restricted __le16 degrades to integer
 ath9k/xmit.c +2474 ## 36: warning: invalid assignment: &=
 ath9k/xmit.c +2474 ## 36:    left side has type restricted __le16
 ath9k/xmit.c +2474 ## 36:    right side has type int

There's no way for frame ftype/stype to be
mistreated as the offending 'moredata' flag when
considering cab queue.

This could've however theoretically led sometimes
to increased power consumption on connected
stations as they would keep their Rx active
waiting for frames that would never come.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3ad79bb4f2c2..d8cc45106f85 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2470,8 +2470,8 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	bf = list_first_entry(&bf_q, struct ath_buf, list);
 	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
 
-	if (hdr->frame_control & IEEE80211_FCTL_MOREDATA) {
-		hdr->frame_control &= ~IEEE80211_FCTL_MOREDATA;
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_MOREDATA)) {
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
 			sizeof(*hdr), DMA_TO_DEVICE);
 	}
-- 
2.1.4

