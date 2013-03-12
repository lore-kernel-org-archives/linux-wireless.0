Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57091 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3CLQvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 12:51:35 -0400
Received: by mail-oa0-f43.google.com with SMTP id l10so60487oag.16
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 09:51:34 -0700 (PDT)
Message-ID: <513F5D14.3060409@lwfinger.net> (sfid-20130312_175139_484630_FEEF6B90)
Date: Tue, 12 Mar 2013 11:51:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing interface
 down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi> <512E58DF.4050001@lwfinger.net> <20130310142919.4375603d5escwu4g@www.dalek.fi> <20130311211709.17775i5d1zo9c8co@www.dalek.fi> <513E3DCD.5040507@lwfinger.net> <20130311230656.949364zqs1dt100s@www.dalek.fi> <513E4D1B.5000902@lwfinger.net> <20130312111035.96082dc0scui0tu8@www.dalek.fi>
In-Reply-To: <20130312111035.96082dc0scui0tu8@www.dalek.fi>
Content-Type: multipart/mixed;
 boundary="------------080903090703020907020107"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080903090703020907020107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/2013 04:10 AM, Jussi Kivilinna wrote:
>
> That patch alone did not help.. however replacing _rtl92cu_set_check_bssid()
> with that new rtl92cu_set_check_bssid() does fix the issue (patch attached).
>
> But I think _rtl92cu_set_check_bssid() needs to be rechecked since it has
> '(IS_NORMAL_CHIP(rtlhal->version))' conditional etc.

I doubt that that IS_NORMAL_CHIP business affects us - the test chips are not 
supposed to be in the wild, but I modified your patch to include that test.

With that patch I am getting watchdog_wq callbacks that force a reconnection 
every 6 seconds, but that is due to other changes in my code. The result is a 
34% loss of pings, but the connection stays up.

Larry



--------------080903090703020907020107
Content-Type: text/x-patch;
 name="01-rtl8192cu_set_network_type_with_new_set_check_bssid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="01-rtl8192cu_set_network_type_with_new_set_check_bssid.patch"



From: Jussi Kivilinna <jussi.kivilinna@iki.fi>


---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |   31 +++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

Index: wireless-testing-rebased/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing-rebased.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing-rebased/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
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
 

--------------080903090703020907020107--
