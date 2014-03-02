Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38409 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaCBJVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2014 04:21:19 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 2/2] wil6210: fix smatch warning in wil_cfg80211_get_station()
Date: Sun, 2 Mar 2014 11:20:51 +0200
Message-ID: <1393752051-7611-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140302_102212_386814_7B64154D)
In-Reply-To: <1393752051-7611-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393752051-7611-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch suggests to propagate error code from wil_find_cid(), and, indeed,
it is a good idea.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index a4da064..7439303 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -181,7 +181,7 @@ static int wil_cfg80211_get_station(struct wiphy *wiphy,
 
 	wil_info(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
 	if (cid < 0)
-		return -ENOENT;
+		return cid;
 
 	rc = wil_cid_fill_sinfo(wil, cid, sinfo);
 
-- 
1.8.3.2

