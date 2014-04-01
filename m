Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40478 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaDAIX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 04:23:57 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so7088737wgh.22
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 01:23:56 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: remove not needed warning when peer unmap
Date: Tue,  1 Apr 2014 10:23:48 +0200
Message-Id: <1396340628-4570-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140401_102405_393105_2458D301)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove not needed warning when get peer unmap
event from the firmware. This is not critical
message. Instead print this as a debug message.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 82669a7..b7f4acc 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -200,7 +200,7 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, ev->peer_id);
 	if (!peer) {
-		ath10k_warn("peer-unmap-event: unknown peer id %d\n",
+		ath10k_dbg(ATH10K_DBG_HTT, "peer-unmap-event: unknown peer id %d\n",
 			    ev->peer_id);
 		goto exit;
 	}
-- 
1.7.9.5

