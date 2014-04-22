Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48891 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaDVKTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 06:19:50 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so4826331pab.27
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 03:19:50 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: avoid handling of SMPS for mesh
Date: Tue, 22 Apr 2014 18:19:25 +0800
Message-Id: <1398161965-1427-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140422_121955_906962_3A7E7AD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: implement SMPS for AP" has caused kernel
oops at mesh STA if the peer mesh STA operates in sleep mode
and then becomes active mode. It can be easily reproduced by
setting the following commands at peer mesh STA:

iw mesh0 station set aa:bb:cc:dd:ee:ff mesh_power_mode deep
iw mesh0 station set aa:bb:cc:dd:ee:ff mesh_power_mode active

Kernel oops will happen at mesh STA aa:bb:cc:dd:ee:ff.

Fix this by avoiding SMPS for mesh mode.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/sta_info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 137a192..847d92f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1148,7 +1148,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	atomic_dec(&ps->num_sta_ps);
 
 	/* This station just woke up and isn't aware of our SMPS state */
-	if (!ieee80211_smps_is_restrictive(sta->known_smps_mode,
+	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
+	    !ieee80211_smps_is_restrictive(sta->known_smps_mode,
 					   sdata->smps_mode) &&
 	    sta->known_smps_mode != sdata->bss->req_smps &&
 	    sta_info_tx_streams(sta) != 1) {
-- 
1.9.2

