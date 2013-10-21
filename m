Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:38157 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3JURW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:57 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so6798362wes.4
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:56 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 06/14] mac80211_hwsim: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:30 +0200
Message-Id: <1382376158-25586-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192300_205118_20188FED)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2cd3f54..1cac658 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -159,7 +159,7 @@ static const struct ieee80211_regdomain hwsim_world_regdom_custom_02 = {
 	.reg_rules = {
 		REG_RULE(2412-10, 2462+10, 40, 0, 20, 0),
 		REG_RULE(5725-10, 5850+10, 40, 0, 30,
-			NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+			 NL80211_RRF_NO_IR),
 	}
 };
 
@@ -1464,7 +1464,7 @@ static void hw_scan_work(struct work_struct *work)
 		    req->channels[hwsim->scan_chan_idx]->center_freq);
 
 	hwsim->tmp_chan = req->channels[hwsim->scan_chan_idx];
-	if (hwsim->tmp_chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
+	if (hwsim->tmp_chan->flags & IEEE80211_CHAN_NO_IR ||
 	    !req->n_ssids) {
 		dwell = 120;
 	} else {
-- 
1.8.4.rc3

