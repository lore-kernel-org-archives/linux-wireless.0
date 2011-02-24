Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1BXThP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 14:37:15 -0500
Subject: [PATCH] rtl8192c: fix compilation errors
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 20:37:10 +0100
Message-ID: <1298576230.4251.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On my G5 this fails to compile with

drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__rtl92c_phy_txpwr_idx_to_dbm causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__rtl92c_phy_txpwr_idx_to_dbm causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__rtl92c_phy_dbm_to_txpwr_Idx causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__rtl92c_phy_dbm_to_txpwr_Idx causes a section type conflict

since you can't export static functions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c	2011-02-24 20:35:47.398280074 +0100
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c	2011-02-24 20:35:58.536168754 +0100
@@ -644,9 +644,9 @@ void rtl92c_phy_set_beacon_hw_reg(struct
 }
 EXPORT_SYMBOL(rtl92c_phy_set_beacon_hw_reg);
 
-static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
-				       enum wireless_mode wirelessmode,
-				       long power_indbm)
+u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
+				enum wireless_mode wirelessmode,
+				long power_indbm)
 {
 	u8 txpwridx;
 	long offset;
@@ -676,9 +676,9 @@ static u8 _rtl92c_phy_dbm_to_txpwr_Idx(s
 }
 EXPORT_SYMBOL(_rtl92c_phy_dbm_to_txpwr_Idx);
 
-static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
-					 enum wireless_mode wirelessmode,
-					 u8 txpwridx)
+long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
+				  enum wireless_mode wirelessmode,
+				  u8 txpwridx)
 {
 	long offset;
 	long pwrout_dbm;


