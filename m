Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:45821 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213Ab3GaIzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:55:25 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/5] ath10k: zero arvif memory on add_interface()
Date: Wed, 31 Jul 2013 10:55:14 +0200
Message-ID: <1375260915-22500-5-git-send-email-michal.kazior@tieto.com> (sfid-20130731_105535_942114_933F4C72)
In-Reply-To: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
References: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The private memory area in vif provided by
mac80211 isn't guaranteed to be zeroed.

This patch should fix issues when switching
between STA and AP interface types.

The tim_bitmap could become polluted by STA bssid
field (since it's a union), wep_keys array
could also become polluted with invalid pointers
and probably much more.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6a130c5..1aa5a39 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1925,6 +1925,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	memset(arvif, 0, sizeof(*arvif));
+
 	arvif->ar = ar;
 	arvif->vif = vif;
 
-- 
1.7.9.5

