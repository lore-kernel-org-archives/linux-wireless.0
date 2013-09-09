Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:49332 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab3IIPvD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 11:51:03 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: define ath10k_debug_start/_stop as static inline
Date: Mon, 9 Sep 2013 17:50:45 +0200
Message-ID: <1378741845-30080-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130909_175107_849151_14146483)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise if CONFIG_ATH10K_DEBUGFS won't be set we will
end up with multiple definitions and compilation failure
in each place the header is included.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 9c442a8..376a56b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -52,12 +52,12 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 				    struct wmi_stats_event *ev);
 
 #else
-int ath10k_debug_start(struct ath10k *ar)
+static inline int ath10k_debug_start(struct ath10k *ar)
 {
 	return 0;
 }
 
-void ath10k_debug_stop(struct ath10k *ar)
+static inline void ath10k_debug_stop(struct ath10k *ar)
 {
 }
 
-- 
1.7.10

