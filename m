Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:22903 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932864AbcKKQnl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 11:43:41 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH] fixed hwsim beacon delta calculation
Date: Fri, 11 Nov 2016 17:37:56 +0100
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <980aa1f8-42c3-4fe4-a930-d930474ad2eb@MAIL1.uni-rostock.de> (sfid-20161111_174345_038313_10E80FFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the cast from uint32_t to int64_t, a wrong next beacon timing is
calculated and effectively the beacon timer stops to work. This is
especially bad for 802.11s mesh networks, because discovery breaks
without beacons.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8f366cc..8d7b0c6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -819,7 +819,7 @@ static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
 		data->bcn_delta = do_div(delta, bcn_int);
 	} else {
 		data->tsf_offset -= delta;
-		data->bcn_delta = -do_div(delta, bcn_int);
+		data->bcn_delta = -(s64)(do_div(delta, bcn_int));
 	}
 }
 
-- 
1.9.1
