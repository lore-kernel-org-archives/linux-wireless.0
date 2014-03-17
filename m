Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46028 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485AbaCQNfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:04 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 12/21] wil6210: reduce printing
Date: Mon, 17 Mar 2014 15:34:16 +0200
Message-ID: <1395063265-6522-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143533_168243_F4094FF0)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert 2 often printed messages to dynamic ones

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index b1bc007..848ed85 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -179,7 +179,7 @@ static int wil_cfg80211_get_station(struct wiphy *wiphy,
 
 	int cid = wil_find_cid(wil, mac);
 
-	wil_info(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
+	wil_dbg_misc(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
 	if (cid < 0)
 		return cid;
 
@@ -218,7 +218,7 @@ static int wil_cfg80211_dump_station(struct wiphy *wiphy,
 		return -ENOENT;
 
 	memcpy(mac, wil->sta[cid].addr, ETH_ALEN);
-	wil_info(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
+	wil_dbg_misc(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
 
 	rc = wil_cid_fill_sinfo(wil, cid, sinfo);
 
-- 
1.8.3.2

