Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34794 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab2DFTy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 15:54:59 -0400
Received: by iagz16 with SMTP id z16so3496127iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 12:54:59 -0700 (PDT)
Message-ID: <4F7F4A0F.2050300@lwfinger.net> (sfid-20120406_215504_189392_4C5954E4)
Date: Fri, 06 Apr 2012 14:54:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nicu Pavel <npavel@mini-box.com>
CC: linux-wireless@vger.kernel.org,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
References: <4F0EEA1B.3040501@wut.de> <4F0FA4DD.5020601@lwfinger.net> <loom.20120405T091556-756@post.gmane.org> <4F7D90AF.2040109@gtri.gatech.edu> <4F7E4F2A.1030404@lwfinger.net> <CAL9MRr=U+CCzjP-cSOkPJpvw=AQuHX23grj1atfkT9uxLzEM4w@mail.gmail.com>
In-Reply-To: <CAL9MRr=U+CCzjP-cSOkPJpvw=AQuHX23grj1atfkT9uxLzEM4w@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080205070301040300080503"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080205070301040300080503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/06/2012 03:48 AM, Nicu Pavel wrote:
> ---->  ifdown/ifup no scanning results.
>
> <6>rtl8192cu: MAC auto ON okay!
> <6>rtl8192cu: Tx queue select: 0x05
> <7>rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0>  FALSE driver sleep or unload
> <6>rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> <7>rtl8192cu:rtl92cu_set_hw_reg():<0-0>  ### Set RCR(0xf0002ace) ###
> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
> <7>rtlwifi:rtl_op_conf_tx():<0-0>  queue number -954253944 is incorrect!
> <7>rtl8192cu:rtl92cu_set_hw_reg():<0-0>  ### Set RCR(0xf0002a0e) ###
>
> ---->  ifdown/ifup no scanning results.

Please try the attached patch. After looking at the backtraces for the calls 
that set the BSSID filters, I could see no reason for the driver to fail, yet it 
did. Once I kept those bits clear you did in the beginning, then it works. The 
amount of extra overhead will be minimal as the bits were only set for a short time.

If this patch works for you, then I will send it upstream for mainline and 
stable. The best place to keep the bits clear would be in the calling routine, 
not in rtl92cu_set_hw_reg(); however, that patch will be much more intrusive and 
would not be accepted for 3.4.

Larry


--------------080205070301040300080503
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_set_check_bssid"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_set_check_bssid"

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1867,8 +1867,14 @@ void rtl92cu_set_hw_reg(struct ieee80211
 			break;
 		}
 	case HW_VAR_RCR:{
-			rtl_write_dword(rtlpriv, REG_RCR, ((u32 *) (val))[0]);
 			mac->rx_conf = ((u32 *) (val))[0];
+			/* whenever the driver sets bits enabling only a
+			 * specific BSSID for beacons or data, a failure
+			 * occurs. Thus we do not allow those bits to be set */
+			if (mac->rx_conf & (RCR_CBSSID_BCN | RCR_CBSSID_DATA))
+				mac->rx_conf &= ~(RCR_CBSSID_BCN |
+						  RCR_CBSSID_DATA);
+			rtl_write_dword(rtlpriv, REG_RCR, ((u32 *) (val))[0]);
 			RT_TRACE(rtlpriv, COMP_RECV, DBG_DMESG,
 				 "### Set RCR(0x%08x) ###\n", mac->rx_conf);
 			break;

--------------080205070301040300080503--
