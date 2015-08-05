Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35041 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbHEKO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 06:14:56 -0400
Received: by lbbpo9 with SMTP id po9so21673209lbb.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 03:14:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix peer limit enforcement
Date: Wed,  5 Aug 2015 12:15:24 +0200
Message-Id: <1438769724-29438-2-git-send-email-michal.kazior@tieto.com> (sfid-20150805_121500_438145_A30C689D)
In-Reply-To: <1438769724-29438-1-git-send-email-michal.kazior@tieto.com>
References: <1438769724-29438-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware peer entries are involved in internal
firmware vdev structures. This was not accounted
for and could lead firmware to crash due to asking
it to do more than it could.

Fixes: 039a0051ec1a ("ath10k: allocate fw resources for iface combinations")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4f6dddac8e43..29ad1d3deb82 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -598,11 +598,19 @@ ath10k_mac_get_any_chandef_iter(struct ieee80211_hw *hw,
 static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr,
 			      enum wmi_peer_type peer_type)
 {
+	struct ath10k_vif *arvif;
+	int num_peers = 0;
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (ar->num_peers >= ar->max_num_peers)
+	num_peers = ar->num_peers;
+
+	/* Each vdev consumes a peer entry as well */
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		num_peers++;
+
+	if (num_peers >= ar->max_num_peers)
 		return -ENOBUFS;
 
 	ret = ath10k_wmi_peer_create(ar, vdev_id, addr, peer_type);
@@ -4086,6 +4094,11 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		       sizeof(arvif->bitrate_mask.control[i].vht_mcs));
 	}
 
+	if (ar->num_peers >= ar->max_num_peers) {
+		ath10k_warn(ar, "refusing vdev creation due to insufficient peer entry resources in firmware\n");
+		return -ENOBUFS;
+	}
+
 	if (ar->free_vdev_map == 0) {
 		ath10k_warn(ar, "Free vdev map is empty, no more interfaces allowed.\n");
 		ret = -EBUSY;
-- 
2.1.4

