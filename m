Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33734 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdBOTBj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 14:01:39 -0500
Received: by mail-wm0-f68.google.com with SMTP id v77so9644901wmv.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 11:01:38 -0800 (PST)
From: Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org, andra.paraschiv7@gmail.com,
        costin.raiciu@cs.pub.ro, dragos.niculescu@cs.pub.ro
Cc: Doru Gucea <gucea.doru@gmail.com>
Subject: [PATCH 1/2] mac80211: Update the driver with beacon info constantly
Date: Wed, 15 Feb 2017 21:01:18 +0200
Message-Id: <1487185278-8643-1-git-send-email-gucea.doru@gmail.com> (sfid-20170215_200143_015997_298E3AD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Doru Gucea <gucea.doru@gmail.com>

Once the mac80211 layer receives a beacon, it should send a notification
to the driver. This will allow finer timining control in case of drivers
that need a correct estimation for the arrival time of a beacon.

Signed-off-by: Doru Gucea <gucea.doru@gmail.com>
---
 net/mac80211/mlme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cd7e55e..0b8eed5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3536,6 +3536,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.bss_conf.sync_dtim_count = 0;
 	}
 
+	/* trigger hardware timers adjustment
+	 * this needs to be done before beacon filtering
+	*/
+	changed |= BSS_CHANGED_BEACON_INFO;
+	ieee80211_bss_info_change_notify(sata, changed);
+
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
 		return;
 	ifmgd->beacon_crc = ncrc;
-- 
1.9.1
