Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56523 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbbC0FVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 01:21:22 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix failed to set smps
Date: Fri, 27 Mar 2015 13:21:14 +0800
Message-ID: <1427433674-5745-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150327_062125_551844_AE1F0CE9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 net/mac80211/debugfs_netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 4d7473f..9aeb50d 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -276,7 +276,8 @@ static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_smps_mode mode;
 
 	for (mode = 0; mode < IEEE80211_SMPS_NUM_MODES; mode++) {
-		if (strncmp(buf, smps_modes[mode], buflen) == 0) {
+		if (strncmp(buf, smps_modes[mode],
+			    strlen(smps_modes[mode])) == 0) {
 			int err = ieee80211_set_smps(sdata, mode);
 			if (!err)
 				return buflen;
-- 
1.9.1

