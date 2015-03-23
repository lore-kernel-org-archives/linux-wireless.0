Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35944 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbbCWKAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 06:00:10 -0400
Received: by lbbug6 with SMTP id ug6so19995047lbb.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 03:00:09 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix aid setup in station mode
Date: Mon, 23 Mar 2015 09:57:28 +0000
Message-Id: <1427104648-5681-1-git-send-email-michal.kazior@tieto.com> (sfid-20150323_110015_820483_158E56DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While debugging something else I noticed AID was
set to 0. This could lead to powersave issues in
station mode. Maybe this isn't really necessary
but set it properly just to be sure.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 506e886..f2b4a49 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1605,12 +1605,18 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 				      struct wmi_peer_assoc_complete_arg *arg)
 {
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	u32 aid;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (vif->type == NL80211_IFTYPE_STATION)
+		aid = vif->bss_conf.aid;
+	else
+		aid = sta->aid;
+
 	ether_addr_copy(arg->addr, sta->addr);
 	arg->vdev_id = arvif->vdev_id;
-	arg->peer_aid = sta->aid;
+	arg->peer_aid = aid;
 	arg->peer_flags |= WMI_PEER_AUTH;
 	arg->peer_listen_intval = ath10k_peer_assoc_h_listen_intval(ar, vif);
 	arg->peer_num_spatial_streams = 1;
-- 
2.1.4

