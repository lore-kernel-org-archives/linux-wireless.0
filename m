Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47574 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579Ab0I0R7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:59:07 -0400
Received: by bwz11 with SMTP id 11so3540087bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:59:05 -0700 (PDT)
Message-Id: <f656eb5cef04fed51344a7f95aa64b9958e6aecb.1285544496.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1285544496.git.chunkeey@googlemail.com>
References: <cover.1285544496.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Sep 2010 23:06:56 +0200
Subject: [PATCH 5/6] carl9170: fix WARN_ON triggered by Broadcom HT STAs
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom's Windows driver for the 4313 advertises
an ampdu density of 7 => 16 us. The AR9170 MAC on
the other hand only supports densities up to 8 us.

This patch removes the noisy WARN_ON, because
there is nothing we can do about it.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index a8b0cec..84bd38e 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1248,7 +1248,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
-		if (WARN_ON_ONCE(!sta_info->ht_sta))
+		if (!sta_info->ht_sta)
 			return -EOPNOTSUPP;
 
 		rcu_read_lock();
-- 
1.7.1

