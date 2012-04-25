Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37654 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2DYNBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 09:01:04 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: fix rate control update on 2040 bss change
Date: Wed, 25 Apr 2012 18:31:49 +0530
Message-ID: <1335358909-24905-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120425_150109_397153_B5FE7644)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate control updatation never be called on 2040 BSS change.
The station should update its rate control on receiving beacon
with different HT mode in the HT operation IE. Not doing so,
leads to sending frames with higher(ht40) rates whereas AP is
running in lower mode (ht20).

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8836fa..56128d3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -210,7 +210,7 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 		disable_40 = true;
 
 	if (sta && (!reconfig ||
-		    (disable_40 != !!(sta->sta.ht_cap.cap &
+		    (disable_40 == !!(sta->sta.ht_cap.cap &
 					IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
 
 		if (disable_40)
-- 
1.7.10

