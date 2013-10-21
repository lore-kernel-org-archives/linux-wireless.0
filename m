Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:62379 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3JURWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:50 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so6766765wes.6
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:49 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 03/14] ath10k: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:27 +0200
Message-Id: <1382376158-25586-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192253_294493_D32537ED)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0b1cc51..f23d61f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1351,12 +1351,12 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			ch->allow_vht = true;
 
 			ch->allow_ibss =
-				!(channel->flags & IEEE80211_CHAN_NO_IBSS);
+				!(channel->flags & IEEE80211_CHAN_NO_IR);
 
 			ch->ht40plus =
 				!(channel->flags & IEEE80211_CHAN_NO_HT40PLUS);
 
-			passive = channel->flags & IEEE80211_CHAN_PASSIVE_SCAN;
+			passive = channel->flags & IEEE80211_CHAN_NO_IR;
 			ch->passive = passive;
 
 			ch->freq = channel->center_freq;
-- 
1.8.4.rc3

