Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33231 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3IMRpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 13:45:19 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 2/7] rtlwifi: rtl8192de: Fix smatch warnings in rtl8192de/hw.c
Date: Fri, 13 Sep 2013 12:44:59 -0500
Message-Id: <1379094304-22041-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130913_194606_090170_F333E65B)
In-Reply-To: <1379094304-22041-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1379094304-22041-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch lists the following:
  CHECK   drivers/net/wireless/rtlwifi/rtl8192de/hw.c
drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.
drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.

Dead code is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 7dd8f6d..c9b0894 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1194,6 +1194,7 @@ void rtl92d_linked_set_reg(struct ieee80211_hw *hw)
  * mac80211 will send pkt when scan */
 void rtl92de_set_qos(struct ieee80211_hw *hw, int aci)
 {
+/*
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	rtl92d_dm_init_edca_turbo(hw);
 	return;
@@ -1213,6 +1214,7 @@ void rtl92de_set_qos(struct ieee80211_hw *hw, int aci)
 		RT_ASSERT(false, "invalid aci: %d !\n", aci);
 		break;
 	}
+ */
 }
 
 void rtl92de_enable_interrupt(struct ieee80211_hw *hw)
-- 
1.8.1.4

