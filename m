Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60138 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLQQAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 11:00:46 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so17464421wiv.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 08:00:44 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] nl80211: increase the max number of rules in regdomain
Date: Wed, 17 Dec 2014 18:00:44 +0200
Message-Id: <1418832044-25582-1-git-send-email-arik@wizery.com> (sfid-20141217_170048_965685_ADA7C904)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some network cards (Intel) produce per-channel regdomains and rely on
cfg80211 to merge rules as needed. This hits the max rules limit and
fails.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 include/uapi/linux/nl80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c0383e9..18cb0aa 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2112,7 +2112,7 @@ enum nl80211_attrs {
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
-#define NL80211_MAX_SUPP_REG_RULES		32
+#define NL80211_MAX_SUPP_REG_RULES		64
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
 #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
-- 
1.9.1

