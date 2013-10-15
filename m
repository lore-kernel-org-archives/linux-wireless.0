Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33739 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3JOAmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 20:42:40 -0400
Received: by mail-pb0-f53.google.com with SMTP id up15so8040280pbc.12
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 17:42:40 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 5/6] ath9k: check for NULL rate when using ieee80211_get_rts_cts_rate()
Date: Mon, 14 Oct 2013 17:42:10 -0700
Message-Id: <1381797731-2454-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131015_024243_364318_2358FA5E)
In-Reply-To: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_get_rts_cts_rate() can return NULL, so don't rely
on its members when it does return NULL.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 47696d2..b9b0819 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2020,6 +2020,9 @@ static void setup_frame_info(struct ieee80211_hw *hw,
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
+
+	if (!rate)
+		return;
 	fi->rtscts_rate = rate->hw_value;
 	if (short_preamble)
 		fi->rtscts_rate |= rate->hw_value_short;
-- 
1.8.4.rc3

