Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3CMSHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 14:07:53 -0400
Date: Wed, 13 Mar 2013 13:07:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: jussi.kivilinna@iki.fi, alessandro.lannocca@gmail.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 for 3.9] rtlwifi: rtl8192cu: Fix problem that prevents
 reassociation
Message-ID: <5140c076.0QLYb3VzUznqlW1n%Larry.Finger@lwfinger.net> (sfid-20130313_190757_646109_3213E3E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver was failing to clear the BSSID when a disconnect happened. That
prevented a reconnection. This problem is reported at
https://bugzilla.redhat.com/show_bug.cgi?id=789605,
https://bugzilla.redhat.com/show_bug.cgi?id=866786,
https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
https://bugzilla.kernel.org/show_bug.cgi?id=46171.

Thanks to Jussi Kivilinna for making the critical observation
that led to the solution.

Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

V2 - removed some changes that were left in by mistake

---
 John,

As you can see by the number of bug reports, this patch should be
pushed as soon as possible.

Thanks,

Larry
---

 hw.c |   87 ++++++++++++++++++++++++++-----------------------------------------
 1 file changed, 35 insertions(+), 52 deletions(-)

Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1377,74 +1377,57 @@ void rtl92cu_card_disable(struct ieee802
 
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
-	/* dummy routine needed for callback from rtl_op_configure_filter() */
-}
-
-/*========================================================================== */
-
-static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
-			      enum nl80211_iftype type)
-{
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	u8 filterout_non_associated_bssid = false;
+	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
 
-	switch (type) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_STATION:
-		filterout_non_associated_bssid = true;
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_AP:
-	default:
-		break;
-	}
-	if (filterout_non_associated_bssid) {
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
+
+	if (check_bssid) {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			switch (rtlphy->current_io_type) {
-			case IO_CMD_RESUME_DM_BY_SCAN:
-				reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* enable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
-				break;
-			case IO_CMD_PAUSE_DM_BY_SCAN:
-				reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
-				rtlpriv->cfg->ops->set_hw_reg(hw,
-						 HW_VAR_RCR, (u8 *)(&reg_rcr));
-				/* disable update TSF */
-				_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
-				break;
-			}
+			reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr |= (RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, 0, (BIT(4)|BIT(5)));
+			reg_rcr |= RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
-	} else if (filterout_non_associated_bssid == false) {
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
+					      (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, 0, tmp);
+	} else {
+		u8 tmp;
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
-			reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
+			reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			tmp = BIT(4);
 		} else {
-			reg_rcr &= (~RCR_CBSSID);
-			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-						      (u8 *)(&reg_rcr));
-			_rtl92cu_set_bcn_ctrl_reg(hw, (BIT(4)|BIT(5)), 0);
+			reg_rcr &= ~RCR_CBSSID;
+			tmp = BIT(4) | BIT(5);
 		}
+		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
+		rtlpriv->cfg->ops->set_hw_reg(hw,
+					      HW_VAR_RCR, (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, tmp, 0);
 	}
 }
 
+/*========================================================================== */
+
 int rtl92cu_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (_rtl92cu_set_media_status(hw, type))
 		return -EOPNOTSUPP;
-	_rtl92cu_set_check_bssid(hw, type);
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		if (type != NL80211_IFTYPE_AP)
+			rtl92cu_set_check_bssid(hw, true);
+	} else {
+		rtl92cu_set_check_bssid(hw, false);
+	}
+
 	return 0;
 }
 

