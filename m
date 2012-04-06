Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55213 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2DFCEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 22:04:31 -0400
Received: by iagz16 with SMTP id z16so2545581iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 19:04:30 -0700 (PDT)
Message-ID: <4F7E4F2A.1030404@lwfinger.net> (sfid-20120406_040435_439186_8D3149D5)
Date: Thu, 05 Apr 2012 21:04:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Nicu Pavel <npavel@mini-box.com>
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
References: <4F0EEA1B.3040501@wut.de> <4F0FA4DD.5020601@lwfinger.net> <loom.20120405T091556-756@post.gmane.org> <4F7D90AF.2040109@gtri.gatech.edu>
In-Reply-To: <4F7D90AF.2040109@gtri.gatech.edu>
Content-Type: multipart/mixed;
 boundary="------------040900000902060106060506"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040900000902060106060506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2012 07:31 AM, Joshua Roys wrote:
> On 04/05/2012 03:27 AM, Nicu Pavel wrote:
>> After mode debugging with DBG_LOUD I found out that the difference when the
>> driver is loaded/modprobed and ifdown/ifup to be a receive configuration
>> register (RCR) value.
>>
>> On bootup/modprobe: ### Set RCR(0xf0002a0e) ###
>> On ifdown/ifup: ### Set RCR(0xf0002ace) ###
>>
>> If I force RCR value to 0x2a0e in rtl92cu_set_hw_reg()inside HW_VAR_RCR case
>> everything works ok.
>>
>> This seems to work with 3 different vendors USB sticks based on 8192cu chipset
>> (Edimax, EDUP and some unknown vendor).
>>
>> I tried looking up the bit values meanings from that register but couldn't find
>> a proper spec.
>
> Hello,
>
> I found a header file that seems to have better definitions and comments than
> what is currently in-tree (I think it's a copy of the Realtek sources). It says
> that the "8192C (RCR) Receive Configuration Register" BIT 6 and 7 are,
> respectively: RCR_CBSSID_DATA [Accept BSSID match packet (Data)] and
> RCR_CBSSID_BCN [Accept BSSID match packet (Rx beacon, probe rsp)].
> These bits are set/cleared in _rtl92cu_set_check_bssid (it calls set_hw_reg
> w/HW_VAR_RCR) which is called by rtl92cu_set_network_type. The set/clear choice
> is made based on the rtlphy->current_io_type which is set in
> rtl8192c/phy_common.c:rtl92c_phy_scan_operation_backup which in turn is called
> from core.c:rtl_op_sw_scan_start/_complete.
> It would be interesting to see the output from rtl8192c/phy_common.c functions
> rtl92c_phy_set_io_cmd and rtl92c_phy_set_io to see if the current_io_type
> perhaps isn't being updated properly.

Attached is a patch that I think will help. The main thing it changes is that 
routine rtl92cu_set_check_bssid() has been coded to update RCR. The other thing 
that was changed is to make the RCR setting always log even with the default 
debug option of 0. That will be temporary and that change will be deleted once 
we get this problem fixed.

Let me know if the patch helps.

I did some stack dumps to see what code is changing the RCR. I captured the 
following instances:

Type 1, which I think is OK.

rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
Call Trace:
  rtl92cu_set_hw_reg+0x60e/0x11d0 [rtl8192cu]
  rtl92cu_set_check_bssid+0x9b/0xc0 [rtl8192cu]
  rtl_op_configure_filter+0xd0/0x400 [rtlwifi]
  ieee80211_configure_filter+0x15b/0x5c0 [mac80211]

Type 2: This one sets the filter, but it is at the end of scanning and should be OK.

rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002ace) ###
Call Trace:
  rtl92cu_set_hw_reg+0x60e/0x11d0 [rtl8192cu]
  rtl92cu_set_check_bssid+0x56/0xc0 [rtl8192cu]
  rtl_op_configure_filter+0x2d3/0x400 [rtlwifi]
  ieee80211_configure_filter+0x15b/0x5c0 [mac80211]
  __ieee80211_scan_completed+0x168/0x660 [mac80211]

Type 3: This one clears the filter, and is also at the end of scanning. I don't 
understand it yet. It seems that the filter should still be set.

rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
Call Trace:
  rtl92cu_set_hw_reg+0x60e/0x11d0 [rtl8192cu]
  _rtl92cu_set_check_bssid+0xce/0x190 [rtl8192cu]
  rtl92cu_set_network_type+0x2f/0x40 [rtl8192cu]
  rtl_op_sw_scan_complete+0x89/0xd0 [rtlwifi]

Type 4: This one occurred when the module was removed. It sets the filter, but 
that seems to be wrong. It probably does not matter as reloading the driver will 
clear those bits,

rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002ace) ###
Call Trace:
  rtl92cu_set_hw_reg+0x60e/0x11d0 [rtl8192cu]
  _rtl92cu_set_check_bssid+0x118/0x190 [rtl8192cu]
  rtl92cu_set_network_type+0x2f/0x40 [rtl8192cu]
  rtl_op_bss_info_changed+0x487/0xaa0 [rtlwifi]

Larry

--------------040900000902060106060506
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_set_check_bssid"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_set_check_bssid"

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1377,12 +1377,27 @@ void rtl92cu_card_disable(struct ieee802
 
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
-	/* dummy routine needed for callback from rtl_op_configure_filter() */
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
+
+	if (!check_bssid) {
+		reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+			rtlpriv->cfg->ops->set_hw_reg(hw,
+					 HW_VAR_RCR, (u8 *)(&reg_rcr));
+			/* disable update TSF */
+			_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
+	} else {
+		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
+		rtlpriv->cfg->ops->set_hw_reg(hw,
+				 HW_VAR_RCR, (u8 *)(&reg_rcr));
+		/* enable update TSF */
+		_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
+	}
 }
 
 /*========================================================================== */
 
-static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
+void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
 			      enum nl80211_iftype type)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1869,7 +1884,7 @@ void rtl92cu_set_hw_reg(struct ieee80211
 	case HW_VAR_RCR:{
 			rtl_write_dword(rtlpriv, REG_RCR, ((u32 *) (val))[0]);
 			mac->rx_conf = ((u32 *) (val))[0];
-			RT_TRACE(rtlpriv, COMP_RECV, DBG_DMESG,
+			RT_TRACE(rtlpriv, COMP_RECV, DBG_EMERG,
 				 "### Set RCR(0x%08x) ###\n", mac->rx_conf);
 			break;
 		}

--------------040900000902060106060506--
