Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43358 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab3CLJKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 05:10:38 -0400
Message-ID: <20130312111035.96082dc0scui0tu8@www.dalek.fi> (sfid-20130312_101055_526436_EBE36F1D)
Date: Tue, 12 Mar 2013 11:10:35 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu gets confused when scan is aborted by bringing
 interface down (Re: rtl8192cu goes silent/dead after some time...)
References: <20130225185141.14193yyf1vunany8@www.dalek.fi>
 <512E58DF.4050001@lwfinger.net>
 <20130310142919.4375603d5escwu4g@www.dalek.fi>
 <20130311211709.17775i5d1zo9c8co@www.dalek.fi>
 <513E3DCD.5040507@lwfinger.net>
 <20130311230656.949364zqs1dt100s@www.dalek.fi>
 <513E4D1B.5000902@lwfinger.net>
In-Reply-To: <513E4D1B.5000902@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_ac69u403oy8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This message is in MIME format.

--=_ac69u403oy8
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Quoting Larry Finger <Larry.Finger@lwfinger.net>:

> On 03/11/2013 04:06 PM, Jussi Kivilinna wrote:
>>
>> Scan appearently is not necessary, 'ifconfig wlan0 up & sleep 0.02; ifconfig
>> wlan0 down' is enough. Just doing 'ifconfig wlan0 up; ifconfig  
>> wlan0 down' is
>> enough.
>>
>> I also tested with monitor interface opened for tcpdump while doing  
>> 'ifconfig
>> up&down' on wlan0 and still triggered the issue. Then turning wlan0  
>> up resulted
>> monitor interface only receiving probe requests from nearby devices.
>
> I am in the middle of a long-term test of rtl8192ce, which keeps me  
> from running tests of rtl8192cu, but I noticed something strange.  
> Does the attached patch help? It is compile tested.
>

That patch alone did not help.. however replacing  
_rtl92cu_set_check_bssid() with that new rtl92cu_set_check_bssid()  
does fix the issue (patch attached).

But I think _rtl92cu_set_check_bssid() needs to be rechecked since it  
has '(IS_NORMAL_CHIP(rtlhal->version))' conditional etc.

-Jussi


--=_ac69u403oy8
Content-Type: text/x-diff;
 charset=ISO-8859-1;
 name="01-rtl8192cu_set_network_type_with_new_set_check_bssid.patch"
Content-Disposition: attachment;
 filename="01-rtl8192cu_set_network_type_with_new_set_check_bssid.patch"
Content-Transfer-Encoding: 7bit



From: Jussi Kivilinna <jussi.kivilinna@iki.fi>


---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |   31 +++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 3c6e18c..ee87201 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1377,11 +1377,28 @@ void rtl92cu_card_disable(struct ieee80211_hw *hw)
 
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
 
+#if 0
 static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
 			      enum nl80211_iftype type)
 {
@@ -1439,12 +1456,22 @@ static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
 		}
 	}
 }
+#endif
 
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
 

--=_ac69u403oy8--

