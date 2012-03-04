Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab2CDUnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 068/101] iwlwifi: remove unused argument from rs_initialize_lq
Date: Sun,  4 Mar 2012 11:29:22 -0800
Message-Id: <1330889395-533-69-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214517_921189_922B353B)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function never uses its conf argument,
so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 9895b80..53f8c51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2677,7 +2677,6 @@ out:
  *       which requires station table entry to exist).
  */
 static void rs_initialize_lq(struct iwl_priv *priv,
-			     struct ieee80211_conf *conf,
 			     struct ieee80211_sta *sta,
 			     struct iwl_lq_sta *lq_sta)
 {
@@ -2912,7 +2911,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 	lq_sta->dbg_fixed_rate = 0;
 #endif
 
-	rs_initialize_lq(priv, conf, sta, lq_sta);
+	rs_initialize_lq(priv, sta, lq_sta);
 }
 
 static void rs_fill_link_cmd(struct iwl_priv *priv,
-- 
1.7.0.4

