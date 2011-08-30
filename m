Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64307 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1H3A7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 20:59:04 -0400
Received: by gxk21 with SMTP id 21so5274293gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 17:59:02 -0700 (PDT)
Message-ID: <4E5C35D1.80600@lwfinger.net> (sfid-20110830_025908_142033_D2B57198)
Date: Mon, 29 Aug 2011 19:58:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rob Browning <rlb@defaultvalue.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>	<4DD074E3.3090502@lwfinger.net>	<87vcxbe5xz.fsf@trouble.defaultvalue.org>	<4DD09C78.2010304@lwfinger.net>	<8762pbkytq.fsf@trouble.defaultvalue.org>	<4DD13EF0.2070803@lwfinger.net>	<87iptaj8nf.fsf@trouble.defaultvalue.org>	<87fwoehtd7.fsf@trouble.defaultvalue.org>	<874o45z6b8.fsf@raven.defaultvalue.org> <874o41rqrg.fsf@trouble.defaultvalue.org>
In-Reply-To: <874o41rqrg.fsf@trouble.defaultvalue.org>
Content-Type: multipart/mixed;
 boundary="------------010604020700020703000906"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010604020700020703000906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/07/2011 09:38 PM, Rob Browning wrote:
> Rob Browning<rlb@defaultvalue.org>  writes:
>
>> As another data point, I just tested the same device on a second machine
>> (a desktop), and saw the same behavior -- initially high transfer rates
>> trailing off to about 60K/s.
>
> ...and another data point.  Just to be sure it wasn't that particular
> usb device, I got another that I think is the same hardware (this time
> the Airlink 101), and I see exactly the same behavior.
>
> Next I'll try a different access point -- I'll let you know what I find.
> And if there's anything else I can do to help test, please let me know.

It has been some time since you wrote this. Any changes?

I recently noticed a slow-down on my rtl8192cu doing TX TCP MAERTS tests with 
netperf. The attached patch seemed to help. If you still have the problem, does 
it help? Note: The patch is badly named - I started trying to fix a problem 
connecting with a 270 Mpbs 2.4 GHz channel. It works with 150 Mbps. On the 
higher speed network, it authenticates and associates, but no data gets through.

Larry



--------------010604020700020703000906
Content-Type: text/plain;
 name="rtlwifi_fix_wpa"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtlwifi_fix_wpa"

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
@@ -610,6 +610,11 @@ static void rtl_op_bss_info_changed(stru
 
 			mac->link_state = MAC80211_NOLINK;
 			memset(mac->bssid, 0, 6);
+
+			/* reset sec info */
+			rtl_cam_reset_sec_info(hw);
+
+			rtl_cam_reset_all_entry(hw);
 			mac->vendor = PEER_UNKNOWN;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
@@ -1063,6 +1068,9 @@ static int rtl_op_set_key(struct ieee802
 		 *or clear all entry here.
 		 */
 		rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
+
+		rtl_cam_reset_sec_info(hw);
+
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,

--------------010604020700020703000906--
