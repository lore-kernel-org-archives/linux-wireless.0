Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34920 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934780AbdBQUxx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 15:53:53 -0500
Received: by mail-wm0-f65.google.com with SMTP id u63so4466500wmu.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2017 12:53:53 -0800 (PST)
From: Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org, andra.paraschiv7@gmail.com,
        costin.raiciu@cs.pub.ro, dragos.niculescu@cs.pub.ro
Cc: Doru Gucea <gucea.doru@gmail.com>
Subject: [RFC-PATCH 1/2 v2] mac80211: Update the driver with beacon info constantly
Date: Fri, 17 Feb 2017 22:53:45 +0200
Message-Id: <1487364825-4616-1-git-send-email-gucea.doru@gmail.com> (sfid-20170217_215357_350364_26678BC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Doru Gucea <gucea.doru@gmail.com>

Once the mac80211 layer receives a beacon, it should send a notification
to the driver. This will allow finer timining control in case of drivers
that need a correct estimation for the arrival time of a beacon.

Changelog

v1:
* fixed typo

Signed-off-by: Doru Gucea <gucea.doru@gmail.com>
---
 net/mac80211/mlme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2398693..f5ebe27 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3548,6 +3548,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.bss_conf.sync_dtim_count = 0;
 	}
 
+	/* trigger hardware timers adjustment
+	 * this needs to be done before beacon filtering
+	 */
+	changed |= BSS_CHANGED_BEACON_INFO;
+	ieee80211_bss_info_change_notify(sdata, changed);
+
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
 		return;
 	ifmgd->beacon_crc = ncrc;
-- 
1.9.1
