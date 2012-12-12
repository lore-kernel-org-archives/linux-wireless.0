Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15378 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2LLGmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 01:42:07 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH V2 1/2] cfg80211: Move the definition of struct mac_address up
Date: Wed, 12 Dec 2012 12:11:30 +0530
Message-ID: <1355294491-30982-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20121212_074211_291879_D8DA821E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct mac_address will be used by ACL related configuration ops.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 include/net/cfg80211.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e78db2c..475230b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -503,6 +503,10 @@ struct cfg80211_beacon_data {
 	size_t probe_resp_len;
 };
 
+struct mac_address {
+	u8 addr[ETH_ALEN];
+};
+
 /**
  * struct cfg80211_ap_settings - AP configuration
  *
@@ -2111,10 +2115,6 @@ struct ieee80211_iface_combination {
 	bool beacon_int_infra_match;
 };
 
-struct mac_address {
-	u8 addr[ETH_ALEN];
-};
-
 struct ieee80211_txrx_stypes {
 	u16 tx, rx;
 };
-- 
1.7.0.4

