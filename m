Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49167 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab2ICMYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 08:24:32 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 1/2] cfg80211: Move the definition of struct mac_address up
Date: Mon, 3 Sep 2012 17:53:56 +0530
Message-ID: <1346675037-17858-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120903_142509_777761_8B73F678)
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
index ba2e616..fd78d38 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1415,6 +1415,10 @@ struct cfg80211_gtk_rekey_data {
 	u8 replay_ctr[NL80211_REPLAY_CTR_LEN];
 };
 
+struct mac_address {
+	u8 addr[ETH_ALEN];
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -2006,10 +2010,6 @@ struct ieee80211_iface_combination {
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

