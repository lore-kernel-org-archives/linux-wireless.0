Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25786 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2DYOxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 10:53:32 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] mac80211: fix rate control update on 2040 bss change
Date: Wed, 25 Apr 2012 20:24:24 +0530
Message-ID: <1335365664-2299-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120425_165336_202304_5A48C549)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate control updation never be called on 2040 BSS change.
The station should update its rate control on receiving beacon
with different HT mode in the HT operation IE. Not doing so,
leads to sending frames with higher(ht40) rates whereas AP is
operating in lower mode (ht20).

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8836fa..5a1b06e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -210,7 +210,7 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 		disable_40 = true;
 
 	if (sta && (!reconfig ||
-		    (disable_40 != !!(sta->sta.ht_cap.cap &
+		    (disable_40 != !(sta->sta.ht_cap.cap &
 					IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
 
 		if (disable_40)
-- 
1.7.10

