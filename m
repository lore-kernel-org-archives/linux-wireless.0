Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35938 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbcGUQbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 12:31:35 -0400
Received: by mail-it0-f65.google.com with SMTP id j124so1479330ith.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 09:31:35 -0700 (PDT)
Received: from hash (CPE0018e7fe5281-CM18593342f28f.cpe.net.cable.rogers.com. [99.254.238.186])
        by smtp.gmail.com with ESMTPSA id o15sm2103769ith.2.2016.07.21.09.31.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Jul 2016 09:31:34 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath9k: fix misleading indent
Date: Thu, 21 Jul 2016 12:31:07 -0400
Message-Id: <20160721163107.686-1-me@bobcopeland.com> (sfid-20160721_183139_412571_F59A23FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes smatch warning:

ath9k_vif_iter_set_beacon() warn if statement not indented

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7594650..70ca746 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -919,7 +919,7 @@ static void ath9k_vif_iter_set_beacon(struct ath9k_vif_iter_data *iter_data,
 	} else {
 		if (iter_data->primary_beacon_vif->type != NL80211_IFTYPE_AP &&
 		    vif->type == NL80211_IFTYPE_AP)
-		iter_data->primary_beacon_vif = vif;
+			iter_data->primary_beacon_vif = vif;
 	}
 
 	iter_data->beacons = true;
-- 
2.9.0

