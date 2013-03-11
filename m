Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43198 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3CKVbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 17:31:10 -0400
Received: by mail-oa0-f52.google.com with SMTP id k14so4954182oag.39
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 14:31:09 -0700 (PDT)
Message-ID: <513E4D1B.5000902@lwfinger.net> (sfid-20130311_223114_629434_AF280A65)
Date: Mon, 11 Mar 2013 16:31:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing interface
 down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi> <512E58DF.4050001@lwfinger.net> <20130310142919.4375603d5escwu4g@www.dalek.fi> <20130311211709.17775i5d1zo9c8co@www.dalek.fi> <513E3DCD.5040507@lwfinger.net> <20130311230656.949364zqs1dt100s@www.dalek.fi>
In-Reply-To: <20130311230656.949364zqs1dt100s@www.dalek.fi>
Content-Type: multipart/mixed;
 boundary="------------010209090605020700050605"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010209090605020700050605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/11/2013 04:06 PM, Jussi Kivilinna wrote:
>
> Scan appearently is not necessary, 'ifconfig wlan0 up & sleep 0.02; ifconfig
> wlan0 down' is enough. Just doing 'ifconfig wlan0 up; ifconfig wlan0 down' is
> enough.
>
> I also tested with monitor interface opened for tcpdump while doing 'ifconfig
> up&down' on wlan0 and still triggered the issue. Then turning wlan0 up resulted
> monitor interface only receiving probe requests from nearby devices.

I am in the middle of a long-term test of rtl8192ce, which keeps me from running 
tests of rtl8192cu, but I noticed something strange. Does the attached patch 
help? It is compile tested.

Larry


--------------010209090605020700050605
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_modify_check_bssid"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_modify_check_bssid"

Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1377,7 +1377,23 @@ void rtl92cu_card_disable(struct ieee802
 
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
-	/* dummy routine needed for callback from rtl_op_configure_filter() */
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
+
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
+
+	if (check_bssid) {
+		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
+					      (u8 *) (&reg_rcr));
+		_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
+	} else if (!check_bssid) {
+		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
+		_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
+		rtlpriv->cfg->ops->set_hw_reg(hw,
+					      HW_VAR_RCR, (u8 *) (&reg_rcr));
+	}
 }
 
 /*========================================================================== */

--------------010209090605020700050605--
