Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1BXH3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 02:29:40 -0500
Date: Thu, 24 Feb 2011 01:29:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix two static/EXPORT conflicts on PowerPC
Message-ID: <4d6608e5.NZRNxEWzbhPgrGpv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A Powerpc allyesconfig build yielded the following errors:

drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__rtl92c_phy_txpwr_idx_to_dbm causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__rtl92c_phy_txpwr_idx_to_dbm causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__rtl92c_phy_dbm_to_txpwr_Idx causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__rtl92c_phy_dbm_to_txpwr_Idx causes a section type conflict

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Stephan Rothwell <sfr@canb.auug.org.au>
---

Stephan,

Are there any problems left after applying this patch?

My x86_64 allyesconfig build did not show these errors.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -644,7 +645,7 @@ void rtl92c_phy_set_beacon_hw_reg(struct
 }
 EXPORT_SYMBOL(rtl92c_phy_set_beacon_hw_reg);
 
-static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
+u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
 				       enum wireless_mode wirelessmode,
 				       long power_indbm)
 {
@@ -676,7 +677,7 @@ static u8 _rtl92c_phy_dbm_to_txpwr_Idx(s
 }
 EXPORT_SYMBOL(_rtl92c_phy_dbm_to_txpwr_Idx);
 
-static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
+long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
 					 enum wireless_mode wirelessmode,
 					 u8 txpwridx)
 {
