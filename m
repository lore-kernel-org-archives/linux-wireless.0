Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39696 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbLCRxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 12:53:24 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: allow Mesh Point to install peer security key
Date: Thu, 3 Dec 2015 09:50:55 -0800
Message-ID: <1449165055-27782-1-git-send-email-poh@qca.qualcomm.com> (sfid-20151203_185328_092493_ECEF1869)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh Point requires peer security key install when running
in secured mode since it's a type of peer links, otherwise peer
link will be removed due to key install failure.

MFP feature set is required to run Mesh in secured mode and
QCA988X firmware, 10.2.4.70.14-2 and above, is the only one
supporting secured Mesh at this moment.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bcb364d..b4bdeb0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -250,7 +250,8 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (WARN_ON(arvif->vif->type != NL80211_IFTYPE_AP &&
-		    arvif->vif->type != NL80211_IFTYPE_ADHOC))
+		    arvif->vif->type != NL80211_IFTYPE_ADHOC &&
+		    arvif->vif->type != NL80211_IFTYPE_MESH_POINT))
 		return -EINVAL;
 
 	spin_lock_bh(&ar->data_lock);
-- 
1.9.1

