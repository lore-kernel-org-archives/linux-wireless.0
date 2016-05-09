Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50100 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbcEIXMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:12:22 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211: Get ethtool-stats frequency more often.
Date: Mon,  9 May 2016 16:12:17 -0700
Message-Id: <1462835537-11268-1-git-send-email-greearb@candelatech.com> (sfid-20160510_012230_890700_A6E8AB88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Some NICs (ath9k_htc) don't use chanctx_conf, it
seems, so look at local->hw.conf.channel->center_freq
in that case.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ethtool.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 9cc986d..4e937c1 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -165,10 +165,14 @@ do_survey:
 		} while (channel != survey.channel);
 	}
 
-	if (survey.filled)
-		data[i++] = survey.channel->center_freq;
-	else
-		data[i++] = 0;
+	if (channel) {
+		data[i++] = channel->center_freq;
+	} else {
+		if (local->_oper_chandef.chan)
+			data[i++] = local->_oper_chandef.chan->center_freq;
+		else
+			data[i++] = 0;
+	}
 	if (survey.filled & SURVEY_INFO_NOISE_DBM)
 		data[i++] = (u8)survey.noise;
 	else
-- 
2.4.3

