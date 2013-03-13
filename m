Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21518 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMP2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:28:16 -0400
Date: Wed, 13 Mar 2013 10:28:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: jussi.kivilinna@iki.fi, alessandro.lannocca@gmail.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH for 3.9] rtlwifi: rtl8192cu: Fix problem that prevents
 reassociation
Message-ID: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net> (sfid-20130313_162820_017420_CDF86D47)
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

John,

As you can see by the number of bug reports, this patch should be
pushed as soon as possible.

Thanks,

Larry
---

 base.h         |    3 +
 pci.c          |    2 -
 rtl8192cu/hw.c |   87 ++++++++++++++++++++++-----------------------------------
 3 files changed, 39 insertions(+), 53 deletions(-)

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
 
Index: linux-2.6/drivers/net/wireless/rtlwifi/base.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/base.h
+++ linux-2.6/drivers/net/wireless/rtlwifi/base.h
@@ -143,5 +143,8 @@ extern struct attribute_group rtl_attrib
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 			 bool isht, u8 desc_rate, bool first_ampdu);
 bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
+struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw,
+				u8 *sa, u8 *bssid, u16 tid);
+void rtl_lps_change_work_callback(struct work_struct *work);
 
 #endif
Index: linux-2.6/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/pci.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/pci.c
@@ -939,7 +939,7 @@ static void _rtl_pci_prepare_bcn_tasklet
 	return;
 }
 
-static void rtl_lps_leave_work_callback(struct work_struct *work)
+void rtl_lps_leave_work_callback(struct work_struct *work)
 {
 	struct rtl_works *rtlworks =
 	    container_of(work, struct rtl_works, lps_leave_work);
