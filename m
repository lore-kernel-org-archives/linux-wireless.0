Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62336 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3JURXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:11 -0400
Received: by mail-wi0-f175.google.com with SMTP id hm4so4325838wib.14
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:23:10 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 12/14] cw1200: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:36 +0200
Message-Id: <1382376158-25586-13-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_193807_575983_A890D260)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/cw1200/scan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/cw1200/scan.c b/drivers/net/wireless/cw1200/scan.c
index ee3c190..8c017bf 100644
--- a/drivers/net/wireless/cw1200/scan.c
+++ b/drivers/net/wireless/cw1200/scan.c
@@ -197,9 +197,9 @@ void cw1200_scan_work(struct work_struct *work)
 			if ((*it)->band != first->band)
 				break;
 			if (((*it)->flags ^ first->flags) &
-					IEEE80211_CHAN_PASSIVE_SCAN)
+					IEEE80211_CHAN_NO_IR)
 				break;
-			if (!(first->flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
+			if (!(first->flags & IEEE80211_CHAN_NO_IR) &&
 			    (*it)->max_power != first->max_power)
 				break;
 		}
@@ -210,7 +210,7 @@ void cw1200_scan_work(struct work_struct *work)
 		else
 			scan.max_tx_rate = WSM_TRANSMIT_RATE_1;
 		scan.num_probes =
-			(first->flags & IEEE80211_CHAN_PASSIVE_SCAN) ? 0 : 2;
+			(first->flags & IEEE80211_CHAN_NO_IR) ? 0 : 2;
 		scan.num_ssids = priv->scan.n_ssids;
 		scan.ssids = &priv->scan.ssids[0];
 		scan.num_channels = it - priv->scan.curr;
@@ -233,7 +233,7 @@ void cw1200_scan_work(struct work_struct *work)
 		}
 		for (i = 0; i < scan.num_channels; ++i) {
 			scan.ch[i].number = priv->scan.curr[i]->hw_value;
-			if (priv->scan.curr[i]->flags & IEEE80211_CHAN_PASSIVE_SCAN) {
+			if (priv->scan.curr[i]->flags & IEEE80211_CHAN_NO_IR) {
 				scan.ch[i].min_chan_time = 50;
 				scan.ch[i].max_chan_time = 100;
 			} else {
@@ -241,7 +241,7 @@ void cw1200_scan_work(struct work_struct *work)
 				scan.ch[i].max_chan_time = 25;
 			}
 		}
-		if (!(first->flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
+		if (!(first->flags & IEEE80211_CHAN_NO_IR) &&
 		    priv->scan.output_power != first->max_power) {
 			priv->scan.output_power = first->max_power;
 			wsm_set_output_power(priv,
-- 
1.8.4.rc3

