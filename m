Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38603 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2GRMlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:41:37 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: [PATCH] cfg80211: Fix mutex locking in reg_last_request_cell_base
Date: Wed, 18 Jul 2012 18:11:29 +0530
Message-ID: <1342615289-3088-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120718_144142_070626_4C7A6B9F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

should fix the following issue

	[ 3229.815012] [ BUG: lock held when returning to user space! ]
	[ 3229.815016] 3.5.0-rc7-wl #28 Tainted: G        W  O
	[ 3229.815017]
	------------------------------------------------
	[ 3229.815019] wpa_supplicant/5783 is leaving the kernel with locks still held!
	[ 3229.815022] 1 lock held by wpa_supplicant/5783:
	[ 3229.815023]  #0: (reg_mutex){+.+.+.}, at: [<fa65834d>]
	reg_last_request_cell_base+0x1d/0x60 [cfg80211]

Cc: Luis Rodriguez <mcgrof@gmail.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/wireless/reg.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dbb01df..2303ee7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -929,11 +929,13 @@ static bool reg_request_cell_base(struct regulatory_request *request)
 
 bool reg_last_request_cell_base(void)
 {
+	bool val;
 	assert_cfg80211_lock();
 
 	mutex_lock(&reg_mutex);
-	return reg_request_cell_base(last_request);
+	val = reg_request_cell_base(last_request);
 	mutex_unlock(&reg_mutex);
+	return val;
 }
 
 #ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
-- 
1.7.0.4

