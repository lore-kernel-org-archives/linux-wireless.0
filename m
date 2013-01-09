Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19665 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3AIE4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 23:56:24 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <djindal@qti.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH V8 1/2] cfg80211: Move the definition of struct mac_address up
Date: Wed, 9 Jan 2013 10:26:11 +0530
Message-ID: <1357707372-12273-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20130109_055632_793820_7AE2FC63)
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
index e5f085c..9cd9248 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -521,6 +521,10 @@ struct cfg80211_beacon_data {
 	size_t probe_resp_len;
 };
 
+struct mac_address {
+	u8 addr[ETH_ALEN];
+};
+
 /**
  * struct cfg80211_ap_settings - AP configuration
  *
@@ -2146,10 +2150,6 @@ struct ieee80211_iface_combination {
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

