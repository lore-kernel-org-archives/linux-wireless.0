Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60875 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1G2IyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 04:54:20 -0400
Date: Fri, 29 Jul 2011 11:52:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:CFG80211 and NL80211" <linux-wireless@vger.kernel.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] cfg80211: off by one in nl80211_trigger_scan()
Message-ID: <20110729085217.GG3752@shale.localdomain> (sfid-20110729_105430_209829_1EC6CA6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The test is off by one so we'd read past the end of the
wiphy->bands[] array on the next line.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 28d2aa1..e83e7fe 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3464,7 +3464,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 				    tmp) {
 			enum ieee80211_band band = nla_type(attr);
 
-			if (band < 0 || band > IEEE80211_NUM_BANDS) {
+			if (band < 0 || band >= IEEE80211_NUM_BANDS) {
 				err = -EINVAL;
 				goto out_free;
 			}
